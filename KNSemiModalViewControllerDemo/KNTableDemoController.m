//
//  KNTableDemoController.m
//  KNSemiModalViewControllerDemo
//
//  Created by Kent Nguyen on 4/5/12.
//  Copyright (c) 2012 Kent Nguyen. All rights reserved.
//

#import "KNTableDemoController.h"
#import "UIViewController+KNSemiModal.h"
#import "KNModalTableViewController.h"

@implementation KNTableDemoController

- (id)initWithStyle:(UITableViewStyle)style {
  self = [super initWithStyle:style];
  if (self) {
    self.title = @"Third";
    self.tabBarItem.image = [UIImage imageNamed:@"first"];
    modalVC = [[KNModalTableViewController alloc] initWithStyle:UITableViewStylePlain];
  }
  return self;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
  return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
  static NSString *CellIdentifier = @"Demo3Cell";
  UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
  if (!cell) {
    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
  }
  cell.textLabel.text = [NSString stringWithFormat:@"Demo row %d", indexPath.row];
  return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  [tableView deselectRowAtIndexPath:indexPath animated:NO];

  // You have to retain the ownership of ViewController that you are presenting
  [self presentSemiViewController:modalVC withOptions:@{
		 KNSemiModalOptionKeys.pushParentBack : @(NO),
		 KNSemiModalOptionKeys.parentAlpha : @(0.8)
	 }];
  
  // The following code won't work
//  KNModalTableViewController * vc = [[KNModalTableViewController alloc] initWithStyle:UITableViewStylePlain];
//  [self presentSemiViewController:vc];
}

@end
