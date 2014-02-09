//
//  GameInstructionViewController.h
//  BattleTextProject
//
//   Created by freelancer on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "BattleTextAppDelegate.h"
@interface GameInstructionViewController : UIViewController<AMFCallerDelegate,UIWebViewDelegate>
@property (retain, nonatomic) IBOutlet UIWebView *webInstruction;
@property (retain, nonatomic) AMFCaller *m_caller;
@property (retain, nonatomic) NSString  *strGameInstruction;
@property (nonatomic,retain) BattleTextAppDelegate *appDel;
-(void)getGameInstruction;
@end
