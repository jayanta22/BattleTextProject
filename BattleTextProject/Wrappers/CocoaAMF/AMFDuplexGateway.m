//
//  AMFDuplexSocket.m
//  CocoaAMF
//
//  Created by Marc Bauer on 20.02.09.
//  Copyright 2009 nesiumdotcom. All rights reserved.
//

#import "AMFDuplexGateway.h"

#define kReadDataLengthTag 1
#define kReadDataTag 2

@interface AMFRemoteGateway (Private)
- (void)_continueReading;
- (void)_sendActionMessage:(AMFActionMessage *)am;
- (void)_processActionMessage:(AMFActionMessage *)am;
- (void)_processResponseWithServiceName:(NSString *)serviceName methodName:(NSString *)methodName 
	responseData:(id)responseData invocationIndex:(int)invocationIndex 
	resultType:(NSString *)resultType;
- (void)_executeQueuedInvocations;
@end

@implementation AMFDuplexGateway

@synthesize delegate=m_delegate, mode=m_mode;

#pragma mark -
#pragma mark Initialization & Deallocation

- (id)init
{
	if (self == [super init])
	{
		m_socket = [[AsyncSocket alloc] init];
		[m_socket setDelegate:self];
		m_services = [[NSMutableDictionary alloc] init];
		m_remoteGateways = [[NSMutableSet alloc] init];
		m_mode = kAMFDuplexGatewayModeNotConnected;
		m_remoteGatewayClass = [AMFRemoteGateway class];
	}
	return self;
}

- (void)dealloc
{
	[m_socket disconnect];
	[m_socket release];
	[m_remoteGateways release];
	[m_services release];
	[super dealloc];
}



#pragma mark -
#pragma mark Public methods

- (BOOL)startOnPort:(uint16_t)port error:(NSError **)error
{
	if (m_mode != kAMFDuplexGatewayModeNotConnected)
		[self stop];

	if (![m_socket acceptOnPort:port error:error])
	{
		return NO;
	}
	m_mode = kAMFDuplexGatewayModeServer;
	return YES;
}

- (BOOL)connectToRemote:(NSString *)server port:(uint16_t)port error:(NSError **)error
{
	if (m_mode != kAMFDuplexGatewayModeNotConnected)
		[self stop];
		
	if (![m_socket connectToHost:server onPort:port error:error])
		return NO;
	
	NSData *headerData = [@"BIN-INIT\0" dataUsingEncoding:NSUTF8StringEncoding];
	[m_socket writeData:headerData withTimeout:-1 tag:0];
	m_mode = kAMFDuplexGatewayModeClient;
	AMFRemoteGateway *gateway = [[AMFRemoteGateway alloc] initWithLocalGateway:self socket:m_socket 
		type:kAMFRemoteGatewayTypeOutgoing];
	[m_remoteGateways addObject:gateway];
	if ([m_delegate respondsToSelector:@selector(gateway:remoteGatewayDidConnect:)])
		objc_msgSend(m_delegate, @selector(gateway:remoteGatewayDidConnect:), self, gateway);
	[gateway release];
	return YES;
}

- (void)stop
{
	[m_remoteGateways removeAllObjects];
	m_mode = kAMFDuplexGatewayModeNotConnected;
	[m_socket disconnect];
}

- (UInt16)localPort
{
	return [m_socket localPort];
}

- (void)registerService:(id)service withName:(NSString *)name
{
	m_services[name] = service;
}

- (void)unregisterServiceWithName:(NSString *)name
{
	[m_services removeObjectForKey:name];
}

- (id)serviceWithName:(NSString *)name
{
	return m_services[name];
}

- (void)setRemoteGatewayClass:(Class)aClass
{
	if (aClass != [AMFRemoteGateway class] && 
		class_getSuperclass(aClass) != [AMFRemoteGateway class])
	{
		@throw [NSException exceptionWithName:@"AMFDuplexGatewayInvalidRemoteGatewayClassException" 
			reason:@"You need to supply a class which is a subclass of AMFRemoteGateway" 
			userInfo:nil];
	}
	m_remoteGatewayClass = aClass;
}

- (NSSet *)remoteGateways
{
	return m_remoteGateways;
}



#pragma mark -
#pragma mark AsyncSocket delegate methods
 
- (void)onSocket:(AsyncSocket *)sock didAcceptNewSocket:(AsyncSocket *)newSocket
{
	AMFRemoteGateway *remoteGateway = [[m_remoteGatewayClass alloc] initWithLocalGateway:self 
		socket:newSocket type:kAMFRemoteGatewayTypeIncoming];
	[m_remoteGateways addObject:remoteGateway];
	if ([m_delegate respondsToSelector:@selector(gateway:remoteGatewayDidConnect:)])
	{
		objc_msgSend(m_delegate, @selector(gateway:remoteGatewayDidConnect:), self, remoteGateway);
	}
	[remoteGateway release];
}

