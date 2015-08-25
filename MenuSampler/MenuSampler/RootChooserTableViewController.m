//
//  RootChooserTableViewController.m
//  MenuSampler
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "RootChooserTableViewController.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <MenuKit/Core.h>
#import <MenuKit/RestKit.h>
#import <MenuKit/UI.h>
#import <RestKit/RestKit.h>
#import "BRMenu+MenuSampler.h"

static NSString * const kShowMenuSegue = @"ShowMenu";
static NSString * const kReviewOrderSegue = @"ReviewOrder";

@interface RootChooserTableViewController ()

@end

@implementation RootChooserTableViewController {
	BRMenuOrder *order;
}

- (void)viewDidLoad {
	[super viewDidLoad];
	order = [BRMenuOrder new];
	BRMenuOrderCountBarButtonItemView *reviewOrderButton = [BRMenuOrderCountBarButtonItemView new];
	reviewOrderButton.order = order;
	reviewOrderButton.inverse = YES;
	[reviewOrderButton addTarget:self action:@selector(viewOrder:) forControlEvents:UIControlEventTouchUpInside];
	[reviewOrderButton sizeToFit];
	self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:reviewOrderButton];
	
	self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:NSLocalizedString(@"Style", nil)
																							target:self
																							action:@selector(editGlobalStyle:)];
	
}

- (NSArray *)menuNames {
	return @[@"menu-donuts", @"menu-lunchstop", @"menu-pizza", @"menu-shakeshack"];
}

- (BRMenu *)menuForIndexPath:(NSIndexPath *)indexPath {
	NSArray *menus = [self menuNames];
	if ( indexPath.row < menus.count ) {
		return [BRMenu sampleMenuForResourceName:menus[indexPath.row]];
	}
	return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( indexPath.section == 1 ) {
		BRMenu *menu = [self menuForIndexPath:indexPath];
		if ( menu ) {
			UIStoryboard *menuStoryboard = [NSBundle storyboardForBRMenuOrdering];
			NSAssert(menuStoryboard != nil, @"MenuKitOrdering storyboard not found!");
			// the root is a nav controller, but we can re-use our existing controller here
			BRMenuOrderingViewController *dest = [menuStoryboard instantiateViewControllerWithIdentifier:@"MenuOrdering"];
			NSString *title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
			dest.navigationItem.title = title;
			dest.menu = menu;
			dest.order = order;
			
			BRMenuOrderCountBarButtonItemView *reviewOrderButton = [BRMenuOrderCountBarButtonItemView new];
			reviewOrderButton.order = order;
			reviewOrderButton.inverse = YES;
			[reviewOrderButton addTarget:self action:@selector(viewOrder:) forControlEvents:UIControlEventTouchUpInside];
			[reviewOrderButton sizeToFit];
			dest.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:reviewOrderButton];

			[self.navigationController pushViewController:dest animated:YES];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - Actions

- (IBAction)editGlobalStyle:(id)sender {
	[self performSegueWithIdentifier:@"EditGlobalStyle" sender:sender];
}

- (IBAction)viewOrder:(id)sender {
	[self performSegueWithIdentifier:kReviewOrderSegue sender:sender];
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:kReviewOrderSegue] ) {
		BRMenuOrderReviewViewController *dest = segue.destinationViewController;
		dest.order = order;
	}
}

@end
