//
//  BRMenuOrderingViewController.m
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingViewController.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemObjectCell.h"
#import "BRMenuOrderingFlowController.h"

NSString * const BRMenuOrderingItemObjectCellIdentifier = @"ItemObjectCell";

@interface BRMenuOrderingViewController ()

@end

@implementation BRMenuOrderingViewController {
	BRMenuOrderingFlowController *flowController;
}

- (void)viewDidLoad {
    [super viewDidLoad];
	if ( !self.usePrototypeCells ) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 60.0;
		[self.tableView registerClass:[BRMenuItemObjectCell class] forCellReuseIdentifier:BRMenuOrderingItemObjectCellIdentifier];
	}
}

- (void)setMenu:(BRMenu *)menu {
	flowController = [[BRMenuOrderingFlowController alloc] initWithMenu:menu];
}

- (BRMenu *)menu {
	return flowController.menu;
}

#pragma mark - Table support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [flowController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [flowController numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMenuItemObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:BRMenuOrderingItemObjectCellIdentifier forIndexPath:indexPath];
	cell.item = [flowController menuItemObjectAtIndexPath:indexPath];
    return cell;
}

@end
