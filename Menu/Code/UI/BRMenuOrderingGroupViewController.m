//
//  BRMenuOrderingGroupViewController.m
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingGroupViewController.h"

#import <BRStyle/BRUIStylishHost.h>
#import <Masonry/Masonry.h>
#import "BRMenuButton.h"
#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuItem.h"
#import "BRMenuItemCell.h"
#import "BRMenuItemCellWithoutComponents.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderingComponentsViewController.h"
#import "BRMenuOrderingDelegate.h"
#import "BRMenuOrderingFlowController.h"
#import "BRMenuOrderingViewController.h"
#import "BRMenuOrderItem.h"
#import "BRMenuStepper.h"
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIView+BRUIStyle.h"
#import "UIViewController+BRUIStyle.h"

NSString * const BRMenuOrderingItemCellIdentifier = @"ItemCell";
NSString * const BRMenuOrderingItemWithoutComponentsCellIdentifier = @"ItemCellWithoutComponents";
NSString * const BRMenuOrderingItemGroupHeaderCellIdentifier = @"GroupHeaderCell";

@interface BRMenuOrderingGroupViewController () <BRUIStylishHost>
@end

@implementation BRMenuOrderingGroupViewController {
	BRMenuOrderingFlowController *flowController;
	BRMenuButton *saveToOrderButton;
}

@dynamic uiStyle;
@synthesize flowController;

- (void)viewDidLoad {
	[super viewDidLoad];
	if ( !self.usePrototypeCells ) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 60.0;
		self.tableView.estimatedSectionHeaderHeight = 50.0;
		self.tableView.allowsMultipleSelection = YES;
		[self.tableView registerClass:[BRMenuItemCell class] forCellReuseIdentifier:BRMenuOrderingItemCellIdentifier];
		[self.tableView registerClass:[BRMenuItemCellWithoutComponents class] forCellReuseIdentifier:BRMenuOrderingItemWithoutComponentsCellIdentifier];
		[self.tableView registerClass:[BRMenuGroupTableHeaderView class] forHeaderFooterViewReuseIdentifier:BRMenuOrderingItemGroupHeaderCellIdentifier];
	}
	
	self.navigationItem.title = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.ordering.group.title"], flowController.itemGroup.title];
	
	if ( !self.navigationItem.leftBarButtonItem ) {
		NSArray *leftItems = @[[UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil target:self action:@selector(goBack:)]];
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuLeftNavigationBarButtonItems:leftItems];
	}
	
	if ( !self.navigationItem.rightBarButtonItem && flowController.hasMenuItemWithoutComponents && !self.showOrderCount ) {
		UIBarButtonItem *saveItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.saveto.order"]
																				   target:self
																				   action:@selector(saveToOrder:)];
		saveToOrderButton = saveItem.customView;
		[self refreshSaveToOrderButton];
		self.navigationItem.rightBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuRightNavigationBarButtonItems:@[saveItem]];
	}

	[self refreshForStyle:self.uiStyle];
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self refreshForStyle:style];
}

- (void)refreshForStyle:(BRUIStyle *)style {
	self.view.backgroundColor = style.colors.backgroundColor;
}

- (void)setFlowController:(BRMenuOrderingFlowController *)controller {
	if ( controller == flowController ) {
		return;
	}
	flowController = controller;
}

- (void)setShowSaveToOrderCount:(BOOL)value {
	if ( value != _showSaveToOrderCount ) {
		_showSaveToOrderCount = value;
		[self refreshSaveToOrderButton];
	}
}

- (void)refreshSaveToOrderButton {
	if ( self.showSaveToOrderCount && flowController.order ) {
		NSUInteger orderCount = [flowController.order orderItemCount];
		saveToOrderButton.badgeText = (orderCount < 1 ? nil : [NSString stringWithFormat:@"%lu", (unsigned long)orderCount]);
		saveToOrderButton.enabled = (orderCount > 0);
	}
}

#pragma mark - Actions

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goForward:(id)sender {
	if ( self.showSaveToOrderCount ) {
		[self saveToOrder:sender];
	}
}

- (IBAction)saveToOrder:(id)sender {
	[self.orderingDelegate updateOrderItemsInActiveOrder:flowController.order.orderItems];
}