- (void)remoteGatewayDidDisconnect:(AMFRemoteGateway *)remoteGateway
{
	if ([m_delegate respondsToSelector:@selector(gateway:remoteGatewayDidDisconnect:)])
	{
		objc_msgSend(m_delegate, @selector(gateway:remoteGatewayDidDisconnect:), self, remoteGateway);
	}
	[m_remoteGateways removeObject:remoteGateway];
}

@end



@implementation AMFRemoteGateway

@synthesize delegate=m_delegate, 
			localGateway=m_localGateway;

#pragma mark -
#pragma mark Initialization & Deallocation

- (id)init
{
	if (self == [super init])
	{
		m_binaryMode = NO;		
		m_queuedInvocations = [[NSMutableSet alloc] init];
		m_pendingInvocations = [[NSMutableSet alloc] init];
		m_invocationCount = 1;
		m_delegate = nil;
	}
	return self;
}

- (id)initWithLocalGateway:(AMFDuplexGateway *)localGateway socket:(AsyncSocket *)socket 
	type:(AMFRemoteGatewayType)gatewayType
{
	if (self == [self init])
	{
		m_localGateway = localGateway;
		m_gatewayType = gatewayType;
		m_binaryMode = m_gatewayType != kAMFRemoteGatewayTypeIncoming;
		m_socket = [socket retain];
		[m_socket setDelegate:self];
		[self _continueReading];
	}
	return self;
}

- (void)dealloc
{
	[m_socket disconnect];
	[m_socket release];
	[m_queuedInvocations release];
	[m_pendingInvocations release];
	[super dealloc];
}



#pragma mark -
#pragma mark Public methods

- (AMFInvocationResult *)invokeRemoteService:(NSString *)serviceName 
	methodName:(NSString *)methodName argumentsArray:(NSArray *)arguments
{
	AMFActionMessage *am = [[AMFActionMessage alloc] init];
	am.version = kAMF0Version;
	[am addBodyWithTargetURI:[NSString stringWithFormat:@"%@.%@", serviceName, methodName] 
		responseURI:[NSString stringWithFormat:@"/%d", m_invocationCount] data:arguments];
	[self _sendActionMessage:am];
	[am release];
	AMFInvocationResult *result = [AMFInvocationResult invocationResultForService:serviceName 
		methodName:methodName arguments:arguments index:m_invocationCount++];
	result.gateway = self;
	[m_pendingInvocations addObject:result];
	return result;
}

- (AMFInvocationResult *)invokeRemoteService:(NSString *)serviceName 
	methodName:(NSString *)methodName arguments:(id)firstArgument, ...
{
	NSMutableArray *arguments = [NSMutableArray array];
	if (firstArgument != nil)
	{
		va_list args;
		va_start(args, firstArgument);
		id argument = firstArgument;
		do [arguments addObject:argument];
		while (argument == va_arg(args, id));
		va_end(args);
	}
	if ([arguments count] == 0) arguments = nil;
	return [self invokeRemoteService:serviceName methodName:methodName argumentsArray:arguments];
}

- (void)disconnect
{
	[m_socket disconnectAfterWriting];
}



#pragma mark -
#pragma mark Private methods

- (void)_continueReading
{
	if (!m_binaryMode)
	{
		[m_socket readDataToData:[AsyncSocket ZeroData] withTimeout:-1 tag:0];
		return;
	}
	[m_socket readDataToLength:4 withTimeout:-1 tag:kReadDataLengthTag];
}

- (void)_sendActionMessage:(AMFActionMessage *)am
{
	NSData *data = [am data];
	uint32_t msgDataLength = CFSwapInt32HostToBig([data length]);
	NSMutableData *lengthBits = [NSMutableData data];
	[lengthBits appendBytes:&msgDataLength length:sizeof(uint32_t)];
	[m_socket writeData:lengthBits withTimeout:-1 tag:0];
	[m_socket writeData:data withTimeout:-1 tag:0];
}

