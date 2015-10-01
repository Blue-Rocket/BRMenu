//
//  BRMenuOrderTests.m
//  MenuKit
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"
#import "BRMenuMappingPostProcessor.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuOrder+Encoding.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"
#import "BRMenuTestingMenuProvider.h"

@interface BRMenuOrderTests : XCTestCase

@end

@implementation BRMenuOrderTests

- (void)setUp {
	[super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRMenuRestKitTestingSupport setFixtureBundle:bundle];
}

- (BRMenu *)testMenu {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menu.json"]
							  destinationObject:menu]
	 performMapping];
	
	[BRMenuMappingPostProcessor assignMenuIDs:menu];

	return menu;
}

- (BRMenu *)testMenuForResource:(NSString *)resource {
	BRMenu *menu = [BRMenu new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMapping]
								   sourceObject:[[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:resource] valueForKey:@"menu"]
							  destinationObject:menu]
	 performMapping];
	
	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	
	return menu;
}

- (void)testEncodeForBarcode {
	BRMenu *menu = [self testMenu];
	
	BRMenuItem *item = menu.items[0]; // pizza
	
	// create a test order
	BRMenuOrder *order = [BRMenuOrder new];
	order.name = @"Test";
	order.menu = menu;
	
	BRMenuOrderItem *item1 = [BRMenuOrderItem new];
	item1.quantity = 1;
	item1.item = item;
	item1.takeAway = YES;
	[item1 addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[(BRMenuItemComponentGroup *)item.componentGroups[0] components][0]
															placement:BRMenuOrderItemComponentPlacementLeft
															 quantity:BRMenuOrderItemComponentQuantityNormal]];
	[item1 addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[(BRMenuItemComponentGroup *)item.componentGroups[1] components][0]
															placement:BRMenuOrderItemComponentPlacementWhole
															 quantity:BRMenuOrderItemComponentQuantityNormal]];
	[item1 addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[(BRMenuItemComponentGroup *)item.componentGroups[2] components][0]
															placement:BRMenuOrderItemComponentPlacementRight
															 quantity:BRMenuOrderItemComponentQuantityHeavy]];
	[order addOrderItem:item1];
	
	const NSUInteger kExpectedEncodedSize = 19;
	
	NSData *data = [order dataForBarcodeEncoding];
	assertThat(data, notNilValue());
	assertThatUnsignedInteger([data length], equalTo(@(kExpectedEncodedSize)));
	uint8_t bytes[kExpectedEncodedSize];
	[data getBytes:&bytes length:kExpectedEncodedSize];
	assertThatUnsignedInt(bytes[0], describedAs(@"encoding format %0", equalTo(@(BRMenuOrderEncodingFormat_v1)), @(BRMenuOrderEncodingFormat_v1), nil));
	assertThatUnsignedInt(bytes[1], describedAs(@"version hi byte %0", equalTo(@0), @0, nil));
	assertThatUnsignedInt(bytes[2], describedAs(@"version lo byte %0", equalTo(@1), @1, nil));
	assertThat([NSString stringWithCString:(const char *)&bytes[3] encoding:NSASCIIStringEncoding], equalTo(@"Test"));
	assertThatUnsignedInt(bytes[8], describedAs(@"item count %0", equalTo(@1), @1, nil));
	assertThatUnsignedInt(bytes[9], describedAs(@"item ID %0", equalTo(@1), @1, nil));
	assertThatUnsignedInt(bytes[10], describedAs(@"quantity %0", equalTo(@1), @1, nil));
	assertThatUnsignedInt(bytes[11], describedAs(@"component count %0", equalTo(@3), @3, nil));
	assertThatUnsignedInt(bytes[12], describedAs(@"component 1 ID %0", equalTo(@1), @1, nil));
	assertThatUnsignedInt(bytes[13], describedAs(@"component 1 flags %0", equalTo(@4), @4, nil));
	assertThatUnsignedInt(bytes[14], describedAs(@"component 2 ID %0", equalTo(@4), @4, nil));
	assertThatUnsignedInt(bytes[15], describedAs(@"component 2 flags %0", equalTo(@0), @0, nil));
	assertThatUnsignedInt(bytes[16], describedAs(@"component 3 ID %0", equalTo(@0xA), @0xA, nil));
	assertThatUnsignedInt(bytes[17], describedAs(@"component 3 flags %0", equalTo(@0xA), @0xA, nil));
	assertThatUnsignedInt(bytes[18], describedAs(@"attributes %0", equalTo(@1), @1, nil));
}

