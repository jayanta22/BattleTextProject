//
//  GameTokenCell.m
//  BattleTextProject
//
//   Created by freelancer on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTokenCell.h"

@implementation GameTokenCell
@synthesize lblToken;
@synthesize lblPrice;
@synthesize btnBuy;
@synthesize bgImage;
@synthesize lblBuyFor;

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
    [lblToken release];
    [lblPrice release];
    [btnBuy release];
    [bgImage release];
    [super dealloc];
}
@end
