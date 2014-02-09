//
//  BattleTextAppDelegate.m
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "BattleTextAppDelegate.h"
#import "LoginViewController.h"
#import "LeaderBoardViewController.h"
#import "UserProfileViewController.h"
#import "PlayGameViewController.h"

@implementation BattleTextAppDelegate

@synthesize window = _window;
@synthesize loginviewController = _loginviewController;
@synthesize userProfileviewController=_userProfileviewController;
@synthesize navcontroller=_navcontroller;
@synthesize HUD;
@synthesize m_caller;
@synthesize imgSplash;
@synthesize arrChallengers;
@synthesize dicGameBoard;
@synthesize strChances;
@synthesize strGameToken;
@synthesize fbDicInformation;
@synthesize m_strDeviceToken;

- (void)dealloc
{
    [m_caller release];
    [_window release];
    
    if(_loginviewController)
        [_loginviewController release];
    
    if(_userProfileviewController)
        [_userProfileviewController release];
    
    [alertGame release];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    //gfghj
    
    m_strDeviceToken=@"";
    
    [[UIApplication sharedApplication] registerForRemoteNotificationTypes:
     (UIRemoteNotificationTypeBadge | UIRemoteNotificationTypeSound | UIRemoteNotificationTypeAlert)];
    
    
      self.arrChallengers=[[NSMutableArray alloc] init];
    [NSUserDefaults resetStandardUserDefaults];
    [NSUserDefaults standardUserDefaults];
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    [[NSUserDefaults standardUserDefaults] setObject:[self getDocDirPath] forKey:@"DocDirPath"];
    imgSplash=[[UIImageView alloc]initWithFrame:self.window.bounds];
    isAlertShown=NO;
    if([self isiPhone5])
    {
        imgSplash.image=[UIImage imageNamed:@"Default-568@2x.png"];
    }
    else
    {
        imgSplash.image=[UIImage imageNamed:@"Default.png"];
        
    }
    [self.window addSubview:imgSplash];
   // [imgSplash release];
    [self.window makeKeyAndVisible];
    
    [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"forgetpassword"];
    [[NSUserDefaults standardUserDefaults]synchronize];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loggedOutStopTimer) name:@"logout" object:nil ];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loggedInStartTimer) name:@"loggedin" object:nil ];
  

  if((([kUserType isEqualToString:@"FB"]) && ([kUserID length]>0)))
  {
      
      if([self isiPhone5])
      {
          self.userProfileviewController = [[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController-iPhone5" bundle:nil] autorelease];
          
      }
      else
      {
          self.userProfileviewController = [[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil] autorelease];
      }
      self.navcontroller=[[[UINavigationController alloc]initWithRootViewController:_userProfileviewController]autorelease];
      self.navcontroller.navigationBar.tintColor=[UIColor blackColor];
      self.window.rootViewController = self.navcontroller;
      
      [self performSelector:@selector(hideSplashView) withObject:nil afterDelay:1.0];
      
      [self performSelector:@selector(loggedInStartTimer)];

  }
    
   else
   {
       
   if([kUserName length]>0 && [kPassword length]>0 &&!kForgetPasssword){
        
        [self logoutAction];
       
       
       
        
    }
    else
    {
    
        self.loginviewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
        self.navcontroller=[[[UINavigationController alloc]initWithRootViewController:_loginviewController]autorelease];
        self.navcontroller.navigationBar.tintColor=[UIColor blackColor];
        self.window.rootViewController = self.navcontroller;
        
        
        [self performSelector:@selector(hideSplashView) withObject:nil afterDelay:1.0];
        
        
        
    }
  }
    return YES;
}

- (void)application:(UIApplication*)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData*)deviceToken
{
	NSLog(@"My token is: %@", deviceToken);
    m_strDeviceToken=[[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    
    // Prepare the Device Token for Registration (remove spaces and < >)
    m_strDeviceToken = [[[m_strDeviceToken
                            stringByReplacingOccurrencesOfString:@"<"withString:@""]
                           stringByReplacingOccurrencesOfString:@">" withString:@""]
                          stringByReplacingOccurrencesOfString: @" " withString: @""];
    

}

- (void)application:(UIApplication*)application didFailToRegisterForRemoteNotificationsWithError:(NSError*)error
{
	NSLog(@"Failed to get token, error: %@", error);
}
-(void)upadateBadge
{


}
-(void)loggedInStartTimer
{
    NSLog(@"User name : %@ user id : %@",kUserName,kUserID);
    
     callGameBoardTimer=[NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(getGameStatusAndChallenges) userInfo:nil repeats:YES];
}
-(void)getGameStatusAndChallenges
{
    callerID=101;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameStatusAndChallenges:kUserID];
    
    
}
- (BOOL)checkAlertExistDismiss{
    for (UIWindow* window in [UIApplication sharedApplication].windows) {
        NSArray* subviews = window.subviews;
        if ([subviews count] > 0){
            for (id cc in subviews) {
                if ([cc isKindOfClass:[UIAlertView class]]) {
                    UIAlertView *alv=cc;
                    [alv dismissWithClickedButtonIndex:1 animated:YES];
                    
                    return YES;
                }
            }
        }
    }
    return NO;
}
-(void)loggedOutStopTimer
{

   
    
    if (callGameBoardTimer) {
        
        [callGameBoardTimer invalidate];
        callGameBoardTimer=nil;
    }
    
    
     
   

}
-(void)quitGame
{
    callerID=8;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller quitGame:kUserID gameID:dicGameBoard[@"game_id"]];

}
-(void)getGameBoard
{
    callerID=4;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameBoard:kUserID];

}
#pragma mark

