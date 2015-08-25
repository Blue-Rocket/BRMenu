//
//  BRMenuOrderReviewTableViewController.m
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderReviewViewController.h"

#import "BRMenuBarButtonItemView.h"
#import "BRMenuFlipToggleButton.h"
#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuItem.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderingItemDetailsViewController.h"
#import "BRMenuOrderItem.h"
#import "BRmenuOrderItemAttributes.h"
#import "BRMenuOrderItemAttributesProxy.h"
#import "BRMenuOrderGroupsController.h"
#import "BRMenuOrderReviewCell.h"
#import "BRMenuPlusMinusButton.h"
#import <BRStyle/BRUIStylishHost.h>
#import "NSBundle+BRMenu.h"
#import "NSNumberFormatter+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIView+BRUIStyle.h"
#import "UIViewController+BRUIStyle.h"

NSString * const BRMenuOrderReviewOrderItemCellIdentifier = @"OrderItemCell";
NSString * const BRMenuOrderReviewGroupHeaderCellIdentifier = @"GroupHeaderCell";

NSString * const BRMenuOrderReviewViewOrderItemDetailsSegue = @"ViewOrderItemDetails";

static void * kOrderTotalPriceContext = &kOrderTotalPriceContext;

@interface BRMenuOrderReviewViewController () <BRUIStylishHost>

@end

@implementation BRMenuOrderReviewViewController {
	BRMenuOrder *order;
	NSDictionary *groupKeyMapping;
	BRMenuOrderGroupsController *groupsController;
}

@dynamic uiStyle;
@synthesize order;
@synthesize groupKeyMapping;

- (void)dealloc {
	[self setOrder:nil]; // release KVO
}

- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.tableView.rowHeight = UITableViewAutomaticDimension;
	self.tableView.sectionHeaderHeight = UITableViewAutomaticDimension;
	self.tableView.estimatedRowHeight = 60.0;
	self.tableView.estimatedSectionHeaderHeight = 50.0;
	self.tableView.allowsMultipleSelection = YES;
	[self.tableView registerClass:[BRMenuOrderReviewCell class] forCellReuseIdentifier:BRMenuOrderReviewOrderItemCellIdentifier];
	[self.tableView registerClass:[BRMenuGroupTableHeaderView class] forHeaderFooterViewReuseIdentifier:BRMenuOrderReviewGroupHeaderCellIdentifier];

	[self refreshForStyle:self.uiStyle];
	
	if ( !self.navigationItem.leftBarButtonItem ) {
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil
																								target:self
																								action:@selector(goBack:)];
	}
	if ( self.navigationItem.rightBarButtonItem == nil ) {
		UIBarButtonItem *rightItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.edit"]
																					target:self
																					action:@selector(toggleEditing:)];
		self.navigationItem.rightBarButtonItem = rightItem;
		self.editButton = rightItem.customView;
	}

	[self.tableView reloadData];
	[self refreshFromModel];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	[self.tableView flashScrollIndicators];
}

- (void)refresh {
	if ( self.order ) {
		groupsController = [[BRMenuOrderGroupsController alloc] initWithOrder:self.order groupKeyMapping:self.groupKeyMapping];
	} else {
		groupsController = nil;
	}
	[self.tableView reloadData];
	[self refreshFromModel];
}

- (void)refreshFromModel {
	const BOOL haveItems = ([groupsController numberOfSections] > 0);
	if ( [self.editButton respondsToSelector:@selector(setEnabled:)] ) {
		[(UIControl *)self.editButton setEnabled:haveItems];
	}
	self.checkoutTotalButton.badgeText = [[NSNumberFormatter standardBRMenuPriceFormatter] stringFromNumber:order.totalPrice];
	[self.checkoutTotalButton sizeToFit];
	self.checkoutTotalButton.enabled = haveItems;
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self refreshForStyle:style];
}

- (void)refreshForStyle:(BRUIStyle *)style {
	self.view.backgroundColor = style.appBodyColor;
	self.tableView.backgroundColor = style.appBodyColor;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if ( context == kOrderTotalPriceContext ) {
		[self refreshFromModel];
	} else {
		return [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
	}
}

#pragma mark - Accessors 

- (void)setOrder:(BRMenuOrder *)theOrder {
	if ( theOrder == order ) {
		return;
	}
	if ( order ) {
		[order removeObserver:self forKeyPath:NSStringFromSelector(@selector(totalPrice)) context:kOrderTotalPriceContext];
	}
	order = theOrder;
	if ( theOrder ) {
		[theOrder addObserver:self forKeyPath:NSStringFromSelector(@selector(totalPrice)) options:NSKeyValueObservingOptionNew context:kOrderTotalPriceContext];
		[self refresh];
	}
}

- (void)setGroupKeyMapping:(NSDictionary *)mapping {
	if ( mapping == groupKeyMapping ) {
		return;
	}
	groupKeyMapping = mapping;
	if ( order ) {
		[self refresh];
	}
}

#pragma mark - Navigation support

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:BRMenuOrderReviewViewOrderItemDetailsSegue] ) {
		BRMenuOrderingItemDetailsViewController *dest = segue.destinationViewController;
		NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
		if ( indexPath ) {
			BRMenuOrderReviewCell *cell = (BRMenuOrderReviewCell *)[self.tableView cellForRowAtIndexPath:indexPath];
			dest.orderItem = cell.orderItem;
			[self.tableView deselectRowAtIndexPath:indexPath animated:YES];
		}
	}
}

