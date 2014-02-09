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
-(void)getPortfolio;
-(void)getCategory;
-(void)getThemByCategoryId:(NSString *)catID;
-(void)getBannerSizeAndId;
-(void)getThemeByCatIdAndSizeId:(NSString*)catId sizeId:(NSString*)sizeId;
-(void)getPreviewBySizeIdAndThemeId:(NSString*)sizeId themeId:(NSString*)themeId;



- (void)saveGameData:(NSMutableArray *) arr :(NSMutableArray *)arr1: (NSMutableArray *)arr2: (NSString *)loc: (NSString *)loc1: (NSString *)loc2: (NSString *)loc3:(NSString *)loc4:(NSString *)loc5:(NSString *)loc6:(NSString *)loc7:(NSMutableArray *) arr3 :(NSMutableArray *)arr4;
- (void)getGameData:(NSString *) loc:(NSString *)loc1;
- (void)checkWords:(NSString *) loc:(NSMutableArray *) loc1;
- (void)userLogin:(NSString *) loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4;
- (void)createPassPlayGame:(NSString *) loc;
- (void)createUserNameGame:(NSString *) loc:(NSString *) loc1;
- (void)yourMove:(NSString *)loc;
- (void)ansGame:(NSString *) loc:(NSString *)loc1;
- (void)theirMove:(NSString *) loc;
- (void)gameMoveEnd:(NSString *) loc;
- (void)quitGame:(NSString *) loc:(NSString *)loc1;
- (void)playerRequestForRandom:(NSString *) loc:(NSString *)loc1;
- (void)getPoints:(NSString *) loc:(NSString *)loc1;
- (void)passTheGame:(NSString *) loc:(NSString *)loc1:(NSString *)loc2;
- (void)isGameCreated:(NSString *) loc;
- (void)gameCreateFromContact:(NSString *) loc:(NSString *)loc1 :(NSString *)loc2;
-(void )userEmailCheck:(NSString *)loc;
- (void)userRegistration:(NSString *) loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4;
-(void )searchUserFromFB:(NSString *)loc:(NSString *)loc1;
-(void )loginFromFB:(NSString *)loc:(NSString *)loc1:(NSString *)loc2:(NSString *)loc3:(NSString *)loc4;
-(void )updateGame4Replace:(NSString *)loc:(NSString *)loc1:(NSString *)loc2:(NSMutableArray *)arr1;
-(void )updateGameTrayLetters:(NSString *)loc:(NSString *)loc1:(NSString *)loc2:(NSMutableArray *)arr1;

-(void )setFirstLetter:(NSString *)loc:(NSMutableArray *)arr1:(NSMutableArray *)arr2;

-(void) getProfile :(NSString *)bType;
-(void) updateProfile:(NSString *)userid :(NSString *)email :(NSString *)mobile_no :(NSString *)password; 

-(void)callgetGameChatMethod:(NSString *)gameId:(NSString *)userId;
-(void)callpostGameChatMethod:(NSString *)gameId:(NSString *)uid:(NSString *)chatText:(NSString *)timeStamp;

//- (void)callReturnFloatMethod;

@end


@protocol AMFCallerDelegate
- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object;
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error;
@end