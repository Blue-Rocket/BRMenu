//
//  BRMenuOrderingViewController.m
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingViewController.h"

#import "BRMenu.h"
#import "BRMenuItemObject.h"
#import "BRMenuItemObjectCell.h"
#import "BRMenuOrderingComponentsViewController.h"
#import "BRMenuOrderingFlowController.h"
#import "BRMenuUIStylishHost.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIViewController+BRMenuUIStyle.h"

NSString * const BRMenuOrderingItemObjectCellIdentifier = @"ItemObjectCell";
NSString * const BRMenuOrderingConfigureComponentsSegue = @"ConfigureComponents";

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
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithWithTitle:nil
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

#pragma mark - Navigation support

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:BRMenuOrderingConfigureComponentsSegue] ) {
		BRMenuOrderingComponentsViewController *dest = segue.destinationViewController;
		dest.flowController = [flowController flowControllerForItemAtIndexPath:[self.tableView indexPathForSelectedRow]];
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
	}
}

@end
