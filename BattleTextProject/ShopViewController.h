//
//  ShopViewController.h
//  BattleTextProject
//
//   Created by freelancer on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "IconDownloader.h"
#import "BattleTextAppDelegate.h"
@interface ShopViewController : UIViewController<AMFCallerDelegate,IconDownloaderDelegate>
{
    BattleTextAppDelegate *appDel;
}
@property (retain, nonatomic) AMFCaller *m_caller;
@property (assign, nonatomic) int callerID;
@property (retain, nonatomic)NSMutableArray *mutArrayOfChances;
@property (retain, nonatomic) IBOutlet UITableView *tblViewShop;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;
- (IBAction)buyCheetahMembershipButtonAction:(id)sender;
-(void)buyChancesLists;
- (IBAction)buyGameTokenButton:(id)sender;
- (IBAction)cheetahUserButtonAction:(id)sender;
- (IBAction)gazelleUserButtonAction:(id)sender;

@end
