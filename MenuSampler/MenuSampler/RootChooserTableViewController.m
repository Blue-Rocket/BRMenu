//
//  RootChooserTableViewController.m
//  MenuSampler
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "RootChooserTableViewController.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <BRMenu/Core/Core.h>
#import <BRMenu/RestKit/RestKit.h>
#import <BRMenu/UI/BRMenuOrderingViewController.h>
#import <RestKit/RestKit.h>
#import "BRMenu+MenuSampler.h"

static NSString * const kShowMenuSegue = @"ShowMenu";

@interface RootChooserTableViewController ()

@end

@implementation RootChooserTableViewController

- (IBAction)editGlobalStyle:(id)sender {
	[self performSegueWithIdentifier:@"EditGlobalStyle" sender:sender];
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
			// TODO: move the storybaord and instantiation code into BRMenu
			UIStoryboard *menuStoryboard = [UIStoryboard storyboardWithName:@"MenuOrdering" bundle:nil];
			// the root is a nav controller, but we can re-use our existing controller here
			BRMenuOrderingViewController *dest = [menuStoryboard instantiateViewControllerWithIdentifier:@"MenuOrdering"];
			NSString *title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
			dest.navigationItem.title = title;
			dest.menu = menu;
			[self.navigationController pushViewController:dest animated:YES];
		}
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