- (NSString *) getDocDirPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory , NSUserDomainMask, YES);
	return paths[0];
}

#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    if( callerID==1)
    {
    NSArray *arrResult = (NSArray*)object;
        NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);

    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
                        
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"user_id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            if([self isiPhone5])
            {
            self.userProfileviewController = [[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController-iPhone5" bundle:nil] autorelease];
                
            }
            else
            {
                 self.userProfileviewController = [[[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil] autorelease];
            }
            self.navcontroller=[[[UINavigationController alloc]initWithRootViewController:_userProfileviewController]autorelease];
            self.navcontroller.navigationBar.tintColor=[UIColor blackColor];
            self.window.rootViewController = self.navcontroller;
            
            [self performSelector:@selector(hideSplashView) withObject:nil afterDelay:1.0];
            
            [self performSelector:@selector(loggedInStartTimer)];
        }
        else if([dic[@"errorcode"] intValue]==1){
            
            self.loginviewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
            self.navcontroller=[[[UINavigationController alloc]initWithRootViewController:_loginviewController]autorelease];
            self.navcontroller.navigationBar.tintColor=[UIColor blackColor];
            self.window.rootViewController = self.navcontroller;
            
            
            [self performSelector:@selector(hideSplashView) withObject:nil afterDelay:1.0];
            
        }
    }
        
    }
    else if( callerID==2)
    {
        
        NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);

      
    }
    else if( callerID==3)
    {
        NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);

        
        
        NSArray *arrResult = (NSArray*)object;
         NSDictionary *dic=arrResult[0];
        if([dic[@"errorcode"] intValue]==1)
           {
       
           }
           else
           {
           
           
           }
    }
    else if(callerID==4)
    {
        NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);

        if([((NSDictionary *)object)[@"errorcode"] integerValue]==0)
        {
        if(self.dicGameBoard)
        {
        [self.dicGameBoard release];
        self.dicGameBoard=nil;
        }
        
        self.dicGameBoard=(NSDictionary *)object;
        [self.dicGameBoard retain];
            if (callGameBoardTimer) {
                
                [callGameBoardTimer invalidate];
                callGameBoardTimer=nil;
            }
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"Challanged User : %@", (self.dicGameBoard)[@"opponent"][@"first_name"]] message:(self.dicGameBoard)[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        alert.tag=1001;//it was 101
        
        [alert show];
        [alert release];
       
        
      
        }
    
    }
    else if(callerID==5)
    {
            NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);

            
    }
        
    else if(callerID==6)
    {
            NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);
            
            
    }
    else if(callerID==101)
    {
            NSDictionary *dic = (NSDictionary*)object;
        
                     NSLog(@"dictChallengedUsrapp delegate%@",dic[@"challenges"]);
        
                if(![dic[@"challenges"][@"errorcode"] intValue]==1)
                {
                    [self.arrChallengers removeAllObjects];
                    dictChallengedUsr=dic[@"challenges"];
                    
                    for(id key in dictChallengedUsr)
                    {
                        if(!([key isEqual:@"errorcode"]))
                        {
                            [self.arrChallengers addObject:dictChallengedUsr[key]];
                        } 
                    }
                    
                    [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:nil];
                    NSLog(@"[appDeligate.arrChallengers count] %d",[self.arrChallengers count]);
                
                }
        else
        {
            [self.arrChallengers removeAllObjects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateBadge" object:nil];

        
        }
         NSLog(@"appdeligateobjectcallerID %d %@",callerID,object);
        if (![dic[@"game_status"][@"errorcode"] intValue]==1) {
           
            
           
                if(self.dicGameBoard)
                {
                    [self.dicGameBoard release];
                    self.dicGameBoard=nil;
                }
                
                self.dicGameBoard=dic[@"game_status"];
                [self.dicGameBoard retain];
                            
            if([(self.dicGameBoard)[@"status"] intValue]==2)
            {
                //if(![alertGame isHidden])
                //{
                if(!isAlertShown)
                {
                    [self checkAlertExistDismiss];
                   
                    alertGame =[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@", (self.dicGameBoard)[@"opponent"][@"first_name"]] message:(self.dicGameBoard)[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    alertGame.tag=101;
                    
                    [alertGame show];
                    
                    [alertGame release];
                    isAlertShown=YES;
                }
                //}
                if (callGameBoardTimer) {
                    
                    [callGameBoardTimer invalidate];
                    callGameBoardTimer=nil;
                }
                
            }
            else
            {
//                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:[NSString stringWithFormat:@"%@", [[self.dicGameBoard objectForKey:@"opponent"] objectForKey:@"first_name"]] message:[self.dicGameBoard objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//                alert.tag=101;
//                
//                [alert show];
//                [alert release];
            
            
            }
            
          
            
        }
        
                       
        }
    else if (callerID==108)
    {
        NSLog(@"Logout %@",object);
        callerID=1;
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        [m_caller getLoginCredentialsUser:kUserName pass:kPassword :m_strDeviceToken :@""];
    }
   
    
    }
    
    

- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
//    self.loginviewController = [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
//    self.navcontroller=[[[UINavigationController alloc]initWithRootViewController:_loginviewController]autorelease];
//    self.navcontroller.navigationBar.tintColor=[UIColor blackColor];
//    self.window.rootViewController = self.navcontroller;
//    
//    [self performSelector:@selector(hideSplashView) withObject:nil afterDelay:1.0];
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Message" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    
                    [alert show];
                    [alert release];
    
}
#pragma mark - iPhone 5 related
-(BOOL)isiPhone5
{
    if(UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
    {
        CGSize result = [[UIScreen mainScreen] bounds].size;
        
        if(result.height==568)
            
            return YES;
        else
            return NO;
    }
    return NO;
}
-(void)hideSplashView{
    if(imgSplash)
    {
        if([imgSplash superview]!=nil )
        {
         [imgSplash removeFromSuperview];
       
        }
        
    }
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
   
    if(alertView.tag==100)
    {
    if(buttonIndex==0)
    {
        [self acceeptDenyChallenge :@"yes"];
    }
    else
    {
            [self acceeptDenyChallenge :@"no"];
    }
    }
    else if(alertView.tag ==101)
    {
        isAlertShown=NO;
                
        //[self performSelector:@selector(enterGameBoard) onThread:[] withObject:<#(id)#> waitUntilDone:<#(BOOL)#>];
        if([strChances integerValue]>0 && [strGameToken integerValue]>0)
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
            [self.navcontroller pushViewController:playGameViewController animated:YES];
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

}

-(void)logoutAction{
    
    callerID=108;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller logOutFromApp:kUserID];
    
    
    
    
}

-(void)acceeptDenyChallenge:(NSString *)response
{
    
    NSString *challengedID=dictChallengedUsr[@"challenge_id"];//[self.arrChallengers objectAtIndex:0];
    callerID=3;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller challengeResponse:challengedID response:response];
    
    
    
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    
    
    /*
     Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
     If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
     */
    
    if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
		if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
			UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
            
			__block UIBackgroundTaskIdentifier background_task; //Create a task object
            
			background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
				[application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
				background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                NSLog(@"\n\nRunning in the background!\n\n");
				//System will be shutting down the app at any point in time now
			}];
            
			//Background tasks require you to use asyncrous tasks
            
			dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
				//Perform your tasks that your application requires
                
				NSLog(@"\n\nRunning in the background!\n\n");
                callerID=20001;
                m_caller = [[AMFCaller alloc] init];
                m_caller.delegate = self;
                [m_caller logOutFromApp:kUserID];
                
				[application endBackgroundTask: background_task]; //End the task so the system knows that you are done with what you need to perform
				background_task = UIBackgroundTaskInvalid; //Invalidate the background_task
			});
		}
	}

    
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    //sleep(5.0);
           // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
