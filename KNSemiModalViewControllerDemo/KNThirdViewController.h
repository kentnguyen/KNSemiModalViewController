//
//  KNThirdViewController.h
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 2/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KNThirdViewController : UIViewController

@property (unsafe_unretained, nonatomic) IBOutlet UILabel *helpLabel;
@property (unsafe_unretained, nonatomic) IBOutlet UIButton *dismissButton;

- (IBAction)dismissButtonDidTouch:(id)sender;

@end
