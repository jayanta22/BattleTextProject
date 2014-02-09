//
//  ReceiptCheck.m
//  Newsstand
//
//  Created by Carlo Vigiani on 29/Oct/11.
//  Copyright (c) 2011 viggiosoft. All rights reserved.
//

#import "ReceiptCheck.h"
#import "NSString+Base64.h"

//#warning INSERT YOUR ITUNESCONNECT SHARED SECRET
#define SHARED_SECRET    @"a5f1c2385cf34acb8a657b1adf5c31b4"    /*@"INSERT HERE YOUR ITUNESCONNECT SHARED SECRECT KEY FOR AUTORENEWABLE SUBCRIPTIONS RECEIPT VALIDATION"*/

@implementation ReceiptCheck

@synthesize receiptData,completionBlock;

@synthesize delegate;
@synthesize retrivedResponse;

static    ReceiptCheck *checker=nil;

/*+(ReceiptCheck *)validateReceiptWithData:(NSData *)_receiptData completionHandler:(void(^)(BOOL,NSString *))handler {
    ReceiptCheck *checker = [[ReceiptCheck alloc] init];
    checker.receiptData=_receiptData;
    checker.completionBlock=handler;
    
    [checker checkReceipt];
    return checker;
    
}*/

#pragma mark-
#pragma mark  Share Instance  Method

+(ReceiptCheck*)initShareReceiptCheck
{
    if(checker==nil)
    {
        checker=[[ReceiptCheck  alloc] init];
        
    }
    
    return checker;
}

#pragma mark-
#pragma mark  Check Receipt  Method

-(void)checkReceipt:(NSData *)_receiptData{
    // verifies receipt with Apple
    NSError *jsonError = nil;
    
    receiptData=_receiptData;
    
    NSString *receiptBase64 = [NSString base64StringFromData:receiptData length:[receiptData length]];
    
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:@{@"receipt-data": receiptBase64,
                                                                @"password": SHARED_SECRET}
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&jsonError];
    
    // URL for sandbox receipt validation; replace "sandbox" with "buy" in production or you will receive
    // error codes 21006 or 21007
    
    NSURL *requestURL = [NSURL URLWithString:@"https://sandbox.itunes.apple.com/verifyReceipt"];
    
    NSMutableURLRequest *req = [[NSMutableURLRequest alloc] initWithURL:requestURL];
    [req setHTTPMethod:@"POST"];
    [req setHTTPBody:jsonData];
    NSURLConnection *conn = [[NSURLConnection alloc] initWithRequest:req delegate:self];
    if(conn) {
        receivedData = [[NSMutableData alloc] init];
    } else {
       // completionBlock(NO,@"Cannot create connection");
        //[self autorelease];
        ;
    }
}

#pragma mark-
#pragma mark  Connection  Delegate Method

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    NSLog(@"Cannot transmit receipt data. %@",[error localizedDescription]);
    //completionBlock(NO,[error localizedDescription]);
    //[self autorelease];
    ;
}

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    [receivedData setLength:0];
}

-(void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [receivedData appendData:data];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection {
    NSString *response = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
   // NSLog(@"iTunes response: %@",response);
    
    //self.completionBlock(YES,response);
    //[self autorelease];
    
    if(retrivedResponse==0)
    {
        if(delegate)
            [delegate  receivedResponse:YES ResponseMSG:response];
    }
    else if(retrivedResponse==1){
        if(delegate)
            [delegate  receivedResponse_Restore:YES ResponseMSG:response];
    }
    
    
}


@end
