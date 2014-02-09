//
//  DemoCaller.h
//  CocoaAMF-iPhone
//
//  Created by Marc Bauer on 11.01.09.
//  Copyright 2009 nesiumdotcom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AMFRemotingCall.h"
#import "Reachability.h"

#import "AMFCaller.h"


@protocol AMFCallerDelegate;

@interface AMFCaller : NSObject <AMFRemotingCallDelegate>
{
	AMFRemotingCall *m_remotingCall;
	NSObject <AMFCallerDelegate> *m_delegate;
}

@property (nonatomic, assign) NSObject <AMFCallerDelegate> *delegate;
- (void)userRegistration:(NSString *)loc0:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4;
-(void)getLoginCredentialsUser:(NSString *)username pass:(NSString *)pass :(NSString *)device_token :(NSString *)device_type;
-(void)forgetPassword:(NSString *)email;
-(void)changePassword:(NSString *)user_id Password:(NSString *)pwd;
-(void)inviteFriends:(NSString *)name withEmailID:(NSString *)email;
-(void)getUserDetails:(NSString *)userName;
-(void)getUserList:(NSString *)user_id;
-(void)editUserName:(NSString *)oldUserName andNewUserName:(NSString *)newUserName;
-(void)editEmailID:(NSString *)oldEmailID andUserName:(NSString *)userName;
-(void)getShopItem;
-(void)buyChances:(NSString *)userID;
-(void)getCheetahMembership:(NSString *)userID;
-(void)getGameInstruction;
-(void)getGameToken;
-(void)updateGameChances:(NSString *)user_id getChances:(NSString *)chance gameToken:(NSString *)noOfgametoken;
-(void)updateGameToken:(NSString *)user_id getTokens:(NSString *)token;

-(void)getText;
-(void)submitGameResult:(NSString *)gameId userId:(NSString *)userId withDuration:(NSString *)duration;
-(void)submitSinglePlayerGameResult:(NSString *)userId withDuration:(NSString *)duration;
-(void)getGameChallenges:(NSString *)userID;
-(void)challengeUser:(NSString *)userID chalangedUser:(NSString *)chalangedUserID gameTocken:(NSString *)gameTocken;
-(void)challengeResponse:(NSString *)challengedID response:(NSString*)response;
-(void)getGameBoard:(NSString *)userID;
-(void)enterGameBoard:(NSString *)userID;
-(void)logOutFromApp:(NSString *)userID;
-(void)quitGame:(NSString *)userID gameID:(NSString*)gameID;
-(void)getGameStatusAndChallenges:(NSString *)userID;
-(void)getGameHistory:(NSString *)userID;
-(void)deleteGameHistory:(NSString*)gameID :(NSString *)userID;

-(void)claimprize:(NSString *)userID;
-(void)buymedals:(NSString *)userID;
-(void)acceptPrize:(NSString *)userID;

-(void)facebookLogin:(NSString *)username :(NSString*)fname :(NSString *)lname :(NSString *)email :(NSString *)facebookId :(NSString *)imageLink :(NSString *)device_token :(NSString *)device_type;
@end


@protocol AMFCallerDelegate
- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object;
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error;
@end