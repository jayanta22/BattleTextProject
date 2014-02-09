//
//  LeaderBoardViewController.m
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "LeaderBoardViewController.h"
#import "UserDetailsCC.h"
#import "LeaderBoardCell.h"
#import "GameTokenViewController.h"
#import "ImageDownloaderCC.h"
#import "PlayGameViewController.h"

@interface LeaderBoardViewController ()

@end

@implementation LeaderBoardViewController
@synthesize viewLeaderBoard;
@synthesize tblLeaderBoard;
@synthesize m_caller;
@synthesize mutArrOfUserList;
@synthesize allButton;
@synthesize cheetahButton;
@synthesize gazelleButton;
@synthesize challengedUserButton;
@synthesize viewSegment;
@synthesize currentButonTag;
@synthesize txtViewDetails;
@synthesize callerID;
@synthesize mutArrOfchallengeList;
@synthesize mutArrOfcheetahList;
@synthesize mutArrOfgazelleList;
@synthesize tblID;
@synthesize imageDownloadsInProgress;

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
    self.title=@"LeaderBoard";
    appDel=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];
    [[allButton layer]setBorderColor:[UIColor blackColor].CGColor];
    [[allButton layer]setBorderWidth:1.0];
    [[cheetahButton layer]setBorderColor:[UIColor blackColor].CGColor];
    [[cheetahButton layer]setBorderWidth:1.0];
    [[gazelleButton layer]setBorderColor:[UIColor blackColor].CGColor];
    [[gazelleButton layer]setBorderWidth:1.0];
    [[challengedUserButton layer]setBorderColor:[UIColor blackColor].CGColor];
    [[challengedUserButton layer]setBorderWidth:1.0];
    [[viewSegment layer]setBorderColor:[UIColor blackColor].CGColor];
    [[viewSegment layer]setBorderWidth:1.0];
    
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];

    currentButonTag=1;
    mutArrOfUserList=[[NSMutableArray alloc]init];
    
    txtViewDetails.hidden=TRUE;

    [self getUserList];
    
    self.navigationItem.rightBarButtonItem=[[UIBarButtonItem  alloc]initWithTitle:@"Play" style:UIBarButtonItemStylePlain target:self action:@selector(playButtonAction:)];
    
}

