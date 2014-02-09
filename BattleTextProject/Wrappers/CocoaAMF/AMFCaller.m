//
//  DemoCaller.m
//  CocoaAMF-iPhone
//
//  Created by Marc Bauer on 11.01.09.
//  Copyright 2009 nesiumdotcom. All rights reserved.
//

#import "AMFCaller.h"
#import <objc/message.h>
#define BASE_URL @"http://mybattletext.com/battletest/amfphp/gateway.php"
/* Live URL
http://mybattletext.com/amfphp/gateway.php
*/
/*Demo URL
 
 http://mybattletext.com/battletest/amfphp/gateway.php
 */

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

			break;
		}
		case ReachableViaWWAN:
		{			
			if (self == [super init])
			{
                
				m_remotingCall = [[AMFRemotingCall alloc] init];
				m_remotingCall.URL = [NSURL URLWithString:BASE_URL];// //
				m_remotingCall.service = @"battle";
				m_remotingCall.delegate = self;
				m_delegate = nil;
			}
			
						
			break;
		}
		case ReachableViaWiFi:
		{
			if (self == [super init])
			{
				m_remotingCall = [[AMFRemotingCall alloc] init];
				
				m_remotingCall.URL = [NSURL URLWithString:BASE_URL];// //http://mindriderstech.com/battletext/amfphp/gateway.php
				
				m_remotingCall.service = @"battle";
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
-(void)getLoginCredentialsUser:(NSString *)username pass:(NSString *)pass :(NSString *)device_token :(NSString *)device_type
{
    m_remotingCall.method = @"appUserLogin";
    m_remotingCall.arguments = @[username,pass,device_token,device_type];//@"returnArray";
	[m_remotingCall start];	
}

- (void)userRegistration:(NSString *) loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4
{
    
    NSLog(@": %@ : %@ :%@ :%@ :%@",loc,loc1,loc2,loc3,loc4);
	
	m_remotingCall.method = @"appUserRegister";//@"returnArray";
	m_remotingCall.arguments = @[loc,loc1,loc2,loc3,loc4];
	[m_remotingCall start];	
	
}

-(void)getUserDetails:(NSString *)userName
{
    m_remotingCall.method = @"getUserDescription";//@"returnArray";
	m_remotingCall.arguments = @[userName];
	[m_remotingCall start];	

    
}

-(void)forgetPassword:(NSString *)email{
    
    NSLog(@": %@",email);
	
	m_remotingCall.method = @"forgotPassword";//@"returnArray";
	m_remotingCall.arguments =@[email] ;
	[m_remotingCall start];	

    
}

-(void)changePassword:(NSString *)user_id Password:(NSString *)pwd{
    
    m_remotingCall.method = @"changePassword";//@"returnArray";
	m_remotingCall.arguments =@[user_id,pwd] ;
	[m_remotingCall start];	
    
}

-(void)getUserList:(NSString *)user_id{
    
    
    m_remotingCall.method = @"getUserList";//@"returnArray";
	m_remotingCall.arguments =@[user_id] ;
	[m_remotingCall start];	
    
}

-(void)editUserName:(NSString *)oldUserName andNewUserName:(NSString *)newUserName{
    
    m_remotingCall.method = @"editUserName";//@"returnArray";
	m_remotingCall.arguments =@[oldUserName,newUserName] ;
	[m_remotingCall start];	

    
}
-(void)editEmailID:(NSString *)oldEmailID andUserName:(NSString *)userName{
    
    m_remotingCall.method = @"editUserEmailId";//@"returnArray";
	m_remotingCall.arguments =@[userName,oldEmailID] ;
	[m_remotingCall start];	

    
}

-(void)inviteFriends:(NSString *)name withEmailID:(NSString *)email{
    
    m_remotingCall.method = @"inviteFriendbyEmail";//@"returnArray";
	m_remotingCall.arguments = @[name,email];
	[m_remotingCall start];	
    
}

-(void)buyChances:(NSString *)userID{
    
    m_remotingCall.method = @"buyChances";//@"returnArray";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];	
    
}

-(void)getShopItem{
    
    m_remotingCall.method = @"getShopItems";//@"returnArray";
    m_remotingCall.arguments =@[] ;
	[m_remotingCall start];	
    
}

-(void)getCheetahMembership:(NSString *)userID{
    
    m_remotingCall.method = @"cheetahMembership";//@"returnArray";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];	
    
}
-(void)getGameInstruction{
    
    m_remotingCall.method = @"getGameInstruction";//@"returnArray";
    m_remotingCall.arguments =@[] ;
	[m_remotingCall start];	
    
}

-(void)getGameToken{
    
    m_remotingCall.method = @"getGameToken";//@"returnArray";
    m_remotingCall.arguments =@[] ;
	[m_remotingCall start];	
}

-(void)updateGameChances:(NSString *)user_id getChances:(NSString *)chance gameToken:(NSString *)noOfgametoken{
    
    m_remotingCall.method = @"updateChances";//@"returnArray";
	m_remotingCall.arguments =@[user_id,chance,noOfgametoken] ;
	[m_remotingCall start];	

}
-(void)updateGameToken:(NSString *)user_id getTokens:(NSString *)token{
    
    m_remotingCall.method = @"updateGameToken";//@"returnArray";
	m_remotingCall.arguments =@[user_id,token] ;
	[m_remotingCall start];	

    
}

-(void)getText
{

    m_remotingCall.method = @"getBattleText";//@"returnArray";
    m_remotingCall.arguments =@[] ;
	[m_remotingCall start];

}

-(void)claimprize:(NSString *)userID
{
    m_remotingCall.method = @"claimprize";//@"returnArray";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];

}
-(void)submitGameResult:(NSString *)gameId userId:(NSString *)userId withDuration:(NSString *)duration
{
    
    NSLog(@"submitGameResult gameId %@ userId %@  duration %@",gameId,userId,duration);
    m_remotingCall.method = @"submitGameResult";
	m_remotingCall.arguments =@[gameId,userId,duration] ;
	[m_remotingCall start];

}
-(void)submitSinglePlayerGameResult:(NSString *)userId withDuration:(NSString *)duration
{
    NSLog(@"submitGameResult  userId %@  duration %@",userId,duration);
    m_remotingCall.method = @"submitSinglePlayerGameResult";
	m_remotingCall.arguments =@[userId,duration] ;
	[m_remotingCall start];

}
-(void)getGameChallenges:(NSString *)userID
{
    m_remotingCall.method = @"getGameChallenges";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];


}
-(void)challengeUser:(NSString *)userID chalangedUser:(NSString *)chalangedUserID gameTocken:(NSString *)gameTocken{
    m_remotingCall.method = @"challengeUser";
	m_remotingCall.arguments =@[userID,chalangedUserID,gameTocken] ;
	[m_remotingCall start];

}

-(void)challengeResponse:(NSString *)challengedID response:(NSString*)response
{

    m_remotingCall.method = @"challengeResponse";
	m_remotingCall.arguments =@[challengedID,response] ;
	[m_remotingCall start];

}
-(void)getGameBoard:(NSString *)userID
{
    m_remotingCall.method = @"getGameStatus";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];

}

