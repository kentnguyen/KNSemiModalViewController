//
//  KNThirdViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KNThirdViewController.h"
#import "UIViewController+KNSemiModal.h"
#import <QuartzCore/QuartzCore.h>

@interface KNThirdViewController ()

@end

@implementation KNThirdViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  // You can customize your own semi-modal size
  self.view.frame = CGRectMake(0, 0, 320, 180);
  self.view.backgroundColor = [UIColor colorWithWhite:0.80 alpha:1];

  UILabel * demoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,15, 320, 50)];
  demoLabel.backgroundColor = [UIColor clearColor];
  demoLabel.text = @"You can add any UIView elements here\neven dismiss button\n(if you know what you are doing)";
  demoLabel.font = [UIFont systemFontOfSize:12];
  demoLabel.numberOfLines = 3;
  demoLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:demoLabel];
  
  // Here's how to call dismiss button on the parent ViewController
  // be careful with view hierarchy
  UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
  [dismissButton setBackgroundColor:[UIColor redColor]];
  [dismissButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
  [dismissButton.titleLabel setFont:[UIFont boldSystemFontOfSize:14]];
  dismissButton.layer.cornerRadius = 10.0f;
  dismissButton.layer.masksToBounds = YES;
  dismissButton.frame = CGRectMake(100, 75, 120, 35);
  [dismissButton addTarget:self.parentViewController
                    action:@selector(dismissSemiModalView)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:dismissButton];
}

@end
