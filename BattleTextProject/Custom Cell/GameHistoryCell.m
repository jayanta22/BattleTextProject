//
//  LeaderBoardCell.m
//  BattleTextProject
//
//   Created by freelancer on 23/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameHistoryCell.h"

@implementation GameHistoryCell
@synthesize imgViewLB;
@synthesize lblUserNameLB;
@synthesize imgViewBackLB;
@synthesize actInd;
@synthesize lblStatus;
@synthesize lblDateOfPlay;
@synthesize btnDeleteGameHistory;
@synthesize lblGameDurationUser;
@synthesize lblGameDurationOponent;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
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
    [imgViewBackLB release];
    [actInd release];
    [lblStatus release];
    [lblGameDurationUser release];
    [lblGameDurationOponent release];
    [super dealloc];
}
@end
