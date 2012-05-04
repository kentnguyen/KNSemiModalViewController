//
//  KNAboutViewController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 3/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KNAboutViewController.h"

@interface KNAboutViewController ()

@end

@implementation KNAboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    self.title = @"About";
    self.tabBarItem.image = [UIImage imageNamed:@"second"];
  }
  return self;
}

-(IBAction)blogButtonDidTouch:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://kentnguyen.com/"]];
}

-(IBAction)twitterButtonDidTouch:(id)sender {
  [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"http://twitter.com/ntluan"]];
}


@end
