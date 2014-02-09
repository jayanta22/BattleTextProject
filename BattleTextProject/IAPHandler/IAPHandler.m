//
//  IAPHandler.m
//  InAppSample
//
//  Created by Subhra Roy on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "IAPHandler.h"
#import "GameTokenViewController.h"

@implementation IAPHandler

@synthesize request = _request;
@synthesize delegate;
@synthesize  purchasedProducts  = _purchasedProducts;
@synthesize  productIdentifiers = _productIdentifiers;

@synthesize _previousProductIdentifier;


static     IAPHandler      *inAppInstance=nil;


#pragma mark-
#pragma mark  Singleton Instance

+(IAPHandler*)shareInstance
{
    if (inAppInstance == nil) {
        
        inAppInstance = [[IAPHandler alloc] init];
        [[SKPaymentQueue defaultQueue] addTransactionObserver:inAppInstance];
        
        return inAppInstance;
    }
    
    return inAppInstance;
}

#pragma mark-
#pragma mark  identifire Method

-(void)setIdentifire:(NSSet*)product  _sender:(GameTokenViewController*)sender
{
    _productIdentifiers=product;
    
    parent=sender;
    
}

#pragma mark-
#pragma mark  Request For Product Method

- (void)requestForProducts {
    
    if([self CheckNetworkForPurchase])
    {
        
        _request = [[[SKProductsRequest alloc] initWithProductIdentifiers:_productIdentifiers] autorelease];
        _request.delegate = self;
        [_request start];
    }
    else {
        [parent killHUD];
        
        //[parent.indicator  HideActivity];
        
        UIAlertView    *alert=[[UIAlertView  alloc] initWithTitle:@"InApp Purchase" message:@"Error in Connenction" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        
        [alert  show];
        [alert  release];
    }
    
}

#pragma mark-
#pragma mark  SKProductRequest Delegate


- (void)productsRequest:(SKProductsRequest *)request didReceiveResponse:(SKProductsResponse *)response
{
    
    NSLog(@"Received products results...");   
    
    _products_Arr = response.products;
    NSLog(@"_products_Arr %@  response.products %@",_products_Arr,response.products);
    _request.delegate=nil;
    _request = nil;
    
   
    
    if(delegate)
        [delegate  retrivedAllProducts:_products_Arr];

}

- (void)requestDidFinish:(SKRequest *)request
{
    ;
}


- (void)request:(SKRequest *)request didFailWithError:(NSError *)error
{

    [parent killHUD];
    NSLog(@"Failed to connect with error: %@", [error localizedDescription]); 
}

#pragma mark-
#pragma mark  Check Network

-(BOOL)CheckNetworkForPurchase
{
    
    BOOL success = NO;
    
    NetworkStatus currentStatus = [[Reachability reachabilityForInternetConnection] 
                                   currentReachabilityStatus];
    
    
    if(currentStatus == ReachableViaWiFi)
    {
        return YES;
    }
    
    else if(currentStatus == ReachableViaWWAN)
    {
        
        return YES;
    }
    
    else if(currentStatus == NotReachable){
        
        success = NO;
        
    }
    else
    {
        ;
    }
    
    return success;
    
}

//----------------------Transaction-----------------------------//

#pragma mark-
#pragma mark   Transaction Delegate Method


-(void)paymentQueue:(SKPaymentQueue *)queue updatedTransactions:(NSArray *)transactions 
{
    for(SKPaymentTransaction *transaction in transactions) {
        
        switch (transaction.transactionState) {
            case SKPaymentTransactionStateFailed:
                [self errorWithTransaction:transaction];
                break;
            case SKPaymentTransactionStatePurchasing:
                NSLog(@"Purchasing...");
                break;
            case SKPaymentTransactionStatePurchased:
                [self  finishedTransaction:transaction];
                break;
            case SKPaymentTransactionStateRestored:
                [self restoreTransaction:transaction];
                break;
            default:
                break;
        }
    }
}

-(void)paymentQueueRestoreCompletedTransactionsFinished:(SKPaymentQueue *)queue {
    NSLog(@"Restored all completed transactions");
    
    [parent killHUD];
    
}

-(void)paymentQueue:(SKPaymentQueue *)queue removedTransactions:(NSArray *)transactions
{
    ;
}


#pragma mark-
#pragma mark  Finish Transction Method

-(void)finishedTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"Finished transaction");
    
    NSLog(@"%@",[NSString   stringWithFormat:@"receipt_%@",transaction.payment.productIdentifier]);
    
  /*  if(![[NSUserDefaults  standardUserDefaults]  objectForKey:[NSString   stringWithFormat:@"receipt_%@",transaction.payment.productIdentifier]])
    {
        
        // save receipt
        [[NSUserDefaults standardUserDefaults] setObject:transaction.transactionIdentifier forKey:[NSString   stringWithFormat:@"receipt_%@",transaction.payment.productIdentifier]];
        
        if([@"ghhdjhd"  isEqualToString:transaction.payment.productIdentifier])
        {
            [[NSUserDefaults  standardUserDefaults]  setObject:transaction.payment.productIdentifier forKey:@"receiptRenew"];
            
            
        }
        
        // check receipt
        [self checkReceipt:transaction.transactionReceipt];
    }*/
    
    [self checkReceipt:transaction.transactionReceipt];

    //[[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    });

}