- (void)testDecodeWithBarcodeData {
	BRMenu *menu = [self testMenu];
	BRMenuTestingMenuProvider *provider = [[BRMenuTestingMenuProvider alloc] initWithMenu:menu];

	// get this item to use later in testing...
	BRMenuItem *pizza = menu.items[0];
	
	const NSUInteger kExpectedEncodedSize = 19;
	
	uint8_t buf[kExpectedEncodedSize] = {1,0,1,'T','e','s','t',0,1,1,1,3,1,4,4,0,0xA,0xA,1};
	NSData *data = [NSData dataWithBytes:&buf length:kExpectedEncodedSize];
	BRMenuOrder *order = [BRMenuOrder orderWithBarcodeData:data menuProvider:provider];
	assertThat(order, notNilValue());
	assertThat(order.menu, sameInstance(menu));
	assertThat(order.name, equalTo(@"Test"));
	assertThat(order.orderItems, hasCountOf(1));
	
	BRMenuOrderItem *item = order.orderItems[0];
	assertThatUnsignedInt(item.quantity, equalTo(@1));
	assertThatBool(item.takeAway, equalTo(@YES));
	assertThat(item.item, sameInstance(pizza));
	assertThat(item.components, hasCountOf(3));
	
	for ( int i = 0; i < 3; i++ ) {
		BRMenuOrderItemComponent *comp = item.components[i];
		BRMenuItemComponent *menuComp = [(BRMenuItemComponentGroup *)pizza.componentGroups[i] components][0];
		assertThat(comp.component, sameInstance(menuComp));
		BRMenuOrderItemComponentPlacement placement = BRMenuOrderItemComponentPlacementWhole;
		BRMenuOrderItemComponentQuantity quantity = BRMenuOrderItemComponentQuantityNormal;
		switch ( i ) {
			case 0:
				placement = BRMenuOrderItemComponentPlacementLeft;
				break;
				
			case 2:
				placement = BRMenuOrderItemComponentPlacementRight;
				quantity = BRMenuOrderItemComponentQuantityHeavy;
				break;
				
			default:
				// nothing
				break;
		}
		assertThatInt(comp.placement, equalTo(@(placement)));
		assertThatInt(comp.quantity, equalTo(@(quantity)));
	}
}

- (void)testReplaceOrderItems {
	BRMenu *menu = [self testMenu];
	BRMenuItem *pizza = [menu menuItemForKey:@"pizza"];
	assertThat(pizza, notNilValue());
	
	BRMenuOrder *order = [BRMenuOrder new];
	BRMenuOrderItem *pizzaOrderItem = [BRMenuOrderItem new];
	pizzaOrderItem.item = pizza;
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];
	assertThat(order.orderItems, hasCountOf(1));
	
	[order replaceOrderItems:nil];
	assertThat(order.orderItems, hasCountOf(0));
	
	[order replaceOrderItems:@[pizzaOrderItem]];
	assertThat(order.orderItems, hasCountOf(1));
	assertThat(order.orderItems[0], sameInstance(pizzaOrderItem));
	
	[order replaceOrderItems:@[]];
	assertThat(order.orderItems, hasCountOf(0));
	
	[order addOrderItem:pizzaOrderItem];
	assertThat(order.orderItems, hasCountOf(1));
	
	BRMenuItem *pizzaPlus = [menu menuItemForKey:@"pizza+"];
	assertThat(pizzaPlus, notNilValue());
	BRMenuOrderItem *pizzaPlusOrderItem = [BRMenuOrderItem new];
	pizzaPlusOrderItem.item = pizzaPlus;
	pizzaPlusOrderItem.quantity = 1;
	[order replaceOrderItems:@[pizzaOrderItem, pizzaPlusOrderItem]];
	assertThat(order.orderItems, hasCountOf(2));
	assertThat(order.orderItems[0], sameInstance(pizzaOrderItem));
	assertThat(order.orderItems[1], sameInstance(pizzaPlusOrderItem));
}

