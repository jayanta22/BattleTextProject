//
//  PLayGameViewController.m
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PlayGameViewController.h"
#import "BattleTextAppDelegate.h"
#import "UserProfileViewController.h"
#import "GameInstructionViewController.h"


@interface PlayGameViewController ()

@end

@implementation PlayGameViewController
@synthesize stopWatchLabel;
@synthesize txtViewUserInput;
@synthesize m_caller;
@synthesize gameString;
@synthesize compareString;
@synthesize userNameLbl;
@synthesize isChallengedUser;
@synthesize callFrom;
@synthesize userGameToken;
@synthesize imageUserGroup;
#define MAX_SPEED 200.0


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isQuit=NO;
    //[self canPerformAction:nil withSender:txtViewUserInput];
    //  [txtViewUserInput removeGestureRecognizer:<#(UIGestureRecognizer *)#>]
    for (UIGestureRecognizer *g in txtViewUserInput.gestureRecognizers)
    {
        if ([g isKindOfClass:[UITapGestureRecognizer class]] || [g isKindOfClass:[UILongPressGestureRecognizer class]])
        {
            g.enabled=NO;
        }
    }
    //txtViewUserInput.userInteractionEnabled=NO;
    stopWatchLabel.textColor=[UIColor colorWithRed:195.0/255.0 green:137.0/255.0 blue:79.0/255.0 alpha:1.0];
    // stopWatchLabel.font=[UIFont boldSystemFontOfSize:21.0];
    userGameToken.textColor=[UIColor colorWithRed:255.0/255.0 green:133.0/255.0 blue:5.0/255.0 alpha:1.0];
    userGameToken.font=[UIFont boldSystemFontOfSize:15.0];
    userNameLbl.font=[UIFont boldSystemFontOfSize:16.0];
    
    appDelegate=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];
    self.title=@"Play Battle Text";
    //[self.navigationItem setHidesBackButton:YES];
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc] initWithTitle:@"Quit" style:UIBarButtonItemStylePlain target:self action:@selector(quitGameBoard)];
    //self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"btn_info.png"] style:UIBarButtonItemStylePlain target:self action:@selector(instructionPageButtonAction:)];
    UIButton *button =  [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame=CGRectMake(0, 0, 50 , 50);
    [button setImage:[UIImage imageNamed:@"btn_info.png"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(instructionPageButtonAction:)
     forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButton = [[UIBarButtonItem alloc]
                                  initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = barButton;
    
    [barButton release];
    
    NSLog(@"callFromcallFrom %d isChallengedUser %d",callFrom,isChallengedUser);
    
    
    [self showHUD];
    
    if(callFrom==1)
    {
        [self getTextFromAMF];
        
    }
    else //if (!isChallengedUser)
    {
        [self enterGameBoard];
        
        
        
    }
    
    NSLog(@"kGroupID %@",kGroupID);
    
    if (!isChallengedUser)
    {
        
    }
    userNameLbl.text=kUserName;
    
    userGameToken.text=[NSString stringWithFormat:@"%@ token",kGameToken];
    
    if([kGroupID integerValue]==1)
        imageUserGroup.image=[UIImage imageNamed:@"icon_gazzle@2x.png"];
    else if([kGroupID integerValue]==2)
        imageUserGroup.image=[UIImage imageNamed:@"icon_cheetah@2x.png"];
    
    
    
    
    // Do any additional setup after loading the view from its nib.
}
-(void)instructionPageButtonAction:(id)sender
{
    GameInstructionViewController *controller=[[GameInstructionViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    
}
-(void)quitGameBoard
{
    
    
    if(callFrom==1)
    {
        isQuit=YES;
        
        
        [self submitSinglePlayerGameResult:kUserID withDuration:stopWatchLabel.text];
        
        
    }
    else
    {
        // [self performSelector:@selector(getGameStatusAndChallenges) withObject:nil afterDelay:1.0];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(getGameStatusAndChallenges) object: nil];
        
        
        callerID=108;
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        [m_caller quitGame:kUserID gameID:appDelegate.dicGameBoard[@"game_id"]];
        // [appDelegate quitGame];
    }
    
    
    
}
-(void)viewDidDisappear:(BOOL)animated
{
    //[appDelegate quitGame];
    
}
-(void)enterGameBoard
{
    callerID=5;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller enterGameBoard:kUserID];
    
}
-(void)getGameStatusAndChallenges
{
    [self showHUD];
    callerID=4;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameStatusAndChallenges:kUserID];
    
    
}
-(void)getGameChallenges:(NSString *)userID
{
    callerID=3;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameChallenges:userID];
    
    
    
    
}
- (void)getTextFromAMF{
    if(ticker)
        [ticker removeFromSuperview];
    initialSpeed=40.0f;
    if([self isiPhone5])
    {
        ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 150, 202, 50)];
        
    }
    else
    {
        ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 138, 202, 50)];
    }
    [ticker setDirection:JHTickerDirectionLTR];
    ticker.backgroundColor=[UIColor clearColor];
    [self.view addSubview:ticker];
    callerID=1;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getText];
    
    // [self showHUD];
    
    
}
#pragma mark
#pragma mark amf delegate
#pragma mark