-(void)playButtonAction:(id)sender
{
    if([appDel.strChances integerValue]>0 && [appDel.strGameToken integerValue]>0)
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 80.0;

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    if(tblID==0){
        
        return [mutArrOfUserList count];
        
    }
    else if(tblID==1){
        
        return [mutArrOfcheetahList count];
        
    }
    else if(tblID==2){
        
        return [mutArrOfgazelleList count];
        
    }
    else if(tblID==3){
        
        return [mutArrOfchallengeList count];
        
    }

    return 1;
    
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
  //  UserDetailsCC *obj=nil;
    
    if(tblID==0)
        obj=mutArrOfUserList[indexPath.row];
    if(tblID==1)
        obj=mutArrOfcheetahList[indexPath.row];
    if(tblID==2)
        obj=mutArrOfgazelleList[indexPath.row];
    if(tblID==3)
        obj=mutArrOfchallengeList[indexPath.row];

    
    static NSString *CellIdentifier = @"LeaderBoardCell";
    
    LeaderBoardCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        
        UIViewController *controller=[[[UIViewController alloc]initWithNibName:CellIdentifier bundle:nil]autorelease];
        cell = (LeaderBoardCell *)controller.view;
        
    }
    
    if(indexPath.row%2==1){
        
        cell.imgViewBackLB.image=[UIImage imageNamed:@"strip_even.png"];
        
    }
    else{
        
        cell.imgViewBackLB.image=[UIImage imageNamed:@"strip_odd.png"];
    }
    cell.imgViewLB.layer.borderColor=[UIColor orangeColor].CGColor;
    cell.imgViewLB.layer.borderWidth=1.0;
    
    if (!obj.imgIconObj.imgIcon)
    {
        
        [cell.actInd startAnimating];
        cell.imgViewLB.image=[UIImage imageNamed:@"ld_back.png"];
        if (self.tblLeaderBoard.dragging == NO && self.tblLeaderBoard.decelerating == NO)
        {
            
            [self startIconDownload:obj.imgIconObj forIndexPath:indexPath];
            
        }
        // if a download is deferred or in progress, return a placeholder image
        //cell.imgViewLB.image = [UIImage imageNamed:@"2.png"];
    }
    else
    {
        [cell.actInd stopAnimating];
        cell.imgViewLB.image = obj.imgIconObj.imgIcon;
       
    }

    
    //cell.imgViewLB.image=[UIImage imageNamed:@"leader.png"];
    cell.lblUserNameLB.text=obj.userName;
    cell.lblCurrentPointLB.text=[NSString  stringWithFormat:@"Points:%@ ",obj.weeklyScore];
    cell.lblGameWonLB.text=[NSString  stringWithFormat:@"Game won:%@",obj.totalWin];
    cell.imgViewUserStatus.image=[self getImagenameByUserStatus:obj.playerStatus];
    NSLog(@"obj.minDuration%@",obj.minDuration);
    if([obj.minDuration isEqualToString:@"0"])
        cell.lblShotDuration.text=@"No game yet";
    else
    cell.lblShotDuration.text=[NSString stringWithFormat:@"  Time:%@",obj.minDuration];
    [cell.btnChallengeLB setHidden:NO];

    if(tblID==3)
    {
        [cell.btnChallengeLB setTitle:@"challenged" forState:UIControlStateNormal];
        [cell.btnChallengeLB setEnabled:NO];
    }
    else
    {
        if(obj.challengeUser)
        {
            [cell.btnChallengeLB setTitle:@"challenged" forState:UIControlStateNormal];
            [cell.btnChallengeLB setEnabled:NO];
        }
        else
        {
            
        [cell.btnChallengeLB setTitle:@"challenge" forState:UIControlStateNormal];
            if(obj.playerStatus==1)
            {
        [cell.btnChallengeLB setEnabled:YES];
        [cell.btnChallengeLB addTarget:self action:@selector(challengedUserAction:) forControlEvents:UIControlEventTouchUpInside];
            }
            else
            {
            [cell.btnChallengeLB setEnabled:NO];
            }
        }
    }
    if([obj.usderID isEqualToString:kUserID])
    {
        
        [cell.btnChallengeLB setEnabled:NO];
        [cell.btnChallengeLB setHidden:YES];
    }
    
    cell.btnChallengeLB.tag=indexPath.row;
    
    return cell;
    
}
-(UIImage *)getImagenameByUserStatus:(int)playerStatus
{
    NSString *imageName=nil;
    UIImage *image=nil;

    switch (playerStatus) {
        case 0:
            imageName=@"user-offline.png";
            break;
        case 1:
            imageName=@"user-available.png";
            break;
        case 2:
            imageName=@"user-busy.png";
            break;
        default:
            imageName=@"user-offline.png";
            break;
    }
    image=[UIImage imageNamed:imageName];
    return image;
}

#pragma mark -
#pragma mark Table cell image support

- (void)startIconDownload:(ImageDownloaderCC *)appRecord forIndexPath:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = imageDownloadsInProgress[indexPath];
    if (iconDownloader == nil) 
    {
        iconDownloader = [[IconDownloader alloc] init];
        iconDownloader.imgDownloader = appRecord;
        iconDownloader.indexPathInTableView = indexPath;
        iconDownloader.delegate = self;
        imageDownloadsInProgress[indexPath] = iconDownloader;
        [iconDownloader startDownload];
        [iconDownloader release];   
    }
}

// this method is used in case the user scrolled into a set of cells that don't have their app icons yet
- (void)loadImagesForOnscreenRows
{
    if ([mutArrOfUserList count] > 0)
    {
        NSArray *visiblePaths = [self.tblLeaderBoard indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            UserDetailsCC *appRecord = mutArrOfUserList[indexPath.row];
            
            if (!appRecord.imgIconObj.imgIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord.imgIconObj forIndexPath:indexPath];
            }
        }
    }
}

