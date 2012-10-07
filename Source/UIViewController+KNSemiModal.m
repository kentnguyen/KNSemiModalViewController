//
//  KNSemiModalViewController.m
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

const struct KNSemiModalOptionKeys KNSemiModalOptionKeys = {
	.animationDuration = @"KNSemiModalOptionAnimationDuration",
	.pushParentBack = @"KNSemiModalOptionPushParentBack",
};

#define kSemiModalTransitionOptions @"kn_semiModalTransitionOptions"
#define kSemiModalDefaultAnimationDuration 0.5

@interface UIViewController (KNSemiModalInternal)
-(UIView*)parentTarget;
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward;
@end

@implementation UIViewController (KNSemiModalInternal)

-(UIView*)parentTarget {
  // To make it work with UINav & UITabbar as well
  UIViewController * target = self;
  while (target.parentViewController != nil) {
    target = target.parentViewController;
  }
  return target.view;
}

#pragma mark Options accessors

-(double)kn_optionsDurationOrDefault {
	NSDictionary *options = objc_getAssociatedObject(self, kSemiModalTransitionOptions);
	return [([options objectForKey:KNSemiModalOptionKeys.animationDuration]
					 ?: @(kSemiModalDefaultAnimationDuration)) doubleValue];
}

-(BOOL)kn_optionsPushParentBackOrDefault {
	NSDictionary *options = objc_getAssociatedObject(self, kSemiModalTransitionOptions);
	if (options == nil || [options objectForKey:KNSemiModalOptionKeys.pushParentBack] == nil) {
		return NO; // default - options dict or key not set
	} else {
		return [[options objectForKey:KNSemiModalOptionKeys.pushParentBack] boolValue];
	}
}

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
  // Create animation keys, forwards and backwards
  CATransform3D t1 = CATransform3DIdentity;
  t1.m34 = 1.0/-900;
  t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
  t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);

  CATransform3D t2 = CATransform3DIdentity;
  t2.m34 = t1.m34;
  t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
  t2 = CATransform3DScale(t2, 0.8, 0.8, 1);

  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = [self kn_optionsDurationOrDefault];
  animation.duration = duration/2;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];

  CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
  animation2.beginTime = animation.duration;
  animation2.duration = animation.duration;
  animation2.fillMode = kCAFillModeForwards;
  animation2.removedOnCompletion = NO;

  CAAnimationGroup *group = [CAAnimationGroup animation];
  group.fillMode = kCAFillModeForwards;
  group.removedOnCompletion = NO;
  [group setDuration:animation.duration*2];
  [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
  return group;
}
@end

@implementation UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc {
	[self presentSemiViewController:vc withOptions:nil];
}

-(void)presentSemiView:(UIView*)view {
	[self presentSemiView:view withOptions:nil];
}

-(void)presentSemiViewController:(UIViewController*)vc withOptions:(NSDictionary*)options {
  [self presentSemiView:vc.view withOptions:options];
}

-(void)presentSemiView:(UIView*)view withOptions:(NSDictionary*)options {
  // Determine target
  UIView * target = [self parentTarget];
	
  if (![target.subviews containsObject:view]) {
		// Remember transition options for symmetrical dismiss transition
		objc_setAssociatedObject(self, kSemiModalTransitionOptions, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
		
    // Calulate all frames
    CGRect sf = view.frame;
    CGRect vf = target.frame;
    CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
    CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);

    // Add semi overlay
    UIView * overlay = [[UIView alloc] initWithFrame:target.bounds];
    overlay.backgroundColor = [UIColor blackColor];
    
    // Take screenshot and scale
    UIGraphicsBeginImageContextWithOptions(target.bounds.size, YES, [[UIScreen mainScreen] scale]);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView * ss = [[UIImageView alloc] initWithImage:image];
    [overlay addSubview:ss];
    [target addSubview:overlay];

    // Dismiss button
    // Don't use UITapGestureRecognizer to avoid complex handling
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = of;
    [overlay addSubview:dismissButton];

    // Begin overlay animation
		if ([self kn_optionsPushParentBackOrDefault]) {
			[ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
		}
		NSTimeInterval duration = [self kn_optionsDurationOrDefault];
    [UIView animateWithDuration:duration animations:^{
      ss.alpha = 0.5;
    }];

    // Present view animated
    view.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
    [target addSubview:view];
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(0, -2);
    view.layer.shadowRadius = 5.0;
    view.layer.shadowOpacity = 0.8;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;

    [UIView animateWithDuration:duration animations:^{
      view.frame = f;
    } completion:^(BOOL finished) {
      if(finished){
        [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidShowNotification
                                                            object:self];
      }
    }];
  }
}

-(void)dismissSemiModalView {
  UIView * target = [self parentTarget];
  UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
  UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
	NSTimeInterval duration = [self kn_optionsDurationOrDefault];
	[UIView animateWithDuration:duration animations:^{
    modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
  } completion:^(BOOL finished) {
    [overlay removeFromSuperview];
    [modal removeFromSuperview];
  }];

  // Begin overlay animation
  UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
	if ([self kn_optionsPushParentBackOrDefault]) {
		[ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
	}
  [UIView animateWithDuration:duration animations:^{
    ss.alpha = 1;
  } completion:^(BOOL finished) {
    if(finished){
      [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidHideNotification
                                                          object:self];
    }
  }];
}

- (void)resizeSemiView:(CGSize)newSize {
  UIView * target = [self parentTarget];
  UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
  CGRect mf = modal.frame;
  mf.size.width = newSize.width;
  mf.size.height = newSize.height;
  mf.origin.y = target.frame.size.height - mf.size.height;
  UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
  UIButton * button = [[overlay subviews] objectAtIndex:1];
  CGRect bf = button.frame;
  bf.size.height = overlay.frame.size.height - newSize.height;
	[UIView animateWithDuration:[self kn_optionsDurationOrDefault] animations:^{
    modal.frame = mf;
    button.frame = bf;
  } completion:^(BOOL finished) {
    if(finished){
      [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalWasResizedNotification
                                                          object:self];
    }
  }];
}

@end

#pragma mark - 

// Convenient category method to find actual ViewController that contains a view
// Adapted from: http://stackoverflow.com/questions/1340434/get-to-uiviewcontroller-from-uiview-on-iphone

@implementation UIView (FindUIViewController)
- (UIViewController *) containingViewController {
  UIView * target = self.superview ? self.superview : self;
  return (UIViewController *)[target traverseResponderChainForUIViewController];
}

- (id) traverseResponderChainForUIViewController {
  id nextResponder = [self nextResponder];
  BOOL isViewController = [nextResponder isKindOfClass:[UIViewController class]];
  BOOL isTabBarController = [nextResponder isKindOfClass:[UITabBarController class]];
  if (isViewController && !isTabBarController) {
    return nextResponder;
  } else if(isTabBarController){
    UITabBarController *tabBarController = nextResponder;
    return [tabBarController selectedViewController];
  } else if ([nextResponder isKindOfClass:[UIView class]]) {
    return [nextResponder traverseResponderChainForUIViewController];
  } else {
    return nil;
  }
}

@end