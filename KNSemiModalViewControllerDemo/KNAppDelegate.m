//
//  KNAppDelegate.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "KNAppDelegate.h"

#import "KNFirstViewController.h"
#import "KNSecondViewController.h"
#import "KNAboutViewController.h"
#import "KNTableDemoController.h"

@implementation KNAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  // First tab
  UIViewController * vc1 = [[KNFirstViewController alloc] initWithNibName:@"KNFirstViewController" bundle:nil];

  // Second tab
  UINavigationController * uinav = [[UINavigationController alloc] initWithRootViewController:vc1];
  UIViewController * vc2 = [[KNSecondViewController alloc] initWithNibName:@"KNSecondViewController" bundle:nil];

  // Third tab
  KNTableDemoController * vc3 = [[KNTableDemoController alloc] initWithStyle:UITableViewStyleGrouped];
  
  // About tab
  KNAboutViewController * ab = [[KNAboutViewController alloc] initWithNibName:@"KNAboutViewController" bundle:nil];
  
  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:uinav, vc2, vc3, ab, nil];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
