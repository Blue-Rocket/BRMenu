//
//  BRMenuOrderReviewTableViewController.m
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderReviewViewController.h"

#import "BRMenuBarButtonItemView.h"
#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderGroupsController.h"
#import "BRMenuOrderReviewCell.h"
#import "BRMenuUIStylishHost.h"
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIViewController+BRMenuUIStyle.h"

NSString * const BRMenuOrderReviewOrderItemCellIdentifier = @"OrderItemCell";
NSString * const BRMenuOrderReviewGroupHeaderCellIdentifier = @"GroupHeaderCell";

@interface BRMenuOrderReviewViewController () <BRMenuUIStylishHost>

@end

@implementation BRMenuOrderReviewViewController {
	BRMenuOrder *order;
	NSDictionary *groupKeyMapping;
	BRMenuOrderGroupsController *groupsController;
}

@dynamic uiStyle;
@synthesize order;
@synthesize groupKeyMapping;

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
	}

	[self.tableView reloadData];
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
}

- (void)uiStyleDidChange:(BRMenuUIStyle *)style {
	[self refreshForStyle:style];
}

- (void)refreshForStyle:(BRMenuUIStyle *)style {
	self.view.backgroundColor = style.appBodyColor;
	self.tableView.backgroundColor = style.appBodyColor;
}

#pragma mark - Accessors 

- (void)setOrder:(BRMenuOrder *)theOrder {
	if ( theOrder == order ) {
		return;
	}
	order = theOrder;
	[self refresh];
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

#pragma mark - Actions

- (IBAction)toggleEditing:(UIControl *)sender {
	[self setEditing:!self.editing animated:YES];
	if ( [sender isKindOfClass:[BRMenuBarButtonItemView class]] ) {
		BRMenuBarButtonItemView *editingButton = (BRMenuBarButtonItemView *)sender;
		editingButton.title = (self.editing
							   ? [NSBundle localizedBRMenuString:@"menu.action.done"]
							   : [NSBundle localizedBRMenuString:@"menu.action.edit"]);
	}
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated {
	[super setEditing:editing animated:animated];
	[self.tableView setEditing:editing animated:animated];
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
	cell.orderItem = [groupsController orderItemAtIndexPath:indexPath];
    return cell;
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
