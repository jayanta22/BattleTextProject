//
//  BattleTextAppDelegate.h
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import "AMFCaller.h"

@class LoginViewController;
@class UserProfileViewController;
@interface BattleTextAppDelegate : UIResponder <UIApplicationDelegate,AMFCallerDelegate>
{
    int callerID;
    
    NSTimer *callChallengeUser;
    NSTimer *callGameBoardTimer;
    NSMutableArray *arrChallengers;
    
    NSDictionary *dicGameBoard;
    NSDictionary *dictChallengedUsr;
    NSString *strChances;
    NSString *strGameToken;
    UIAlertView *alertGame;
    BOOL isAlertShown;
    
    
    
}

@property (nonatomic, retain)NSDictionary *fbDicInformation;
@property (nonatomic, retain)NSString *m_strDeviceToken;
@property (nonatomic, retain)NSDictionary *dicGameBoard;
@property (nonatomic, retain)NSMutableArray *arrChallengers;
@property (nonatomic, retain) NSString *strChances;
@property (nonatomic, retain) NSString *strGameToken;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UIImageView *imgSplash;
@property (strong, nonatomic) MBProgressHUD *HUD;
@property (strong, nonatomic) LoginViewController *loginviewController;
@property (strong, nonatomic) UserProfileViewController *userProfileviewController;
@property (strong, nonatomic) UINavigationController *navcontroller;
- (NSString *) getDocDirPath;
-(void)getGameChallenges;
-(void)loggedInStartTimer;
-(void)loggedOutStopTimer;
-(void)getGameBoard;
-(void)enterGameBoard;
-(void)quitGame;
@end
