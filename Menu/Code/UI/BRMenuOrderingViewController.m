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
#import "BRMenuOrderCountButton.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderingComponentsViewController.h"
#import "BRMenuOrderingFlowController.h"
#import "BRMenuOrderingGroupViewController.h"
#import <BRStyle/BRUIStylishHost.h>
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIViewController+BRUIStyle.h"

NSString * const BRMenuOrderingItemObjectCellIdentifier = @"ItemObjectCell";
NSString * const BRMenuOrderingConfigureComponentsSegue = @"ConfigureComponents";
NSString * const BRMenuOrderingShowItemGroupSegue = @"ShowItemGroup";

@interface BRMenuOrderingViewController () <BRUIStylishHost>

@end

@implementation BRMenuOrderingViewController {
	BRMenuOrderingFlowController *flowController;
}

@dynamic uiStyle;

- (void)viewDidLoad {
    [super viewDidLoad];
	if ( !self.usePrototypeCells ) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 100.0;
		[self.tableView registerClass:[BRMenuItemObjectCell class] forCellReuseIdentifier:BRMenuOrderingItemObjectCellIdentifier];
	}
	
	if ( !self.navigationItem.leftBarButtonItem ) {
		NSArray *leftItems = @[[UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil target:self action:@selector(goBack:)]];
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuLeftNavigationBarButtonItems:leftItems];
	}

	[self refreshForStyle:self.uiStyle];
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self refreshForStyle:style];
}

- (void)refreshForStyle:(BRUIStyle *)style {
	self.view.backgroundColor = style.colors.backgroundColor;
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

- (void)updateOrderItemsInActiveOrder:(NSArray<BRMenuOrderItem *> *)orderItems {
	if ( self.order == nil ) {
		self.order = [BRMenuOrder new];
	}
	if ( !self.allowRemoveFromOrder ) {
		// merge quantities if we find the same line item, otherwise add new line item.
		// we use a temporary array so that KVO on that array still works, e.g. BRMenuOrderCountButton
		NSMutableArray<BRMenuOrderItem *> *mergedOrderItems = [NSMutableArray arrayWithArray:self.order.orderItems];
		for ( BRMenuOrderItem *item in orderItems ) {
			BOOL added = NO;
			for ( BRMenuOrderItem *existing in mergedOrderItems ) {
				if ( [item isEqual:existing] ) {
					existing.quantity += item.quantity;
					added = YES;
					break;
				}
			}
			if ( !added ) {
				[mergedOrderItems addObject:item];
			}
		}
		orderItems = mergedOrderItems;
	}
	[self.order replaceOrderItems:orderItems];
	[self.navigationController popToViewController:self animated:YES];
}

- (BOOL)shouldExcludeMenuItemObject:(id<BRMenuItemObject>)item {
	// extending classes can implement different logic here, for example to support out-of-stock items
	return NO;
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
		dest.flowController.order = (!self.enableUndoSupport
									 ? self.order
									 : (self.allowRemoveFromOrder
										? [self.order copy]
										: [BRMenuOrder new]));
		dest.showOrderCount = !self.enableUndoSupport;
		dest.showSaveToOrderCount = (self.enableUndoSupport && !self.allowRemoveFromOrder);
		dest.orderingDelegate = self;
		if ( self.orderCountButton && !self.enableUndoSupport ) {
			BRMenuOrderCountButton *reviewOrderButton = [self.orderCountButton copy];
			UIBarButtonItem *reviewOrderBarButton = [[UIBarButtonItem alloc] initWithCustomView:reviewOrderButton];
			dest.navigationItem.rightBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuRightNavigationBarButtonItems:@[reviewOrderBarButton]];
		}
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
	id<BRMenuItemObject> item = [flowController menuItemObjectAtIndexPath:indexPath];
	cell.item = item;
	cell.disabled = [self shouldExcludeMenuItemObject:item];
	return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	id<BRMenuItemObject> item = [flowController menuItemObjectAtIndexPath:indexPath];
	if ( [self shouldExcludeMenuItemObject:item] ) {
		NSString *msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.item.excluded"], item.title];
		[[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:[NSBundle localizedBRMenuString:@"menu.action.ok"] otherButtonTitles:nil] show];
	} else if ( item.hasComponents ) {
		[self performSegueWithIdentifier:BRMenuOrderingConfigureComponentsSegue sender:self];
	} else {
		[self performSegueWithIdentifier:BRMenuOrderingShowItemGroupSegue sender:self];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
