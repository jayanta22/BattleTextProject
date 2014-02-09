//
//  TabToNumberPadController.m
//  BiostatCalculatorApp
//
//   Created by freelancer on 19/07/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "TabToNumberPadController.h"
#import "BattleTextAppDelegate.h"

@implementation TabToNumberPadController
@synthesize barDivider;
@synthesize controller;
@synthesize btnTab;
@synthesize btnReset;
@synthesize btnDone;

- (void)dealloc
{
    [btnTab release];
    [btnReset release];
    [btnDone release];
    [barDivider release];
    [super dealloc];
}


#pragma mark ModalView methods ########

- (void) showModal{
	UIView* modalView=self;
    if([self isiPhone5])
    {
     modalView.frame=CGRectOffset(modalView.frame, 0, 325);
    }
    else{
        
        modalView.frame=CGRectOffset(modalView.frame, 0, 325);
    }
    
	UIWindow* mainWindow = (((BattleTextAppDelegate*) [UIApplication sharedApplication].delegate).window);
	CGPoint middleCenter = modalView.center;   
	CGSize offSize = [UIScreen mainScreen].bounds.size;   
    CGPoint offScreenCenter ;
    offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	modalView.center = offScreenCenter;	

	// we start off-screen   
	[mainWindow addSubview:modalView];    
	// Show it with a transition effect   
    
	[UIView beginAnimations:nil context:nil];   
	[UIView setAnimationDuration:0.2]; 
    // animation duration in seconds   
	modalView.center = middleCenter;
	[UIView commitAnimations]; 
   
    
}
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

- (void)hideModal{

  	UIView* modalView=self; 
	CGSize offSize = [UIScreen mainScreen].bounds.size;
	CGPoint offScreenCenter = CGPointMake(offSize.width / 2.0, offSize.height * 1.5);
	[UIView beginAnimations:nil context:modalView];
	[UIView setAnimationDuration:0.0];
	[UIView setAnimationDelegate:self];
	[UIView setAnimationDidStopSelector:@selector(hideModalEnded:finished:context:)];
	modalView.center = offScreenCenter;
	[UIView commitAnimations];
	
    
}
- (void)hideModalEnded:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
	UIView* modalView = (UIView *)context;
	
	[modalView removeFromSuperview];
	
	
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{

    return (interfaceOrientation == UIInterfaceOrientationPortrait);
        
}


//not needed here

#pragma mark -
#pragma mark Manual oritentation change

#define RADIANS(degrees) ((degrees * (float)M_PI) / 180.0f)

- (void)deviceOrientationDidChange:(NSNotification *)notification { 
    if (!self.superview) {
        return;
    }
    if ([self.superview isKindOfClass:[UIWindow class]]) {
        [self setTransformForCurrentOrientation:YES];
    }
}

- (void)setTransformForCurrentOrientation:(BOOL)animated {
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    NSInteger degrees = 0;
    
    // Stay in sync with the superview
    if (self.superview) {
        self.bounds = self.superview.bounds;
        [self setNeedsDisplay];
    }
    
    if (UIInterfaceOrientationIsLandscape(orientation)) {
        if (orientation == UIInterfaceOrientationLandscapeLeft) { degrees = -90; } 
        else { degrees = 90; }
        // Window coordinates differ!
        self.bounds = CGRectMake(0, 0, self.bounds.size.height, self.bounds.size.width);
    } else {
        if (orientation == UIInterfaceOrientationPortraitUpsideDown) { degrees = 180; } 
        else { degrees = 0; }
    }
    
   CGAffineTransform   rotationTransform = CGAffineTransformMakeRotation(RADIANS(degrees));
    
    if (animated) {
        [UIView beginAnimations:nil context:nil];
    }
    [self setTransform:rotationTransform];
    if (animated) {
        [UIView commitAnimations];
    }
}





@end
