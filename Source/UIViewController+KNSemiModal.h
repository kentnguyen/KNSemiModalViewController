//
//  KNSemiModalViewController.h
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#define kSemiModalAnimationDuration   0.5

@interface UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc;
-(void)presentSemiView:(UIView*)vc;
-(void)dismissSemiModalView;

@end
