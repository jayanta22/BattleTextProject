//
//  UIViewController+UICustomController.m
//  BattleTextProject
//
//   Created by freelancer on 08/07/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "UIViewController+UICustom.h"
#import "BattleTextAppDelegate.h"

@implementation UIViewController (UICUstom)

- (void) showHUDTitled : (NSString *) title andSubTitled : (NSString *) subTitle
{
    // Should be initialized with the windows frame so the HUD disables all user input by covering the entire screen
	
	BattleTextAppDelegate *appDelgObj = (BattleTextAppDelegate *) [[UIApplication sharedApplication] delegate];
	
	appDelgObj.HUD = [[MBProgressHUD alloc] initWithView:appDelgObj.window ] ;
	[appDelgObj.window addSubview:appDelgObj.HUD];
	[appDelgObj.window bringSubviewToFront:appDelgObj.HUD];
	appDelgObj.HUD.labelText = title;
	appDelgObj.HUD.detailsLabelText = subTitle;
	[appDelgObj.HUD show:YES];
    //	NSLog(@"Completed showHUD");
}
- (void) showHUDWithTitle : (NSString *) title
{
	[self showHUDTitled:title andSubTitled:nil];
}
- (void) showHUD 
{
	[self showHUDTitled:nil andSubTitled:nil];
}
- (void) killHUD
{
    //	NSLog(@"Entered killHUD");
	BattleTextAppDelegate *appDelgObj = (BattleTextAppDelegate *) [[UIApplication sharedApplication] delegate];
	if ( appDelgObj.HUD )
	{
		[appDelgObj.HUD hide:YES];
		[appDelgObj.HUD release], appDelgObj.HUD = nil;
	}
    //	NSLog(@"Completed killHUD");
}



- (BOOL)validateEmail:(NSString *)email {
	
	NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+[.]+[A-Za-z]{2,4}"; 
	NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex]; 
	return [emailTest evaluateWithObject:email];
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

@end
