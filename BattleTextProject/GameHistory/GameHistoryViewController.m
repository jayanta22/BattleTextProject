//
//  GameHistoryViewController.m
//  BattleTextProject
//
//  Created by Jayanta Das on 19/11/12.
//
//

#import "GameHistoryViewController.h"
#import "GameHistoryCell.h"
#import "PlayGameViewController.h"
@interface GameHistoryViewController ()

@end

@implementation GameHistoryViewController

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
    delDictChallengers=[[NSDictionary alloc] init];
    self.title=@"Game History";
    arrGameHistory=[[NSMutableArray alloc] init];
    appDeligate=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
    [self callGetGameHistory];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem  alloc]initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playButtonAction:)];
    
}
-(void)callGetGameHistory
{
    [self showHUD];
    callFrom=1;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameHistory:kUserID];
}

-(void)playButtonAction:(id)sender
{
    if([appDeligate.strChances integerValue]>0 && [appDeligate.strGameToken integerValue]>0)
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
#pragma mark tableview delegates and data sources

-(void)closeViewController
{
    
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [arrGameHistory count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dictChallengers=arrGameHistory[indexPath.row];
   // NSLog(@"dictChallengers %@",dictChallengers);
    
    static NSString *CellIdentifier = @"GameHistoryCell";
    
    GameHistoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        UIViewController *controller=[[[UIViewController alloc]initWithNibName:CellIdentifier bundle:nil]autorelease];
        cell = (GameHistoryCell *)controller.view;
        
    }
    
    if(indexPath.row%2==1){
        
        cell.imgViewBackLB.image=[UIImage imageNamed:@"strip_even.png"];
        
    }
    else{
        
        cell.imgViewBackLB.image=[UIImage imageNamed:@"strip_odd.png"];
    }
   
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_async(queue, ^ {
        // Background work here
        NSURL *url = [NSURL URLWithString:dictChallengers[@"opponent_desc"][@"thumb_image"]];
         NSData *data = [NSData dataWithContentsOfURL:url];
        
        dispatch_async(dispatch_get_main_queue(), ^ {
            
           UIImage *  image = [UIImage imageWithData:data];
           cell.imgViewLB.image = image;
        });
    });
    

    
    
    cell.imgViewLB.layer.borderWidth=1.5;
    cell.imgViewLB.layer.borderColor=[UIColor orangeColor].CGColor;
    
    
    //cell.imgViewLB.image=[UIImage imageNamed:@"leader.png"];
    // NSData *ImagenUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:]];
    
    cell.lblUserNameLB.text=[NSString stringWithFormat:@"%@ ",dictChallengers[@"opponent_desc"][@"first_name"]];
    if( [dictChallengers[@"game_mode"] isEqualToString:@"S"] )
    {
    cell.lblStatus.text=[NSString stringWithFormat:@"Mode: Single"];
        cell.lblGameDurationOponent.alpha=0.0;
    }
    else
    {

        cell.lblGameDurationOponent.alpha=1.0;
        cell.lblStatus.text=[NSString stringWithFormat:@" %@ ",dictChallengers[@"game_status"]];
        cell.lblGameDurationOponent.text=[NSString stringWithFormat:@"Opponent's Time: %@ ",dictChallengers[@"opponent_desc"][@"game_duration"]];
    }
    cell.lblDateOfPlay.text=[self dateTimeFromInterval:dictChallengers[@"start_time"]];
    cell.lblMessage.text=dictChallengers[@"game_token"];
    cell.lblGameDurationUser.text=[NSString stringWithFormat:@"Your Time: %@ ",dictChallengers[@"game_duration"]];

    cell.btnDeleteGameHistory.tag=indexPath.row;
   // cell.btnChallengeLBDeny.tag=indexPath.row;
    [cell.btnDeleteGameHistory addTarget:self action:@selector(btnActionDeleteGamehistory:) forControlEvents:UIControlEventTouchUpInside];
//    [cell.btnChallengeLBDeny addTarget:self action:@selector(denyChallengedUserAction:) forControlEvents:UIControlEventTouchUpInside];
//    
    return cell;
    
}
-(void)btnActionDeleteGamehistory:(id)sender
{
    UIAlertView *alv=[[UIAlertView alloc] initWithTitle:@"Do you Really Want To Delete The Record" message:nil delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
    [alv show];
    [alv release];
    UIButton *btn=(UIButton *)sender;
    
     delDictChallengers=arrGameHistory[btn.tag];
    
      

}

-(NSString *)dateTimeFromInterval:(NSString *)timeInterval
{
    NSTimeInterval tempTimeInterval = [timeInterval longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tempTimeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MMM dd yyyy hh:mm:ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}
#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    if(callFrom==1)
    {
        [arrGameHistory removeAllObjects];
        NSDictionary *dicResult = (NSDictionary*)object;
        
        if([dicResult[@"errorcode"] intValue]==0)
        {
            for(id keyValue in [dicResult allKeys]){
                
                if(![keyValue isEqual:@"errorcode"])
                {
                    NSDictionary *dic=dicResult[keyValue];
                    
                    
                    [arrGameHistory addObject:dic];
                    
                    
                    
                }
            }
            NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"position" ascending:NO];
            [arrGameHistory sortUsingDescriptors:[NSArray arrayWithObject:sortDescriptor]];
            
            [tblGameHistory reloadData];
            tblGameHistory.hidden=NO;
        }
        else{
            [arrGameHistory removeAllObjects];
            [tblGameHistory reloadData];
            tblGameHistory.hidden=NO;
            UIAlertView *alv=[[UIAlertView alloc] initWithTitle:@"Message" message:@"No records found" delegate:nil cancelButtonTitle:@"OK"otherButtonTitles:nil, nil];
            
            [alv show];
            [alv release];
            
        }
        
        
        [self killHUD];
    }
    else if(callFrom ==2)
    {
        [self killHUD];
        [self callGetGameHistory];
    }
    
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    
    if(buttonIndex==1)
    {
        
        [self showHUD];
        callFrom=2;
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        [m_caller deleteGameHistory:delDictChallengers[@"game_id"] :kUserID];

    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)dealloc
{
    
//    if(delDictChallengers)
//    {
//    [delDictChallengers release];
//    delDictChallengers=nil;
//    }
    [super dealloc];
}

@end
