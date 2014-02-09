//
//  RegisterViewController.m
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegisterViewController.h"
#import "UserProfileViewController.h"

@interface RegisterViewController ()

@end

@implementation RegisterViewController
@synthesize scrollView;
@synthesize txtFieldUserName;
@synthesize txtFieldUserLastName;
@synthesize txtFieldFirstName;
@synthesize txtFieldEmail;
@synthesize txtFieldPass;
@synthesize m_caller;
@synthesize tabToNumberPadObj;
@synthesize currentTextField;
@synthesize bgImage;

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
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Register";
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Log In" style:UIBarButtonItemStylePlain target:self action:@selector(loginButtonAction:)];
    self.navigationItem.hidesBackButton=TRUE;
    
    if([self isiPhone5])
    {
        self.bgImage.image=[UIImage imageNamed:@"bg-568.png"];
        
    }
    else
    {
        self.bgImage.image=[UIImage imageNamed:@"bg-568.png"];
        
    }

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


#pragma mark button action and methods

-(void)loginButtonAction:(id)sender{
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }

    
    [self.navigationController popViewControllerAnimated:TRUE];
    
}

- (IBAction)registerButtonAction:(id)sender {

    if([txtFieldEmail.text length]<=0 || [txtFieldFirstName.text length]<=0 || [txtFieldPass.text length]<=0 || [txtFieldUserLastName.text length]<=0 || [txtFieldUserName.text length]<=0 ){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input all the fields" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        
    }
    else{
        
        if([self validateEmail:txtFieldEmail.text]){
            
            [self showHUD];
            
            [self tapToResignAction:nil];
            
            if(m_caller){
                
                [m_caller release];
            }

            
            m_caller = [[AMFCaller alloc] init];
            m_caller.delegate = self;
            [m_caller userRegistration:txtFieldUserName.text :txtFieldFirstName.text :txtFieldUserLastName.text :txtFieldEmail.text :txtFieldPass.text];
            
        }
        else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input a valid email address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
        }
    }
}

- (IBAction)tapToResignAction:(id)sender {
    
    for(UITextField *txtField in scrollView.subviews){
        
        if(txtField.isFirstResponder){
            
            [txtField resignFirstResponder];
            
        }
        
        if(tabToNumberPadObj.superview){
            
            [tabToNumberPadObj removeFromSuperview];
            tabToNumberPadObj=nil;
        }        
    }
}

- (IBAction)didTapFaceBookLogin:(id)sender {
    if (!FBSession.activeSession.isOpen) {
        // if the session is closed, then we open it here, and establish a handler for state changes
        [FBSession openActiveSessionWithReadPermissions:nil
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

-(void)btnResetAction{
    
    
    currentTextField.text=@"";
    
}

-(void)btnTabAction{
    
    NSInteger nextTag = currentTextField.tag + 1;
    if(nextTag>5){
        
        nextTag=1;
        
    }
    
    UIResponder* nextResponder = [scrollView viewWithTag:nextTag];   
    if (nextResponder) {
        [nextResponder becomeFirstResponder];       
    }
}


#pragma mark textfield delegates

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    currentTextField=textField;
        
    [self moveScrollView:textField];
    
    if (tabToNumberPadObj==nil) {
        
        UIViewController *controller=[[UIViewController alloc] initWithNibName:@"TabToNumberPadController" bundle:nil];
        
        tabToNumberPadObj=(TabToNumberPadController *)controller.view;
        [tabToNumberPadObj.btnDone addTarget:self action:@selector(registerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        [tabToNumberPadObj.btnReset addTarget:self action:@selector(btnResetAction) forControlEvents:UIControlEventTouchUpInside];
        [tabToNumberPadObj.btnTab addTarget:self action:@selector(btnTabAction) forControlEvents:UIControlEventTouchUpInside];
        
        [tabToNumberPadObj showModal];
        [controller release];
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    [self originalSizeScrollView:textField]; 
    
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    for(UITextField *txtField in scrollView.subviews){
        
        if(txtField.isFirstResponder){
            
            [txtField resignFirstResponder];
            
        }
        
        if(tabToNumberPadObj.superview){
            
            [tabToNumberPadObj removeFromSuperview];
            tabToNumberPadObj=nil;
        }
    }
    return YES;
}

#pragma mark ScrollView methods ::::::::::::::::::::::::::::::::::::::::::::

-(void)moveScrollView:(UIView *)theView{
    
    CGRect rc = [theView bounds];
    
    rc = [theView convertRect:rc toView:scrollView];
    CGPoint pt = rc.origin;
    pt.x = 0;
    
    NSLog(@"float point-%f",theView.bounds.size.height);
    
    pt.y=pt.y-20;
    
    [scrollView setContentOffset:pt animated:YES];
}

-(void)originalSizeScrollView:(UIView *)theView{
    
    CGRect rc = [theView bounds];
    
    rc = [theView convertRect:rc toView:scrollView];
    CGPoint pt = rc.origin;
    pt.x = 0;
    pt.y = 0;
    [scrollView setContentOffset:pt animated:YES];
    
    
}



#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    NSArray *arrResult = (NSArray*)object;

    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Registration Successful" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            
            
        }
        else if([dic[@"errorcode"] intValue]==1){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Registration failed" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];

            
        }
    }
    
     [self killHUD];
    
    
}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Registration failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
    
}

#pragma mark alertview delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }
   
    [self.navigationController popToRootViewControllerAnimated:TRUE];    
}


- (void)viewDidUnload
{
    [self setTxtFieldUserName:nil];
    [self setTxtFieldUserLastName:nil];
    [self setTxtFieldFirstName:nil];
    [self setTxtFieldEmail:nil];
    [self setTxtFieldPass:nil];
    [self setScrollView:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [txtFieldUserName release];
    [txtFieldUserLastName release];
    [txtFieldFirstName release];
    [txtFieldEmail release];
    [txtFieldPass release];
    [scrollView release];
    [super dealloc];
}

@end
