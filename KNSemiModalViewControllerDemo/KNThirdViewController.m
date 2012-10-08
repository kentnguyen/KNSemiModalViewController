//
//  KNThirdViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "KNThirdViewController.h"
#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>

@interface KNThirdViewController ()

@end

@implementation KNThirdViewController
@synthesize helpLabel;
@synthesize dismissButton;
@synthesize resizeButton;

- (void)viewDidLoad {
  [super viewDidLoad];
  
  dismissButton.layer.cornerRadius  = 10.0f;
  dismissButton.layer.masksToBounds = YES;
  resizeButton.layer.cornerRadius   = 10.0f;
  resizeButton.layer.masksToBounds  = YES;
}

- (void)viewDidUnload {
  [self setHelpLabel:nil];
  [self setDismissButton:nil];
  [self setResizeButton:nil];
  [super viewDidUnload];
}

- (IBAction)dismissButtonDidTouch:(id)sender {

  // Here's how to call dismiss button on the parent ViewController
  // be careful with view hierarchy
  UIViewController * parent = [self.view containingViewController];
  if ([parent respondsToSelector:@selector(dismissSemiModalView)]) {
    [parent dismissSemiModalView];
  }

}

- (IBAction)resizeSemiModalView:(id)sender {
  UIViewController * parent = [self.view containingViewController];
  if ([parent respondsToSelector:@selector(resizeSemiView:)]) {
    [parent resizeSemiView:CGSizeMake(320, arc4random() % 280 + 180)];
  }
}

@end
