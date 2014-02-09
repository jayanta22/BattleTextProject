//
//  UIViewController+UICustomController.h
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (UICUstom)
- (void) showHUDTitled : (NSString *) title andSubTitled : (NSString *) subTitle;
- (void) showHUDWithTitle : (NSString *) title;
- (void) showHUD;
- (void) killHUD;
- (BOOL)validateEmail:(NSString *)email;
-(BOOL)isiPhone5;
@end
