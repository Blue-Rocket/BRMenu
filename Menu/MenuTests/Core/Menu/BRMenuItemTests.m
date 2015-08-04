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

@end
