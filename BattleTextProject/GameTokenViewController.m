//
//  GameTokenViewController.m
//  BattleTextProject
//
//   Created by freelancer on 12/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "GameTokenViewController.h"
#import "GameTokenCell.h"
#import "LeaderBoardViewController.h"
#import "ShopViewController.h"
#import "PlayGameViewController.h"
#import "JSON.h"

@interface GameTokenViewController ()
@end

@implementation GameTokenViewController
@synthesize tblGameToken;
@synthesize m_caller;
@synthesize mutArrayOfToken;
@synthesize callerID;
@synthesize totalProduct_Arr;

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
    self.title=@"Buy Game Tokens";
    totalProduct_Arr=[[NSMutableArray alloc] init];
    // Do any additional setup after loading the view from its nib.
    [self getGameToken];
}

#pragma mark tableview delegates and data sources




- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return [mutArrayOfToken count]+1;
    
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"GameTokenCell";
   
    GameTokenCell *cellM =(GameTokenCell *) [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cellM == nil) {
        UIViewController *controller=[[[UIViewController alloc]initWithNibName:CellIdentifier bundle:nil]autorelease];
        cellM = (GameTokenCell *)controller.view;
    }
    if(indexPath.row%2==0){
        
        cellM.bgImage.image=[UIImage imageNamed:@"strip_even.png"];
        
    }
    else{
        
        cellM.bgImage.image=[UIImage imageNamed:@"strip_odd.png"];
    }
    if(indexPath.row ==0)
    {
        cellM.lblToken.text=@"Game Token";
        cellM.lblPrice.frame=CGRectMake(cellM.lblPrice.frame.origin.x-25, cellM.lblPrice.frame.origin.y, cellM.lblPrice.frame.size.width+20, cellM.lblPrice.frame.size.height);
        cellM.lblPrice.text=@"Real Cash";
        cellM.btnBuy.hidden=YES;
        cellM.lblBuyFor.hidden=YES;
        
    }
    else
    {
        cellM.btnBuy.hidden=NO;
        cellM.lblBuyFor.hidden=NO;
        NSDictionary *dic=mutArrayOfToken[indexPath.row -1];
        cellM.lblToken.text=[NSString stringWithFormat:@"%@ tokens",dic[@"userid"]];
        cellM.lblPrice.text=[NSString stringWithFormat:@"$ %@",dic[@"price"]];
        cellM.btnBuy.tag=indexPath.row-1;
        [cellM.btnBuy addTarget:self action:@selector(buyToken:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    cellM.selectionStyle=UITableViewCellSelectionStyleNone;
    
    return cellM;
    
}


#pragma mark methods and button action

-(void)buyToken:(id)sender{
    
    UIButton *btn=(UIButton *)sender;
    NSLog(@"btnbtnbtn %d",btn.tag);
    
    if([mutArrayOfToken count]>btn.tag)
    {
    selectedDict=mutArrayOfToken[btn.tag];
    NSLog(@"dicdic %@ totalProduct_Arr %@",selectedDict,totalProduct_Arr);
    if([totalProduct_Arr count]>btn.tag)
    {
       
         [self showHUD];
    SKProduct *product = totalProduct_Arr[btn.tag];
        
        [[IAPHandler shareInstance]bySKProduct:product];
        NSLog(@"product .identifier %@  selectedDict %@ ",product.productIdentifier,selectedDict);
   // [[IAPHandler  shareInstance]  buyProductIdentifier:[selectedDict objectForKey:@"product_identifier"]];//[selectedDict objectForKey:@"product_identifier"]
    }

    }
    
}

#pragma mark-
#pragma mark  Response of Transaction delegate  Methods

-(void)successfullTransaction:(NSString*)message
{
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    callerID=2;
    NSLog(@"selectedDict %@",selectedDict);
    [m_caller updateGameToken:kUserID getTokens:selectedDict[@"userid"]];
    NSLog(@"Transaction successfully completed");
    [self killHUD];

    NSLog(@"Purchase data:%@",message);
    
      SBJSON *jsonParsing =[SBJSON  new];
    
    NSDictionary *parentJSONDirectory = [jsonParsing objectWithString:message error:nil];
    
    
    for(id key in parentJSONDirectory)
        NSLog(@"%@",key);
    
    NSDictionary    *receiptJSONDictionary=[parentJSONDirectory   valueForKey:@"receipt"];
    
    for(id key in receiptJSONDictionary)
        NSLog(@"%@",key);
    
    
    NSString   *status_Value_Str=[parentJSONDirectory valueForKey:@"status"];
    
    NSLog(@"%@",status_Value_Str);//status of purchase(if 0 then valid else....)
    
    //-----------------------
    /*   NSString   *purchase_Date=[receiptJSONDictionary  valueForKeyPath:@"purchase_date"];
     // NSLog(@"%@",purchase_Date);
     
     NSString  *formattedPurchase_Date=@"";
     
     if([purchase_Date  length]>0)
     formattedPurchase_Date=[purchase_Date  substringWithRange:NSMakeRange(0,19)];*/
    
    //NSLog(@"%@",formattedPurchase_Date);
    
    
    //----------------------
    
    //NSString  *formattedExpire_Date=@"";
       
}

-(IBAction)leaderBoardButtonAction:(id)sender{
    NSString *stringNibName=@"LeaderBoardViewController";
    if([self isiPhone5])
    {
        stringNibName=@"LeaderBoardViewController-iPhone5";
    }
    else
    {
        stringNibName=@"LeaderBoardViewController";
    }

    LeaderBoardViewController *controller=[[LeaderBoardViewController alloc]initWithNibName:stringNibName bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release],controller=nil;
    
}

- (void)getGameToken{
    
    m_caller = [[AMFCaller alloc] init];
    m_caller.delegate = self;
    [m_caller getGameToken];
    callerID=1;
    [self showHUD];

    
}

- (IBAction)gamePlayButtonAction:(id)sender {
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

- (IBAction)shopButtonAction:(id)sender {
    
    NSString *stringNibName=@"ShopViewController";
    if([self isiPhone5])
    {
        stringNibName=@"ShopViewController-iPhone5";
    }
    else
    {
        stringNibName=@"ShopViewController";
    }

    
    ShopViewController *controller=[[ShopViewController alloc]initWithNibName:stringNibName bundle:nil];
    [self.navigationController pushViewController:controller animated:YES];
    [controller release],controller=nil;
}


#pragma mark 
#pragma mark amf delegate
#pragma mark 


#pragma mark amfcaller delegates

- (void)callerDidFinishLoading:(AMFCaller *)caller receivedObject:(NSObject *)object
{
    
    
    if(callerID==1){
        NSDictionary *dic=(NSDictionary *)object;
        NSLog(@"dic %@",dic);
       
        
        if(mutArrayOfToken){
            
            [mutArrayOfToken release];
        }
      
         mutArrayOfToken=(NSMutableArray *)object;
        [mutArrayOfToken retain];
//        for(id keyValue in [dic allKeys]){
//            
//            if(![keyValue isEqual:@"errorcode"])
//                [mutArrayOfToken addObject:[dic objectForKey:keyValue]];
//            
//        }
        NSLog(@"mutArrayOfToken %@",mutArrayOfToken[0][@"product_identifier"]);
        [self killHUD];
        [tblGameToken reloadData];
        
        [self   performSelector:@selector(callIAPHandler) withObject:nil afterDelay:0.0];
    }
    else if(callerID==2){
        
        NSArray *arrResult = (NSArray*)object;
        
        for(NSDictionary *dic in arrResult)
        {
            
            if([dic[@"errorcode"] intValue]==0){
                
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Upgrade game token status" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                
            }
            else if([dic[@"errorcode"] intValue]==1){
                
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Upgrade game token status" message:dic[@"msg"] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                
                [alert show];
                [alert release];
                
                
            }
        }
        
        [self killHUD];
        
    }
    
}
- (void)caller:(AMFCaller *)caller didFailWithError:(NSError *)error{
    
    UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"Upgrade game token Status" message:[error description] delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    
    [alert show];
    [alert release];
    
    [self killHUD];
}
#pragma mark-
#pragma mark  callIAPHandler  Method

-(void)callIAPHandler
{
  
    NSMutableArray *arrProductIdentifiers=[[NSMutableArray alloc] init];
    for (int i=0; i<[mutArrayOfToken count]; i++) {
       
        [arrProductIdentifiers addObject:mutArrayOfToken[i][@"product_identifier"]];
        
        NSLog(@"arrProductIdentifiers %@",[arrProductIdentifiers objectAtIndex:i]);
        
    }
    NSArray *tempArr=[(NSArray*)arrProductIdentifiers retain];
     NSMutableSet *setProductIdentifier=[NSMutableSet setWithArray:arrProductIdentifiers];
    
    [[IAPHandler  shareInstance]  setIdentifire:(NSSet *)setProductIdentifier  _sender:self];
    [[IAPHandler  shareInstance]  setDelegate:self];
    [[IAPHandler  shareInstance]  requestForProducts];
    
    [arrProductIdentifiers removeAllObjects];
    [arrProductIdentifiers release];
    
    [tempArr release];
    
}
#pragma mark-
#pragma mark  Response of Product delegate

-(void)retrivedAllProducts:(NSArray*)productArr
{
    NSArray *arr=  (NSArray*)productArr;//[productArr  retain];
  
    NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:@"price" ascending:YES];
    arr=[arr sortedArrayUsingDescriptors:[NSArray arrayWithObject:sort]];
    totalProduct_Arr =[(NSMutableArray*)arr retain];
    
    for (int i=0; i<[totalProduct_Arr count]; i++) {
        
        SKProduct *product=[totalProduct_Arr objectAtIndex:i];
        
        NSLog(@"productIdentifier %@ price %@ description %@",product.productIdentifier, product.price, product.description);
    }
   // totalProduct_Arr=[(NSMutableArray*)productArr retain];

    
   
}

- (void)viewDidUnload
{
    [self setTblGameToken:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [tblGameToken release];
    [super dealloc];
}
@end