- (IBAction)didAdjustQuantity:(BRMenuStepper *)sender {
	BRMenuItemCellWithoutComponents *cell = [sender nearestAncestorViewOfType:[BRMenuItemCellWithoutComponents class]];
	if ( cell == nil ) {
		return;
	}
	BRMenuItem *menuItem = (BRMenuItem *)cell.item;
	BRMenuOrderItem *orderItem = nil;
	if ( sender.value == 0 ) {
		[flowController.order removeItemForMenuItem:menuItem];
	} else {
		orderItem = [flowController.order getOrAddItemForMenuItem:menuItem];
		orderItem.quantity = sender.value;
	}
	cell.orderItem = orderItem;
	[self refreshSaveToOrderButton];
}

#pragma mark - BRMenuOrderingDelegate

- (void)addOrderItemToActiveOrder:(BRMenuOrderItem *)orderItem {
	if ( flowController.hasMenuItemWithoutComponents ) {
		[flowController.order addOrderItem:orderItem];
		[self refreshSaveToOrderButton];
		[self.navigationController popToViewController:self animated:YES];
	} else {
		[self.orderingDelegate addOrderItemToActiveOrder:orderItem];
	}
}

- (void)updateOrderItemsInActiveOrder:(NSArray<BRMenuOrderItem *> *)orderItems {
	if ( flowController.hasMenuItemWithoutComponents ) {
		[flowController.order replaceOrderItems:orderItems];
		[self refreshSaveToOrderButton];
		[self.navigationController popToViewController:self animated:YES];
	} else {
		[self.orderingDelegate updateOrderItemsInActiveOrder:orderItems];
	}
}

- (BOOL)shouldExcludeMenuItemObject:(id<BRMenuItemObject>)item {
	return [self.orderingDelegate shouldExcludeMenuItemObject:item];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [[segue identifier] isEqualToString:BRMenuOrderingConfigureComponentsSegue] ) {
		BRMenuOrderingComponentsViewController *dest = [segue destinationViewController] ;
		dest.flowController = [flowController flowControllerForItemAtIndexPath:[self.tableView indexPathForSelectedRow]];
		dest.orderingDelegate = self;
	}
}

#pragma mark - Table support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return [flowController numberOfSections];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	NSString *title = [flowController titleForSection:section];
	if ( title == nil ) {
		// when there is no title, we want to hide the section header for this section... so create a 1px high view with a clear background
		UIView *empty = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 1)];
		empty.backgroundColor = [UIColor clearColor];
		[empty mas_makeConstraints:^(MASConstraintMaker *make) {
			make.height.equalTo(@1);
		}];
		return empty;
	}
	BRMenuGroupTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BRMenuOrderingItemGroupHeaderCellIdentifier];
	header.title = title;
	header.price = [flowController priceForSection:section];
	return header;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	return [flowController numberOfItemsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	BRMenuItem *item = (BRMenuItem *)[flowController menuItemObjectAtIndexPath:indexPath];
	BRMenuItemObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:(item.hasComponents ? BRMenuOrderingItemCellIdentifier : BRMenuOrderingItemWithoutComponentsCellIdentifier)
														   forIndexPath:indexPath];
	cell.item = item;
	
	if ( !item.hasComponents && [cell isKindOfClass:[BRMenuItemCellWithoutComponents class]] ) {
		// configure order state
		BRMenuOrderItem *orderItem = [flowController.order orderItemForMenuItem:item];
		BRMenuItemCellWithoutComponents *directCell = (BRMenuItemCellWithoutComponents *)cell;
		directCell.orderItem = orderItem;
		if ( [directCell.stepper actionsForTarget:self forControlEvent:UIControlEventValueChanged].count < 1 ) {
			[directCell.stepper addTarget:self action:@selector(didAdjustQuantity:) forControlEvents:UIControlEventValueChanged];
		}
	}
	
	cell.disabled = [self shouldExcludeMenuItemObject:item];

	return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	BRMenuItemObjectCell *cell = (BRMenuItemObjectCell *)[tableView cellForRowAtIndexPath:indexPath];
	id<BRMenuItemObject> item = cell.item;
	BOOL excluded = [self shouldExcludeMenuItemObject:item];
	if ( excluded ) {
		NSString *msg = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.validation.item.excluded"], item.title];
		[[[UIAlertView alloc] initWithTitle:nil message:msg delegate:nil cancelButtonTitle:[NSBundle localizedBRMenuString:@"menu.action.ok"] otherButtonTitles:nil] show];
	}
	return (cell.item.hasComponents && !excluded);
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( [self tableView:tableView shouldHighlightRowAtIndexPath:indexPath] ) {
		return indexPath;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	[self performSegueWithIdentifier:BRMenuOrderingConfigureComponentsSegue sender:self];
	[tableView deselectRowAtIndexPath:indexPath animated:NO];
}

@end
