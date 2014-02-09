//
//  ResetPwdViewControllerViewController.m
//  BattleTextProject
//
//  Created by Anirban on 22/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ResetPwdViewControllerViewController.h"
#import "UserProfileViewController.h"

@interface ResetPwdViewControllerViewController ()

@end

@implementation ResetPwdViewControllerViewController
@synthesize txtOldPwdField;
@synthesize txtNewPwdField;
@synthesize m_caller;
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
    self.navigationItem.title=@"Reset Password";
    // Do any additional setup after loading the view from its nib.
}

#pragma mark button action and methods

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
    
    if(txtOldPwdField.isFirstResponder){
        
        [txtOldPwdField resignFirstResponder];
    }
    else if(txtNewPwdField.isFirstResponder){
        
        [txtNewPwdField resignFirstResponder];
        
    }
    
    if(tabToNumberPadObj.superview){
        
        [tabToNumberPadObj removeFromSuperview];
        tabToNumberPadObj=nil;
    }
}

- (IBAction)resetButtonAction:(id)sender {
    
    [self tapToResignButtonAction:nil];
    
    
    
    if(txtNewPwdField.text.length==0 || txtOldPwdField.text.length==0){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"entry field cannot be blank" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
        [alert release];
        
    }
    else{
        
        if([txtOldPwdField.text isEqualToString:kPassword]){
            [self showHUD];
            
            if(m_caller){
                
                [m_caller release];
            }
            
            m_caller = [[AMFCaller alloc] init];
            m_caller.delegate = self;
            [m_caller changePassword:kUserID Password:txtNewPwdField.text];
        }
        else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input last used password correctly" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            [alert release];

            
        }
            
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
    
    NSArray *arrResult = (NSArray*)object;
    
    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password reset status" message:dic[@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            NSString *password=txtNewPwdField.text;
            
            [[NSUserDefaults standardUserDefaults]setBool:NO forKey:@"forgetpassword"];
            [[NSUserDefaults standardUserDefaults]setObject:password forKey:@"password"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
            
        }
        else if([dic[@"errorcode"] intValue]==1){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password reset status" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
            
        }
    }
    
    [self killHUD];
    
    
    
}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password reset failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
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
    
    //LeaderBoardViewController *controller=[[LeaderBoardViewController alloc]init];
    UserProfileViewController *controller=[[UserProfileViewController alloc]init];
    [self.navigationController pushViewController:controller animated:TRUE];
    [controller release];
    
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [m_caller release];
    [txtOldPwdField release];
    [txtNewPwdField release];
    [super dealloc];
}



@end
