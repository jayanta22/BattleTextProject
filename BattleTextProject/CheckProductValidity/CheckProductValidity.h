//
//  CheckProductValidity.h
//  InAppSample
//
//  Created by Subhra Roy on 25/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#define kReceiptValidationURL @"https://sandbox.itunes.apple.com/verifyReceipt"
#define kSharedSecret    @"a5f1c2385cf34acb8a657b1adf5c31b4"

#import <Foundation/Foundation.h>
#import <StoreKit/StoreKit.h>
#import "JSONKit.h"

@interface CheckProductValidity : NSObject

@property (nonatomic, copy) void (^onSubscriptionVerificationFailed)();
@property (nonatomic, copy) void (^onSubscriptionVerificationCompleted)(NSNumber* isActive);
@property (nonatomic, strong) NSData *receipt;
@property (nonatomic, readonly) NSDictionary *verifiedReceiptDictionary;
@property (nonatomic, assign) int subscriptionDays; 
@property (nonatomic, strong) NSString *productId;
@property (nonatomic, strong) NSURLConnection *theConnection;
@property (nonatomic, strong) NSMutableData *dataFromConnection;


- (void) verifyReceiptOnComplete:(void (^)(NSNumber*)) completionBlock
                         onError:(void (^)(NSError*)) errorBlock;

-(BOOL) isSubscriptionActive;
-(id) initWithProductId:(NSString*) productId subscriptionDays:(int) days;

-(void)setProductDetails:(NSString*) aProductId subscriptionDays:(int) days;

@end
