//
//  GameHistoryViewController.h
//  BattleTextProject
//
//  Created by Jayanta Das on 19/11/12.
//
//

#import <UIKit/UIKit.h>
#import "BattleTextAppDelegate.h"
#import "AMFCaller.h"
@interface GameHistoryViewController : UIViewController<AMFCallerDelegate>
{

    AMFCaller  *m_caller;
    IBOutlet UITableView *tblGameHistory;
    BattleTextAppDelegate *appDeligate;
    NSMutableArray *arrGameHistory;
    int callFrom;
    NSDictionary *delDictChallengers;
}
@end
