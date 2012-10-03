//
//  KNSemiModalViewController.m
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>


@interface KNSemiModalBackground : UIWindow {
@private
  UIWindow *_previousKeyWindow;
}

+ (KNSemiModalBackground *) sharedBackground;

- (void)hide;
- (void)show;

@end

@implementation KNSemiModalBackground

+ (KNSemiModalBackground*)sharedBackground
{
  static dispatch_once_t onceToken;
  static KNSemiModalBackground* __sharedBackground;
  dispatch_once(&onceToken, ^{
    __sharedBackground = [[[self class] alloc] init];
  });
  return __sharedBackground;
}

- (id)init
{
  self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
  if (self) {
    self.windowLevel = UIWindowLevelStatusBar;
    self.userInteractionEnabled = NO;
    self.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
  }
  return self;
}

- (void) show
{
  _previousKeyWindow = [[UIApplication sharedApplication] keyWindow];
  self.hidden = NO;
  self.userInteractionEnabled = YES;
  [self makeKeyWindow];
}

- (void) hide
{
  for (UIView* view in self.subviews) {
    [view removeFromSuperview];
  }
  
  self.hidden = YES;
  self.userInteractionEnabled = NO;
  [_previousKeyWindow makeKeyWindow];
  _previousKeyWindow = nil;
}

@end

@interface UIViewController (KNSemiModalInternal)
-(UIView*)parentTarget;
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward delegate:(id)delegate;
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

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward delegate:(id)delegate {
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
  animation.duration = kSemiModalAnimationDuration/2;
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
  group.delegate = delegate;
  [group setDuration:animation.duration*2];
  [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
  return group;
}
@end

@implementation UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc {
  [self presentSemiView:vc.view];
}

-(void)presentSemiView:(UIView*)view {
  // Determine target
  UIView * target = [self parentTarget];
  
  if (![target.window.subviews containsObject:view]) {
    KNSemiModalBackground *modalBackground = [KNSemiModalBackground sharedBackground];

    // Calulate all frames
    CGRect sf = view.frame;
    CGRect vf = modalBackground.frame;
    CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
    CGRect bf = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);
    CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height);
    
    // Add semi overlay
    UIView *overlay = [[UIView alloc] initWithFrame:of];
    overlay.backgroundColor = [UIColor blackColor];
    overlay.alpha = 0.0f;
    [modalBackground addSubview:overlay];
    
    // Dismiss button
    // Don't use UITapGestureRecognizer to avoid complex handling
    UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [dismissButton addTarget:self action:@selector(dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
    dismissButton.backgroundColor = [UIColor clearColor];
    dismissButton.frame = bf;
    [modalBackground addSubview:dismissButton];
    
    // Begin overlay animation
    target.layer.shouldRasterize = YES;
    target.layer.rasterizationScale = [UIScreen mainScreen].scale*0.8f;
    [target.layer addAnimation:[self animationGroupForward:YES delegate:nil] forKey:@"pushedBackAnimation"];
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
      overlay.alpha = 0.5f;
    }];
    
    // Present view animated
    view.frame = CGRectMake(0, vf.size.height, vf.size.width, vf.size.height);
    [modalBackground addSubview:view];
    view.layer.shadowColor = [[UIColor blackColor] CGColor];
    view.layer.shadowOffset = CGSizeMake(0, -2);
    view.layer.shadowRadius = 5.0;
    view.layer.shadowOpacity = 0.8;
    view.layer.shouldRasterize = YES;
    view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:view.bounds];
    view.layer.shadowPath = path.CGPath;
    
    [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
      view.frame = f;
    } completion:^(BOOL finished) {
      view.layer.shouldRasterize = NO;
      if(finished){
        [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidShowNotification
                                                            object:self];
      }
    }];
    
    [modalBackground show];
  }
}

-(void)dismissSemiModalView {
  UIView * target = [self parentTarget];
  
  KNSemiModalBackground *modalBackground = [KNSemiModalBackground sharedBackground];
  UIView * modal = [modalBackground.subviews objectAtIndex:modalBackground.subviews.count-1];
  UIView * overlay = [modalBackground.subviews objectAtIndex:modalBackground.subviews.count-3];
  [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
    modal.frame = CGRectMake(0, modalBackground.frame.size.height, modal.frame.size.width, modal.frame.size.height);
    overlay.alpha = 0.0f;
  } completion:^(BOOL finished) {
    [modalBackground hide];
    if(finished){
      [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidHideNotification
                                                          object:self];
    }
  }];
  
  // Begin overlay animation
  [target.layer addAnimation:[self animationGroupForward:NO delegate:self] forKey:@"bringForwardAnimation"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag {
  if (flag) {
    UIView * target = [self parentTarget];
    target.layer.rasterizationScale = [UIScreen mainScreen].scale;
    target.layer.shouldRasterize = NO;
  }
}

- (void)resizeSemiView:(CGSize)newSize {
  UIView * target = [self parentTarget];
  UIView * modal = [target.window.subviews objectAtIndex:target.window.subviews.count-1];
  CGRect mf = modal.frame;
  mf.size.width = newSize.width;
  mf.size.height = newSize.height;
  mf.origin.y = target.window.frame.size.height - mf.size.height;
  UIView * overlay = [target.window.subviews objectAtIndex:target.window.subviews.count-2];
  UIButton * button = [[overlay subviews] objectAtIndex:1];
  CGRect bf = button.frame;
  bf.size.height = overlay.frame.size.height - newSize.height;
  [UIView animateWithDuration:kSemiModalAnimationDuration animations:^{
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