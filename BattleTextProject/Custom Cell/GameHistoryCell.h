//
//  LeaderBoardCell.h
//  BattleTextProject
//
//   Created by freelancer on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameHistoryCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imgViewLB;
@property (retain, nonatomic) IBOutlet UILabel *lblUserNameLB;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewBackLB;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@property (nonatomic, retain) IBOutlet UILabel *lblStatus;
@property (nonatomic, retain) IBOutlet UILabel *lblMessage;
@property (nonatomic, retain) IBOutlet UILabel *lblDateOfPlay;
@property (nonatomic, retain) IBOutlet UIButton *btnDeleteGameHistory;
@property (nonatomic, retain) IBOutlet UILabel *lblGameDurationUser;
@property (nonatomic, retain) IBOutlet UILabel *lblGameDurationOponent;
@end
