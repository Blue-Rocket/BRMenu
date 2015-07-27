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
#import "BRMenuItem.h"
#import "BRMenuOrderingFlowController.h"
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"

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

	self.navigationItem.title = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.ordering.item.title"], flowController.item.title];
	
	if ( !self.navigationItem.leftBarButtonItem ) {
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithWithTitle:nil
																									target:self
																									action:@selector(goBack:)];
	}
	
	// add right nav button: Review or Add or Next
	if ( flowController.finalStep ) {
		if ( flowController.item.needsReview ) {
			self.navigationItem.rightBarButtonItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.review"]
																									target:self
																									action:@selector(reviewOrderItem:)];
		} else {
			self.navigationItem.rightBarButtonItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.add"]
																									target:self
																									action:@selector(addOrderItemToActiveOrder:)];
		}
	} else {
		self.navigationItem.rightBarButtonItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.next"]
																								target:self
																								action:@selector(gotoNextFlowStep:)];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	
	// TODO: [self setupTableCellSelections];
}

#pragma mark - Actions

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoNextFlowStep:(id)sender {
	// TODO
}

- (IBAction)reviewOrderItem:(id)sender {
	// TODO
}

- (IBAction)addOrderItemToActiveOrder:(id)sender {
	// TODO
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
