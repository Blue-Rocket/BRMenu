//
//  BRMenuItemTests.m
//  Menu
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenuItem.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"

@interface BRMenuItemTests : XCTestCase
@end

@implementation BRMenuItemTests

- (void)testRootGroupNoGroup {
	BRMenuItem *item = [BRMenuItem new];
	assertThat([item rootMenuItemGroup], nilValue());
}

- (void)testRootGroupDirectParent {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	item.group = group;
	assertThat([item rootMenuItemGroup], equalTo(group));
}

- (void)testRootGroupNestedParent {
	BRMenuItem *item = [BRMenuItem new];
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	item.group = group;
	BRMenuItemGroup *grandparentGroup = [BRMenuItemGroup new];
	group.parentGroup = grandparentGroup;
	assertThat([item rootMenuItemGroup], equalTo(grandparentGroup));
}

- (void)testArchive {
	BRMenuItem *item = [BRMenuItem new];
	item.itemId = 1;
	item.key = @"k";
	item.extendsKey = @"e";
	item.title = @"1";
	item.desc = @"2";
	item.price = [NSDecimalNumber decimalNumberWithString:@"1.99"];
	item.tags = 2;
	item.askTakeaway = YES;
	item.askQuantity = NO;
	item.needsReview = YES;
	
	BRMenuItemComponentGroup *compGroup = [BRMenuItemComponentGroup new];
	compGroup.title = @"c";
	
	item.componentGroups = @[compGroup];
	
	BRMenuItem *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:item]];
	assertThat(unarchived, notNilValue());
	assertThat(unarchived, isNot(sameInstance(item)));
	assertThatUnsignedInt(unarchived.itemId, equalToUnsignedInt(item.itemId));
	assertThat(unarchived.title, equalTo(item.title));
	assertThat(unarchived.desc, equalTo(item.desc));
	assertThat(unarchived.price, equalTo(item.price));
	assertThatInt(unarchived.tags, equalToInt(item.tags));
	assertThatBool(unarchived.askTakeaway, isTrue());
	assertThatBool(unarchived.askQuantity, isFalse());
	assertThatBool(unarchived.needsReview, isTrue());
}

@end
