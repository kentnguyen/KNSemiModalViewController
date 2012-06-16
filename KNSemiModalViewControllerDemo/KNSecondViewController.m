//
//  KNSecondViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "KNSecondViewController.h"
#import "KNThirdViewController.h"
#import "UIViewController+KNSemiModal.h"

@implementation KNSecondViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
      self.title = @"Second";
      self.tabBarItem.image = [UIImage imageNamed:@"second"];

      // Take note that you need to take ownership of the ViewController that is being presented
      semiVC = [[KNThirdViewController alloc] initWithNibName:@"KNThirdViewController" bundle:nil];
    }
    return self;
}
							
- (IBAction)buttonDidTouch:(id)sender {

  // You can also present a UIViewController with complex views in it
  // and optionally containing an explicit dismiss button for semi modal
  [self presentSemiViewController:semiVC];

}

@end
