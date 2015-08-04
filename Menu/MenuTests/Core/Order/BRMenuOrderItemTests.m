//
//  BRMenuOrderItemTests.m
//  MenuKit
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemAttributes.h"
#import "BRMenuOrderItemComponent.h"

@interface BRMenuOrderItemTests : XCTestCase

@end

@implementation BRMenuOrderItemTests

- (void)testTakeAwayFlag {
	BRMenuOrderItemAttributes *attr;
	BRMenuOrderItem *item = [BRMenuOrderItem new];
	XCTAssertNil([item attributesAtIndex:0], @"attributes initial value");
	XCTAssertEqual(NO, item.takeAway, @"initial takeAway flag value");
	
	item.takeAway = YES;
	XCTAssertEqual(YES, item.takeAway, @"takeAway flag set to YES");
	attr = [item attributesAtIndex:0];
	XCTAssertNotNil(attr, @"attributes present");
	XCTAssertEqual(YES, attr.takeAway, @"attribute takeAway flag");
	
	item.takeAway = NO;
	XCTAssertEqual(NO, item.takeAway, @"takeAway flag set to NO");
	XCTAssertEqual(NO, attr.takeAway, @"attribute takeAway flag");
}

- (void)testEquals {
	BRMenu *menu = [BRMenu new];
	BRMenuItem *pizzaItem = [BRMenuItem new];
	pizzaItem.title = @"Pizza";
	pizzaItem.itemId = 1;
	pizzaItem.menu = menu;
	
	BRMenuItem *pizzaPlusItem = [BRMenuItem new];
	pizzaPlusItem.title = @"Pizza+";
	pizzaPlusItem.itemId = 2;
	pizzaPlusItem.menu = menu;
	
	BRMenuItemComponent *traditionalDough = [BRMenuItemComponent new];
	traditionalDough.componentId = 1;
	traditionalDough.title = @"Traditional";
	
	BRMenuItemComponent *wholeWheatDough = [BRMenuItemComponent new];
	wholeWheatDough.componentId = 2;
	wholeWheatDough.title = @"Whole Wheat";

	BRMenuOrderItem *pizzaOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaItem];
	BRMenuOrderItem *pizzaOrderItem2 = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaItem];
	BRMenuOrderItem *pizzaPlusOrderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizzaPlusItem];
	XCTAssertEqual(YES, [pizzaOrderItem isEqual:pizzaOrderItem2], @"equal items");
	XCTAssertEqual(NO, [pizzaOrderItem isEqual:pizzaPlusOrderItem], @"not equal items");
						
	// add components to item, now items should differ as components differ
	[pizzaOrderItem addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:traditionalDough]];
	XCTAssertEqual(NO, [pizzaOrderItem isEqual:pizzaOrderItem2], @"not equal from components");
	
	// but add component to other item and they should be equal again
	[pizzaOrderItem2 addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:traditionalDough]];
	XCTAssertEqual(YES, [pizzaOrderItem isEqual:pizzaOrderItem2], @"equal with components");
}

- (void)testGroupKeyNoGroup {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:item];
	assertThat([orderItem orderGroupKey:nil], equalTo(BRMenuOrderItemDefaultGroupKey));
}

- (void)testGroupKeyNoGroupKey {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	item.group = group;
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:item];
	assertThat([orderItem orderGroupKey:nil], equalTo(BRMenuOrderItemDefaultGroupKey));
}

- (void)testGroupKeyDirect {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	group.key = @"test-direct";
	item.group = group;
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:item];
	assertThat([orderItem orderGroupKey:nil], equalTo(group.key));
}

- (void)testGroupKeyDirectMapped {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	group.key = @"test-direct";
	item.group = group;
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:item];
	assertThat([orderItem orderGroupKey:@{@"test-direct" : @"direct"}], equalTo(@"direct"));
}

- (void)testGroupKeyNested {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	group.key = @"test-direct";
	item.group = group;
	BRMenuItemGroup *grandparentGroup = [BRMenuItemGroup new];
	grandparentGroup.key = @"test-nested";
	group.parentGroup = grandparentGroup;
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:item];
	assertThat([orderItem orderGroupKey:nil], equalTo(grandparentGroup.key));
}

- (void)testGroupKeyNestedMapped {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	group.key = @"test-direct";
	item.group = group;
	BRMenuItemGroup *grandparentGroup = [BRMenuItemGroup new];
	grandparentGroup.key = @"test-nested";
	group.parentGroup = grandparentGroup;
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:item];
	assertThat([orderItem orderGroupKey:@{@"test-nested" : @"nested"}], equalTo(@"nested"));
}

@end
