//
//  GameTokenCell.h
//  BattleTextProject
//
//   Created by freelancer on 16/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GameTokenCell : UITableViewCell
@property (retain, nonatomic) IBOutlet UILabel *lblToken;
@property (retain, nonatomic) IBOutlet UILabel *lblPrice;
@property (retain, nonatomic) IBOutlet UILabel *lblBuyFor;
@property (retain, nonatomic) IBOutlet UIButton *btnBuy;
@property (nonatomic, retain) IBOutlet UIImageView *bgImage;

@end
