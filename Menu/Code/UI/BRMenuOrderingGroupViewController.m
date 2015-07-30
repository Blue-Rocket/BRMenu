//
//  BRMenuOrderingGroupViewController.m
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingGroupViewController.h"

#import <Masonry/Masonry.h>
#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuItem.h"
#import "BRMenuItemCell.h"
#import "BRMenuItemCellWithoutComponents.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderingDelegate.h"
#import "BRMenuOrderingFlowController.h"
#import "BRMenuOrderItem.h"
#import "BRMenuStepper.h"
#import "BRMenuUIStylishHost.h"
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIView+BRMenuUIStyle.h"
#import "UIViewController+BRMenuUIStyle.h"

NSString * const BRMenuOrderingItemCellIdentifier = @"ItemCell";
NSString * const BRMenuOrderingItemWithoutComponentsCellIdentifier = @"ItemCellWithoutComponents";
NSString * const BRMenuOrderingItemGroupHeaderCellIdentifier = @"GroupHeaderCell";

@interface BRMenuOrderingGroupViewController () <BRMenuUIStylishHost>
@end

@implementation BRMenuOrderingGroupViewController {
	BRMenuOrderingFlowController *flowController;
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
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil
																								target:self
																								action:@selector(goBack:)];
	}
}

- (void)setFlowController:(BRMenuOrderingFlowController *)controller {
	if ( controller == flowController ) {
		return;
	}
	flowController = controller;
	if ( !self.navigationItem.rightBarButtonItem && flowController.hasMenuItemWithoutComponents ) {
		self.navigationItem.rightBarButtonItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.saveto.order"]
																								target:self
																								action:@selector(saveToOrder:)];
	}
}

#pragma mark - Actions

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)saveToOrder:(id)sender {
	[self.orderingDelegate updateOrderItemsInActiveOrder:flowController.temporaryOrder.orderItems];
}

- (IBAction)didAdjustQuantity:(BRMenuStepper *)sender {
	BRMenuItemObjectCell *cell = [sender nearestAncestorViewOfType:[BRMenuItemObjectCell class]];
	if ( cell == nil ) {
		return;
	}
	BRMenuItem *menuItem = cell.item;
	if ( sender.value == 0 ) {
		[flowController.temporaryOrder removeItemForMenuItem:menuItem];
	} else {
		[flowController.temporaryOrder getOrAddItemForMenuItem:menuItem].quantity = sender.value;
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
	BRMenuItem *item = [flowController menuItemObjectAtIndexPath:indexPath];
	BRMenuItemObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:(item.hasComponents ? BRMenuOrderingItemCellIdentifier : BRMenuOrderingItemWithoutComponentsCellIdentifier)
														   forIndexPath:indexPath];
	cell.item = item;
	
	if ( !item.hasComponents && [cell isKindOfClass:[BRMenuItemCellWithoutComponents class]] ) {
		// configure order state
		BRMenuOrderItem *orderItem = [flowController.temporaryOrder orderItemForMenuItem:item];
		BRMenuItemCellWithoutComponents *directCell = (BRMenuItemCellWithoutComponents *)cell;
		[directCell configureForOrderItem:orderItem];
		if ( [directCell.stepper actionsForTarget:self forControlEvent:UIControlEventValueChanged].count < 1 ) {
			[directCell.stepper addTarget:self action:@selector(didAdjustQuantity:) forControlEvents:UIControlEventValueChanged];
		}
	}

	// calling this (often, but not always) fixes an apparent bug in iOS 8.4 where the first pass of
	// drawing the cells results in an incorrectly calculated height
	[cell layoutIfNeeded];
	return cell;
}

@end
