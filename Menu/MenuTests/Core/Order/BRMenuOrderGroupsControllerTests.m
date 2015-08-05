//
//  BRMenuOrderGroupsControllerTests.m
//  Menu
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuMappingPostProcessor.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderGroupsController.h"
#import "BRMenuOrderItem.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"
#import "BRMenuTestingMenuProvider.h"

@interface BRMenuOrderGroupsControllerTests : XCTestCase

@end

@implementation BRMenuOrderGroupsControllerTests

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

- (BRMenuOrder *)testOrder {
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
	
	return order;
}

- (void)testBasicController {
	BRMenuOrder *order = [self testOrder];
	assertThat(order.menus, hasCountOf(1));
	BRMenu *pizzaMenu = [order.menus firstObject];
	
	BRMenuOrderGroupsController *controller = [[BRMenuOrderGroupsController alloc] initWithOrder:order
																				 groupKeyMapping:@{@"pizza+" : @"pizza"}];
	assertThat(@([controller numberOfSections]), equalToUnsignedInteger(3));
	
	assertThat(@([controller numberOfItemsInSection:0]), equalToUnsignedInteger(2));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].item, equalTo([pizzaMenu menuItemForKey:@"pizza"]));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].item, equalTo([pizzaMenu menuItemForKey:@"pizza+"]));

	assertThat(@([controller numberOfItemsInSection:1]), equalToUnsignedInteger(1));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].item, equalTo([[pizzaMenu menuItemGroupForKey:@"salad"].items firstObject]));
	
	assertThat(@([controller numberOfItemsInSection:2]), equalToUnsignedInteger(1));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:2]].item, equalTo([pizzaMenu menuItemForKey:@"dessert-pizza"]));
}

- (void)testMultiMenuController {
	// TODO
}

@end
