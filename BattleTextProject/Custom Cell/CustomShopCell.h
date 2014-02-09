//
//  CustomShopCell.h
//  BattleTextProject
//
//   Created by freelancer on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomShopCell : UITableViewCell

@property (retain, nonatomic) IBOutlet UILabel *lblTitle;
@property (retain, nonatomic) IBOutlet UIButton *btnBuy;
@property (retain, nonatomic) IBOutlet UILabel *lblPrice;
@property (retain, nonatomic) IBOutlet UITextView *txtDesc;
@property (retain, nonatomic) IBOutlet UIImageView *imgViewThumb;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *actInd;
@end
