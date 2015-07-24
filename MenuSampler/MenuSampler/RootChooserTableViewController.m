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
		NSString *jsonPath = [[NSBundle mainBundle] pathForResource:menus[indexPath.row] ofType:@"json"];
		NSData *data = [NSData dataWithContentsOfFile:jsonPath];
		NSError *error = nil;
		id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
		if ( error ) {
			log4Error(@"Error parsing JSON: %@", [error localizedDescription]);
			return nil;
		}
		// we need the "menu" top-level dictionary object
		object = [object valueForKeyPath:@"menu"];
		static BRMenuRestKitDataMapper *mapper;
		if ( !mapper ) {
			mapper = [[BRMenuRestKitDataMapper alloc] initWithObjectMapping:[BRMenuMappingRestKit menuMapping]];
		}
		BRMenu *menu = [mapper performMappingWithSourceObject:object error:&error];
		if ( error ) {
			log4Error(@"Error mapping JSON: %@", [error localizedDescription]);
			return nil;
		}
		return menu;
	}
	return nil;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
	if ( [segue.identifier isEqualToString:kShowMenuSegue] ) {
		BRMenuOrderingViewController *dest = segue.destinationViewController;
		NSIndexPath *indexPath = [self.tableView indexPathForCell:sender]; // sender from tableView:didSelectRowAtIndexPath:
		BRMenu *menu = [self menuForIndexPath:indexPath];
		if ( menu ) {
			NSString *title = [self.tableView cellForRowAtIndexPath:indexPath].textLabel.text;
			dest.navigationItem.title = title;
			dest.menu = menu;
		}
	}
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
	if ( indexPath.section == 1 ) {
		[self performSegueWithIdentifier:kShowMenuSegue sender:[tableView cellForRowAtIndexPath:indexPath]];
	}
	[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
