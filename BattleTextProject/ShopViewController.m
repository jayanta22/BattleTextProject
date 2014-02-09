//
//  ShopViewController.m
//  BattleTextProject
//
//   Created by freelancer on 03/09/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//


#import "ShopViewController.h"
#import "CustomShopCell.h"
#import "ShopObjectCC.h"
#import "ImageDownloaderCC.h"
#import "GameTokenViewController.h"
#import "PlayGameViewController.h"
#import "LeaderBoardViewController.h"

@interface ShopViewController ()

@end

@implementation ShopViewController
@synthesize m_caller;
@synthesize callerID;
@synthesize mutArrayOfChances;
@synthesize tblViewShop;
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
    appDel=(BattleTextAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    // Do any additional setup after loading the view from its nib.
    self.navigationItem.title=@"Shop";
    self.navigationItem.backBarButtonItem.title=@"Back";
    self.imageDownloadsInProgress = [NSMutableDictionary dictionary];
    [self buyChancesLists];
    
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

#pragma mark method and button action

- (IBAction)buyCheetahMembershipButtonAction:(id)sender {
    
    
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    callerID=1;
    [m_caller getCheetahMembership:kUserID];

    
}

-(void)buyChancesLists{
    
    [self showHUD];
    
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    callerID=2;
    [m_caller getShopItem];
    
    
}

- (IBAction)buyGameTokenButton:(id)sender {
    
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
- (IBAction)cheetahUserButtonAction:(id)sender
{
    NSString *stringNibName=@"LeaderBoardViewController";
    if([self isiPhone5])
    {
        stringNibName=@"LeaderBoardViewController-iPhone5";
    }
    else
    {
        stringNibName=@"LeaderBoardViewController";
    }

    LeaderBoardViewController *leaderBoardVC=[[LeaderBoardViewController alloc] initWithNibName:stringNibName bundle:nil];
    [self.navigationController pushViewController:leaderBoardVC animated:YES];
    [leaderBoardVC  release];
    

}

- (IBAction)gazelleUserButtonAction:(id)sender
{
    NSString *stringNibName=@"LeaderBoardViewController";
    if([self isiPhone5])
    {
        stringNibName=@"LeaderBoardViewController-iPhone5";
    }
    else
    {
        stringNibName=@"LeaderBoardViewController";
    }
    
    LeaderBoardViewController *leaderBoardVC=[[LeaderBoardViewController alloc] initWithNibName:stringNibName bundle:nil];
    [self.navigationController pushViewController:leaderBoardVC animated:YES];
    [leaderBoardVC  release];
}


#pragma mark tableView delegate and dataSource methods

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 175;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return [mutArrayOfChances count];
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

 
    NSString *cellIdentifier=@"CustomShopCell";
    
    CustomShopCell *cellM=[tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if(cellM==nil){
        
        UIViewController *controller=[[UIViewController alloc]initWithNibName:cellIdentifier bundle:nil];
        cellM=(CustomShopCell *)controller.view;
        [controller release];
        
    }
    ShopObjectCC *obj=mutArrayOfChances[indexPath.row];    
    
    cellM.lblTitle.text=[NSString stringWithFormat:@"%@",obj.item];
    cellM.lblPrice.text=[NSString stringWithFormat:@"%ld GameTokens",(lroundf([obj.price floatValue]))];
    cellM.txtDesc.text=obj.description;
    cellM.btnBuy.tag=[[NSString stringWithFormat:@"%d",indexPath.row]intValue];
    [cellM.btnBuy addTarget:self action:@selector(buyAccessories:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!obj.imgObject.imgIcon)
    {
        
        [cellM.actInd startAnimating];
        cellM.imgViewThumb.image=[UIImage imageNamed:@"ld_back.png"];
        if (self.tblViewShop.dragging == NO && self.tblViewShop.decelerating == NO)
        {
            
            [self startIconDownload:obj.imgObject forIndexPath:indexPath];
            
        }
        // if a download is deferred or in progress, return a placeholder image
        //cell.imgViewLB.image = [UIImage imageNamed:@"2.png"];
    }
    else
    {
        [cellM.actInd stopAnimating];
        cellM.imgViewThumb.image = obj.imgObject.imgIcon;
    }

            
    return cellM;
}

-(void)buyAccessories:(id)sender{
    if([appDel.strChances integerValue]>0 || [appDel.strGameToken integerValue]>0)
    {
       
    
      
    
    UIButton *btn=(UIButton *)sender;
    
    if(btn.tag==0){
         [self showHUD];
        
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        callerID=1;
        [m_caller getCheetahMembership:kUserID];

        
    }
//    else if(btn.tag ==[mutArrayOfChances count]-1)
//    {
//         [self showHUD];
//        m_caller = [[AMFCaller alloc] init];
//        m_caller.delegate = self;
//        callerID=4;
//        [m_caller buymedals:kUserID];
//
//    
//    }
    else {
         [self showHUD];
        ShopObjectCC *obj=mutArrayOfChances[btn.tag];
        
        m_caller = [[AMFCaller alloc] init];
        m_caller.delegate = self;
        callerID=3;
        NSLog(@"obj.chances %@ obj.price %@",obj.chances,obj.price);
        [m_caller updateGameChances:kUserID getChances:obj.chances gameToken:obj.price];

    }
    }
    else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Insufficient GameToken" message:nil delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
    }

    
}




#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object{
    
    if(callerID==1){
        
        NSArray *arrResult = (NSArray*)object;
        
        for(NSDictionary *dic in arrResult)
        {
            
            if([dic[@"errorcode"] intValue]==0){
                
                    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Cheetah Membership Status" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    
                    [alert show];
                    [alert release];

                
            }
            else if([dic[@"errorcode"] intValue]==1){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Cheetah Membership Status" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];

                
            }
        }
        
        [self killHUD];
    }
    else if(callerID==2){
        
        if(mutArrayOfChances){
            
            [mutArrayOfChances release];
        }
        NSLog(@"callerID %d objectobject %@",callerID,object);
       mutArrayOfChances=[[NSMutableArray alloc]init];
      //  mutArrayOfChances=(NSMutableArray *)object;
        for(NSDictionary *dic in (NSMutableArray *)object )
        {
            {
               // NSDictionary *dic=[dicResult objectForKey:keyValue];
                NSLog(@"dic %@",dic);
                ShopObjectCC *object=[[ShopObjectCC alloc]init];
                object.description=dic[@"description"];
                object.idChances=dic[@"id"];
                object.item=dic[@"item"];
                object.itemType=dic[@"item_type"];
                object.price=dic[@"price"];
                object.chances=dic[@"increase_count"];
                
                object.imgObject=[[ImageDownloaderCC alloc]init];
                object.imgObject.imgLink=dic[@"image"];
                
                [mutArrayOfChances addObject:object];
                
                [object.imgObject release];
                [object release];
                
            }
        }
        
     
        [self killHUD];
        [tblViewShop reloadData];
                       
    }
    else if (callerID==3) {
        
        NSArray *arrResult = (NSArray*)object;
        
        for(NSDictionary *dic in arrResult)
        {
            
            if([dic[@"errorcode"] intValue]==0){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Upgrade chances Status" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                
            }
            else if([dic[@"errorcode"] intValue]==1){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Upgrade chances Status" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                
            }
        }
        
        [self killHUD];
        
    }
    else if(callerID==4)
    {
            NSArray *arrResult = (NSArray*)object;
        for(NSDictionary *dic in arrResult)
        {
            
            if([dic[@"errorcode"] intValue]==0){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Successfull" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                
            }
            else if([dic[@"errorcode"] intValue]==1){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Unsuccessfull" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                
            }
        }
        
        [self killHUD];
    }
    
    
}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{

    if(callerID==1){
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Cheetah Membership Status" message:@"failed to upgrade" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        [self killHUD];
        
    }
    else if(callerID==3){
        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Upgrade chances Status" message:@"failed to upgrade" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert show];
        [alert release];
        
        [self killHUD];

        
    }
        
    
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
    if ([mutArrayOfChances count] > 0)
    {
        NSArray *visiblePaths = [self.tblViewShop indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visiblePaths)
        {
            ShopObjectCC *appRecord = mutArrayOfChances[indexPath.row];
            
            if (!appRecord.imgObject.imgIcon) // avoid the app icon download if the app already has an icon
            {
                [self startIconDownload:appRecord.imgObject forIndexPath:indexPath];
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
        CustomShopCell *cell = (CustomShopCell *)[self.tblViewShop cellForRowAtIndexPath:iconDownloader.indexPathInTableView];
        
        // Display the newly loaded image
        cell.imgViewThumb.image = iconDownloader.imgDownloader.imgIcon;
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

- (void)viewDidUnload
{
    [self setTblViewShop:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tblViewShop release];
    [super dealloc];
}
@end
