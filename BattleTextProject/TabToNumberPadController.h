//
//  TabToNumberPadController.h
//  BiostatCalculatorApp
//
//   Created by freelancer on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeanController;
@interface TabToNumberPadController : UIView {
    
    MeanController *controller;
    UIButton *btnTab;
    UIButton *btnReset;
    UIButton *btnDone;
    UIImageView *barDivider;
}
@property(nonatomic,retain) MeanController *controller;
@property (nonatomic, retain) IBOutlet UIButton *btnTab;
@property (nonatomic, retain) IBOutlet UIButton *btnReset;
@property (nonatomic, retain) IBOutlet UIButton *btnDone;
- (void)setTransformForCurrentOrientation:(BOOL)animated;
- (void) showModal;
- (void)hideModal;
@property (nonatomic, retain) IBOutlet UIImageView *barDivider;

@end
