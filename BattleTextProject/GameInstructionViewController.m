//
//  GameInstructionViewController.m
//  BattleTextProject
//
//   Created by freelancer on 30/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameInstructionViewController.h"
#import "PlayGameViewController.h"
@interface GameInstructionViewController ()

@end

@implementation GameInstructionViewController
@synthesize webInstruction;
@synthesize m_caller;
@synthesize strGameInstruction;
@synthesize appDel;

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
    appDel=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];

    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Instruction";
    
    [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    
    [self showHUD];
    webInstruction.hidden=TRUE;
    [webInstruction setOpaque:NO];
    webInstruction.backgroundColor = [UIColor clearColor];
    [self getGameInstruction];
    
   // self.navigationItem.rightBarButtonItem=[[UIBarButtonItem  alloc]initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playButtonAction:)];
    
}

-(void)playButtonAction:(id)sender
{
    if([appDel.strChances integerValue]>0 && [appDel.strGameToken integerValue]>0)
    {
        NSString *stringNibName=@"PlayGameViewController";
        if([self isiPhone5])
        {
            stringNibName=@"PlayGameViewController-iPhone5";
        }
        else
        {
            stringNibName=@"PlayGameViewController";
        }
        
        
        PlayGameViewController *playGameViewController =[[PlayGameViewController alloc] initWithNibName:stringNibName bundle:nil];
        
        playGameViewController.callFrom=1;
        [self.navigationController pushViewController:playGameViewController animated:YES];
        [playGameViewController release];
        playGameViewController=nil;
        
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Insufficient Chances or GameToken" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }
    
    
    

}

-(void)getGameInstruction{
    
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameInstruction];
    
}

#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    NSArray *arrResult = (NSArray*)object;
    
    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
            
            strGameInstruction=dic[@"Game_Instruction"];
            [strGameInstruction retain];
            
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@; color:#FFF}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body style='background-color: transparent';>%@</body> \n"
                                           "</html>", @"helvetica-bold", [NSNumber numberWithInt:15.0], strGameInstruction];
            
            [webInstruction setScalesPageToFit:NO];
            [webInstruction setOpaque:NO];
             webInstruction.backgroundColor = [UIColor clearColor];
            webInstruction.delegate=self;
            [webInstruction loadHTMLString:myDescriptionHTML baseURL:nil];
            
            webInstruction.hidden=NO;

            
        }
        else if([dic[@"errorcode"] intValue]==1){
            
            NSString *myDescriptionHTML = [NSString stringWithFormat:@"<html> \n"
                                           "<head> \n"
                                           "<style type=\"text/css\"> \n"
                                           "body {font-family: \"%@\"; font-size: %@;}\n"
                                           "</style> \n"
                                           "</head> \n"
                                           "<body style='background-color: transparent';>%@</body> \n"
                                           "</html>", @"helvetica-bold", [NSNumber numberWithInt:20.0], @"No Instruction Found"];
            
            [webInstruction setScalesPageToFit:NO];
            [webInstruction setOpaque:NO];
            webInstruction.backgroundColor = [UIColor clearColor];
            webInstruction.delegate=self;
            [webInstruction loadHTMLString:myDescriptionHTML baseURL:nil];
            webInstruction.hidden=NO;
            
            
        }
    }
    
    
    
    
    
}

- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"login failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
    
}

#pragma mark webView delegate

- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [self killHUD];
    webInstruction.hidden=NO;
    
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [self killHUD];
    
}



- (void)viewDidUnload
{
    [self setWebInstruction:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [webInstruction release];
    [super dealloc];
}
@end
