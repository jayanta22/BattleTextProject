//
//  ForgetPasswordViewController.m
//  BattleTextProject
//
//   Created by freelancer on 09/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ForgetPasswordViewController.h"
#import "RegisterViewController.h"

@interface ForgetPasswordViewController ()

@end

@implementation ForgetPasswordViewController
@synthesize txtEmail;
@synthesize lblPassword;
@synthesize m_caller;

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
    self.navigationItem.title=@"Password";
    [self.navigationItem.backBarButtonItem setTitle:@"Back"];
    
    lblPassword.hidden=TRUE;
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Register" style:UIBarButtonItemStylePlain target:self action:@selector(registerAction:)];
}

#pragma mark button action and methods

-(void)registerAction:(id)sender{
    
    RegisterViewController *regObjVC=[[RegisterViewController alloc]init] ;
    [self.navigationController pushViewController:regObjVC animated:TRUE];
    [regObjVC release];
    
    
}

- (IBAction)retrievePasswordButtonAction:(id)sender {
    
    if([txtEmail.text length]<=0) {
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input email address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        
    }
    else{
        
        if([self validateEmail:txtEmail.text]){
            
            if(txtEmail.isFirstResponder){
                
                [txtEmail resignFirstResponder];
                
            }

            
            [self showHUD];
            
            if(m_caller){
                
                [m_caller release];
            }

            
            m_caller = [[AMFCaller alloc] init];
            m_caller.delegate = self;
            [m_caller forgetPassword:txtEmail.text];
            
        }
        else{
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Please input a valid email address" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
            
        }
    }

    
}

- (IBAction)tapToResign:(id)sender {
    
    if(txtEmail.isFirstResponder){
        
        [txtEmail resignFirstResponder];
        
    }
    
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
            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"forgetpassword"];
            [[NSUserDefaults standardUserDefaults]synchronize];
            
        }
        else if([dic[@"errorcode"] intValue]==1){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Password sent to mail failed" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
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

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)viewDidUnload
{
    [self setTxtEmail:nil];
    [self setLblPassword:nil];
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
    [super dealloc];
}
@end
