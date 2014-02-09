//
//  CustomShopCell.m
//  BattleTextProject
//
//   Created by freelancer on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CustomShopCell.h"

@implementation CustomShopCell
@synthesize lblTitle;
@synthesize btnBuy;
@synthesize lblPrice;
@synthesize txtDesc;
@synthesize imgViewThumb;
@synthesize actInd;

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
    [lblTitle release];
    [btnBuy release];
    [lblPrice release];
    [txtDesc release];
    [imgViewThumb release];
    [actInd release];
    [super dealloc];
}
@end