-(void)enterGameBoard:(NSString *)userID
{

    m_remotingCall.method = @"enterGameBoard";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];

}
-(void)logOutFromApp:(NSString *)userID
{
    m_remotingCall.method = @"appUserLogout";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];

}
-(void)quitGame:(NSString *)userID gameID:(NSString*)gameID
{
    m_remotingCall.method = @"quitGame";
	m_remotingCall.arguments =@[userID,gameID] ;
	[m_remotingCall start];

}
-(void)getGameStatusAndChallenges:(NSString *)userID
{
    m_remotingCall.method = @"getGameStatusAndChallenges";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];
}
-(void)getGameHistory:(NSString *)userID
{

    m_remotingCall.method = @"getGameHistory";
	m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];
}
-(void)deleteGameHistory:(NSString*)gameID :(NSString *)userID
{
    m_remotingCall.method = @"deleteGameHistory";
	m_remotingCall.arguments =@[gameID,userID] ;
	[m_remotingCall start];

}
-(void)buymedals:(NSString *)userID
{
    m_remotingCall.method = @"buymedals";
    m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];
}
-(void)acceptPrize:(NSString *)userID
{
    m_remotingCall.method = @"acceptprize";
    m_remotingCall.arguments =@[userID] ;
	[m_remotingCall start];

}

-(void)facebookLogin:(NSString *)username :(NSString *)fname :(NSString *)lname :(NSString *)email :(NSString *)facebookId :(NSString *)imageLink :(NSString *)device_token :(NSString *)device_type
{

    m_remotingCall.method = @"facebookLogin";
	m_remotingCall.arguments =@[username,fname,lname,email,facebookId,imageLink,device_token,device_type] ;
	[m_remotingCall start];
}
#pragma mark -
#pragma mark AMFRemotingCall Delegate methods

- (void)remotingCallDidFinishLoading:(AMFRemotingCall *)remotingCall 
					  receivedObject:(NSObject *)object
{	if(m_delegate)
	objc_msgSend(m_delegate, @selector(callerDidFinishLoading:receivedObject:), self, object);
}

- (void)remotingCall:(AMFRemotingCall *)remotingCall didFailWithError:(NSError *)error
{		
	
	
	objc_msgSend(m_delegate, @selector(caller:didFailWithError:), self, error);
}

@end