#pragma mark-
#pragma mark  Restore Transction Method

-(void)restoreTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"Restore transaction");
    
    
    
    if([_previousProductIdentifier  isEqualToString:transaction.payment.productIdentifier])
    {
        
        if([[NSUserDefaults  standardUserDefaults]  objectForKey:[NSString   stringWithFormat:@"receipt_%@",transaction.payment.productIdentifier]])
        {
            
            [[NSUserDefaults  standardUserDefaults]  setObject:transaction.transactionIdentifier forKey:[NSString  stringWithFormat:@"purchase_%@",transaction.payment.productIdentifier]];
            
            if([@"hahhsk"  isEqualToString:transaction.payment.productIdentifier])
            {
                [[NSUserDefaults  standardUserDefaults]  setObject:transaction.payment.productIdentifier forKey:@"receiptRenew"];
                
               
            }
            
            // check receipt
            [self checkReceiptsForRestore:transaction.transactionReceipt];
        }
        
    }


    // [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        [[SKPaymentQueue defaultQueue] finishTransaction: transaction];
    });

}


-(void)errorWithTransaction:(SKPaymentTransaction *)transaction {
    NSLog(@"[transaction.error code]%d",[transaction.error code]);
    [[SKPaymentQueue defaultQueue] finishTransaction:transaction];
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Unable to Process "
                                                    message:[transaction.error localizedDescription]
                                                   delegate:nil
                                          cancelButtonTitle:@"Close"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
    
    [parent killHUD];
    
    
}

//----------------------Transaction for buy---------------//

#pragma mark-
#pragma mark  Buy product identifire method

- (void)buyProductIdentifier:(NSString *)productIdentifier {
    
    NSLog(@"Buying %@...", productIdentifier);
    
   
    
    if([SKPaymentQueue canMakePayments])
    {
        
        SKPayment *payment = [SKPayment paymentWithProductIdentifier:productIdentifier];
       
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        
        UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                message: @"You have no authentication"
                                                              delegate : nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [failureAlert show];
        [failureAlert release];
    }
    
}
-(void)bySKProduct:(SKProduct*)_product
{
    if([SKPaymentQueue canMakePayments])
    {
        
        SKPayment *payment=[SKPayment paymentWithProduct:_product];
    
        
        [[SKPaymentQueue defaultQueue] addPayment:payment];
    }
    else {
        
        UIAlertView *failureAlert = [[UIAlertView alloc] initWithTitle :@"In-App-Purchase Error:"
                                                                message: @"You have no authentication"
                                                              delegate : nil cancelButtonTitle:@"OK"otherButtonTitles:nil];
        [failureAlert show];
        [failureAlert release];
        [parent killHUD];
    }

}
//-------------Transaction for restore-----------------//