// called by our ImageDownloader when an icon is ready to be displayed
- (void)appImageDidLoad:(NSIndexPath *)indexPath
{
    IconDownloader *iconDownloader = imageDownloadsInProgress[indexPath];
    if (iconDownloader != nil)
    {
        LeaderBoardCell *cell = (LeaderBoardCell *)[self.tblLeaderBoard cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imgViewLB.image = iconDownloader.imgDownloader.imgIcon;
        [cell.actInd stopAnimating];
    }
    
    // Remove the IconDownloader from the in progress list.
    // This will result in it being deallocated.
    [imageDownloadsInProgress removeObjectForKey:indexPath];
}


#pragma mark -
#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadImagesForOnscreenRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadImagesForOnscreenRows];
}

#pragma mark methods and Button Action



-(void)getViewFrame:(UIButton *)btn{
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.2];
    CGRect frame = CGRectMake(btn.frame.origin.x, viewSegment.frame.origin.y, btn.frame.size.width, btn.frame.size.height);
    self.viewSegment.frame = frame;
    
    [UIView commitAnimations];

    
}

- (IBAction)allUserButtonAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    
    if(currentButonTag!=btn.tag){
        
            
        currentButonTag=btn.tag;
        [self getViewFrame:btn];

    }
    
    tblID=0;
    if([mutArrOfUserList count]>0){
        
        [tblLeaderBoard reloadData];
        txtViewDetails.hidden=YES;
        tblLeaderBoard.hidden=NO;
        
    }
    else{
        
        txtViewDetails.hidden=NO;
        tblLeaderBoard.hidden=YES;
        
        
    }

    
}

- (IBAction)cheetahUserButtonAction:(id)sender {
    UIButton *btn=(UIButton *)sender;
    
    if(currentButonTag!=btn.tag){
        
        if(btn.tag==5){
            
            currentButonTag=cheetahButton.tag;
            [self getViewFrame:cheetahButton];
            
            
            
        }
        else {
            
            currentButonTag=btn.tag;
            [self getViewFrame:btn];
        }
        
        tblID=1;
        if([mutArrOfcheetahList count]>0){
            
            [tblLeaderBoard reloadData];
            txtViewDetails.hidden=YES;
            tblLeaderBoard.hidden=NO;
            
        }
        else{
            
            txtViewDetails.hidden=NO;
            tblLeaderBoard.hidden=YES;
            
            
        }
    }
    
}

- (IBAction)gazelleUserButtonAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    
    if(currentButonTag!=btn.tag){
        
        if(btn.tag==6){
            
            currentButonTag=gazelleButton.tag;
            [self getViewFrame:gazelleButton];
            
        }
        else{
            
            currentButonTag=btn.tag;
            [self getViewFrame:btn];
        }
        
        tblID=2;
        if([mutArrOfgazelleList count]>0){
            
            [tblLeaderBoard reloadData];
            txtViewDetails.hidden=YES;
            tblLeaderBoard.hidden=NO;
            
        }
        else{
            
            txtViewDetails.hidden=NO;
            tblLeaderBoard.hidden=YES;
            
            
        }

    }

}

- (IBAction)challengedUserButtonAction:(id)sender {
    
    UIButton *btn=(UIButton *)sender;
    [self getViewFrame:btn];
    
    tblID=3;
    if([mutArrOfchallengeList count]>0){
        
        [tblLeaderBoard reloadData];
        txtViewDetails.hidden=YES;
        tblLeaderBoard.hidden=NO;
        
        
    }
    else{
        
        txtViewDetails.hidden=NO;
        tblLeaderBoard.hidden=YES;
        
        
    }
    currentButonTag=btn.tag;


}

