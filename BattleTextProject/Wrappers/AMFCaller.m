//
//  DemoCaller.m
//  CocoaAMF-iPhone
//
//  Created by Marc Bauer on 11.01.09.
//  Copyright 2009 nesiumdotcom. All rights reserved.
//

#import "AMFCaller.h"


@implementation AMFCaller

@synthesize delegate=m_delegate;

#pragma mark -
#pragma mark Initialization & Deallocation

- (id)init
{
	Reachability *curReach = [[Reachability reachabilityForInternetConnection] retain];
	NetworkStatus netStatus = [curReach currentReachabilityStatus];
	
	switch (netStatus)
	{
		case NotReachable:
		{
			UIAlertView *connectionAlert = [[UIAlertView alloc] init]; 
			[connectionAlert setTitle:@"Internet Connection Error"];
			[connectionAlert setMessage:@"Please check network conenction because you need active internet connection to play the game."];    
			[connectionAlert setDelegate:self];
			[connectionAlert setTag:1];
			[connectionAlert addButtonWithTitle:@"Exit"];
			[connectionAlert show];
			[connectionAlert release];
			//NSLog(@"NETWORKCHECK: Not Connected");
			break;
		}
		case ReachableViaWWAN:
		{
			//NSLog(@"NETWORKCHECK: Connected Via WWAN");
			
			/*NSString *finalUrl =  [NSString stringWithFormat:@"%@",appDel.LTURL4CAT];			
			isSuccess = [appDel callingXML4LT:finalUrl];*/
			
			
			if (self == [super init])
			{
				m_remotingCall = [[AMFRemotingCall alloc] init];
				
				//m_remotingCall.URL = [NSURL URLWithString:@"http://www.isisdev.net/hotornot/amfphp/gateway.php"];
				m_remotingCall.URL = [NSURL URLWithString:@"http://www.5gsoftware.net/demo/bannerapp/amfphp/gateway.php"];
				
				//m_remotingCall.URL = [NSURL URLWithString:@"http://wordssupreme.reachmessaging.com/amfphp/gateway.php"];
				
				m_remotingCall.service = @"bannerapp";//@"SupremeNew";
				m_remotingCall.delegate = self;
				m_delegate = nil;
			}
			
						
			break;
		}
		case ReachableViaWiFi:
		{
			//NSLog(@"NETWORKCHECK: Connected Via WiFi");
			
			//NSString *finalUrl =  [NSString stringWithFormat:@"%@",appDel.LTURL4CAT];			
			//isSuccess = [appDel callingXML4LT:finalUrl];
			
			
			if (self == [super init])
			{
				m_remotingCall = [[AMFRemotingCall alloc] init];
				
				m_remotingCall.URL = [NSURL URLWithString:@"http://www.5gsoftware.net/demo/bannerapp/amfphp/gateway.php"];
				
				
				//m_remotingCall.URL = [NSURL URLWithString:@"http://wordssupreme.reachmessaging.com/amfphp/gateway.php"];
				
				//m_remotingCall.URL = [NSURL URLWithString:@"http://192.168.1.11/word_supreme/amfphp/gateway.php"];
				
				m_remotingCall.service = @"bannerapp";//@"SupremeNew";
				m_remotingCall.delegate = self;
				m_delegate = nil;
			}
			
			break;
		}
			
	}
	
	
	return self;
}

- (void)dealloc
{
	[m_remotingCall release];
	[super dealloc];
}


- (void)alertView:(UIAlertView *)alertView willDismissWithButtonIndex:(NSInteger)buttonIndex
{
	//exit(0);
		
}


#pragma mark -
#pragma mark Public methods
-(void)getPortfolio
{
    m_remotingCall.method = @"portfolio";//@"returnArray";
	[m_remotingCall start];	
}

-(void)getCategory
{
	m_remotingCall.method = @"category";//@"returnArray";
	[m_remotingCall start];	

}
-(void)getThemByCategoryId:(NSString *)catID
{
	m_remotingCall.method = @"theme";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:catID,nil];
	[m_remotingCall start];	

}
-(void)getBannerSizeAndId
{
	m_remotingCall.method = @"banner";//@"returnArray";
	[m_remotingCall start];	

}
-(void)getThemeByCatIdAndSizeId:(NSString*)catId sizeId:(NSString*)sizeId
{
	NSLog(@"catId catId %@ sizeIdsizeId %@",catId,sizeId);
	m_remotingCall.method = @"specific_theme";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:sizeId,catId,nil];
	[m_remotingCall start];	
	

}
-(void)getPreviewBySizeIdAndThemeId:(NSString*)sizeId themeId:(NSString*)themeId
{
	m_remotingCall.method = @"preview";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:sizeId,themeId,nil];
	[m_remotingCall start];	
}





- (void)saveGameData:(NSMutableArray *) arr :(NSMutableArray *)arr1: (NSMutableArray *)arr2: (NSString *)loc: (NSString *)loc1: (NSString *)loc2: (NSString *)loc3: (NSString *)loc4:(NSString *)loc5:(NSString *)loc6:(NSString *)loc7:(NSMutableArray *) arr3 :(NSMutableArray *)arr4
{
//NSLog(@"XXXXXXXXXXX     %@    %@ ",arr3,arr4);	
	m_remotingCall.method = @"updateGame";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,arr,arr1,arr2,loc2,loc3,loc4,loc5,loc6,loc7,arr3,arr4,nil];
	//m_remotingCall.arguments = [NSArray arrayWithObjects:@"1",@"1",arr,arr1,nil];
	[m_remotingCall start];	
}

- (void)getGameData:(NSString *) loc:(NSString *)loc1
{
	
	m_remotingCall.method = @"getGame";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
}

