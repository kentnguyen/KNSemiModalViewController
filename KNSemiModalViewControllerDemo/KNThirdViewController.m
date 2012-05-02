//
//  KNThirdViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KNThirdViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface KNThirdViewController ()

@end

@implementation KNThirdViewController

- (void)viewDidLoad {
  [super viewDidLoad];

  self.view.backgroundColor = [UIColor whiteColor];
  self.view.frame = CGRectMake(0, 0, 320, 180);

  UILabel * demoLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,15, 320, 50)];
  demoLabel.text = @"You can add any UIView elements here\neven dismiss button\n(if you know what you are doing)";
  demoLabel.font = [UIFont systemFontOfSize:12];
  demoLabel.numberOfLines = 3;
  demoLabel.textAlignment = UITextAlignmentCenter;
  [self.view addSubview:demoLabel];
  
  UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [dismissButton setTitle:@"Dismiss" forState:UIControlStateNormal];
  dismissButton.frame = CGRectMake(100, 75, 120, 35);
  [dismissButton addTarget:self.parentViewController // careful with view hierarchy
                    action:@selector(dismissSemiModalView)
          forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:dismissButton];
}

@end
