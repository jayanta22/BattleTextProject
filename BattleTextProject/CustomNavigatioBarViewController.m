//
//  CustomNavigatioBarViewController.m
//  BattleTextProject
//
//  Created by Partha on 09/10/12.
//
//

#import "CustomNavigatioBarViewController.h"
#import "CustomBadge.h"
#import "GameChallengesViewController.h"
#import "BattleTextAppDelegate.h"

@interface CustomNavigatioBarViewController ()

@end

@implementation CustomNavigatioBarViewController
@synthesize callerID,m_caller,appDeligate,customBadge;

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
       
     appDeligate=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];

    
        
   
	// Do any additional setup after loading the view.
}

-(void)getGameChallenges
{
    
    //[appDeligate.arrChallengers removeAllObjects];
    //[appDeligate.arrChallengers release];
    
    callerID=101;
    self.m_caller = [[AMFCaller alloc] init];
   self.m_caller.delegate = self;
    [self.m_caller getGameChallenges:kUserID];
    
    
    
    
}

#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
 
    if(self.callerID==101)
    {
    NSDictionary *dic = (NSDictionary*)object;
    // NSDictionary *dic=[arrResult objectAtIndex:0];
    if([dic[@"errorcode"] intValue]==1)
    {
        
    }
    else
    {
//        appDeligate.arrChallengers=[[NSMutableArray alloc] initWithCapacity:1];
//        // NSArray *arrResult = (NSArray*)object;
//        dictChallengedUsr=(NSDictionary*)object;
//        [appDeligate.arrChallengers addObject:(NSDictionary*)object];
        
        
    }
    }
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
