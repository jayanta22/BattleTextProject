//
//  InviteFriendsViewController.h
//  BattleTextProject
//
//   Created by freelancer on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "TabToNumberPadController.h"
@interface InviteFriendsViewController : UIViewController<AMFCallerDelegate>

@property (retain, nonatomic) IBOutlet UITextField *txtEmail;
@property (retain, nonatomic) IBOutlet UILabel *lblPassword;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) IBOutlet UITextField *txtName;
@property (retain, nonatomic) TabToNumberPadController *tabToNumberPadObj;
@property (retain, nonatomic) UITextField *currentTextField;

- (IBAction)invitedFriendsEmailid:(id)sender;
- (IBAction)tapToResign:(id)sender;


@end
