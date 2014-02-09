//
//  RegisterViewController.h
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "TabToNumberPadController.h"
#import <FacebookSDK/FacebookSDK.h>

@interface RegisterViewController : UIViewController<AMFCallerDelegate>
@property (retain, nonatomic) IBOutlet UIScrollView *scrollView;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldUserName;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldUserLastName;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldFirstName;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldEmail;
@property (retain, nonatomic) IBOutlet UITextField *txtFieldPass;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) TabToNumberPadController *tabToNumberPadObj;
@property (retain, nonatomic) UITextField *currentTextField;
@property (nonatomic,retain) IBOutlet UIImageView *bgImage;
- (IBAction)registerButtonAction:(id)sender;
- (IBAction)tapToResignAction:(id)sender;
- (IBAction)didTapFaceBookLogin:(id)sender;

@end
