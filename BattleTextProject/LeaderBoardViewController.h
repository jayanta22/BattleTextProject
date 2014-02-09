//
//  LeaderBoardViewController.h
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "IconDownloader.h"
#import "UserDetailsCC.h"
#import "BattleTextAppDelegate.h"
#import "UserProfileViewController.h"

@interface LeaderBoardViewController : UIViewController<AMFCallerDelegate,IconDownloaderDelegate>
{
   UITextField *challengeToken;
    UserDetailsCC *obj;
    BattleTextAppDelegate *appDel;
}
@property (retain, nonatomic) IBOutlet UIView *viewLeaderBoard;
@property (retain, nonatomic) IBOutlet UITableView *tblLeaderBoard;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) NSMutableArray *mutArrOfUserList;
@property (retain, nonatomic) NSMutableArray *mutArrOfcheetahList;
@property (retain, nonatomic) NSMutableArray *mutArrOfgazelleList;
@property (retain, nonatomic) NSMutableArray *mutArrOfchallengeList;
@property (retain, nonatomic) IBOutlet UIButton *allButton;
@property (retain, nonatomic) IBOutlet UIButton *cheetahButton;
@property (retain, nonatomic) IBOutlet UIButton *gazelleButton;
@property (retain, nonatomic) IBOutlet UIButton *challengedUserButton;
@property (retain, nonatomic) IBOutlet UIView *viewSegment;
@property (assign, nonatomic) int currentButonTag;
@property (retain, nonatomic) IBOutlet UITextView *txtViewDetails;
@property (assign, nonatomic) int callerID;
@property (assign, nonatomic) int tblID;
@property (nonatomic, retain) NSMutableDictionary *imageDownloadsInProgress;



- (void)appImageDidLoad:(NSIndexPath *)indexPath;
- (IBAction)allUserButtonAction:(id)sender;
- (IBAction)cheetahUserButtonAction:(id)sender;
- (IBAction)gazelleUserButtonAction:(id)sender;
- (IBAction)challengedUserButtonAction:(id)sender;
- (IBAction)buyGameTOkenAction:(id)sender;
- (void)appImageDidLoad:(NSIndexPath *)indexPath;
-(void)getUserList;
-(void)getViewFrame:(UIButton *)btn;
-(void)challengedUserAction:(id)sender;
-(UIImage *)getImagenameByUserStatus:(int)playerStatus;
@end
