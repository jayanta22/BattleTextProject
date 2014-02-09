//
//  GameTokenViewController.h
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "IAPHandler.h"
#import "BattleTextAppDelegate.h"
@interface GameTokenViewController : UIViewController<AMFCallerDelegate,ResponseOfProductDelegate>
{
    NSDictionary *selectedDict;
    BattleTextAppDelegate *appDel;
}
@property (retain, nonatomic) IBOutlet UITableView *tblGameToken;
@property (nonatomic, retain)NSMutableArray *totalProduct_Arr;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) NSMutableArray *mutArrayOfToken;
@property (assign, nonatomic) int callerID;
- (IBAction)leaderBoardButtonAction:(id)sender;
- (IBAction)gamePlayButtonAction:(id)sender;
- (IBAction)shopButtonAction:(id)sender;
- (void)getGameToken;
@end
