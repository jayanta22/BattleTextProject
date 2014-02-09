//
//  ReceiptCheck.h
//  Newsstand
//
//  Created by Carlo Vigiani on 29/Oct/11.
//  Copyright (c) 2011 viggiosoft. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum
{
    PURCHASE_RESPONSE,
    RESTORE_RESPONSE

}PurchaseOrRestoreResponse;

@protocol ReceiptCheckDelegate <NSObject>

-(void)receivedResponse:(BOOL)status  ResponseMSG:(NSString*)response;
-(void)receivedResponse_Restore:(BOOL)status  ResponseMSG:(NSString*)response;

@end


@interface ReceiptCheck : NSObject<NSURLConnectionDelegate> {
    NSMutableData *receivedData;
    
    NSObject<ReceiptCheckDelegate>*delegate;
    
    PurchaseOrRestoreResponse    retrivedResponse;
}

@property(nonatomic,retain)NSObject<ReceiptCheckDelegate>*delegate;

//+(ReceiptCheck *)validateReceiptWithData:(NSData *)receiptData completionHandler:(void(^)(BOOL,NSString *))handler;



@property (nonatomic,retain) void(^completionBlock)(BOOL,NSString *);
@property (nonatomic,retain) NSData *receiptData;
@property(nonatomic,readwrite) PurchaseOrRestoreResponse    retrivedResponse;


+(ReceiptCheck*)initShareReceiptCheck;
-(void)checkReceipt:(NSData *)_receiptData;

@end
