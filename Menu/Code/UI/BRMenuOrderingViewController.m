//
//  BRMenuOrderingViewController.m
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingViewController.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemObjectCell.h"

NSString * const BRMenuOrderingItemObjectCellIdentifier = @"ItemObjectCell";

@interface BRMenuOrderingViewController ()

@end

@implementation BRMenuOrderingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	if ( !self.usePrototypeCells ) {
		self.tableView.rowHeight = UITableViewAutomaticDimension;
		self.tableView.estimatedRowHeight = 60.0;
		[self.tableView registerClass:[BRMenuItemObjectCell class] forCellReuseIdentifier:BRMenuOrderingItemObjectCellIdentifier];
	}
}

- (id<BRMenuItemObject>)menuItemObjectAtIndexPath:(NSIndexPath *)indexPath {
	// TODO: move into flow controller
	id<BRMenuItemObject> result = nil;
	NSUInteger index = indexPath.row;
	if ( index < [self.menu.items count] ) {
		result = [self.menu.items objectAtIndex:index];
	} else {
		index -= [self.menu.items count];
		result = [self.menu.groups objectAtIndex:index];
	}
	return result;
}

#pragma mark - Table support

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	// TODO: move into flow controller
	return ([self.menu.items count] + [self.menu.groups count]);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    BRMenuItemObjectCell *cell = [tableView dequeueReusableCellWithIdentifier:BRMenuOrderingItemObjectCellIdentifier forIndexPath:indexPath];
	cell.item = [self menuItemObjectAtIndexPath:indexPath];
    return cell;
}

@end