#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    
    
    if(callerID==1){
        
        
        self.gameString=(NSString *)object;
        NSArray *tickerStrings = [self.gameString componentsSeparatedByString:@"|"];
        [ticker setTickerStrings:@[tickerStrings[0]]];
        [ticker setTickerSpeed:initialSpeed];
        [ticker start];
        [self startTimer];
        [self killHUD];
        
        [txtViewUserInput  becomeFirstResponder];
    }
    else if(callerID==2){
        
        NSArray *arr=(NSArray*)object;
        NSDictionary *dic = arr[0];
        NSLog(@"submit  object   %@",object);
        [self killHUD];
        if([dic[@"errorcode"] intValue]==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Game Result" message:dic[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            alert.tag=111;
            
            [alert show];
            [alert release];
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Game Result" message:dic[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            alert.tag=111;
            
            [alert show];
            [alert release];
        }
        
    }
    else if(callerID==3){
        
        
        NSDictionary *dic = (NSDictionary*)object;
        // NSDictionary *dic=[arrResult objectAtIndex:0];
        if([dic[@"errorcode"] intValue]==1)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Challanged User" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
        else
        {
            // NSArray *arrResult = (NSArray*)object;
            
            NSDictionary *dic=(NSDictionary*)object;
            NSLog(@"arrResult %@",dic);
            if([dic[@"errorcode"] intValue]==0)
            {
                NSArray *arrChallangers=dic[@"challenges"];
                NSLog(@"arrChallangers %@",arrChallangers);
                
            }
        }
        //[self getTextFromAMF];
        [self killHUD];
    }
    else if(callerID==4)
    {
        
        // self.gameString=[appDelegate.dicGameBoard objectForKey:@"battletext"];
        NSLog(@"callerIDcallerIDcallerID %@  %d",object,callerID);
        
        if([object isKindOfClass:[NSDictionary class]])
        {
            NSDictionary *dic = (NSDictionary*)object;
            if (![dic[@"game_status"][@"errorcode"] intValue]==1) {
                NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);
                
                
                if(appDelegate.dicGameBoard)
                {
                    [appDelegate.dicGameBoard release];
                    appDelegate.dicGameBoard=nil;
                }
                
                appDelegate.dicGameBoard=dic[@"game_status"];
                [appDelegate.dicGameBoard retain];
                
                //            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@", [[appDelegate.dicGameBoard     objectForKey:@"opponent"] objectForKey:@"first_name"]] message:[appDelegate.dicGameBoard objectForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                //            alert.tag=101;
                //
                //            [alert show];
                //            [alert release];
                //([[appDelegate.dicGameBoard objectForKey:@"msg"] isEqualToString:@"Opponent Player has accepted your request"]||[[appDelegate.dicGameBoard objectForKey:@"msg"] isEqualToString:@"both the player in to the game board"])
                
                if([(appDelegate.dicGameBoard)[@"status"] intValue]==3)
                {
                    if(ticker)
                        [ticker removeFromSuperview];
                    initialSpeed=50.0f;
                    if([self isiPhone5])
                    {
                        ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 150, 202, 50)];
                        
                    }
                    else
                    {
                        ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 138, 202, 50)];
                    }
                    [ticker setDirection:JHTickerDirectionLTR];
                    ticker.backgroundColor=[UIColor clearColor];
                    [self.view addSubview:ticker];
                    self.gameString=(appDelegate.dicGameBoard)[@"battletext"];
                    NSArray *tickerStrings = [self.gameString  componentsSeparatedByString:@"|"];
                    [ticker setTickerStrings:@[tickerStrings[0]]];
                    [ticker setTickerSpeed:initialSpeed];
                    [ticker start];
                    
                    [self killHUD];
                    [self startTimer];
                    [txtViewUserInput  becomeFirstResponder];
                    
                }
                else
                {
                    
                    [self performSelector:@selector(getGameStatusAndChallenges) withObject:nil afterDelay:1.0];
                }
                
                
                
            }
            [self killHUD];
        }
        
        
        
    }
    else if(callerID==5)
    {
        
        NSLog(@"callerIDcallerIDcallerID %@  %d",object,callerID);
        NSArray *arr=(NSArray *)object;
        NSDictionary *dict=arr[0];
        if([dict[@"msg"] isEqualToString:@"Player2 entered the Game Board"] || [dict[@"msg"] isEqualToString:@"Player1 entered the Game Board"] || [dict[@"msg"] isEqualToString:@"Player1 could not join the Game Board"] || [dict[@"msg"] isEqualToString:@"Player2 could not join the Game Board"])
        {
            NSArray *tickerStrings = @[@"Please wait for your opponent to enter the game"];
            if(ticker)
                [ticker removeFromSuperview];
            initialSpeed=50.0f;
            if([self isiPhone5])
            {
                ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 150, 202, 50)];
                
            }
            else
            {
                ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 138, 202, 50)];
            }
            [ticker setDirection:JHTickerDirectionLTR];
            ticker.backgroundColor=[UIColor clearColor];
            [self.view addSubview:ticker];
            [ticker setTickerStrings:tickerStrings];
            [ticker setTickerSpeed:initialSpeed];
            [ticker start];
            [self performSelector:@selector(getGameStatusAndChallenges) withObject:nil afterDelay:0.0];
        }
        else
        {
            NSLog(@"callerIDcallerIDcallerID %@  %d",object,callerID);
            
        }
        
    }
    else if(callerID==1001)
    {
        if(!isQuit)
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Game result submitted" message:@"" delegate:self cancelButtonTitle:@"Play again now!" otherButtonTitles:@"Cancel", nil];
            alert.tag=10002;
            [alert show];
            [alert release];
            isQuit=NO;
            
        }
        else {
            
            for (UIViewController *obj in [self.navigationController viewControllers]) {
                if([obj isKindOfClass:[UserProfileViewController class]])
                {
                    [self.navigationController popToViewController:obj animated:YES];
                    break;
                }
            }
            
            [self killHUD];
        }
        
    }
    else if (callerID==108)
    {
        
        NSLog(@"GAME QUIT %@",object);
        
        
        for (UIViewController *obj in [self.navigationController viewControllers])
        {
            if([obj isKindOfClass:[UserProfileViewController class]])
            {
                [self.navigationController popToViewController:obj animated:YES];
                break;
            }
        }
        
        
    }
    [self killHUD];
    
}


- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
}



- (void)updateTimer
{
    NSDate *currentDate = [NSDate date];
    NSTimeInterval timeInterval = [currentDate timeIntervalSinceDate:startDate];
    NSDate *timerDate = [NSDate dateWithTimeIntervalSince1970:timeInterval];
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"mm:ssSS"];
    [dateFormatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:0.0]];
    NSString *timeString=[dateFormatter stringFromDate:timerDate];
    stopWatchLabel.text = timeString;
    [dateFormatter release];
}
- (void)startTimer{
    startDate = [[NSDate date]retain];
    // Create the stop watch timer that fires every 10 ms
    stopWatchTimer = [NSTimer scheduledTimerWithTimeInterval:1.0/10.0
                                                      target:self
                                                    selector:@selector(updateTimer)
                                                    userInfo:nil
                                                     repeats:YES];
}

- (void)stopTimer{
    [stopWatchTimer invalidate];
    stopWatchTimer = nil;
    [self updateTimer];
    [ticker removeFromSuperview];
}


- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
{
    
    return YES;
    
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView
{
    
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView;
{
    
    indexOFText=0;
    self.compareString=[self.gameString componentsSeparatedByString:@"|"][indexOFText];
    
}
- (void)textViewDidEndEditing:(UITextView *)textView
{
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    BOOL booltest;
    NSLog(@"texttt %@  lenght %d  range.length %d  range.location %d",text,[textView.text length],range.length,range.location && ([[self.gameString componentsSeparatedByString:@"|"] count]-1>indexOFText));
    if([self.compareString length]-1==[textView.text length] && [self compareString:[textView.text length] withString:text])
        txtViewUserInput.text=@"";
    booltest= [self compareString:[textView.text length] withString:text];
    return booltest;
}
- (void)textViewDidChange:(UITextView *)textView
{
}
- (void)textViewDidChangeSelection:(UITextView *)textView
{
}
-(BOOL)compareString:(int)atindext withString:(NSString *)str
{
    NSLog(@"self.compareString %@  strstr %@",self.compareString,str);
    NSString * newString;
    if([self.compareString length]-1>atindext)
    {
        newString =  [self.compareString substringWithRange:NSMakeRange(atindext, 1)];
        return [[newString capitalizedString] isEqualToString:[str capitalizedString]];
        //return [newString isEqualToString:str];
    }
    else if([self.compareString length]-1==atindext && ([[self.gameString componentsSeparatedByString:@"|"] count]-1>indexOFText))
    {
        newString =  [self.compareString substringWithRange:NSMakeRange(atindext, 1)];
        if([[newString capitalizedString] isEqualToString:[str capitalizedString]])
        {
            [self playAudio];
            txtViewUserInput.text=@"";
            indexOFText=indexOFText+1;
            [ticker removeFromSuperview];
            if([self isiPhone5])
            {
                ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 150, 202, 50)];
                
            }
            else
            {
                ticker = [[JHTickerView alloc] initWithFrame:CGRectMake(75, 138, 202, 50)];
            }
            [ticker setDirection:JHTickerDirectionLTR];
            ticker.backgroundColor=[UIColor clearColor];
            [self.view addSubview:ticker];
            
            
            NSArray *tickerStrings = [self.gameString  componentsSeparatedByString:@"|"];
            [ticker setTickerStrings:@[@""]];
            [ticker setTickerStrings:@[tickerStrings[indexOFText]]];
            NSLog(@"initialSpeed + 20.0f %f",initialSpeed + 20.0f);
            initialSpeed=initialSpeed + MAX_SPEED/[tickerStrings count];
            [ticker setTickerSpeed:initialSpeed];
            [ticker start];
            
            self.compareString=[self.gameString componentsSeparatedByString:@"|"][indexOFText];
            return [[newString capitalizedString] isEqualToString:[str capitalizedString]];
            
        }
        return [[newString capitalizedString] isEqualToString:[str capitalizedString]];
    }
    
    else
    {
        
        
        
        txtViewUserInput.text=@"";
        NSLog(@"submitgameeeee");
        [self stopTimer];
        [txtViewUserInput resignFirstResponder];
        [self playAudio];
        if(callFrom==1)
        {
            
            NSArray *arr=[stopWatchLabel.text componentsSeparatedByString:@":"];
            float sec=(float)([arr[0] intValue]*600000 + [arr[1] intValue])/1000;
            NSLog(@"time estimate %.3f  %d   %d",sec,[arr[0] intValue],[arr[1] intValue]);
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Game Over" message:[NSString stringWithFormat:@"Totla Time Played:%@ min",stopWatchLabel.text] delegate:self cancelButtonTitle:@"Submit Score" otherButtonTitles:@"Cancel", nil];
            alert.tag=10001;
            [alert show];
            [alert release];
            
            
        }
        else
        {
            NSArray *arr=[stopWatchLabel.text componentsSeparatedByString:@":"];
            float sec=(float)([arr[0] intValue]*600000 + [arr[1] intValue])/1000;
            NSLog(@"stopWatchLabel.text %@ time estimate %.3f  %d   %d",stopWatchLabel.text,sec,[arr[0] intValue],[arr[1] intValue]);
            [self submitGameResult:(appDelegate.dicGameBoard)[@"game_id"] userId:kUserID withDuration:stopWatchLabel.text];//[NSString stringWithFormat:@"%.3f",sec]
            
        }
        
        // }
        
        
        return NO;
    }
    
}
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    UIMenuController *menuController = [UIMenuController sharedMenuController];
    if (menuController) {
        [UIMenuController sharedMenuController].menuVisible = NO;
    }
    [UIMenuController sharedMenuController].menuVisible = NO;
    if (action == @selector(paste:))
        return NO;
    if (action == @selector(select:))
        return NO;
    if (action == @selector(selectAll:))
        return NO;
    if (action == @selector(cut:))
        return NO;
    
    
    return [txtViewUserInput canPerformAction:action withSender:sender];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag==10001)
    {
        if(buttonIndex==0)
        {
            NSArray *arr=[stopWatchLabel.text componentsSeparatedByString:@":"];
            float sec=(float)([arr[0] intValue]*600000 + [arr[1] intValue])/1000;
            NSLog(@"stopWatchLabel.text %@ time estimate %.3f  %d   %d",stopWatchLabel.text,sec,[arr[0] intValue],[arr[1] intValue]);
            [self submitSinglePlayerGameResult:kUserID withDuration:stopWatchLabel.text];//[NSString stringWithFormat:@"%.3f",sec]
            
            
        }
        else{
            
            isQuit=YES;
            
            
            [self submitSinglePlayerGameResult:kUserID withDuration:stopWatchLabel.text];
            
        }
        
    }
    else if(alertView.tag==111)
    {
        for (UIViewController *obj in [self.navigationController viewControllers]) {
            if([obj isKindOfClass:[UserProfileViewController class]])
            {
                [self.navigationController popToViewController:obj animated:YES];
                break;
            }
        }
        
        [appDelegate loggedInStartTimer];
    }
    
    else if(alertView.tag==10002)
    {
        if(buttonIndex==0)
        {
            [self getTextFromAMF];
            
            
        }
        else{
            for (UIViewController *obj in [self.navigationController viewControllers]) {
                if([obj isKindOfClass:[UserProfileViewController class]])
                {
                    [self.navigationController popToViewController:obj animated:YES];
                    break;
                }
            }
        }
        
    }
}
-(void)submitGameResult:(NSString *)gameId userId:(NSString *)userId withDuration:(NSString *)duration
{
    
    [self showHUD];
    callerID=2;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller submitGameResult:gameId userId:userId withDuration:duration];
    
    
    
}
-(void)submitSinglePlayerGameResult:(NSString *)userID withDuration:(NSString *)duration
{
    if(!isQuit)
    {
        [self showHUD];
        
    }
    else
    {
        duration=@"NA";
        
    }
    callerID=1001;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller submitSinglePlayerGameResult:userID withDuration:duration];
    
    
}
-(void)playAudio
{
    
    
    NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"fireworks" ofType:@"mp3"];
    dispatch_queue_t downloadQueue = dispatch_queue_create("audio data downloader", NULL);
    dispatch_async(downloadQueue, ^{
        NSURL *audioURL = [[NSURL alloc] initFileURLWithPath: soundFilePath];
        NSData *audioData = [NSData dataWithContentsOfURL:audioURL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            NSError *error = nil;
            AVAudioPlayer *audioPlayer = [[AVAudioPlayer alloc] initWithData:audioData error:&error];
            NSLog(@"%@", error);
            //  audioPlayer.delegate = self;
            [audioPlayer prepareToPlay];
            [audioPlayer setVolume: 0.8];
            [audioPlayer play];
            audioPlayer=nil;
            [audioURL release];
            
        });
    });
}
//- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
//{
//
//}
//
///* if an error occurs while decoding it will be reported to the delegate. */
//- (void)audioPlayerDecodeErrorDidOccur:(AVAudioPlayer *)player error:(NSError *)error
//{
//
//
//}
- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
