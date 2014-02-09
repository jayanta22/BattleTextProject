//
//  CustomNavigatioBarViewController.h
//  BattleTextProject
//
//  Created by Partha on 09/10/12.
//
//

#import <UIKit/UIKit.h>

#import "BattleTextAppDelegate.h"
#import "AMFCaller.h"
@class CustomBadge;
@interface CustomNavigatioBarViewController : UIViewController<AMFCallerDelegate>
{
    
    NSDictionary *dictChallengedUsr;
     NSMutableArray *arrChallengers;
    
    NSTimer *callChallengeUser;
    AMFCaller *m_caller;
    
    int callerID;
    CustomBadge *customBadge;
    BattleTextAppDelegate *appDeligate;


}
@property (nonatomic, retain) BattleTextAppDelegate *appDeligate;
@property (nonatomic, retain)AMFCaller *m_caller;
@property (nonatomic, retain)CustomBadge *customBadge;
@property int callerID;
@end
