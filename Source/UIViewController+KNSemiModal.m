//
//  KNSemiModalViewController.m
//  KNSemiModalViewController
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>

@interface UIViewController (KNSemiModalInternal)
-(UIView*)parentTarget;
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
@end

@implementation UIViewController (KNSemiModal)

-(void)presentSemiViewController:(UIViewController*)vc {
  [self presentSemiView:vc.view];
}

-(void)presentSemiView:(UIView*)vc {
  // Determine target
  UIView * target = [self parentTarget];
  
  if (![target.subviews containsObject:vc]) {
    // Calulate all frames
    CGRect sf = vc.frame;
    CGRect vf = target.frame;
    CGRect f  = CGRectMake(0, vf.size.height-sf.size.height, vf.size.width, sf.size.height);
    CGRect of = CGRectMake(0, 0, vf.size.width, vf.size.height-sf.size.height);

    // Add semi overlay
    UIView * overlay = [[UIView alloc] initWithFrame:target.bounds];
    overlay.backgroundColor = [UIColor blackColor];
    
    // Add dismiss gesture
    UITapGestureRecognizer * tg = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissSemiModalView)];
    [overlay addGestureRecognizer:tg];

    // Take screenshot and scale
    UIGraphicsBeginImageContext(target.bounds.size);
    [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIImageView * ss = [[UIImageView alloc] initWithImage:image];
    [overlay addSubview:ss];
    [target addSubview:overlay];

    // Begin overlay animation
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:CATransform3DConcat(CATransform3DMakeScale(0.8, 0.8, 1), CATransform3DMakeTranslation(0, -(f.size.height*0.2), 0))];
    animation.duration = 0.3;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [ss.layer addAnimation:animation forKey:@"pushedBackAnimation"];
    [UIView animateWithDuration:0.3 animations:^{
      ss.alpha = 0.5;
      overlay.frame = of;
    }];

    // Present view animated
    vc.frame = CGRectMake(0, vf.size.height, vf.size.width, sf.size.height);
    [target addSubview:vc];
    vc.layer.shadowColor = [[UIColor blackColor] CGColor];
    vc.layer.shadowOffset = CGSizeMake(0, -2);
    vc.layer.shadowRadius = 5.0;
    vc.layer.shadowOpacity = 0.8;
    [UIView animateWithDuration:0.3 animations:^{
      vc.frame = f;
    }];
  }
}

-(void)dismissSemiModalView {
  UIView * target = [self parentTarget];
  UIView * modal = [target.subviews objectAtIndex:target.subviews.count-1];
  UIView * overlay = [target.subviews objectAtIndex:target.subviews.count-2];
  [UIView animateWithDuration:0.3 animations:^{
    overlay.frame = target.bounds;
    modal.frame = CGRectMake(0, target.frame.size.height, modal.frame.size.width, modal.frame.size.height);
  } completion:^(BOOL finished) {
    [overlay removeFromSuperview];
    [modal removeFromSuperview];
  }];

  // Begin overlay animation
  UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
  CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
  animation.toValue = [NSValue valueWithCATransform3D:CATransform3DIdentity];
  animation.duration = 0.3;
  animation.fillMode = kCAFillModeForwards;
  animation.removedOnCompletion = NO;
  [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
  [ss.layer addAnimation:animation forKey:@"bringForwardAnimation"];
  [UIView animateWithDuration:0.3 animations:^{
    ss.alpha = 1;
  }];
}

@end
