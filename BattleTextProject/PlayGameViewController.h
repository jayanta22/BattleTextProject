//
//  PLayGameViewController.h
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AMFCaller.h"
#import "JHTickerView.h"
#import "BattleTextAppDelegate.h"
#import <AVFoundation/AVFoundation.h>
@interface PlayGameViewController : UIViewController<AMFCallerDelegate,AVAudioPlayerDelegate >

{
    UILabel *stopWatchLabel;
    
    NSTimer *stopWatchTimer; // Store the timer that fires after a certain time
    NSDate *startDate; // Stores the date of the click on the start button
    
    UITextView *txtViewUserInput;
    int callerID;
    
    JHTickerView *ticker;
    
    NSString *gameString;
    NSString *compareString;
    
    int indexOFText;
    BattleTextAppDelegate *appDelegate;
    
    int callFrom;
    NSString *strGameToken;
    float initialSpeed;
    
    BOOL isQuit;
    
    

}
@property int callFrom;
@property (nonatomic, retain) IBOutlet  UITextView *txtViewUserInput;
@property (nonatomic, retain) IBOutlet UILabel *stopWatchLabel;
@property (nonatomic, retain) IBOutlet UILabel *userNameLbl;
@property (nonatomic, retain) IBOutlet UILabel *userGameToken;
@property (nonatomic, retain) IBOutlet UIImageView *imageUserGroup;

@property (retain, nonatomic) AMFCaller *m_caller;
@property (nonatomic, retain)NSString *gameString;
@property (nonatomic, retain) NSString  *compareString;
@property BOOL isChallengedUser;

- (void)startTimer;
-(void)stopTimer;
- (void)getTextFromAMF;
-(void)submitGameResult:(NSString *)gameId userId:(NSString *)userId withDuration:(NSString *)duration;
-(void)getGameChallenges:(NSString *)userID;

-(void)instructionPageButtonAction:(id)sender;
@end
