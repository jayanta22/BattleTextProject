//
//  BattleTextViewController.h
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "TabToNumberPadController.h"
#import "BattleTextAppDelegate.h"

@interface LoginViewController : UIViewController<AMFCallerDelegate>
{
    BattleTextAppDelegate *appDelegate;
    int amfCallType;
}
@property (nonatomic,retain) IBOutlet UIImageView *bgImage;


@property (retain, nonatomic) IBOutlet UITextField *txtUserNameField;
@property (retain, nonatomic) IBOutlet UITextField *txtPasswordField;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) TabToNumberPadController *tabToNumberPadObj;
@property (retain, nonatomic) UITextField *currentTextField;
@property (nonatomic, retain) NSDictionary *fbDicInfo;


-(IBAction)tapToResignButtonAction:(id)sender;
- (IBAction)forgetButtonAction:(id)sender;
- (IBAction)loginAction:(id)sender;
- (IBAction)faceBookLoginAction:(id)sender;
@end
