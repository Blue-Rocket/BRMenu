//
//  BRMenuOrderingComponentsViewController.m
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingComponentsViewController.h"

#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentCell.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItem.h"
#import "BRMenuModelPropertyEditor.h"
#import "BRMenuOrderingFlowController.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuOrderingDelegate.h"
#import "BRMenuOrderingItemDetailsViewController.h"
#import <BRStyle/BRUIStylishHost.h>
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIView+BRUIStyle.h"
#import "UIViewController+BRUIStyle.h"

NSString * const BRMenuOrderingItemComponentCellIdentifier = @"ItemComponentCell";
NSString * const BRMenuOrderingGroupHeaderCellIdentifier = @"GroupHeaderCell";

NSString * const BRMenuOrderingReviewOrderItemSegue = @"ReviewOrderItem";

@interface BRMenuOrderingComponentsViewController () <BRUIStylishHost>
@end

@implementation BRMenuOrderingComponentsViewController {
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
		[self.tableView registerClass:[BRMenuItemComponentCell class] forCellReuseIdentifier:BRMenuOrderingItemComponentCellIdentifier];
		[self.tableView registerClass:[BRMenuGroupTableHeaderView class] forHeaderFooterViewReuseIdentifier:BRMenuOrderingGroupHeaderCellIdentifier];
	}

	self.navigationItem.title = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.ordering.item.title"], flowController.item.title];
	
	if ( !self.navigationItem.leftBarButtonItem ) {
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil
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
	[self refreshForStyle:self.uiStyle];
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self refreshForStyle:style];
}

- (void)refreshForStyle:(BRUIStyle *)style {
	self.view.backgroundColor = style.colors.backgroundColor;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self setupTableCellSelections];
}

// configure the table view cell selection state; needed when going back/forth in navigation flow
- (void)setupTableCellSelections {
	NSArray *tableSelectedIndexPaths = [self.tableView indexPathsForSelectedRows];
	NSArray *indexPaths = [flowController indexPathsForSelectedComponents];
	for ( NSIndexPath *indexPath in indexPaths ) {
		if ( ![tableSelectedIndexPaths containsObject:indexPath] ) {
			[self.tableView selectRowAtIndexPath:indexPath
										animated:NO
								  scrollPosition:UITableViewScrollPositionNone];
		}
	}
}

#pragma mark - Navigation

- (BOOL)canGotoNextStep {
	NSError *error = nil;
	BOOL result = [flowController canGotoNextStep:&error];
	if ( !result ) {
		[[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:[NSBundle localizedBRMenuString:@"menu.action.ok"] otherButtonTitles:nil] show];
	}
	return result;
}

- (BOOL)canAddToOrder {
	NSError *error = nil;
	BOOL result = [flowController canAddItemToOrder:&error];
	if ( !result ) {
		[[[UIAlertView alloc] initWithTitle:nil message:[error localizedDescription] delegate:nil cancelButtonTitle:[NSBundle localizedBRMenuString:@"menu.action.ok"] otherButtonTitles:nil] show];
	}
	return result;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:BRMenuOrderingReviewOrderItemSegue] ) {
		BRMenuOrderingItemDetailsViewController *dest = (BRMenuOrderingItemDetailsViewController *)segue.destinationViewController;
		dest.showAddToOrder = YES;
		dest.orderItem = flowController.orderItem;
		dest.orderingDelegate = self.orderingDelegate;
	}
}

#pragma mark - Actions

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)gotoNextFlowStep:(id)sender {
	if ( ![self canGotoNextStep] ) {
		return;
	}
	BRMenuOrderingComponentsViewController *dest = [self.storyboard instantiateViewControllerWithIdentifier:@"MenuOrderingComponents"];
	dest.flowController = [flowController flowControllerForNextStep];
	dest.orderingDelegate = self.orderingDelegate;
	[self.navigationController pushViewController:dest animated:YES];
}

- (IBAction)reviewOrderItem:(id)sender {
	if ( ![self canGotoNextStep] ) {
		return;
	}
	[self performSegueWithIdentifier:BRMenuOrderingReviewOrderItemSegue sender:sender];
}

