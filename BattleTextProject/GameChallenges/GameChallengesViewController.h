//
//  GameChallengesViewController.h
//  BattleTextProject
//
//  Created by Partha on 07/10/12.
//
//

#import <UIKit/UIKit.h>
#import "BattleTextAppDelegate.h"
#import "AMFCaller.h"

@interface GameChallengesViewController : UIViewController<AMFCallerDelegate>

{
    AMFCaller  *m_caller;
    IBOutlet UITableView *tblViewGameChallenges;
    BattleTextAppDelegate *appDeligate;
    
    int iamfCall;
    
    NSDictionary *dictChallengedUsr;
    
    

}


@end
