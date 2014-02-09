//
//  ClaimPrizeViewController.h
//  BattleTextProject
//
//  Created by Jayanta Das on 28/11/12.
//
//

#import <UIKit/UIKit.h>
#import "BattleTextAppDelegate.h"
#import "AMFCaller.h"

@interface ClaimPrizeViewController : UIViewController<AMFCallerDelegate>
{

    AMFCaller  *m_caller;
    BattleTextAppDelegate *appDeligate;
    
    
    
    IBOutlet UILabel *lblGameToken;
    IBOutlet UILabel *lblMedal;
    IBOutlet UILabel *lblChances;
    int amfcallType;
    
    UIView *topView;
    
}
-(IBAction)btnActionAcceptPrize:(id)sender;

@end
