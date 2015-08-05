//
//  BRMenuOrderReviewTableViewController.m
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderReviewViewController.h"

#import "BRMenuGroupTableHeaderView.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderGroupsController.h"
#import "BRMenuOrderReviewCell.h"
#import "BRMenuUIStylishHost.h"
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

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
