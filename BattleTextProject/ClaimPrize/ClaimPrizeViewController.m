 //
//  ClaimPrizeViewController.m
//  BattleTextProject
//
//  Created by Jayanta Das on 28/11/12.
//
//

#import "ClaimPrizeViewController.h"

@interface ClaimPrizeViewController ()

@end

@implementation ClaimPrizeViewController

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
   
    topView=[[UIView alloc] initWithFrame:self.view.frame];
    topView.backgroundColor=[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0];
    [self.view addSubview:topView];
    self.title=@"Claim Prize";
    [self performSelector:@selector(claimPrizeAMFcall)];
    // Do any additional setup after loading the view from its nib.
}
-(void)claimPrizeAMFcall
{
     amfcallType=0;
    [self showHUD];
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller claimprize:kUserID];
}
#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
  
    [self killHUD];
    if(amfcallType==0)
    {
    NSDictionary *dicResult;
    if([object isKindOfClass:[NSArray class]])
    {
        NSArray *arrResult = (NSArray*)object;
        dicResult=arrResult[0];
    }
    else {
        dicResult =(NSDictionary *)object;;
    }
  
    if([dicResult[@"errorcode"] intValue]==0)
    {
        lblChances.text=dicResult[@"chances"];
        lblGameToken.text=[NSString stringWithFormat:@"Game Token:%@",dicResult[@"game_token"]];
        lblMedal.text=dicResult[@"medal"];
        topView.alpha=0.0;
    
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:dicResult[@"msg"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        [alert release];
        topView.alpha=1.0;
    
    }
    }
    else if (amfcallType==1)
    {
        
      //  [self performSelector:@selector(claimPrizeAMFcall)];
//        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:[(NSDictionary *)object objectForKey:@"msg"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
//        
//        [alert show];
//        [alert release];
//        topView.alpha=1.0;
        
        NSDictionary *dicResult;
        if([object isKindOfClass:[NSArray class]])
        {
            NSArray *arrResult = (NSArray*)object;
            dicResult=arrResult[0];
        }
        else {
            dicResult =(NSDictionary *)object;;
        }
        
        if([dicResult[@"errorcode"] intValue]==0)
        {
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:dicResult[@"msg"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            topView.alpha=1.0;
        }
        else
        {
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:dicResult[@"msg"] delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
            
            [alert show];
            [alert release];
            topView.alpha=1.0;
            
        }
        
    
    }
    
       
    
}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
}
-(IBAction)btnActionAcceptPrize:(id)sender
{
   [self showHUD];
    amfcallType=1;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller acceptPrize:kUserID];

}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(buttonIndex==0)
    {
        [self.navigationController popViewControllerAnimated:YES];
    
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
