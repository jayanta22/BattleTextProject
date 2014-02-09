//
//  LeaderBoardCell.m
//  BattleTextProject
//
//   Created by freelancer on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderBoardCell.h"

@implementation LeaderBoardCell
@synthesize imgViewLB;
@synthesize lblUserNameLB;
@synthesize lblCurrentPointLB;
@synthesize btnChallengeLB;
@synthesize lblGameWonLB;
@synthesize imgViewBackLB;
@synthesize actInd;
@synthesize imgViewUserStatus;
@synthesize lblShotDuration;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        imgViewLB.layer.borderWidth=1.0;
        imgViewLB.layer.borderColor=[UIColor orangeColor].CGColor;
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [imgViewLB release];
    [lblUserNameLB release];
    [lblCurrentPointLB release];
    [btnChallengeLB release];
    [lblGameWonLB release];
    [imgViewBackLB release];
    [actInd release];
    [imgViewUserStatus release];
    [super dealloc];
}
@end
