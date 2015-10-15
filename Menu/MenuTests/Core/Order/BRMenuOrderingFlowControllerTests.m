//
//  BRmenuOrderingFlowControllerTests.m
//  Menu
//
//  Created by Matt on 30/09/15.
//  Copyright © 2015 Blue Rocket. All rights reserved.
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
#import "BRmenuOrderingFlowController.h"
#import "BRMenuOrder+Encoding.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemComponent.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"
#import "BRMenuTestingMenuProvider.h"

@interface BRMenuOrderingFlowControllerTests : XCTestCase

@end

@implementation BRMenuOrderingFlowControllerTests

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

- (void)testTopLevelSectionInfo {
	BRMenuOrderingFlowController *controller = [[BRMenuOrderingFlowController alloc] initWithMenu:[self testMenu]];
	assertThatInteger([controller numberOfSections], describedAs(@"All groups and items at root are in 1 section", equalToInteger(1), nil));
	assertThat([controller priceForSection:5], nilValue());
	
	assertThat([controller titleForSection:0], nilValue());

	assertThatInteger([controller numberOfItemsInSection:0], equalToInteger(6));
	id<BRMenuItemObject> item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(item, notNilValue());
}

- (void)testTopLevelItemInfo {
	BRMenuOrderingFlowController *controller = [[BRMenuOrderingFlowController alloc] initWithMenu:[self testMenu]];
	assertThatInteger([controller numberOfItemsInSection:0], equalToInteger(6));
	id<BRMenuItemObject> item;
 
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(item, instanceOf([BRMenuItem class]));
	assertThat(item.title, equalTo(@"Pizza"));

	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
	assertThat(item, instanceOf([BRMenuItemGroup class]));
	assertThat(item.title, equalTo(@"Suggestions"));
}

- (void)testTopLevelNavigation {
	BRMenuOrderingFlowController *controller = [[BRMenuOrderingFlowController alloc] initWithMenu:[self testMenu]];

	
	NSError *error = nil;
	assertThatBool([controller canGotoNextStep:&error], isTrue());
	assertThat(error, nilValue());
	
	assertThatBool([controller canAddItemToOrder:&error], isTrue());
	assertThat(error, nilValue());
	
	assertThatBool(controller.hasMenuItemWithoutComponents, isFalse());
	
	BRMenuOrderingFlowController *nextController = [controller flowControllerForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(nextController, notNilValue());
}

- (void)testMenuItemWithComponentsInfo {
	BRMenuOrderingFlowController *rootController = [[BRMenuOrderingFlowController alloc] initWithMenu:[self testMenu]];
	BRMenuOrderingFlowController *controller = [rootController flowControllerForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];

	assertThatBool(controller.finalStep, isTrue());
	assertThatInteger([controller numberOfSections], describedAs(@"Component groups turn into sections", equalToInteger(3), nil));
	assertThat([controller titleForSection:0], equalTo(@"Dough"));
	assertThat([controller titleForSection:1], equalTo(@"Sauce or Spread"));
	assertThat([controller titleForSection:2], equalTo(@"Cheese"));
	
	assertThat([controller priceForSection:0], nilValue());
	assertThat([controller priceForSection:1], nilValue());
	assertThat([controller priceForSection:2], nilValue());
	
	assertThatInteger([controller numberOfItemsInSection:0], equalToInteger(3));
	assertThatInteger([controller numberOfItemsInSection:1], equalToInteger(6));
	assertThatInteger([controller numberOfItemsInSection:2], equalToInteger(6));
	
	assertThat(controller.orderItem, describedAs(@"Order item automatically created for item flow", notNilValue(), nil));
	
	NSError *error = nil;
	assertThatBool([controller canGotoNextStep:&error], isFalse());
	assertThat(error, notNilValue());
	
	error = nil;
	assertThatBool([controller canAddItemToOrder:&error], isFalse());
	assertThat(error, notNilValue());
	
	id<BRMenuItemObject> item;
	
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Traditional"));
	
	[controller.orderItem getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)item];
	assertThatBool([controller canGotoNextStep:&error], isFalse());
	assertThatBool([controller canAddItemToOrder:&error], isFalse());
	
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Spicy Tomato"));
	
	[controller.orderItem getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)item];
	assertThatBool([controller canGotoNextStep:&error], isFalse());
	assertThatBool([controller canAddItemToOrder:&error], isFalse());
	
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:2]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Ricotta"));
	
	[controller.orderItem getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)item];
	error = nil;
	assertThatBool([controller canGotoNextStep:&error], isTrue());
	assertThat(error, nilValue());
	error = nil;
	assertThatBool([controller canAddItemToOrder:&error], isTrue());
	assertThat(error, nilValue());
}