- (void)checkWords:(NSString *) loc:(NSMutableArray *) loc1
{
	
	m_remotingCall.method = @"checkWords";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
	
}
- (void)userLogin:(NSString *) loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4
{
	
	m_remotingCall.method = @"userLogin";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,loc3,loc4,nil];
	[m_remotingCall start];	
	
}
- (void)createPassPlayGame:(NSString *) loc
{
	
	m_remotingCall.method = @"createPassPlayGame";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,nil];
	[m_remotingCall start];	
	
}
- (void)createUserNameGame:(NSString *) loc:(NSString *) loc1
{
	
	m_remotingCall.method = @"searchByUsername";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
	
}
- (void)yourMove:(NSString *) loc
{
	
	m_remotingCall.method = @"getMyTurn";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,nil];
	[m_remotingCall start];	
	
}
- (void)theirMove:(NSString *) loc
{
	
	m_remotingCall.method = @"getOpponentTurn";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,nil];
	[m_remotingCall start];	
	
}
- (void)gameMoveEnd:(NSString *) loc
{
	
	m_remotingCall.method = @"getFinishedGame";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,nil];
	[m_remotingCall start];	
	
}

- (void)ansGame:(NSString *) loc:(NSString *)loc1
{
	
	m_remotingCall.method = @"answereGameRequest";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
	
}
- (void)quitGame:(NSString *) loc:(NSString *)loc1
{
	
	m_remotingCall.method = @"quitGame";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
	
}
- (void)playerRequestForRandom:(NSString *) loc:(NSString *)loc1
{
	
	m_remotingCall.method = @"gameRequest";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
	
}

- (void)getPoints:(NSString *) loc:(NSString *)loc1
{
	
	m_remotingCall.method = @"getMyGamePoints";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];	
	
}

- (void)passTheGame:(NSString *) loc:(NSString *)loc1:(NSString *)loc2
{
	
	m_remotingCall.method = @"skipGameTurn";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,nil];
	[m_remotingCall start];	
	
}

- (void)isGameCreated:(NSString *) loc
{
	
	m_remotingCall.method = @"getGameCreateStatus";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,nil];
	[m_remotingCall start];	
	
}

- (void)gameCreateFromContact:(NSString *) loc:(NSString *)loc1 :(NSString *)loc2
{
	
	m_remotingCall.method = @"searchByContactNAmeMobile";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,nil];
	[m_remotingCall start];	
	
}

-(void )userEmailCheck:(NSString *)loc
{
	m_remotingCall.method = @"checkUserEmail";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,nil];
	[m_remotingCall start];
	
}

-(void )searchUserFromFB:(NSString *)loc:(NSString *)loc1
{
	m_remotingCall.method = @"searchByFbFriends";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,nil];
	[m_remotingCall start];
	
}


- (void)userRegistration:(NSString *) loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4
{
	
	m_remotingCall.method = @"userRegistration";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,loc3,loc4,nil];
	[m_remotingCall start];	
	
}
-(void )loginFromFB:(NSString *)loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4
{
	m_remotingCall.method = @"userLogRegFb";//@"returnArray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,loc3,loc4,nil];
	[m_remotingCall start];		
	
}

- (void) getProfile :(NSString *)bType
{	
	m_remotingCall.method = @"getProfile";
	m_remotingCall.arguments = [NSArray arrayWithObjects:bType,nil];
	[m_remotingCall start];
}


-(void) updateProfile:(NSString *)userid :(NSString *)email :(NSString *)mobile_no :(NSString *)password
{	
	m_remotingCall.method = @"updateProfile";
	m_remotingCall.arguments = [NSArray arrayWithObjects:userid,email,mobile_no,password,nil];
	
	[m_remotingCall start];
}

-(void)callgetGameChatMethod:(NSString *)gameId:(NSString *)userId
{
	m_remotingCall.method = @"getGameChat";
	m_remotingCall.arguments = [NSArray arrayWithObjects:gameId,userId,nil];
	[m_remotingCall start];
	
}
-(void)callpostGameChatMethod:(NSString *)gameId:(NSString *)uid:(NSString *)chatText:(NSString *)timeStamp
{
	m_remotingCall.method = @"postGameChat";
	m_remotingCall.arguments = [NSArray arrayWithObjects:gameId,uid,chatText,timeStamp,nil];
	[m_remotingCall start];
	
}
-(void)updateGame4Replace:(NSString *)loc:(NSString *)loc1:(NSString *)loc2:(NSMutableArray *)arr1
{
	m_remotingCall.method = @"updateGameReplace";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,arr1,nil];
	[m_remotingCall start];
	
}
-(void )updateGameTrayLetters:(NSString *)loc:(NSString *)loc1:(NSString *)loc2:(NSMutableArray *)arr1
{
	
	m_remotingCall.method = @"updateGameTray";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,loc1,loc2,arr1,nil];
	[m_remotingCall start];
	
	
}

-(void )setFirstLetter:(NSString *)loc:(NSMutableArray *)arr1:(NSMutableArray *)arr2
{
	
	m_remotingCall.method = @"setGameFirstLetters";
	m_remotingCall.arguments = [NSArray arrayWithObjects:loc,arr1,arr2,nil];
	[m_remotingCall start];
	
	
}

#pragma mark -
#pragma mark AMFRemotingCall Delegate methods

- (void)remotingCallDidFinishLoading:(AMFRemotingCall *)remotingCall 
					  receivedObject:(NSObject *)object
{	
	objc_msgSend(m_delegate, @selector(callerDidFinishLoading:receivedObject:), self, object);
}

- (void)remotingCall:(AMFRemotingCall *)remotingCall didFailWithError:(NSError *)error
{		
	
	
	objc_msgSend(m_delegate, @selector(caller:didFailWithError:), self, error);
}

@end