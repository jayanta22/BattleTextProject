//
//  BattleTextViewController.m
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetPasswordViewController.h"
#import "UserProfileViewController.h"
#import "LeaderBoardViewController.h"
#import "ResetPwdViewControllerViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController
@synthesize txtUserNameField;
@synthesize txtPasswordField;
@synthesize m_caller;
@synthesize tabToNumberPadObj;
@synthesize currentTextField;
@synthesize bgImage;

- (void)viewDidLoad
{
    [super viewDidLoad];
    appDelegate =(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];
    amfCallType=0;
    
	// Do any additional setup after loading the view, typically from a nib.
    self.navigationItem.title=@"Log In";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(registerButtonAction:)];
    
    if([self isiPhone5])
    {
        self.bgImage.image=[UIImage imageNamed:@"bg-568.png"];
        
        
    
    }
    else
    {
        self.bgImage.image=[UIImage imageNamed:@"bg-568.png"];
    
    }
}




-(void)viewWillAppear:(BOOL)animated{
    
    txtPasswordField.text=@"";
    txtUserNameField.text=@"";
    
}


#pragma mark button action and methods

-(void)registerButtonAction:(id)sender{
    
    
    [self tapToResignButtonAction:nil];
    
    RegisterViewController *regObjVC=[[RegisterViewController alloc]init] ;
    [self.navigationController pushViewController:regObjVC animated:TRUE];
    [regObjVC release];
    
    
}

-(void)btnResetAction{
    

    currentTextField.text=@"";
    
}

-(void)btnTabAction{
    
    NSInteger nextTag = currentTextField.tag + 1;
    if(nextTag>2){
        
        nextTag=1;
        
    }
    
    UIResponder* nextResponder = [self.view viewWithTag:nextTag];   
    if (nextResponder) {
        [nextResponder becomeFirstResponder];       
    }
    
}

-(IBAction)tapToResignButtonAction:(id)sender{

    if(txtUserNameField.isFirstResponder){
        
        [txtUserNameField resignFirstResponder];
    }
    else if(txtPasswordField.isFirstResponder){
        
        [txtPasswordField resignFirstResponder];
        
    }
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(txtUserNameField.isFirstResponder){
        
        [txtUserNameField resignFirstResponder];
    }
    else if(txtPasswordField.isFirstResponder){
        
        [txtPasswordField resignFirstResponder];
        
    }
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }
    return YES;
}

- (IBAction)forgetButtonAction:(id)sender {

    ForgetPasswordViewController *controller=[[ForgetPasswordViewController alloc]init];
    
    [self.navigationController pushViewController:controller animated:TRUE];
    
    [controller release];

}

- (IBAction)loginAction:(id)sender {
    
    [self tapToResignButtonAction:nil];
    
    
    
    if(txtPasswordField.text.length==0 || txtUserNameField.text.length==0){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"entry field cannot be blank" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else{
        amfCallType=0;
        
        [self showHUD];
        
        if(m_caller){
            
            [m_caller release];
        }
        
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
       
        
        [m_caller getLoginCredentialsUser:txtPasswordField.text pass: txtPasswordField.text:appDelegate.m_strDeviceToken :@""];
        
    }
    
    [self tapToResignButtonAction:nil];
    
    
}

#pragma mark textField Delegates

- (void) textFieldDidBeginEditing:(UITextField *)textField {
    
    currentTextField=textField;
    
    if (tabToNumberPadObj==nil) {

        UIViewController *controller=[[UIViewController alloc] initWithNibName:@"TabToNumberPadController" bundle:nil];
        
        tabToNumberPadObj=(TabToNumberPadController *)controller.view;
        [tabToNumberPadObj.btnDone addTarget:self action:@selector(loginAction:) forControlEvents:UIControlEventTouchUpInside];
        [tabToNumberPadObj.btnReset addTarget:self action:@selector(btnResetAction) forControlEvents:UIControlEventTouchUpInside];
        [tabToNumberPadObj.btnTab addTarget:self action:@selector(btnTabAction) forControlEvents:UIControlEventTouchUpInside];
        
        [tabToNumberPadObj showModal];
        [controller release];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    
    
}


#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    if(amfCallType==0 )
    {
    NSArray *arrResult = (NSArray*)object;
    NSLog(@"object log in %@ ",object);
    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
            
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"login Successful" message:[dic objectForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
//            [alert release];
            [self killHUD];
            NSString *username=txtUserNameField.text;
            NSString *password=txtPasswordField.text;
            [[NSUserDefaults standardUserDefaults]setObject:dic[@"user_id"] forKey:@"user_id"];
            [[NSUserDefaults standardUserDefaults]setObject:username forKey:@"user_name"];
             [[NSUserDefaults standardUserDefaults]setObject:@"BT" forKey:@"user_type"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
           // [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"]
            [[NSUserDefaults standardUserDefaults]synchronize];
            UserProfileViewController *controller=nil;
              [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedin" object:nil];
            if([self isiPhone5])
            {
                controller = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController-iPhone5" bundle:nil] ;
                
            }
            else
            {
                controller = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil] ;
            }
            
            [self.navigationController pushViewController:controller animated:TRUE];
            [controller release];
            
            
        }
        else if([dic[@"errorcode"] intValue]==1){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"login failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            
        }
    }
    
   
    
    }
    else if(amfCallType==1)
    {
     NSArray *arrResult = (NSArray*)object;
        NSDictionary *dic =[arrResult objectAtIndex:0 ];
    if([dic[@"errorcode"] intValue]==0)
    {
    
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"user_id"] forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:dic[@"name"] forKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults]setObject:@"FB" forKey:@"user_type"];
         [[NSUserDefaults standardUserDefaults]synchronize];
        UserProfileViewController *controller=nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"loggedin" object:nil];
        if([self isiPhone5])
        {
            controller = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController-iPhone5" bundle:nil] ;
            
        }
        else
        {
            controller = [[UserProfileViewController alloc] initWithNibName:@"UserProfileViewController" bundle:nil] ;
        }
        
        [self.navigationController pushViewController:controller animated:FALSE];
        [controller release];

    }
    else if([dic[@"errorcode"] intValue]==1){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"login failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        
    }
    }
     [self killHUD];
    
}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"login failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
    
}