- (IBAction)buyGameTOkenAction:(id)sender {
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

-(void)getUserList{
    
    [self showHUD];
    callerID=1;
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getUserList:kUserID];

    
}
-(void)challengedUserAction:(id)sender
{
    
    UIButton *btn=(UIButton *)sender;
    
    if(tblID==0)
        obj=mutArrOfUserList[btn.tag];
    if(tblID==1)
        obj=mutArrOfcheetahList[btn.tag];
    if(tblID==2)
        obj=mutArrOfgazelleList[btn.tag];
    if(tblID==3)
        obj=mutArrOfchallengeList[btn.tag];
    

    
    UIAlertView* alv = [[UIAlertView alloc] init];
    [alv setDelegate:self];
    [alv setTitle:@"Enter challenge amount"];
    [alv setMessage:@" "];
    [alv addButtonWithTitle:@"challenge"];
    [alv addButtonWithTitle:@"Cancel"];
    if([[[UIDevice currentDevice] systemVersion] integerValue]>= 7.0){
        // do something
        alv.alertViewStyle = UIAlertViewStylePlainTextInput;
        [alv textFieldAtIndex:0].keyboardType = UIKeyboardTypeNumberPad;

    }
    else
    {

    challengeToken = [[UITextField alloc] initWithFrame:CGRectMake(20.0, 45.0, 245.0, 25.0)];
    [challengeToken setBackgroundColor:[UIColor whiteColor]];
    [alv addSubview:challengeToken];
    
    challengeToken.keyboardType=UIKeyboardTypeNumberPad;
    [challengeToken release];
    }
    
    CGAffineTransform moveUp = CGAffineTransformMakeTranslation(0.0, 30.0);
    [alv setTransform: moveUp];
    [alv show];
    
    [alv release];
   
   

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
{
    
    if(alertView.tag==-100)
    {
        if(buttonIndex==0)
        {
        for (UIViewController *objUserProf in [self.navigationController viewControllers]) {
            if([objUserProf isKindOfClass:[UserProfileViewController class]])
            {
                [self.navigationController popToViewController:objUserProf animated:YES];
                break;
            }
        }
        }
    }
    
    else
    {
        if(buttonIndex==0)
        {
            
            
            if([[[UIDevice currentDevice] systemVersion] integerValue]>= 7.0){
                
                challengeToken=[alertView textFieldAtIndex:0];
            }
            else
            {
                
            }
            if([challengeToken.text integerValue]>0)
            {
                
                //if(([challengeToken.text integerValue]<=[kGameToken integerValue])&&([challengeToken.text integerValue]<=[obj.gameToken integerValue]))
              //  {
                    
                    [self showHUD];
                    callerID=2;
                    m_caller = [[AMFCaller alloc] init];
                    m_caller.delegate = self;
                    
                    [m_caller challengeUser:kUserID chalangedUser:obj.usderID gameTocken:challengeToken.text];
              /*  }
                else
                {
                    NSString *message=@"";
                    if([challengeToken.text integerValue]>[kGameToken integerValue])
                    {
                        message=[NSString stringWithFormat:@"You don't have sufficiant game token,Please challange with lower amount"];
                    }
                    //            else if([challengeToken.text integerValue]>[obj.gameToken integerValue])
                    //            {
                    //            message=[NSString stringWithFormat:@"Your challanger don't have sufficiant game token,Please challange with lower amount"];
                    //            }
                    UIAlertView *alv=[[UIAlertView alloc] initWithTitle:@"Message" message:message delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                    
                    [alv show];
                    [alv release];
                }*/
            }
            else
            {
                UIAlertView *alv=[[UIAlertView alloc] initWithTitle:@"Message" message:@"Enter challenge amount first then press submit" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];
                
                [alv show];
                [alv release];
            }
        }
    
    }
    
}

#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object
{
    
    if(callerID ==1)
    {
    NSArray *arrResult = (NSArray*)object;
    
    if([arrResult count]>0){
        
        if(mutArrOfUserList){
            
            [mutArrOfUserList release];
        }
        
        if(mutArrOfchallengeList){
            
            [mutArrOfchallengeList release];
        }
        
        if(mutArrOfcheetahList){
            
            [mutArrOfcheetahList release];
            
        }
        
        if(mutArrOfgazelleList){
            
            [mutArrOfgazelleList release];
            
        }
        
        mutArrOfUserList=[[NSMutableArray alloc]init];
        mutArrOfgazelleList=[[NSMutableArray alloc]init];
        mutArrOfcheetahList=[[NSMutableArray alloc]init];
        mutArrOfchallengeList=[[NSMutableArray alloc]init];
        
    }
    
  
    
    for(NSDictionary *dic in arrResult)
    {
        
        if([dic[@"errorcode"] intValue]==0){
            
            UserDetailsCC *userListObj=[[UserDetailsCC alloc]init];
            userListObj.userName=dic[@"username"];
            userListObj.totalWin=dic[@"game_won"];
            userListObj.weeklyScore=dic[@"current_point"];
            BOOL value= NO;
            NSLog(@"dic objectForKey:challenge_user %@",dic[@"challenge_User"]);
            if([dic[@"challenge_User"] isEqualToString:@"YES"])
               value=YES;
            userListObj.challengeUser=value;
            userListObj.grpName=dic[@"group"];
            userListObj.grpID=dic[@"group_id"];
            
            userListObj.imgIconObj=[[ImageDownloaderCC alloc]init];
            userListObj.imgIconObj.imgLink=dic[@"thumb_image"];
            userListObj.usderID=dic[@"userid"];
            userListObj.playerStatus=[dic[@"user_status_code"] intValue];
            userListObj.gameToken=dic[@"game_token"];
            userListObj.minDuration =dic[@"min_duration"];
            [mutArrOfUserList addObject:userListObj];
            
            if(userListObj.challengeUser){
                
                [mutArrOfchallengeList addObject:userListObj];
                
            }
            
            if([userListObj.grpName isEqualToString:@"Gazelle"]){
                
                [mutArrOfgazelleList addObject:userListObj];
                
            }
            else{
                
                [mutArrOfcheetahList addObject:userListObj];
                
            }
            
            [userListObj.imgIconObj release];
            [userListObj release];
            
        }
    }
    
    if([mutArrOfUserList count]>0){
        [self getViewFrame:allButton ];
        [tblLeaderBoard reloadData];
        txtViewDetails.hidden=YES;
        tblLeaderBoard.hidden=NO;
        
    }
    else{
        
        txtViewDetails.hidden=NO;
        tblLeaderBoard.hidden=YES;

        
    }
        
        [self killHUD];
    }
    else if(callerID==2)
    {
        [self killHUD];
        NSArray *arrResult = (NSArray*)object;
        NSDictionary *dic=arrResult[0];
        UIAlertView *alert ;
        if([dic[@"errorcode"] intValue]==0)
        {
         
        alert=[[UIAlertView alloc]initWithTitle:@"Challenged User" message:dic[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            alert.tag=-100;
        [alert show];
        //[alert release];
            
            
        [self getUserList];

           
        }
        else
        {
           
            alert=[[UIAlertView alloc]initWithTitle:@"Challenged User" message:dic[@"msg"] delegate:self cancelButtonTitle:nil otherButtonTitles:nil, nil];
            alert.tag=-100;
            [alert show];
           // [alert release];

        
        }
        
         [self performSelector:@selector(dismissAlertView:) withObject:alert afterDelay:2];
    }
    
   // [self performSelector:@selector(cheetahUserButtonAction:) ];
    
    
}
-(void)dismissAlertView:(UIAlertView *)alv
{

    [alv dismissWithClickedButtonIndex:0 animated:YES];
    [alv release];

}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"LeaderBoard list status" message:@"failed to fetch" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
    
}


#pragma mark ::::::::

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    
    // terminate all pending download connections
    NSArray *allDownloads = [imageDownloadsInProgress allValues];
    [allDownloads makeObjectsPerformSelector:@selector(cancelDownload)];
}

- (void)viewDidUnload
{
    [self setViewLeaderBoard:nil];
    [self setTblLeaderBoard:nil];
    [self setMutArrOfUserList:nil];
    [self setAllButton:nil];
    [self setCheetahButton:nil];
    [self setGazelleButton:nil];
    [self setChallengedUserButton:nil];
    [self setViewSegment:nil];
    [self setTxtViewDetails:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


- (void)dealloc {
    [m_caller release];
    [imageDownloadsInProgress release];
    [viewLeaderBoard release];
    [tblLeaderBoard release];
    [mutArrOfUserList release];
    [mutArrOfgazelleList release];
    [mutArrOfcheetahList release];
    [mutArrOfchallengeList release];
    [allButton release];
    [cheetahButton release];
    [gazelleButton release];
    [challengedUserButton release];
    [viewSegment release];
    [txtViewDetails release];
    [super dealloc];
}
@end
