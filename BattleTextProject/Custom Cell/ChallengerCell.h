//
//  LeaderBoardCell.h
//  BattleTextProject
//
//   Created by freelancer on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChallengerCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UIImageView *imgViewLB;
@property (retain, nonatomic) IBOutlet UILabel *lblUserNameLB;
@property (retain, nonatomic) IBOutlet UILabel *lblCurrentPointLB;
@property (retain, nonatomic) IBOutlet UIButton *btnChallengeLB;
@property (retain, nonatomic) IBOutlet UIButton *btnChallengeLBDeny;
@property (retain, nonatomic) IBOutlet UILabel *lblGameWonLB;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewBackLB;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@end
