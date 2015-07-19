//
//  BRMenuMappingPostProcessorTests.m
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"
#import "BRMenuItemTag.h"
#import "BRMenuMappingPostProcessor.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"

@interface BRMenuRestKitMappingTests : XCTestCase

@end

@implementation BRMenuRestKitMappingTests

- (void)setUp {
	[super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRMenuRestKitTestingSupport setFixtureBundle:bundle];
}

- (void)testParseMenuItemComponent {
	BRMenuItemComponent *comp = [BRMenuItemComponent new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuItemComponentMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menuitemcomponent.json"]
							  destinationObject:comp]
	 performMapping];
	assertThat(comp.title, equalTo(@"Housemade Mozzarella"));
	assertThat(comp.desc, equalTo(@"Fresh homemade pizza base from the finest ingredients"));
	assertThatBool(comp.askQuantity, equalTo(@YES));
	assertThatBool(comp.askPlacement, equalTo(@YES));
	assertThatBool(comp.showWithFoodInformation, equalTo(@YES));
	assertThatBool(comp.absenceOfComponent, equalTo(@YES));
}

- (void)testParseMenuItemComponentGroup {
	BRMenuItemComponentGroup *group = [BRMenuItemComponentGroup new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuItemComponentGroupMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menuitemcomponentgroup.json"]
							  destinationObject:group]
	 performMapping];
	assertThat(group.title, equalTo(@"Cheese"));
	assertThat(group.desc, equalTo(@"Tasty!"));
	assertThat(group.key, equalTo(@"foo"));
	assertThat(group.extendsKey, equalTo(@"bar"));
	assertThatBool(group.multiSelect, equalTo(@YES));
	assertThatUnsignedInt(group.requiredCount, equalTo(@1));
	assertThat(group.components, hasCountOf(6));
}

- (void)testParseMenuItemComponentGroupNested {
	BRMenuItemComponentGroup *group = [BRMenuItemComponentGroup new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuItemComponentGroupMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menuitemcomponentgroup-nested.json"]
							  destinationObject:group]
	 performMapping];
	assertThat(group.title, equalTo(@"Cooked toppings"));
	assertThat(group.components, nilValue());
	assertThat(group.componentGroups, hasCountOf(1));

	BRMenuItemComponentGroup *nested = [group.componentGroups objectAtIndex:0];
	assertThat(nested.title, equalTo(@"Cheese"));
	assertThat(nested.desc, equalTo(@"Tasty!"));
	assertThat(nested.components, hasCountOf(6));
}

- (void)testParseMenuItem {
	BRMenuItem *item = [BRMenuItem new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuItemMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menuitem.json"]
							  destinationObject:item]
	 performMapping];
	assertThat(item.title, equalTo(@"Side Salad"));
	assertThat(item.desc, equalTo(@"Arugula, Spinach, Asiago, Pecans, Your Choice of Vinaigrette"));
	assertThat(item.key, equalTo(@"foo"));
	assertThat(item.extendsKey, equalTo(@"bar"));
	assertThat(item.price, equalTo([NSDecimalNumber decimalNumberWithMantissa:318 exponent:-2 isNegative:NO]));
	assertThatInt(item.tags, equalTo(@3));
	assertThatBool(item.askTakeaway, equalTo(@YES));
	assertThatBool(item.needsReview, equalTo(@YES));

	assertThat(item.componentGroups, hasCountOf(1));
	BRMenuItemComponentGroup *group = [item.componentGroups objectAtIndex:0];
	assertThat(group.title, equalTo(@"Proteins"));
	assertThat(group.components, hasCountOf(2));
	assertThat([group.components[0] title], equalTo(@"Pepperoni"));
	assertThat([group.components[1] title], equalTo(@"Chicken"));
}

- (void)testParseMenuItemGroup {
	BRMenuItemGroup *item = [BRMenuItemGroup new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuItemGroupMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menuitemgroup.json"]
							  destinationObject:item]
	 performMapping];
	assertThat(item.title, equalTo(@"Suggestions"));
	assertThat(item.desc, equalTo(@"your choice of dough…"));
	assertThat(item.key, equalTo(@"suggestions"));
	assertThat(item.price, equalTo([NSDecimalNumber decimalNumberWithMantissa:864 exponent:-2 isNegative:NO]));
	assertThatBool(item.showItemDelimiters, equalTo(@YES));
	assertThat(item.items, hasCountOf(2));
}

- (void)testParseMenuItemTag {
	BRMenuItemTag *item = [BRMenuItemTag new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuItemTagMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menuitemtag.json"]
							  destinationObject:item]
	 performMapping];
	assertThat(item.title, equalTo(@"Vegetarian"));
	assertThat(item.desc, equalTo(@"Yea!"));
	assertThat(item.key, equalTo(@"vege"));
}

