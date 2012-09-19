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

      // You can optionally listen to notifications
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModalPresented:)
                                                   name:kSemiModalDidShowNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModalDismissed:)
                                                   name:kSemiModalDidHideNotification
                                                 object:nil];
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModalResized:)
                                                   name:kSemiModalWasResizedNotification
                                                 object:nil];
    }
    return self;
}

#pragma mark - Demo

- (IBAction)buttonDidTouch:(id)sender {
  
  // You can set the opacity of the background to whatever you like.
  // Make sure you do this before you present the view controller.
  self.parentViewPresentedOpacity = 0.1;

  // You can also present a UIViewController with complex views in it
  // and optionally containing an explicit dismiss button for semi modal
  [self presentSemiViewController:semiVC];

}

#pragma mark - Optional notifications

- (void) semiModalResized:(NSNotification *) notification {
  if(notification.object == self){
    NSLog(@"The view controller presented was been resized");
  }
}

- (void)semiModalPresented:(NSNotification *) notification {
  if (notification.object == self) {
    NSLog(@"This view controller just shown a view with semi modal annimation");
  }
}
- (void)semiModalDismissed:(NSNotification *) notification {
  if (notification.object == self) {
    NSLog(@"A view controller was dismissed with semi modal annimation");
  }
}

-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