#pragma mark - Actions

- (IBAction)toggleEditing:(id)sender {
	[self setEditing:!self.editing animated:YES];
	if ( [sender isKindOfClass:[BRMenuBarButtonItemView class]] ) {
		BRMenuBarButtonItemView *editingButton = (BRMenuBarButtonItemView *)sender;
		editingButton.title = (self.editing
							   ? [NSBundle localizedBRMenuString:@"menu.action.done"]
							   : [NSBundle localizedBRMenuString:@"menu.action.edit"]);
		[editingButton sizeToFit];
	}
}

- (IBAction)toggleTakeAway:(id)sender {
	BRMenuOrderReviewCell *cell = [sender nearestAncestorViewOfType:[BRMenuOrderReviewCell class]];
	if ( cell == nil ) {
		return;
	}
	BRMenuOrderItem *orderItem = cell.orderItem;
	orderItem.takeAway = !orderItem.takeAway;
}

- (IBAction)adjustQuantity:(UIControl *)sender {
	BRMenuOrderReviewCell *cell = [sender nearestAncestorViewOfType:[BRMenuOrderReviewCell class]];
	if ( cell == nil ) {
		return;
	}
	BRMenuOrderItem *orderItem = cell.orderItem;
	
	if ( sender == cell.deleteButton ) {
		[self removeOrderItem:cell];
	} else if ( cell.orderItem.item.askTakeaway == YES && sender == cell.plusButton ) {
		[self duplicateOrderItem:cell];
	} else {
		if ( sender == cell.plusButton ) {
			if ( orderItem.quantity < 32 ) { // TODO: define constant or env prop for max
				orderItem.quantity++;
			}
		} else if ( cell.deleteState ) {
			// cancel "delete"
			[cell leaveDeleteState:YES];
			if ( cell.editing != self.editing ) {
				cell.editing = self.editing;
			}
		} else if ( orderItem.quantity == 1 || orderItem.item.askTakeaway == YES ) {
			// we must confirm this action; enter "delete" state
			[cell enterDeleteState:YES];
		} else if ( orderItem.quantity > 0 ) {
			orderItem.quantity--;
		}
		
		if ( cell.orderItem.quantity < 1 ) {
			[self removeOrderItem:cell];
		}
	}
}

- (IBAction)deleteRow:(UISwipeGestureRecognizer *)sender {
	BRMenuOrderReviewCell *row = [sender.view nearestAncestorViewOfType:[BRMenuOrderReviewCell class]];
	row.editing = YES;
	[row enterDeleteState:YES];
}

#pragma mark - Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
}