#pragma mark Alertview delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }
    
    
    if(kForgetPasssword){
        
        ResetPwdViewControllerViewController *controller=[[ResetPwdViewControllerViewController alloc]init];
        [self.navigationController pushViewController:controller animated:TRUE];
        [controller release];

        
    }
    else{
       
        //LeaderBoardViewController *controller=[[LeaderBoardViewController alloc]init];
//        UserProfileViewController *controller=[[UserProfileViewController alloc]init];
//        [self.navigationController pushViewController:controller animated:TRUE];
//        [controller release];

        
    }

    
}
- (IBAction)faceBookLoginAction:(id)sender {
    
   // 455514637903957  //138073119547669
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:@[@"basic_info", @"email", @"user_likes", @"user_photos"]
                                           allowLoginUI:YES
                                      completionHandler:^(FBSession *session,
                                                          FBSessionState state,
                                                          NSError *error) {
                                          if (error) {
                                              UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                                                                  message:error.localizedDescription
                                                                                                 delegate:nil
                                                                                        cancelButtonTitle:@"OK"
                                                                                        otherButtonTitles:nil];
                                              [alertView show];
                                          } else if (session.isOpen) {
                                              [self sessionStateChanged:session state:state error:error];
                                          }
                                      }];
        return;
    }
    
    
}

- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error

{
    
    // If the session was opened successfully
    
    if (!error && state == FBSessionStateOpen){
        
        NSLog(@"Session opened");
        
        // Show the user the logged-in UI
        
        FBRequest* friendsRequest = [FBRequest requestForMe];
        
        [friendsRequest startWithCompletionHandler: ^(FBRequestConnection *connection,
                                                      
                                                      NSDictionary* result,
                                                      
                                                      NSError *error) {
            NSLog(@"%@",result);
            if(!error)
            {
                
                
            appDelegate.fbDicInformation=[NSDictionary dictionaryWithDictionary:result];
            
            [self facebookLogin];
            }
            
        }];
        
        return;
        
    }
    
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        
        // If the session is closed
        
        NSLog(@"Session closed");
        
        // Show the user the logged-out UI
        
    }
    
    
    
    // Handle errors
    
    if (error){
        
        NSLog(@"Error");
        
        // If the error requires people using an app to make an action outside of the app in order to recover
        
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            
        } else {
            
            
            
            // Clear this token
            
            [FBSession.activeSession closeAndClearTokenInformation];
            
            // Show the user the logged-out UI
            
        }
        
    }
    
}
-(void)facebookLogin
{
    [self showHUD];
     amfCallType=1;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    NSString *url = [NSString stringWithFormat:@"https://graph.facebook.com/%@/picture", [appDelegate.fbDicInformation objectForKey:@"id"]];

    
    [m_caller facebookLogin:[appDelegate.fbDicInformation objectForKey:@"name"] :[appDelegate.fbDicInformation objectForKey:@"first_name"] :[appDelegate.fbDicInformation objectForKey:@"last_name"] :[appDelegate.fbDicInformation objectForKey:@"email"] :[appDelegate.fbDicInformation objectForKey:@"id"] :url :appDelegate.m_strDeviceToken :@""];

}
- (void)viewDidUnload
{
    [self setTxtUserNameField:nil];
    [self setTxtPasswordField:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [m_caller release];
    [txtUserNameField release];
    [txtPasswordField release];
    [super dealloc];
}

@end