- (IBAction)addOrderItemToActiveOrder:(id)sender {
	if ( [self canAddToOrder] == NO ) {
		return;
	}
	[self.orderingDelegate addOrderItemToActiveOrder:flowController.orderItem];
}

- (IBAction)didToggleQualifierButton:(UIControl<BRMenuModelPropertyEditor> *)sender {
	// when to toggle a button in a cell, automatically select that row if not already selected
	BRMenuItemComponentCell *cell = [sender nearestAncestorViewOfType:[BRMenuItemComponentCell class]];
	if ( cell != nil ) {
		NSIndexPath *path = [self.tableView indexPathForCell:cell];
		if ( ![[self.tableView indexPathsForSelectedRows] containsObject:path] ) {
			NSIndexPath *pathToSelect = [self tableView:self.tableView willSelectRowAtIndexPath:path];
			if ( pathToSelect != nil ) {
				[self.tableView selectRowAtIndexPath:pathToSelect animated:YES scrollPosition:UITableViewScrollPositionNone];
			}
		}

		BRMenuOrderItemComponent *orderComponent = [flowController.orderItem getOrAddComponentForMenuItemComponent:cell.component];
		NSString *keyPath = [sender propertyEditorKeyPathForModel:[orderComponent class]];
		[orderComponent setValue:[sender propertyEditorValue] forKeyPath:keyPath];
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
	if ( ![[cell.placementButton actionsForTarget:self forControlEvent:UIControlEventValueChanged] containsObject:NSStringFromSelector(@selector(didToggleQualifierButton:))] ) {
		[cell.placementButton addTarget:self action:@selector(didToggleQualifierButton:) forControlEvents:UIControlEventValueChanged];
	}
	if ( ![[cell.quantityButton actionsForTarget:self forControlEvent:UIControlEventValueChanged] containsObject:NSStringFromSelector(@selector(didToggleQualifierButton:))] ) {
		[cell.quantityButton addTarget:self action:@selector(didToggleQualifierButton:) forControlEvents:UIControlEventValueChanged];
	}
	cell.item = [flowController menuItemObjectAtIndexPath:indexPath];
	
	BRMenuOrderItemComponent *orderComponent = [flowController.orderItem componentForMenuItemComponent:cell.component];
	[cell configureForOrderItemComponent:orderComponent];

	return cell;
}

- (void)configureSelectedCellState:(BRMenuItemComponentCell *)cell {
	BRMenuItemComponent *component = cell.component;
	[flowController.orderItem getOrAddComponentForMenuItemComponent:component];
}

- (void)configureDeselectedCellState:(BRMenuItemComponentCell *)cell {
	BRMenuItemComponent *component = cell.component;
	[flowController.orderItem removeComponentForMenuItemComponent:component];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
	BRMenuItemComponentCell *cell = (BRMenuItemComponentCell *)[tableView cellForRowAtIndexPath:indexPath];
	[self configureDeselectedCellState:cell];
	return indexPath;
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	BRMenuItemComponentCell *cell = (BRMenuItemComponentCell *)[tableView cellForRowAtIndexPath:indexPath];
	BRMenuItemComponent *component = cell.component;
	BRMenuItemComponentGroup *componentGroup = component.group;
	const BOOL multiSelect = componentGroup.multiSelect;
	const BOOL makeSelected = (multiSelect == NO || ![[tableView indexPathsForSelectedRows] containsObject:indexPath]);
	
	if ( multiSelect == NO ) {
		// radio control behavior: if any other row in current section is selected, deselect it now
		for ( NSIndexPath *selectedIndexPath in [tableView indexPathsForSelectedRows] ) {
			if ( selectedIndexPath.section == indexPath.section && selectedIndexPath.row != indexPath.row ) {
				[tableView deselectRowAtIndexPath:selectedIndexPath animated:YES];
				[self configureDeselectedCellState:(BRMenuItemComponentCell *)[tableView cellForRowAtIndexPath:selectedIndexPath]];
				break;
			}
		}
	}
	
	if ( makeSelected == NO && multiSelect == YES ) {
		[tableView deselectRowAtIndexPath:indexPath animated:YES];
	}
	if ( makeSelected == YES ) {
		[self configureSelectedCellState:cell];
	}
	return (makeSelected ? indexPath : nil);
}

@end
