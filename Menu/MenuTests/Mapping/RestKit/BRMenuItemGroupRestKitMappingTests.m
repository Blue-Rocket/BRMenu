//
//  BRMenuItemGroupRestKitMappingTests.m
//  MenuKit
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuMappingPostProcessor.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"

@interface BRMenuItemGroupRestKitMappingTests : XCTestCase

@end

@implementation BRMenuItemGroupRestKitMappingTests

- (void)setUp {
    [super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRMenuRestKitTestingSupport setFixtureBundle:bundle];
}

- (void)testEnumerateMenuItems {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];

	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	BRMenuItemGroup *drinks = [menu menuItemGroupForKey:@"drink"];
	assertThat(drinks, notNilValue());
	
	// enumerate MenuItem objects from drinks group
	__block NSUInteger count = 0;
	NSArray *expected = @[@"Fountain Soda", @"Bottle Water", @"Bottled Beverages", @"Craft Beer", @"Red Wine",
						  @"White Wine", @"Organic Milk", @"Limonata", @"Pompelmo"];
	[drinks enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
		assertThatUnsignedInteger(idx, equalTo(@(count)));
		assertThat(menuItem.title, equalTo(expected[idx]));
		count++;
	}];
	assertThatUnsignedInteger(count, equalTo(@([expected count])));
}

- (void)testEnumerateMenuItemsWithTopLevelStop {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];
	
	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	BRMenuItemGroup *drinks = [menu menuItemGroupForKey:@"drink"];
	assertThat(drinks, notNilValue());
	
	// enumerate MenuItem objects from drinks group
	__block NSUInteger count = 0;
	NSArray *expected = @[@"Fountain Soda", @"Bottle Water", @"Bottled Beverages"];
	[drinks enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
		assertThatUnsignedInteger(idx, equalTo(@(count)));
		assertThat(menuItem.title, equalTo(expected[idx]));
		count++;
		if ( count == 3 ) {
			*stop = YES;
		}
	}];
	assertThatUnsignedInteger(count, equalTo(@([expected count])));
}

- (void)testEnumerateMenuItemsWithSecondLevelStop {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];
	
	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	BRMenuItemGroup *drinks = [menu menuItemGroupForKey:@"drink"];
	assertThat(drinks, notNilValue());
	
	// enumerate MenuItem objects from drinks group
	__block NSUInteger count = 0;
	NSArray *expected = @[@"Fountain Soda", @"Bottle Water", @"Bottled Beverages", @"Craft Beer", @"Red Wine",
					   @"White Wine", @"Organic Milk", @"Limonata"];
	[drinks enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
		assertThatUnsignedInteger(idx, equalTo(@(count)));
		assertThat(menuItem.title, equalTo(expected[idx]));
		count++;
		if ( count == 8 ) {
			*stop = YES;
		}
	}];
	assertThatUnsignedInteger(count, equalTo(@([expected count])));
}

@end
