//
//  BRMenuOrderingComponentsViewController.m
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingComponentsViewController.h"

#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuItemComponentCell.h"
#import "BRMenuOrderingFlowController.h"

NSString * const BRMenuOrderingItemComponentCellIdentifier = @"ItemComponentCell";
NSString * const BRMenuOrderingGroupHeaderCellIdentifier = @"GroupHeaderCell";

@implementation BRMenuOrderingComponentsViewController {
	BRMenuOrderingFlowController *flowController;
}

@synthesize flowController;

- (void)viewDidLoad {
	[super viewDidLoad];
	if ( !self.usePrototypeCells ) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 60.0;
		self.tableView.estimatedSectionHeaderHeight = 50.0;
		[self.tableView registerClass:[BRMenuItemComponentCell class] forCellReuseIdentifier:BRMenuOrderingItemComponentCellIdentifier];
		[self.tableView registerClass:[BRMenuGroupTableHeaderView class] forHeaderFooterViewReuseIdentifier:BRMenuOrderingGroupHeaderCellIdentifier];
	}
}

#pragma mark - Table support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [flowController numberOfSections];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	BRMenuGroupTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BRMenuOrderingGroupHeaderCellIdentifier];
	header.title = [flowController titleForSection:section];
	header.price = [flowController priceForSection:section];
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [flowController numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BRMenuItemComponentCell *cell = [tableView dequeueReusableCellWithIdentifier:BRMenuOrderingItemComponentCellIdentifier forIndexPath:indexPath];
	cell.item = [flowController menuItemObjectAtIndexPath:indexPath];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> item = [flowController menuItemObjectAtIndexPath:indexPath];
	// TODO: implement
}

@end
