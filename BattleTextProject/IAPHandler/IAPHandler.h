//
//  IAPHandler.h
//  InAppSample
//
//  Created by Subhra Roy on 18/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//



#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "Reachability.h"
#import "ReceiptCheck.h"



@protocol ResponseOfProductDelegate <NSObject>

@required

-(void)retrivedAllProducts:(NSArray*)productArr;

@optional

-(void)successfullTransaction:(NSString*)message;
-(void)successfullRestore:(NSString*)message;

@end


@class GameTokenViewController;

@interface IAPHandler : NSObject<SKProductsRequestDelegate,SKPaymentTransactionObserver,ReceiptCheckDelegate>
{

    SKProductsRequest    *request;
    
    NSSet      *_productIdentifiers;
    NSArray    *_products_Arr;
    NSMutableSet * _purchasedProducts;
    
    NSObject<ResponseOfProductDelegate>*delegate;
    
    GameTokenViewController    *parent;
    
    NSString   *restore_Message;
    
    NSString   *_previousProductIdentifier;
    
    NSString   *_Received_Message;
}

@property(nonatomic,retain)SKProductsRequest    *request;
@property(nonatomic,retain)NSObject<ResponseOfProductDelegate>*delegate;
@property(nonatomic,retain)NSMutableSet   *purchasedProducts;
@property(nonatomic,retain)NSSet      *productIdentifiers;

@property(nonatomic,retain) NSString   *_previousProductIdentifier;


+(IAPHandler*)shareInstance;
-(void)setIdentifire:(NSSet*)product  _sender:(GameTokenViewController*)parent;
- (void)requestForProducts;
-(BOOL)CheckNetworkForPurchase;

-(void)buyProductIdentifier:(NSString *)productIdentifier;
-(void)bySKProduct:(SKProduct*)_product;
-(void)finishedTransaction:(SKPaymentTransaction *)transaction ;
-(void)restoreTransaction:(SKPaymentTransaction *)transaction;
-(void)errorWithTransaction:(SKPaymentTransaction *)transaction;

-(void)checkReceipt:(NSData *)receipt;
-(void)checkReceiptsForRestore:(NSData *)receipt;
- (void)restorePreviousTransaction:(NSString*)previousproduct;

@end