- (void)testParseMenu {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];
	assertThatInt(menu.version, equalTo(@1));
	assertThat(menu.items, hasCountOf(2));
	assertThat(menu.groups, hasCountOf(4));
	
	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	// let's verify a bit of the data as populated into our Menu object
	BRMenuItem *item = [menu.items lastObject];
	assertThat(item.title, equalTo(@"Pizza+"));
	assertThat(item.desc, equalTo(@"your choice of…"));
	assertThatUnsignedInt(item.itemId, equalTo(@2));
	assertThat(item.price, equalTo([NSDecimalNumber decimalNumberWithMantissa:864 exponent:-2 isNegative:NO]));
	assertThat(item.extendsKey, equalTo(@"pizza"));

	assertThat(item.componentGroups, hasCountOf(2));
	BRMenuItemComponentGroup *group = item.componentGroups[1];
	assertThat(group.title, equalTo(@"Finished & Oils"));
	
	assertThat(group.components, hasCountOf(16));
	assertThat(group.components, everyItem(instanceOf([BRMenuItemComponent class])));
	
	BRMenuItemComponent *comp = [group.components lastObject];
	assertThat(comp.title, equalTo(@"Red Pepper Chili Oil"));
	assertThatUnsignedInt(comp.componentId, equalTo(@48));
	
	// verify key search works
	item = [menu menuItemForKey:@"pizza"];
	assertThat(item, notNilValue());
	assertThat(item.title, equalTo(@"Pizza"));
	
	group = [menu menuItemComponentGroupForKey:@"dough"];
	assertThat(group, notNilValue());
	assertThat(group.title, equalTo(@"Dough"));
	BRMenuItemComponentGroup *dough = group; // save for later test
	
	// verify key search works for item in nested groups
	item = [menu menuItemForKey:@"limonata"];
	assertThat(item, notNilValue());
	assertThat(item.title, equalTo(@"Limonata"));
	assertThat(item.group, notNilValue());
	assertThat(item.group.parentGroup, notNilValue());
	assertThatUnsignedInt(item.itemId, isNot(equalTo(@0)));
	
	// verify Maverick suggestion includes Dough components
	item = [menu menuItemForKey:@"maverick"];
	assertThat(item, notNilValue());
	assertThat(item.title, equalTo(@"Maverick"));
	assertThat(item.componentGroups, hasCountOf(1));

	group = item.componentGroups[0];
	assertThat(group.title, equalTo(@"Dough"));
	for ( NSUInteger i = 0; i < [group.components count]; i++ ) {
		assertThat(group.components[i], equalTo(dough.components[i]));
	}
}

- (void)testEnumerateMenuItemObjects {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];

	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	// enumerate MenuItem objects from drinks group
	__block NSUInteger count = 0;
	NSArray *expected = @[@"Pizza", @"Pizza+",
					   @"Maverick", @"Kiss & Fire", @"Gnarlic", @"Backyard Garden", @"Jenny", @"Moonstruck", @"Farmer's Daughter", @"Grecian Market", @"Redvine",
					   @"Caprese", @"Mixed Green", @"Fresca", @"Side Salad",
					   @"Pizzelle Waffle Cookies", @"Dessert Pizza",
					   @"Fountain Soda", @"Bottle Water", @"Bottled Beverages", @"Craft Beer", @"Red Wine", @"White Wine", @"Organic Milk", @"Limonata", @"Pompelmo"];
	[menu enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
		assertThatUnsignedInteger(idx, equalTo(@(count)));
		assertThat(menuItem.title, equalTo(expected[idx]));
		count++;
	}];
	assertThatUnsignedInteger(count, equalTo(@([expected count])));
}

- (void)testEnumerateMenuItemGroups {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];

	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	// enumerate MenuItemGroup objects
	__block NSUInteger count = 0;
	NSArray *expected = @[@"Suggestions", @"salad", @"Dessert", @"Drink", @"San Pellegrino Sparkling Fruit Beverages"];
	[menu enumerateMenuItemGroupsUsingBlock:^(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop) {
		assertThatUnsignedInteger(idx, equalTo(@(count)));
		assertThat(menuItemGroup.title, equalTo(expected[idx]));
		count++;
	}];
	assertThatUnsignedInteger(count, equalTo(@([expected count])));
}

- (void)testEnumerateMenuItemComponentGroups {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];

	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	// enumerate MenuItem objects from drinks group
	__block NSUInteger count = 0;
	NSArray *expected = @[@"Dough", @"Sauce or Spread", @"Cheese", @"Cooked toppings", @"Proteins", @"Vegetables",
					   @"Finished & Oils", @"Dressing"];
	[menu enumerateMenuItemComponentGroupsUsingBlock:^(BRMenuItemComponentGroup *menuItemComponentGroup, NSUInteger idx, BOOL *stop) {
		assertThatUnsignedInteger(idx, equalTo(@(count)));
		assertThat(menuItemComponentGroup.title, equalTo(expected[idx]));
		count++;
	}];
	assertThatUnsignedInteger(count, equalTo(@([expected count])));
}

@end
