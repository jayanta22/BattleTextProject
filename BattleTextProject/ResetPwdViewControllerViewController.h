//
//  ResetPwdViewControllerViewController.h
//  BattleTextProject
//
//  Created by Anirban on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "TabToNumberPadController.h"


@interface ResetPwdViewControllerViewController : UIViewController<AMFCallerDelegate>
@property (retain, nonatomic) IBOutlet UITextField *txtOldPwdField;
@property (retain, nonatomic) IBOutlet UITextField *txtNewPwdField;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) TabToNumberPadController *tabToNumberPadObj;
@property (retain, nonatomic) UITextField *currentTextField;

-(IBAction)tapToResignButtonAction:(id)sender;
- (IBAction)resetButtonAction:(id)sender;
@end
