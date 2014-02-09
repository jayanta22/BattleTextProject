//
//  ForgetPasswordViewController.h
//  BattleTextProject
//
//   Created by freelancer on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"

@interface ForgetPasswordViewController : UIViewController<AMFCallerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UILabel *lblPassword;
@property (retain, nonatomic) AMFCaller *m_caller;

- (IBAction)retrievePasswordButtonAction:(id)sender;
- (IBAction)tapToResign:(id)sender;
@end
