//
//  UserProfileViewController.m
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UserProfileViewController.h"
#import "LeaderBoardViewController.h"
#import "GameTokenViewController.h"
#import "PlayGameViewController.h"
#import "InviteFriendsViewController.h"
#import "ASIFormDataRequest.h"
#import "SBJSON.h"
#import "GameInstructionViewController.h"
#import "ASIHTTPRequest.h"
#import "BattleTextAppDelegate.h"
#import "LoginViewController.h"
#import "CustomBadge.h"
#import "BattleTextAppDelegate.h"
#import "GameChallengesViewController.h"
#import "GameHistoryViewController.h"
#import "ClaimPrizeViewController.h"

@interface UserProfileViewController ()

@end

@implementation UserProfileViewController
@synthesize lblUserName;
@synthesize lblWeeklyScore;
@synthesize lblPrizeAmount;
@synthesize lblGameToken;
@synthesize lblFirstName;
@synthesize lblLastName;
@synthesize lblEmailID;
@synthesize ImgUserPics;
@synthesize imgViewEditEmail;
@synthesize imgViewUserGroup;
@synthesize btnAddEdit;
@synthesize lblGameChances;
//@synthesize m_caller;
@synthesize amfCount;
@synthesize updatedValue;



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
    isImageUpload=NO;
    [super viewDidLoad];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(upadateBadge) name:@"updateBadge" object:nil ];
   
}
-(void)upadateBadge
{
   // btnChalllengs.titleLabel.text=@"1122";
    [btnChalllengs setTitle:[NSString stringWithFormat:@"%d Challenges",[appDeligate.arrChallengers count]] forState:UIControlStateNormal];
     [btnChalllengs setTitle:[NSString stringWithFormat:@"%d Challenges",[appDeligate.arrChallengers count]] forState:UIControlStateHighlighted];
     [btnChalllengs setTitle:[NSString stringWithFormat:@"%d Challenges",[appDeligate.arrChallengers count]] forState:UIControlStateSelected];
    
   
    if([appDeligate.arrChallengers count]>0)
        btnChalllengs.enabled=YES;
    else
        btnChalllengs.enabled=NO;
    


}
- (IBAction)gameHistoryButtonAction:(id)sender
{
    GameHistoryViewController *gameHistoryViewController =[[GameHistoryViewController alloc] initWithNibName:@"GameHistoryViewController" bundle:nil];
    
    [self.navigationController pushViewController:gameHistoryViewController animated:YES ];
    
    [gameHistoryViewController release];


}
- (IBAction)claimPrizeButtonAction:(id)sender

{
    ClaimPrizeViewController *claimPrizeViewController=[[ClaimPrizeViewController alloc]initWithNibName:@"ClaimPrizeViewController" bundle:nil];
    [self.navigationController pushViewController:claimPrizeViewController animated:YES];
    [claimPrizeViewController release];
    

}

-(void)claimPrizeAMF
{
    self.callerID=102;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller claimprize:kUserID];
}
-(IBAction)callGameChallengers:(id)sender
{

    
    GameChallengesViewController *controller=[[GameChallengesViewController alloc]initWithNibName:@"GameChallengesViewController" bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
 
    if(!isImageUpload)
    {
   
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"User Profile";
    self.navigationItem.hidesBackButton=YES;
    [[btnAddEdit layer]setCornerRadius:3.0];
    self.callerID=-1;
    [self getUserDescription];
    
   // btnChalllengs.titleLabel.text=[NSString stringWithFormat:@"%d Challanges",[appDeligate.arrChallengers count]];
     [btnChalllengs setTitle:[NSString stringWithFormat:@"%d Challenges",[appDeligate.arrChallengers count]] forState:UIControlStateNormal];
    if([appDeligate.arrChallengers count]<=0)
    btnChalllengs.enabled=NO;
    else
        btnChalllengs.enabled=YES;
    self.navigationItem.leftBarButtonItem=[[UIBarButtonItem alloc]initWithTitle:@"Log Out" style:UIBarButtonItemStylePlain target:self action:@selector(logoutAction)];
    userProfileImage=[[UIImageView alloc] initWithFrame:CGRectMake(-20, ImgUserPics.frame.size.height-25, 42, 40)];
    if([kGroupID integerValue]==1)
        userProfileImage.image=[UIImage imageNamed:@"icon_gazzle@2x.png"];
    else if([kGroupID integerValue]==2)
        userProfileImage.image=[UIImage imageNamed:@"icon_cheetah@2x.png"];
    [ImgUserPics addSubview:userProfileImage];
   
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem  alloc]initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playButtonAction:)];
    
    imgClaimPrize.alpha=0.0;
    lblClaimPrize.alpha=0.0;
        isImageUpload=NO;
    }
    imgClaimPrize.alpha=0.0;
    lblClaimPrize.alpha=0.0;
    ImgUserPics.contentMode=UIViewContentModeScaleAspectFit;
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

