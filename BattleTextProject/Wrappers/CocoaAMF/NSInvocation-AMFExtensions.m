//
//  NSInvocation-AMFExtensions.m
//  Supertrump
//
//  Created by Marc Bauer on 26.02.09.
//  Copyright 2009 nesiumdotcom. All rights reserved.
//

#import "NSInvocation-AMFExtensions.h"


@implementation NSInvocation (AMFExtensions)

- (id)returnValueAsObject
{
	const char *methodReturnType = [[self methodSignature] methodReturnType];
	switch (*methodReturnType)
	{
		case 'c':
		{
			int8_t value;
			[self getReturnValue:&value];
			return [NSNumber numberWithChar:value];
		}
		case 'C':
		{
			uint8_t value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'i':
		{
			int32_t value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'I':
		{
			uint32_t value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 's':
		{
			int16_t value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'S':
		{
			uint16_t value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'f':
		{
			float value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'd':
		{
			double value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'B':
		{
			uint8_t value;
			[self getReturnValue:&value];
			return @((BOOL)value);
		}
		case 'l':
		{
			long value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'L':
		{
			unsigned long value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'q':
		{
			long long value;
			[self getReturnValue:&value];
			return @(value);
		}
		case 'Q':
		{
			unsigned long long value;
			[self getReturnValue:&value];
			return @(value);
		}
//		case '*':
//		{
//			
//		}
		case '@':
		{
			id value;
			[self getReturnValue:&value];
			return value;
		}
		case 'v':
		case 'V':
		{
			return nil;
		}
		default:
		{
			[NSException raise:NSInternalInconsistencyException
						 format:@"[%@ %@] UnImplemented type: %@",
				[self class], NSStringFromSelector(_cmd), methodReturnType];
		}
	}
	return nil;
}

@end