- (void)removeOrderItem:(BRMenuOrderReviewCell *)cell {
	BRMenuOrderItem *orderItem = cell.orderItem;
	
	[self.tableView beginUpdates];
	
	NSMutableArray *reloadIndexPaths = [NSMutableArray arrayWithCapacity:5];
	NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
	const NSInteger row = indexPath.row;
	const NSUInteger oldSectionCount = [groupsController numberOfSections];
	
	// special consideration for takeaway rows, to handle proxies
	if ( orderItem.item.askTakeaway && orderItem.quantity > 1 ) {
		const UInt8 removeIndex = ([orderItem isProxy] ? ((BRMenuOrderItemAttributesProxy *)orderItem).index : 0);
		NSUInteger remapIndex;
		const NSUInteger endRemapIndex = row + orderItem.quantity - removeIndex;
		for ( remapIndex = row + 1; remapIndex < endRemapIndex; remapIndex++ ) {
			NSIndexPath *reloadIndexPath = [NSIndexPath indexPathForRow:remapIndex inSection:indexPath.section];
			[reloadIndexPaths addObject:reloadIndexPath];
		}
		[orderItem removeAttributesAtIndex:removeIndex];
		orderItem.quantity--;
	} else {
		[order removeItemForMenuItem:orderItem.item];
	}
	
	[groupsController refresh];
	
	if ( reloadIndexPaths.count > 0 ) {
		[self.tableView reloadRowsAtIndexPaths:reloadIndexPaths withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	
	// now delete the row, or entire section if we removed the last row in section
	if ( [groupsController numberOfSections] == oldSectionCount ) {
		[self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
	} else {
		[self.tableView deleteSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationAutomatic];
	}
	
	[self.tableView endUpdates];
	
	// if no more rows, leave edit mode automatically
	if ( [groupsController numberOfSections] < 1 ) {
		[self toggleEditing:self.editButton];
		[self refreshFromModel];
	}
}

- (void)duplicateOrderItem:(BRMenuOrderReviewCell *)cell {
	BRMenuOrderItem *orderItem = cell.orderItem;
	NSInteger insertRow;
	NSIndexPath *origIndexPath = [self.tableView indexPathForCell:cell];
	if ( orderItem.item.askTakeaway ) {
		// For items that support take away, we don't create duplicate items. Instead we manage each "duplicate" as a proxy
		// for the attributes at a speicific index within a single BRMenuOrderItem.
		const UInt8 index = [orderItem.attributes count];
		BRMenuOrderItemAttributes *attr = [BRMenuOrderItemAttributes new];
		attr.takeAway = orderItem.takeAway;
		[orderItem setAttributes:attr atIndex:index];
		orderItem.quantity++;
		insertRow = (origIndexPath.row + ([orderItem isProxy] ? (index - [(BRMenuOrderItemAttributesProxy *)orderItem index]) : index));
	} else {
		BRMenuOrderItem *duplicate;
		duplicate = [[BRMenuOrderItem alloc] initWithOrderItem:cell.orderItem];
		insertRow = origIndexPath.row + 1;
		[order addOrderItem:duplicate];
	}
	[groupsController refresh];
	[self.tableView beginUpdates];
	[self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:insertRow inSection:origIndexPath.section]]
						  withRowAnimation:UITableViewRowAnimationAutomatic];
	[self.tableView endUpdates];
}

#pragma mark - Table view support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [groupsController numberOfSections];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [groupsController numberOfItemsInSection:section];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	BRMenuGroupTableHeaderView *header = [tableView dequeueReusableHeaderFooterViewWithIdentifier:BRMenuOrderReviewGroupHeaderCellIdentifier];
	header.title = [groupsController titleForSection:section];
	return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMenuOrderReviewCell *cell = [tableView dequeueReusableCellWithIdentifier:BRMenuOrderReviewOrderItemCellIdentifier forIndexPath:indexPath];
	if ( [[cell.plusButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] < 1 ) {
		[cell.plusButton addTarget:self action:@selector(adjustQuantity:) forControlEvents:UIControlEventTouchUpInside];
	}
	if ( [[cell.minusButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] < 1 ) {
		[cell.minusButton addTarget:self action:@selector(adjustQuantity:) forControlEvents:UIControlEventTouchUpInside];
	}
	if ( [[cell.deleteButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] < 1 ) {
		[cell.deleteButton addTarget:self action:@selector(adjustQuantity:) forControlEvents:UIControlEventTouchUpInside];
		UISwipeGestureRecognizer *swipeToDelete = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(deleteRow:)];
		swipeToDelete.direction = UISwipeGestureRecognizerDirectionLeft;
		[cell addGestureRecognizer:swipeToDelete];
	}
	if ( [[cell.takeAwayButton actionsForTarget:self forControlEvent:UIControlEventTouchUpInside] count] < 1 ) {
		[cell.takeAwayButton addTarget:self action:@selector(toggleTakeAway:) forControlEvents:UIControlEventTouchUpInside];
	}
	cell.orderItem = [groupsController orderItemAtIndexPath:indexPath];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView shouldHighlightRowAtIndexPath:(NSIndexPath *)indexPath {
	BRMenuOrderReviewCell *cell = (BRMenuOrderReviewCell *)[tableView cellForRowAtIndexPath:indexPath];
	// allow highlight when cell is in delete state, or when item requires review (and thus we can show details)
	return (cell.deleteState || (self.editing == NO && cell.orderItem.item.needsReview == YES));
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// if we are in editing mode, and the cell is in delete state, we should cancel the delete (mimic standard iOS behavior)
	BRMenuOrderReviewCell *cell = (BRMenuOrderReviewCell *)[tableView cellForRowAtIndexPath:indexPath];
	if ( cell.deleteState ) {
		[cell leaveDeleteState:YES];
		if ( cell.editing != self.editing ) {
			cell.editing = self.editing;
		}
	} else if ( self.editing == NO && cell.orderItem.item.needsReview == YES ) {
		return indexPath;
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	// jump to details
	[self performSegueWithIdentifier:BRMenuOrderReviewViewOrderItemDetailsSegue sender:self];
}

// we manually handle showing custom +/- editing controls, so disable indentation while editing with the
// following two delegate methods

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
	return UITableViewCellEditingStyleNone;
}

@end
