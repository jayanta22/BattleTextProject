//
//  InviteFriendsViewController.m
//  BattleTextProject
//
//   Created by freelancer on 29/08/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "InviteFriendsViewController.h"

@interface InviteFriendsViewController ()

@end

@implementation InviteFriendsViewController
@synthesize txtEmail;
@synthesize lblPassword;
@synthesize m_caller;
@synthesize txtName;
@synthesize tabToNumberPadObj;
@synthesize currentTextField;

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
    self.navigationItem.title=@"Invite Friend";
    [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    
    lblPassword.hidden=TRUE;
}

#pragma mark button action and methods

- (IBAction)invitedFriendsEmailid:(id)sender {
    
    if([txtEmail.text length]<=0 || [txtName.text length]<=0) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input all fields" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        
    }
    else{
        
        if([self validateEmail:txtEmail.text]){
            
            [self showHUD];
            
            m_caller = [[AMFCaller alloc] init];
            m_caller.delegate = self;
           // [m_caller forgetPassword:txtEmail.text];
            
            [m_caller inviteFriends:txtName.text withEmailID:txtEmail.text];
            
        }
        else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input a valid email address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
        }
    }
    
    
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


- (IBAction)tapToResign:(id)sender {
    
    if(txtName.isFirstResponder){
        
        [txtName resignFirstResponder];
        
    }
    if(txtEmail.isFirstResponder){
        
        [txtEmail resignFirstResponder];
        
    }
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }

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

#pragma mark Alertview delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }
    
    if(txtName.isFirstResponder){
        
        [txtName resignFirstResponder];
        
    }
    
    if(txtEmail.isFirstResponder){
        
        [txtEmail resignFirstResponder];
        
    }

    
    [self.navigationController popViewControllerAnimated:YES];
    
    
}

#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    NSArray *arrResult = (NSArray*)object;
    
    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:dic[@"msg"] message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
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
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Error" message:@"Please try again" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
    
}

- (void)viewDidUnload
{
    [self setTxtEmail:nil];
    [self setLblPassword:nil];
    [self setTxtName:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [txtEmail release];
    [lblPassword release];
    [txtName release];
    [super dealloc];
}
@end
