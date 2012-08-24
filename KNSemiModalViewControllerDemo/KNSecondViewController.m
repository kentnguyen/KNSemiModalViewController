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
      
      [[NSNotificationCenter defaultCenter] addObserver:self
                                               selector:@selector(semiModalResized:)
                                                   name:kSemiModalWasResizedNotification
                                                 object:nil];
    }
    return self;
}
- (void) semiModalResized:(NSNotification *) notification {
  if(notification.object == self){
    NSLog(@"The view controller presented was been resized");
  }
}
- (IBAction)buttonDidTouch:(id)sender {

  // You can also present a UIViewController with complex views in it
  // and optionally containing an explicit dismiss button for semi modal
  [self presentSemiViewController:semiVC];

}
-(void)dealloc {
  [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
