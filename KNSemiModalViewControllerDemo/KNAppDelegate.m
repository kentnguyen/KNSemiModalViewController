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

@implementation KNAppDelegate

@synthesize window = _window;
@synthesize tabBarController = _tabBarController;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];

  UIViewController * vc1 = [[KNFirstViewController alloc] initWithNibName:@"KNFirstViewController" bundle:nil];
  UIViewController * vc2 = [[KNSecondViewController alloc] initWithNibName:@"KNSecondViewController" bundle:nil];
  
  UINavigationController * uinav = [[UINavigationController alloc] initWithRootViewController:vc1];
  
  self.tabBarController = [[UITabBarController alloc] init];
  self.tabBarController.viewControllers = [NSArray arrayWithObjects:uinav, vc2, nil];
  self.window.rootViewController = self.tabBarController;
  [self.window makeKeyAndVisible];
  return YES;
}

@end
