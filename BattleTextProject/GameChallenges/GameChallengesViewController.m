//
//  GameChallengesViewController.m
//  BattleTextProject
//
//  Created by Partha on 07/10/12.
//
//
#import "BattleTextAppDelegate.h"
#import "ChallengerCell.h"
#import "GameChallengesViewController.h"
#import "PlayGameViewController.h"

@interface GameChallengesViewController ()

@end

@implementation GameChallengesViewController

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
    iamfCall=0;
    self.title=@"Challenges";
    appDeligate=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];
    [self getGameStatusAndChallenges];
//    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Close" style:UIBarButtonItemStylePlain target:self action:@selector(closeViewController)];
    NSLog(@"[appDeligate.arrChallengers] %@",(appDeligate.arrChallengers)[0]);

    // Do any additional setup after loading the view from its nib.
}
#pragma mark tableview delegates and data sources

-(void)closeViewController
{

    [self dismissModalViewControllerAnimated:YES];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 110.0;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return [appDeligate.arrChallengers count];
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *dictChallengers=(appDeligate.arrChallengers)[indexPath.row];
    NSLog(@"dictChallengers %@",dictChallengers);
    
    static NSString *CellIdentifier = @"ChallengerCell";
    
    ChallengerCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        UIViewController *controller=[[[UIViewController alloc]initWithNibName:CellIdentifier bundle:nil]autorelease];
        cell = (ChallengerCell *)controller.view;
        
    }
    
    if(indexPath.row%2==0){
        
        cell.imgViewBackLB.image=[UIImage imageNamed:@"strip_even.png"];
        
    }
    else{
        
        cell.imgViewBackLB.image=[UIImage imageNamed:@"strip_odd.png"];
    }
    
    
    
    NSURL *url = [NSURL URLWithString:dictChallengers[@"challenged_by_desc"][@"thumb_image"]];
    NSData *data = [NSData dataWithContentsOfURL:url];
    UIImage *image = [UIImage imageWithData:data];
   // UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    cell.imgViewLB.backgroundColor=[UIColor blackColor];
    cell.imgViewLB.image = image;
    
    
    //cell.imgViewLB.image=[UIImage imageNamed:@"leader.png"];
   // NSData *ImagenUrl = [NSData dataWithContentsOfURL:[NSURL URLWithString:]];
    cell.lblUserNameLB.text=[NSString stringWithFormat:@"%@ %@",dictChallengers[@"challenged_by_desc"][@"first_name"],dictChallengers[@"challenged_by_desc"][@"last_name"]];
    
  
    cell.lblCurrentPointLB.text=[NSString stringWithFormat:@"Challenge Token:%@",dictChallengers[@"challenge_amount"]];
    cell.lblGameWonLB.text=[NSString stringWithFormat:@"Game Won:%@",dictChallengers[@"challenged_by_desc"][@"total_game_win"]];
    cell.btnChallengeLB.tag=indexPath.row;
    
    [cell.btnChallengeLB addTarget:self action:@selector(acceptChallengedUserAction:) forControlEvents:UIControlEventTouchUpInside];
     [cell.btnChallengeLBDeny addTarget:self action:@selector(denyChallengedUserAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.btnChallengeLBDeny.tag=indexPath.row;
    
    return cell;
    
}
-(NSString *)dateTimeFromInterval:(NSString *)timeInterval
{
    NSTimeInterval tempTimeInterval = [timeInterval longLongValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:tempTimeInterval];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd mm ss"];
    
    NSString *dateString = [formatter stringFromDate:date];
    
    return dateString;
}
#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
  if(iamfCall==1)
  {
    NSLog(@"object %@",object);
    if(object)
    {
    [self killHUD];
    NSArray *arrResult = (NSArray*)object;
    NSDictionary *dic=arrResult[0];
    if([dic[@"errorcode"] intValue]==1)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }
    else
    {
        [self killHUD];
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
            
            playGameViewController.callFrom=2;
            [self.navigationController pushViewController:playGameViewController animated:YES];
            [playGameViewController release];
            playGameViewController=nil;
            
        }
        else
        {
            [self killHUD];
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Insufficient Chances or GameToken" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }

        
    }
    }
  }
    else if (iamfCall==0)
    {
        if(object)
        {
            [self killHUD];
            
            [self.navigationController popViewControllerAnimated:NO];
        }
    }
    else if (iamfCall==101)
    {
        
        [self killHUD];
        NSDictionary *dic = (NSDictionary*)object;
        
        NSLog(@"dictChallengedUsrapp delegate%@",dic[@"challenges"]);
        
        if(![dic[@"challenges"][@"errorcode"] intValue]==1)
        {
            [appDeligate.arrChallengers removeAllObjects];
            dictChallengedUsr=dic[@"challenges"];
            
            for(id key in dictChallengedUsr)
            {
                if(!([key isEqual:@"errorcode"]))
                {
                    [appDeligate.arrChallengers addObject:dictChallengedUsr[key]];
                }
            }
            
          //  [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:nil];
            NSLog(@"[appDeligate.arrChallengers count] %d",[appDeligate.arrChallengers count]);
            
        }
        else
        {
            [appDeligate.arrChallengers removeAllObjects];
         //   [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:nil];
            
            
        }
        [tblViewGameChallenges reloadData];
    }
}

-(void)getGameStatusAndChallenges
{
    [self showHUD];
    iamfCall=101;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameStatusAndChallenges:kUserID];
    
    
}
-(void)acceptChallengedUserAction:(id )response
{

    NSLog(@"appDeligate.arrChallengers %@",appDeligate.arrChallengers);
    UIButton *btn=(UIButton *)response;
    
    if([appDeligate.arrChallengers count]>btn.tag)
    {
        [self showHUD];
        NSDictionary *dictChallengers=(appDeligate.arrChallengers)[btn.tag];
        NSString *challengedID=dictChallengers[@"challenge_id"];//[self.arrChallengers objectAtIndex:0];
        iamfCall=1;
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        [m_caller challengeResponse:challengedID response:@"Y"];
    }
    else
    {
       
        [self getGameStatusAndChallenges];
        
    }
    
    
    
}
-(void)denyChallengedUserAction:(id)response
{
    NSLog(@"[appDeligate.arrChallengers count] %d",[appDeligate.arrChallengers count]);
    
    UIButton *btn=(UIButton *)response;
    if([appDeligate.arrChallengers count]>btn.tag)
    {
        [self showHUD];
        NSDictionary *dictChallengers=(appDeligate.arrChallengers)[btn.tag];
        NSString *challengedID=dictChallengers[@"challenge_id"];//[self.arrChallengers objectAtIndex:0];
        iamfCall=0;
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        [m_caller challengeResponse:challengedID response:@"N"];
    }
   else {
       
        
        [self getGameStatusAndChallenges];
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
