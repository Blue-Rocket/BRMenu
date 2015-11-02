//
//  BRMenuOrderMenuGroupingControllerTests.m
//  Menu
//
//  Created by Matt on 15/10/15.
//  Copyright © 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuMappingPostProcessor.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderMenuGroupingController.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"
#import "BRMenuTestingMenuProvider.h"

@interface BRMenuOrderMenuGroupingControllerTests : XCTestCase

@end

@implementation BRMenuOrderMenuGroupingControllerTests

- (void)setUp {
	[super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRMenuRestKitTestingSupport setFixtureBundle:bundle];
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

- (BRMenuOrder *)createTestMixedOrder {
	BRMenu *pizzaMenu = [self testMenuForResource:@"menu-pizza.json"];
	pizzaMenu.title = @"Pizza Palace";
	
	BRMenu *shakeMenu = [self testMenuForResource:@"menu-shakeshack.json"];
	shakeMenu.title = @"Shake Shack";

	BRMenuOrder *order = [BRMenuOrder new];
	order.name = @"Test Name";
	order.orderNumber = 1;
	
	BRMenuItem *pizza = [pizzaMenu menuItemForKey:@"pizza"];
	BRMenuOrderItem *pizzaOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizza];
	pizzaOrderItem.quantity = 1;
	[order addOrderItem:pizzaOrderItem];
	
	BRMenuItem *salad = [pizzaMenu menuItemForKey:@"side-salad"];
	assertThat(salad, notNilValue());
	BRMenuOrderItem *saladOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:salad];
	saladOrderItem.quantity = 1;
	[order addOrderItem:saladOrderItem];
	
	BRMenuItem *burger = [shakeMenu menuItemForKey:@"burger"];
	assertThat(burger, notNilValue());
	BRMenuOrderItem *burgerOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:burger];
	burgerOrderItem.quantity = 1;
	[order addOrderItem:burgerOrderItem];
	
	BRMenuItem *fries = [shakeMenu menuItemForKey:@"fries"];
	assertThat(fries, notNilValue());
	BRMenuOrderItem *friesOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:fries];
	friesOrderItem.quantity = 1;
	[order addOrderItem:friesOrderItem];

	BRMenuItem *pizzaPlus = [pizzaMenu menuItemForKey:@"pizza+"];
	assertThat(pizzaPlus, notNilValue());
	BRMenuOrderItem *pizzaPlusOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaPlus];
	pizzaPlusOrderItem.quantity = 1;
	[order addOrderItem:pizzaPlusOrderItem];

	BRMenuItem *dessert = [pizzaMenu menuItemForKey:@"dessert-pizza"];
	assertThat(dessert, notNilValue());
	BRMenuOrderItem *dessertOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:dessert];
	dessertOrderItem.quantity = 1;
	[order addOrderItem:dessertOrderItem];
	
	return order;
}

- (void)testBasicController {
	BRMenuOrder *order = [self createTestMixedOrder];
	assertThat(order.menus, hasCountOf(2));
	BRMenu *pizzaMenu = [order.menus firstObject];
	BRMenu *shakeMenu = [order.menus lastObject];
	
	BRMenuOrderMenuGroupingController *controller = [[BRMenuOrderMenuGroupingController alloc] initWithOrder:order];
	assertThat(@([controller numberOfSections]), equalToUnsignedInteger(2));
	
	assertThat([controller titleForSection:0], equalTo(pizzaMenu.title));
	assertThatUnsignedInteger([controller numberOfItemsInSection:0], equalToUnsignedInteger(4));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]].item, equalTo([pizzaMenu menuItemForKey:@"pizza"]));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]].item, equalTo([pizzaMenu menuItemForKey:@"side-salad"]));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]].item, equalTo([pizzaMenu menuItemForKey:@"pizza+"]));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:3 inSection:0]].item, equalTo([pizzaMenu menuItemForKey:@"dessert-pizza"]));
	
	assertThatUnsignedInteger([controller numberOfItemsInSection:1], equalToUnsignedInteger(2));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:1]].item, equalTo([shakeMenu menuItemForKey:@"burger"]));
	assertThat([controller orderItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]].item, equalTo([shakeMenu menuItemForKey:@"fries"]));
}

@end
