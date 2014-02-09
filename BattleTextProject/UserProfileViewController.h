//
//  UserProfileViewController.h
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "CustomNavigatioBarViewController.h"

@interface UserProfileViewController : CustomNavigatioBarViewController<AMFCallerDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

//BattleTextAppDelegate *appDeligate;
    UIImageView *userProfileImage;
   IBOutlet UIButton *btnChalllengs;
    
    IBOutlet UIImageView *imgClaimPrize;
    IBOutlet UILabel *lblClaimPrize;
    BOOL isImageUpload;
}

@property (retain, nonatomic) IBOutlet UILabel *lblUserName;
@property (retain, nonatomic) IBOutlet UILabel *lblWeeklyScore;
@property (retain, nonatomic) IBOutlet UILabel *lblPrizeAmount;
@property (retain, nonatomic) IBOutlet UILabel *lblGameToken;
@property (retain, nonatomic) IBOutlet UILabel *lblFirstName;
@property (retain, nonatomic) IBOutlet UILabel *lblLastName;
@property (retain, nonatomic) IBOutlet UILabel *lblEmailID;
@property (retain, nonatomic) IBOutlet UILabel *lblGameChances;
//@property (retain, nonatomic) AMFCaller *m_caller;
@property (assign, nonatomic) int amfCount;
@property (retain, nonatomic) NSString *updatedValue;
@property (retain, nonatomic) IBOutlet UIImageView *ImgUserPics;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewEditEmail;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewUserGroup;
@property (retain, nonatomic) IBOutlet UIButton *btnAddEdit;

- (IBAction)leaderBoardButtonAction:(id)sender;
- (IBAction)buyGameTokenButtonAction:(id)sender;
- (IBAction)inviteFriendsAction:(id)sender;
- (IBAction)instructionButtonAction:(id)sender;
- (IBAction)editUserNameAction:(id)sender;
- (IBAction)editUserEmailAction:(id)sender;
- (IBAction)addEditImageButtonAction:(id)sender;
- (IBAction)gameHistoryButtonAction:(id)sender;
- (IBAction)claimPrizeButtonAction:(id)sender;
-(IBAction)callGameChallengers:(id)sender;
- (void)getUserDescription;
- (void)setUserImage:(NSString *)link;
- (void)didSelectImageToUpload;
-(void)playButtonAction:(id)sender;


@end
