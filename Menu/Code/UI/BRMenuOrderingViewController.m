//
//  BRMenuOrderingViewController.m
//  MenuKit
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingViewController.h"

#import "BRMenu.h"
#import "BRMenuItemObject.h"
#import "BRMenuItemObjectCell.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderingComponentsViewController.h"
#import "BRMenuOrderingFlowController.h"
#import "BRMenuOrderingGroupViewController.h"
#import "BRMenuUIStylishHost.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIViewController+BRMenuUIStyle.h"

NSString * const BRMenuOrderingItemObjectCellIdentifier = @"ItemObjectCell";
NSString * const BRMenuOrderingConfigureComponentsSegue = @"ConfigureComponents";
NSString * const BRMenuOrderingShowItemGroupSegue = @"ShowItemGroup";

@interface BRMenuOrderingViewController () <BRMenuUIStylishHost>

@end

@implementation BRMenuOrderingViewController {
	BRMenuOrderingFlowController *flowController;
}

@dynamic uiStyle;

- (void)viewDidLoad {
    [super viewDidLoad];
	if ( !self.usePrototypeCells ) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 60.0;
		[self.tableView registerClass:[BRMenuItemObjectCell class] forCellReuseIdentifier:BRMenuOrderingItemObjectCellIdentifier];
	}
	
	if ( !self.navigationItem.leftBarButtonItem ) {
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil
																								target:self
																								action:@selector(goBack:)];
	}

	[self refreshForStyle:self.uiStyle];
}

- (void)uiStyleDidChange:(BRMenuUIStyle *)style {
	[self refreshForStyle:style];
}

- (void)refreshForStyle:(BRMenuUIStyle *)style {
	self.view.backgroundColor = style.appBodyColor;
}

- (void)setMenu:(BRMenu *)menu {
	flowController = [[BRMenuOrderingFlowController alloc] initWithMenu:menu];
}

- (BRMenu *)menu {
	return flowController.menu;
}

#pragma mark - BRMenuOrderingDelegate

- (void)addOrderItemToActiveOrder:(BRMenuOrderItem *)orderItem {
	if ( self.order == nil ) {
		self.order = [BRMenuOrder new];
	}
	[self.order addOrderItem:orderItem];
	[self.navigationController popToViewController:self animated:YES];
}

- (void)updateOrderItemsInActiveOrder:(NSArray *)orderItems {
	if ( self.order == nil ) {
		self.order = [BRMenuOrder new];
	}
	[self.order replaceOrderItems:orderItems];
	[self.navigationController popToViewController:self animated:YES];
}

#pragma mark - Navigation support

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:BRMenuOrderingConfigureComponentsSegue] ) {
		BRMenuOrderingComponentsViewController *dest = segue.destinationViewController;
		dest.flowController = [flowController flowControllerForItemAtIndexPath:[self.tableView indexPathForSelectedRow]];
		dest.orderingDelegate = self;
	} else if ( [segue.identifier isEqualToString:BRMenuOrderingShowItemGroupSegue] ) {
		BRMenuOrderingGroupViewController *dest = segue.destinationViewController;
		dest.flowController = [flowController flowControllerForItemAtIndexPath:[self.tableView indexPathForSelectedRow]];
		dest.flowController.temporaryOrder = self.order;
		dest.orderingDelegate = self;
	}
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> item = [flowController menuItemObjectAtIndexPath:indexPath];
	if ( item.hasComponents ) {
		[self performSegueWithIdentifier:BRMenuOrderingConfigureComponentsSegue sender:self];
	} else {
		[self performSegueWithIdentifier:BRMenuOrderingShowItemGroupSegue sender:self];
	}
}

@end