- (void)testCopyOrder {
	BRMenu *menu = [self testMenu];
	BRMenuItem *pizza = [menu menuItemForKey:@"pizza"];
	assertThat(pizza, notNilValue());
	
	BRMenuOrder *order = [BRMenuOrder new];
	order.name = @"Test Name";
	order.orderNumber = 1;
	BRMenuOrderItem *pizzaOrderItem = [BRMenuOrderItem new];
	pizzaOrderItem.item = pizza;
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];
	
	BRMenuItem *pizzaPlus = [menu menuItemForKey:@"pizza+"];
	assertThat(pizzaPlus, notNilValue());
	BRMenuOrderItem *pizzaPlusOrderItem = [BRMenuOrderItem new];
	pizzaPlusOrderItem.item = pizzaPlus;
	pizzaPlusOrderItem.quantity = 1;
	[order addOrderItem:pizzaPlusOrderItem];
	
	assertThat(order.menus, contains(menu, nil));
   
	BRMenuOrder *copy = [order copy];
	assertThat(copy, notNilValue());
	assertThat(copy.name, equalTo(order.name));
	assertThat(copy.orderItems, equalTo(order.orderItems));
	assertThatUnsignedInteger(copy.orderNumber, equalTo(@(NSNotFound)));
	assertThat(copy.menus, equalTo(order.menus));
}

- (void)testCopyOrderWithMultipleMenus {
	BRMenu *pizzaMenu = [self testMenu];
	BRMenuItem *pizza = [pizzaMenu menuItemForKey:@"pizza"];
	assertThat(pizza, notNilValue());
	
	BRMenuOrder *order = [BRMenuOrder new];
	BRMenuOrderItem *pizzaOrderItem = [BRMenuOrderItem new];
	pizzaOrderItem.item = pizza;
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];

	// get item from different menu
	BRMenu *shackMenu = [self testMenuForResource:@"menu-shakeshack.json"];
	BRMenuItem *burger = [shackMenu menuItemForKey:@"burger"];
	assertThat(burger, notNilValue());
	
	BRMenuOrderItem *burgerOrderItem = [BRMenuOrderItem new];
	burgerOrderItem.item = burger;
	burgerOrderItem.quantity = 1;
	[order addOrderItem:burgerOrderItem];

	assertThat(order.menus, containsInAnyOrder(pizzaMenu, shackMenu, nil));
	
	BRMenuOrder *copy = [order copy];
	assertThat(copy, notNilValue());
	assertThat(copy.orderItems, equalTo(order.orderItems));
	assertThat(copy.menus, equalTo(order.menus));
}

- (void)testOrderedGroupsWithoutMapping {
	BRMenu *pizzaMenu = [self testMenu];
	
	BRMenuOrder *order = [BRMenuOrder new];
	order.name = @"Test Name";
	order.orderNumber = 1;
	
	BRMenuItem *dessert = [pizzaMenu menuItemForKey:@"dessert-pizza"];
	assertThat(dessert, notNilValue());
	BRMenuOrderItem *dessertOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:dessert];
	dessertOrderItem.quantity = 1;
	[order addOrderItem:dessertOrderItem];
	
	BRMenuItem *pizza = [pizzaMenu menuItemForKey:@"pizza"];
	BRMenuOrderItem *pizzaOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizza];
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];
	
	BRMenuItem *salad = [[pizzaMenu menuItemGroupForKey:@"salad"].items firstObject];
	assertThat(salad, notNilValue());
	BRMenuOrderItem *saladOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:salad];
	saladOrderItem.quantity = 1;
	[order addOrderItem:saladOrderItem];
	
	BRMenuItem *pizzaPlus = [pizzaMenu menuItemForKey:@"pizza+"];
	assertThat(pizzaPlus, notNilValue());
	BRMenuOrderItem *pizzaPlusOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaPlus];
	pizzaPlusOrderItem.quantity = 1;
	[order addOrderItem:pizzaPlusOrderItem];
	
	// ok, we have 4 items in order, lets generate those groups
	NSArray *groups = [order orderedGroups:nil];
	
	// we expect pizza, pizza+, salad, desert groups
	assertThat(groups, hasCountOf(4));
	NSUInteger i = 0;
	for ( NSArray *rows in groups ) {
		if ( i == 0 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(pizzaOrderItem));
		} else if ( i == 1 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(pizzaPlusOrderItem));
		} else if ( i == 2 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(saladOrderItem));
		} else {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(dessertOrderItem));
		}
		i++;
	}
}

