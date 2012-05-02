//
//  KNSecondViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KNSecondViewController.h"
#import "UIViewController+KNSemiModal.h"

@interface KNSecondViewController ()

@end

@implementation KNSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    self.title = NSLocalizedString(@"Second", @"Second");
    self.tabBarItem.image = [UIImage imageNamed:@"second"];
    }
    return self;
}
							
- (IBAction)buttonDidTouch:(id)sender {
  UIImageView * imagev = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"temp.jpg"]];
  [imagev sizeToFit];
  [self presentSemiView:imagev];
}

@end