#pragma mark-
#pragma mark  Restore transaction

- (void)restorePreviousTransaction:(NSString*)previousproduct
{
    _previousProductIdentifier=previousproduct;
    
    [[SKPaymentQueue defaultQueue] restoreCompletedTransactions];
    
}



//-----------------------------------------------------------------//

#pragma mark-
#pragma mark   Check Receipt Method For New transaction

-(void)checkReceipt:(NSData *)receipt {
    // save receipt
    
    /*
    NSString *receiptStorageFile = [DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"];
    NSMutableArray *receiptStorage = [[NSMutableArray alloc] initWithContentsOfFile:receiptStorageFile];
    if(!receiptStorage) {
        receiptStorage = [[NSMutableArray alloc] init];
    }
    [receiptStorage addObject:receipt];
    [receiptStorage writeToFile:receiptStorageFile atomically:YES];
    [receiptStorage release];*/
    
    
        
    [[ReceiptCheck  initShareReceiptCheck]  checkReceipt:receipt]; 
    [[ReceiptCheck  initShareReceiptCheck]  setDelegate:self];
    [[ReceiptCheck  initShareReceiptCheck]  setRetrivedResponse:0];
}

#pragma mark-
#pragma mark  Received response  Delegate

-(void)receivedResponse:(BOOL)status  ResponseMSG:(NSString*)response
{
    if(status==YES) {
       
        _Received_Message=response;
        
      /*  UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Purchase message:PurchaseProduct delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        alert.tag=200;
        
        [alert show];
        [alert release];*/
        
        if(delegate)
            [delegate  successfullTransaction:_Received_Message];

        
        
    } else {
       
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"In-App Purchase" message:@"Purchase Error:Cannot validate receipt" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert show];
        [alert release];
    };

}




#pragma mark - Check all saved receipts

-(void)checkReceiptsForRestore:(NSData *)receipt {
    
    
    // open receipts
    /*NSArray *receipts = [[[NSArray alloc] initWithContentsOfFile:[DocumentsDirectory stringByAppendingPathComponent:@"receipts.plist"]] autorelease];
    if(!receipts || [receipts count]==0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"No receipts" message:nil delegate:nil cancelButtonTitle:@"Close" otherButtonTitles:nil];
        [alert show];
        [alert release];
        return;
    }*/
    
    //for(NSData *aReceipt in receipts) {
        
    [[ReceiptCheck  initShareReceiptCheck]  checkReceipt:receipt]; 
    [[ReceiptCheck  initShareReceiptCheck]  setDelegate:self];
    [[ReceiptCheck  initShareReceiptCheck]  setRetrivedResponse:1];
    //}

    
    
}

#pragma mark-
#pragma mark  received restore response delegate


-(void)receivedResponse_Restore:(BOOL)status  ResponseMSG:(NSString*)response
{
    restore_Message=response;
    
    /*UIAlertView *alert = [[UIAlertView alloc] initWithTitle:Purchase
                                                    message:ProductRestore
                                                   delegate:self
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];//@"Success:%d - Message:%@",status,response
    
    alert.tag=100;
    [alert show];
    [alert release];*/
    
    if(delegate)
        [delegate  successfullRestore:restore_Message];


}

#pragma mark-
#pragma mark  Alert view Delegate

/*
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView.tag==100)
    {
        if(buttonIndex==0)
        {
             
            if(delegate)
                [delegate  successfullRestore:restore_Message];

        }
    }
    if(alertView.tag==200)
    {
        if(buttonIndex==0)
        {
            
            if(delegate)
                [delegate  successfullTransaction:_Received_Message];
        }
    }

}
*/

#pragma mark-
#pragma mark   Dealloc

- (void) dealloc {
	[super dealloc];
}

@end