- (void)_processActionMessage:(AMFActionMessage *)am
{
	for (AMFMessageBody *body in am.bodies)
	{
		NSArray *targetComponents = [body.targetURI componentsSeparatedByString:@"."];
		NSString *serviceName = targetComponents[0];
		NSString *methodName = targetComponents[1];
		
		// is a response
		if ([body.responseURI rangeOfString:@"/"].location == NSNotFound)
		{
			NSArray *methodComponents = [methodName componentsSeparatedByString:@"/"];
			methodName = methodComponents[0];
			int responseIndex = [methodComponents[1] intValue];
			NSString *resultType = methodComponents[2];
			[self _processResponseWithServiceName:serviceName methodName:methodName 
				responseData:body.data invocationIndex:responseIndex resultType:resultType];
			continue;
		}

		id service = [m_localGateway serviceWithName:serviceName];
		if (service == nil)
		{
			// @TODO handle error
			NSLog(@"No service registered with the name '%@'", serviceName);
		}
		NSError *error = nil;
		id result = [service invokeMethodWithName:methodName arguments:(NSArray *)body.data 
			error:&error prependName:@"gateway" argument:self];
			
		if (error != nil)
		{
			// @TODO handle error
			NSLog(@"%@", error);
		}
			
		AMFActionMessage *ram = [[AMFActionMessage alloc] init];
		[ram addBodyWithTargetURI:[NSString stringWithFormat:@"%@%@/onResult", body.targetURI, 
			body.responseURI] responseURI:@"null" data:result];
		[self _sendActionMessage:ram];
		[ram release];
	}
}

- (void)_processResponseWithServiceName:(NSString *)serviceName methodName:(NSString *)methodName 
	responseData:(id)responseData invocationIndex:(int)invocationIndex 
	resultType:(NSString *)resultType
{
	AMFInvocationResult *result = nil;
	for (AMFInvocationResult *nextResult in m_pendingInvocations)
	{
		if (nextResult.invocationIndex == invocationIndex && 
			[nextResult.serviceName isEqual:serviceName] && 
			[nextResult.methodName isEqual:methodName])
		{
			result = nextResult;
			break;
		}
	}
	if (result == nil)
	{
		NSLog(@"Received a response to a request we obviously never sent!");
		return;
	}
	result.status = resultType;
	result.result = responseData;
	[result performSelector:@selector(_invocationDidReceiveResponse) withObject:nil];
}

- (void)_executeQueuedInvocations
{
	for (AMFActionMessage *am in m_queuedInvocations)
	{
		[self _sendActionMessage:am];
	}
	[m_queuedInvocations removeAllObjects];
}



#pragma mark -
#pragma mark AsyncSocket delegate methods
 
- (void)onSocket:(AsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
	if (tag == kReadDataLengthTag)
	{
		uint8_t ch1, ch2, ch3, ch4;
		[data getBytes:&ch1 range:(NSRange){0, 1}];
		[data getBytes:&ch2 range:(NSRange){1, 1}];
		[data getBytes:&ch3 range:(NSRange){2, 1}];
		[data getBytes:&ch4 range:(NSRange){3, 1}];
		uint32_t length = (ch1 << 24) + (ch2 << 16) + (ch3 << 8) + ch4;
		[sock readDataToLength:length withTimeout:-1 tag:kReadDataTag];
	}
	else if (tag == kReadDataTag)
	{
		AMFActionMessage *am = nil;
		@try
		{
			AMFActionMessage *am = [[AMFActionMessage alloc] initWithData:data];
			[self _processActionMessage:am];
		}
		@catch (NSException *e) 
		{
			NSLog(@"%@", e);
		}
		@finally 
		{
			[am release];
			[self _continueReading];
		}
	}
	else if (m_binaryMode == NO)
	{
		NSString *message = [NSString stringWithUTF8String:[data bytes]];
		if ([message isEqualToString:@"<policy-file-request/>"])
		{
			NSString *msg = @"<cross-domain-policy>\
<allow-access-from domain=\"*\" to-ports=\"*\"/>\
</cross-domain-policy>\0";
			[m_socket writeData:[msg dataUsingEncoding:NSUTF8StringEncoding] withTimeout:-1 tag:0];
			[self _continueReading];
		}
		else if ([message isEqualToString:@"BIN-INIT"])
		{
			m_binaryMode = YES;
			[self _continueReading];
		}
		else
		{
			NSLog(@"received unexpected data: %@", message);
			[m_socket disconnectAfterWriting];
		}
	}
}

- (void)onSocketDidDisconnect:(AsyncSocket *)sock
{
	[m_localGateway remoteGatewayDidDisconnect:self];
}

@end



@implementation AMFInvocationResult

@synthesize gateway, serviceName, methodName, arguments, invocationIndex, result, status, context, 
	action, target;

+ (AMFInvocationResult *)invocationResultForService:(NSString *)aServiceName 
	methodName:(NSString *)aMethodName arguments:(NSArray *)args index:(uint32_t)index
{
	AMFInvocationResult *result = [[AMFInvocationResult alloc] init];
	result.serviceName = aServiceName;
	result.methodName = aMethodName;
	result.arguments = args;
	result.invocationIndex = index;
	return [result autorelease];
}

- (void)_invocationDidReceiveResponse
{
	[target performSelector:action withObject:self];
}

@end