//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModalDidShowNotification @"kSemiModalDidShowNotification"
#define kSemiModalDidHideNotification @"kSemiModalDidHideNotification"
#define kSemiModalWasResizedNotification @"kSemiModalWasResizedNotification"

extern const struct KNSemiModalOptionKeys {
	__unsafe_unretained NSString *animationDuration; // boxed double, in seconds. default is 0.5.
	__unsafe_unretained NSString *pushParentBack;		 // boxed BOOL. default is YES.
} KNSemiModalOptionKeys;

@interface UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc withOptions:(NSDictionary*)options;
-(void)presentSemiView:(UIView*)view withOptions:(NSDictionary*)options;

-(void)presentSemiViewController:(UIViewController*)vc;
-(void)presentSemiView:(UIView*)vc;
-(void)dismissSemiModalView;
-(void)resizeSemiView:(CGSize)newSize;

@end

// Convenient category method to find actual ViewController that contains a view

@interface UIView (FindUIViewController)
- (UIViewController *) containingViewController;
- (id) traverseResponderChainForUIViewController;
@end