- (void)testMenuItemWithComponentGroupsInfo {
	BRMenuOrderingFlowController *rootController = [[BRMenuOrderingFlowController alloc] initWithMenu:[self testMenuForResource:@"menu-pizza.json"]];
	BRMenuOrderingFlowController *controller = [rootController flowControllerForItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0]];

	assertThatBool(controller.finalStep, isFalse());
	assertThatInteger([controller numberOfSections], describedAs(@"Component groups turn into sections", equalToInteger(3), nil));
	assertThat([controller titleForSection:0], equalTo(@"Dough"));
	assertThat([controller titleForSection:1], equalTo(@"Sauce/Spread"));
	assertThat([controller titleForSection:2], equalTo(@"Cheese"));
	
	assertThat([controller priceForSection:0], nilValue());
	assertThat([controller priceForSection:1], nilValue());
	assertThat([controller priceForSection:2], nilValue());
	
	assertThatInteger([controller numberOfItemsInSection:0], equalToInteger(3));
	assertThatInteger([controller numberOfItemsInSection:1], equalToInteger(9));
	assertThatInteger([controller numberOfItemsInSection:2], equalToInteger(4));
	
	assertThat(controller.orderItem, describedAs(@"Order item automatically created for item flow", notNilValue(), nil));
	
	NSError *error = nil;
	assertThatBool([controller canGotoNextStep:&error], isFalse());
	assertThat(error, notNilValue());
	
	error = nil;
	assertThatBool([controller canAddItemToOrder:&error], isFalse());
	assertThat(error, notNilValue());
	
	id<BRMenuItemObject> item;
	
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Traditional"));
	
	[controller.orderItem getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)item];
	assertThatBool([controller canGotoNextStep:&error], isFalse());
	assertThatBool([controller canAddItemToOrder:&error], isFalse());
	
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:1]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Classic Tomato"));
	
	[controller.orderItem getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)item];
	assertThatBool([controller canGotoNextStep:&error], isFalse());
	assertThatBool([controller canAddItemToOrder:&error], isFalse());
	
	item = [controller menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:2]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Quattro Formaggi Blend"));
	
	[controller.orderItem getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)item];
	error = nil;
	assertThatBool([controller canGotoNextStep:&error], isTrue());
	assertThat(error, nilValue());
	error = nil;
	assertThatBool([controller canAddItemToOrder:&error], isTrue());
	assertThat(error, nilValue());
	
	// goto next step in flow
	assertThat([controller flowControllerForItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]], nilValue());
	BRMenuOrderingFlowController *nextController = [controller flowControllerForNextStep];
	assertThat(nextController, notNilValue());
	
	assertThatBool(nextController.finalStep, isFalse());
	assertThatInteger([nextController numberOfSections], describedAs(@"Component groups turn into sections", equalToInteger(2), nil));
	assertThat([nextController titleForSection:0], equalTo(@"Proteins"));
	assertThat([nextController titleForSection:1], equalTo(@"Vegetables"));
	
	assertThat([nextController priceForSection:0], nilValue());
	assertThat([nextController priceForSection:1], nilValue());
	
	assertThatInteger([nextController numberOfItemsInSection:0], equalToInteger(8));
	assertThatInteger([nextController numberOfItemsInSection:1], equalToInteger(8));
	
	assertThat(nextController.orderItem, sameInstance(controller.orderItem));

	item = [nextController menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Pepperoni"));
	
	assertThatBool([controller canGotoNextStep:nil], isTrue());
	assertThatBool([controller canAddItemToOrder:nil], isTrue());
	
	nextController = [nextController flowControllerForNextStep];
	assertThat(nextController, notNilValue());
	
	assertThatBool(nextController.finalStep, isTrue());
	assertThatInteger([nextController numberOfSections], describedAs(@"Component groups turn into sections", equalToInteger(1), nil));
	assertThat([nextController titleForSection:0], equalTo(@"Finishes/Oils"));
	
	assertThat([nextController priceForSection:0], nilValue());
	
	assertThatInteger([nextController numberOfItemsInSection:0], equalToInteger(19));
	
	assertThat(nextController.orderItem, sameInstance(controller.orderItem));
	
	item = [nextController menuItemObjectAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
	assertThat(item, instanceOf([BRMenuItemComponent class]));
	assertThat(item.title, equalTo(@"Basil Leaves"));
	
	assertThatBool([controller canGotoNextStep:nil], isTrue());
	assertThatBool([controller canAddItemToOrder:nil], isTrue());	
}

@end
