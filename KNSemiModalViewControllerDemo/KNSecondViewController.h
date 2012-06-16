//
//  KNSecondViewController.h
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KNThirdViewController;

@interface KNSecondViewController : UIViewController {
  KNThirdViewController * semiVC;
}
- (IBAction)buttonDidTouch:(id)sender;

@end