#pragma mark button Action & method

- (IBAction)leaderBoardButtonAction:(id)sender {
    NSString *stringNibName=@"LeaderBoardViewController";
    if([self isiPhone5])
    {
        stringNibName=@"LeaderBoardViewController-iPhone5";
    }
    else
    {
        stringNibName=@"LeaderBoardViewController";
    }
    LeaderBoardViewController *leaderVCObj=[[LeaderBoardViewController alloc]initWithNibName:stringNibName bundle:nil];
    [self.navigationController pushViewController:leaderVCObj animated:TRUE];
    [leaderVCObj release];
    
    
}

- (IBAction)buyGameTokenButtonAction:(id)sender {
    NSString *stringNibName=@"GameTokenViewController";
    if([self isiPhone5])
    {
    stringNibName=@"GameTokenViewController-iPhone5";
    }
    else
    {
    stringNibName=@"GameTokenViewController";
    }
    GameTokenViewController *gameTokenVCObj=[[GameTokenViewController alloc]initWithNibName:stringNibName bundle:nil];
    [self.navigationController pushViewController:gameTokenVCObj animated:TRUE];
    [gameTokenVCObj release];
    
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
- (IBAction)inviteFriendsAction:(id)sender {
    
    InviteFriendsViewController *controller=[[InviteFriendsViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
}

- (IBAction)instructionButtonAction:(id)sender {
    
    GameInstructionViewController *controller=[[GameInstructionViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release];
    
}

-(void)getUserDescription{
    
    [self showHUD];
    
    self.callerID=10;
    self.m_caller = [[AMFCaller alloc] init];
   
    self.m_caller.delegate = self;
    [self.m_caller getUserDetails:kUserID];

    
}

- (void)setUserImage:(NSString *)link{
    
    
    ASIHTTPRequest *req=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[link stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [req setDownloadDestinationPath:[kDocDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profile_image.png",kUserName]]];
    [req startSynchronous];
    
    if(![req error]){
        
        ImgUserPics.image=[UIImage imageWithContentsOfFile:[kDocDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profile_image.png",kUserName]]];
        ImgUserPics.contentMode=UIViewContentModeScaleAspectFit;
        
    }
    
    [self killHUD];
    
}

- (IBAction)editUserNameAction:(id)sender {
        
    UIAlertView *myAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm new User Name" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    
    myAlertView.alpha=1.0;
    myAlertView.tag=101;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
       myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else{
        
        myAlertView.message=@"Confirm new User Name";
        
        UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        [myTextField setBackgroundColor:[UIColor clearColor]];
        myTextField.borderStyle = UITextBorderStyleRoundedRect;
        [myAlertView addSubview:myTextField];
        
    }
    
    [myAlertView show];
    [myAlertView release];
    
        
    
}

- (IBAction)editUserEmailAction:(id)sender {
    
    UIAlertView *myAlertView=[[UIAlertView alloc]initWithTitle:@"Confirm new E-mail ID" message:nil delegate:self cancelButtonTitle:@"OK" otherButtonTitles:@"Cancel",nil];
    
    myAlertView.alpha=1.0;
    myAlertView.tag=102;
    
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    if (version >= 5.0)
    {
        myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
    }
    else{
        
        myAlertView.message=@"Confirm new E-mail ID";
        if([[[UIDevice currentDevice] systemVersion] integerValue]>= 7.0){
            // do something
            myAlertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [myAlertView textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;
            
        }
        else
        {
        UITextField *myTextField = [[UITextField alloc] initWithFrame:CGRectMake(12.0, 45.0, 260.0, 25.0)];
        [myTextField setBackgroundColor:[UIColor clearColor]];
        myTextField.borderStyle = UITextBorderStyleRoundedRect;
        [myAlertView addSubview:myTextField];
        }
    }
    
    [myAlertView show];
    [myAlertView release];

}

- (IBAction)addEditImageButtonAction:(id)sender {
    
    UIImagePickerController *controller=[[UIImagePickerController alloc]init];
    controller.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    controller.delegate=self;
    [self presentModalViewController:controller animated:YES];
    
}

-(void)logoutAction{
    [self showHUD];
    callerID=7;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller logOutFromApp:kUserID];
   
    
   
    
}

#pragma mark imagePicker Delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    
    isImageUpload=YES;
    NSAutoreleasePool *pool=[[NSAutoreleasePool alloc]init];
    
    //ImgUserPics.image=[info objectForKey:UIImagePickerControllerOriginalImage];
    
    UIImage *picture=info[UIImagePickerControllerOriginalImage];
    NSData *dataImage = UIImageJPEGRepresentation(picture,1.0);
    UIImage *capturedImage=[UIImage imageWithData:dataImage];
    NSString *strDestThumbFilePath = [kDocDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profile_image.png",kUserName]];
    CGSize size=CGSizeMake(200, 200);
    UIGraphicsBeginImageContext(size);
    UIImage *img=capturedImage;
    [img drawInRect:CGRectMake(0, 0, size.width, size.height)];
    UIImage *destresizedImage = UIGraphicsGetImageFromCurrentImageContext();    
    UIGraphicsEndImageContext();
    NSData *dataResized=[[NSData alloc]initWithData:UIImagePNGRepresentation(destresizedImage)];
    ImgUserPics.image=[UIImage imageWithData:dataResized];
    BOOL fileExists=[dataResized writeToFile:strDestThumbFilePath atomically:YES];
    if(!fileExists){
        
        NSLog(@"not successfully cropped and saved");
        
    }
    [dataResized release],dataResized=nil;
    
    [pool drain];
    
   
    
    [self performSelectorOnMainThread:@selector(didSelectImageToUpload) withObject:nil waitUntilDone:YES];
    [picker dismissModalViewControllerAnimated:YES];
    [picker release],picker=nil;
    
    
    //[self showHUD];
    
    

    
}

-(void)didSelectImageToUpload{
    NSLog(@"url %@",[NSURL URLWithString:[kImageUploadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]);
    ASIFormDataRequest *req=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:[kImageUploadURL stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]]];
    [req setPostValue:kUserID forKey:@"user_id"];
    [req setFile:[NSString stringWithFormat:[kDocDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profile_image.png",kUserName]]] forKey:@"profileImg"];
    [req setDelegate:self];
    [req startAsynchronous];
        
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if([[request responseString]length]>0){
         [self performSelectorOnMainThread:@selector(killHUD) withObject:nil waitUntilDone:YES];
        SBJSON *json=[SBJSON new];
        NSDictionary *dicResult=(NSDictionary *)[json objectWithString:[request responseString]];
        
        if(!dicResult[@"errorcode"]){
            
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Image upload status" message:[dicResult objectForKey:@"msg"] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            alert.tag=103;
//            [alert show];
//            [alert release];
             ImgUserPics.image=[UIImage imageWithContentsOfFile:[kDocDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profile_image.png",kUserName]]];
            
        }
        else{
            
//            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Image upload status" message:[dicResult objectForKey:@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            
//            [alert show];
//            [alert release];

        }
        
    }
  
    isImageUpload=NO;
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    isImageUpload=YES;
    [self performSelectorOnMainThread:@selector(killHUD) withObject:nil waitUntilDone:YES];
    
}


#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    
    if(self.callerID==10){
    NSArray *arrObj = (NSArray*)object;
    
    
    
        lblUserName.text=kUserName;
        NSDictionary *dic=arrObj[0];
//        for(NSDictionary *dic in arrResult)
//        {
        
            if([dic[@"errorcode"] intValue]==0){
                
                appDeligate.strChances=dic[@"chances"];
                appDeligate.strGameToken=dic[@"game_token"];
                lblFirstName.text=dic[@"first_name"];
                lblLastName.text=dic[@"last_name"];
                lblEmailID.text=dic[@"email_id"];
                lblGameToken.text=dic[@"game_token"];
                
                lblPrizeAmount.text=dic[@"prize_amount"];
                lblWeeklyScore.text=dic[@"weekly_score"];
                lblGameChances.text=dic[@"chances"];
                appDeligate.strChances=dic[@"chances"];
                NSLog(@"[dic game_token %@ group_id %@",dic[@"game_token"],dic[@"group_id"]);
                appDeligate.strGameToken=[NSString stringWithFormat:@"%@",dic[@"game_token"]] ;
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"game_token"] forKey:@"game_token"];
                [[NSUserDefaults standardUserDefaults]setObject:dic[@"group_id" ] forKey:@"group_id"];
                [[NSUserDefaults standardUserDefaults]synchronize];

                NSString *getUserLink=dic[@"image"];
                               
                [self setUserImage:getUserLink];
                
                if([kGroupID integerValue]==1)
                    userProfileImage.image=[UIImage imageNamed:@"icon_gazzle@2x.png"];
                else if([kGroupID integerValue]==2)
                    userProfileImage.image=[UIImage imageNamed:@"icon_cheetah@2x.png"];
                NSDictionary *dicResult;
                if([dic[@"claim_prize"] isKindOfClass:[NSArray class]])
                {
                    NSArray *arrObj = dic[@"claim_prize"];
                    dicResult=arrObj[0];
                }
                else {
                    dicResult =dic[@"claim_prize"];
                }
               
              
                if([dicResult[@"errorcode"] isEqualToString:@"0"])
                {
                     if([[dicResult objectForKey:@"medal"] intValue]>0)
                    {
                        imgClaimPrize.alpha=1.0;
                        lblClaimPrize.alpha=1.0;
                      
                        lblClaimPrize.text=dicResult[@"medal"];
                        
                    }
        
                    
                }
                else{
                    
                    imgClaimPrize.alpha=0.0;
                    lblClaimPrize.alpha=0.0;
                }
                
              //  [self claimPrizeAMF];
                
            }
            else if([dic[@"errorcode"] intValue]==1){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Failed to fetch user description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                [self killHUD];
                
                
            }
        //}
    }
    else if (self.callerID==11) {
        [self killHUD];
        
        
        lblUserName.text=updatedValue;
        [updatedValue release];
     
        
        
    }
    else if (self.callerID==12) {
        [self killHUD];
        NSArray *arr;
        NSDictionary *dict;
      
        if([object isKindOfClass:[NSArray class]])
        {
            arr=(NSArray *)object;
            dict= arr[0];

        }
        else
        {
            dict=(NSDictionary *)object;
        }
        if([dict[@"errorcode"] intValue]==1){
            
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:dict[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            
            [alert show];
            [alert release];
        }
        else{
        lblEmailID.text=updatedValue;
        [updatedValue release];
        }
        
    }
    
   else if(self.callerID==101)
   {
   
   
   }
    else if(self.callerID==102)
    {
        NSArray *arrObj = (NSArray*)object;
        NSDictionary *dicResult = arrObj[0];
        if([dicResult[@"errorcode"] intValue]==0)
        {
           // if([[dicResult objectForKey:@"medal"] intValue]>0)
            {
            imgClaimPrize.alpha=1.0;
            lblClaimPrize.alpha=1.0;
            //lblChances.text=[dicResult objectForKey:@"chances"];
            //lblClaimPrize.text=[NSString stringWithFormat:@"Game Token:%@",[dicResult objectForKey:@"game_token"]];
            lblClaimPrize.text=@"1";
            [lblClaimPrize sizeToFit];
            }
          //  else{
          //      imgClaimPrize.alpha=0.0;
          //      lblClaimPrize.alpha=0.0;
            
          //  }
            
        }
        else{
        
            imgClaimPrize.alpha=0.0;
            lblClaimPrize.alpha=0.0;
        }
    
    }
    else if(callerID==7)
    {
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_id"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_name"];
        [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"password"];
         [[NSUserDefaults standardUserDefaults]setObject:@"" forKey:@"user_type"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [NSUserDefaults resetStandardUserDefaults];
        [NSUserDefaults standardUserDefaults];
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"logout" object:nil];
        LoginViewController *controller=[[LoginViewController alloc]initWithNibName:@"LoginViewController" bundle:nil];
        NSArray *viewcontrollers=@[controller];
        [self.navigationController setViewControllers:viewcontrollers];
        viewcontrollers=nil;
        
        [self killHUD];
    }
    
}

- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Sorry" message:@"Failed to fetch user description" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];

    
}

#pragma mark alertView Delegates

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if(alertView.tag==101){
        
        if(buttonIndex==0){
            
            if([[[UIDevice currentDevice] systemVersion] integerValue]>= 7.0){
                
                
                updatedValue=[alertView textFieldAtIndex:0].text;
                [updatedValue retain];
                self.callerID=11;
                self.m_caller.delegate = self;
                [self.m_caller editUserName:kUserName andNewUserName:updatedValue];
            }
            else
            {
            
            for(UIView *viewSub in [alertView subviews]){
                
                if([viewSub isKindOfClass:[UITextField class]]){
                    
                    UITextField *textField=(UITextField *)viewSub;
                    
                    if([textField.text length]>0){
                        
                        //[self showHUD];
                        updatedValue=textField.text;
                        [updatedValue retain];
                        self.callerID=11;
                       self.m_caller.delegate = self;
                        [self.m_caller editUserName:kUserName andNewUserName:textField.text];
                    }
                }
            }
            }
        }
    }
    else if(alertView.tag==102){
     
            
            if(buttonIndex==0){
                UITextField *textField=nil;
                
                if([[[UIDevice currentDevice] systemVersion] integerValue]>= 7.0)
                {
                   textField=[alertView textFieldAtIndex:0];
                    if([textField.text length]>0 && [self validateEmail:textField.text]){
                        
                        
                        updatedValue=textField.text;
                        [updatedValue retain];
                        self.callerID=12;
                        self.m_caller.delegate = self;
                        [self.m_caller editEmailID:textField.text andUserName:kUserName];
                        
                        
                    }
                    else
                    {
                    
                        UIAlertView *alv=[[UIAlertView alloc] initWithTitle:@"Error" message:@"Please enter valid email" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        [alv show];
                        [alv release];
                    
                    }

                }
                else
                {
                for(UIView *viewSub in [alertView subviews]){
                    
                    if([viewSub isKindOfClass:[UITextField class]]){
                        
                        textField=(UITextField *)viewSub;
                        
                        if([textField.text length]>0 && [self validateEmail:textField.text]){
                            
                            
                            updatedValue=textField.text;
                            [updatedValue retain];
                            self.callerID=12;
                           self.m_caller.delegate = self;
                            [self.m_caller editEmailID:textField.text andUserName:kUserName];
                           
                            
                        }
                    }
                }
                }
            }
        
    }
    else if(alertView.tag==103){
        
        ImgUserPics.image=[UIImage imageWithContentsOfFile:[kDocDirPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_profile_image.png",kUserName]]];
        
    }
}


#pragma mark ::::::::::::::::

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)viewDidUnload
{
    [self setLblUserName:nil];
    [self setLblWeeklyScore:nil];
    [self setLblPrizeAmount:nil];
    [self setLblGameToken:nil];
    [self setLblFirstName:nil];
    [self setLblLastName:nil];
    [self setLblEmailID:nil];
    [self setImgUserPics:nil];
    [self setImgViewEditEmail:nil];
    [self setImgViewUserGroup:nil];
    [self setBtnAddEdit:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc {
    [lblUserName release];
    [lblWeeklyScore release];
    [lblPrizeAmount release];
    [lblGameToken release];
    [lblFirstName release];
    [lblLastName release];
    [lblEmailID release];
    [ImgUserPics release];
    [imgViewEditEmail release];
    [imgViewUserGroup release];
    [btnAddEdit release];
    [super dealloc];
}

@end