- (void)testOrderedGroupsWithMapping {
	BRMenu *pizzaMenu = [self testMenu];

	BRMenuOrder *order = [BRMenuOrder new];
	order.name = @"Test Name";
	order.orderNumber = 1;
	
	BRMenuItem *dessert = [pizzaMenu menuItemForKey:@"dessert-pizza"];
	assertThat(dessert, notNilValue());
	BRMenuOrderItem *dessertOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:dessert];
	dessertOrderItem.quantity = 1;
	[order addOrderItem:dessertOrderItem];
	
	BRMenuItem *pizza = [pizzaMenu menuItemForKey:@"pizza"];
	BRMenuOrderItem *pizzaOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizza];
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];
	
	BRMenuItem *salad = [[pizzaMenu menuItemGroupForKey:@"salad"].items firstObject];
	assertThat(salad, notNilValue());
	BRMenuOrderItem *saladOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:salad];
	saladOrderItem.quantity = 1;
	[order addOrderItem:saladOrderItem];
	
	BRMenuItem *pizzaPlus = [pizzaMenu menuItemForKey:@"pizza+"];
	assertThat(pizzaPlus, notNilValue());
	BRMenuOrderItem *pizzaPlusOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaPlus];
	pizzaPlusOrderItem.quantity = 1;
	[order addOrderItem:pizzaPlusOrderItem];
	
	// ok, we have 4 items in order, lets generate those groups
	NSArray *groups = [order orderedGroups:@{@"pizza+" : @"pizza"}];
	
	// we expect pizza, salad, desert groups
	assertThat(groups, hasCountOf(3));
	NSUInteger i = 0;
	for ( NSArray *rows in groups ) {
		if ( i == 0 ) {
			assertThat(rows, hasCountOf(2));
			assertThat(rows[0], equalTo(pizzaOrderItem));
			assertThat(rows[1], equalTo(pizzaPlusOrderItem));
		} else if ( i == 1 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(saladOrderItem));
		} else {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(dessertOrderItem));
		}
		i++;
	}
}

- (void)testOrderGroupsWithMultipleMenus {
	BRMenu *pizzaMenu = [self testMenu];
	BRMenuItem *pizza = [pizzaMenu menuItemForKey:@"pizza"];
	assertThat(pizza, notNilValue());
	
	BRMenuOrder *order = [BRMenuOrder new];

	BRMenuItem *salad = [[pizzaMenu menuItemGroupForKey:@"salad"].items firstObject];
	assertThat(salad, notNilValue());
	BRMenuOrderItem *saladOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:salad];
	saladOrderItem.quantity = 1;
	[order addOrderItem:saladOrderItem];
	
	BRMenuOrderItem *pizzaOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizza];
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];
	
	// get items from different menu
	BRMenu *otherPizzaMenu = [self testMenuForResource:@"menu-pizza.json"];

	BRMenuItem *dessert = [[otherPizzaMenu menuItemGroupForKey:@"dessert"].items firstObject];
	assertThat(dessert, notNilValue());
	BRMenuOrderItem *dessertOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:dessert];
	dessertOrderItem.quantity = 1;
	[order addOrderItem:dessertOrderItem];
	
	BRMenuItem *pizzaPlusMenuItem = [otherPizzaMenu menuItemForKey:@"pizza+"];
	assertThat(pizzaPlusMenuItem, notNilValue());
	BRMenuOrderItem *pizzaPlusOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaPlusMenuItem];
	pizzaPlusOrderItem.quantity = 1;
	[order addOrderItem:pizzaPlusOrderItem];
	
	assertThat(order.menus, contains(pizzaMenu, otherPizzaMenu, nil));
	
	// ok, we have 4 items in order, from 2 menus: lets generate those groups
	NSArray *groups = [order orderedGroups:@{@"pizza+" : @"pizza"}];
	
	// we expect pizza (menu 1), salad, pizza (menu 2), desert groups
	assertThat(groups, hasCountOf(4));
	NSUInteger i = 0;
	for ( NSArray *rows in groups ) {
		if ( i == 0 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(pizzaOrderItem));
		} else if ( i == 1 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(saladOrderItem));
		} else if ( i == 2 ) {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(pizzaPlusOrderItem));
		} else {
			assertThat(rows, hasCountOf(1));
			assertThat(rows[0], equalTo(dessertOrderItem));
		}
		i++;
	}
}

@end
