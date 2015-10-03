//
//  BRMenuTests.m
//  MenuKit
//
//  Created by Matt on 31/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuItemTag.h"

@interface BRMenuTests : XCTestCase
@end

@implementation BRMenuTests

- (void)testEqualsNoKeys {
	BRMenu *menu = [BRMenu new];
	BRMenu *menu2 = [BRMenu new];
	assertThatBool([menu isEqual:menu2], isFalse());
}

- (void)testEqualsMissingOtherKey {
	BRMenu *menu = [BRMenu new];
	menu.key = @"a";
	BRMenu *menu2 = [BRMenu new];
	assertThatBool([menu isEqual:menu2], isFalse());
}

- (void)testEqualsMissingKey {
	BRMenu *menu = [BRMenu new];
	BRMenu *menu2 = [BRMenu new];
	menu2.key = @"b";
	assertThatBool([menu isEqual:menu2], isFalse());
}

- (void)testEqualsDifferentKeys {
	BRMenu *menu = [BRMenu new];
	menu.key = @"a";
	BRMenu *menu2 = [BRMenu new];
	menu2.key = @"b";
	assertThatBool([menu isEqual:menu2], isFalse());
}

- (void)testEqualsMatchingKeys {
	BRMenu *menu = [BRMenu new];
	menu.key = @"a";
	BRMenu *menu2 = [BRMenu new];
	menu2.key = @"a";
	assertThatBool([menu isEqual:menu2], isTrue());
}

- (void)testEqualsMatchingInstance {
	BRMenu *menu = [BRMenu new];
	menu.key = @"a";
	assertThatBool([menu isEqual:menu], isTrue());
}

- (void)testEqualsMatchingInstanceNoKey {
	BRMenu *menu = [BRMenu new];
	assertThatBool([menu isEqual:menu], isTrue());
}

- (void)testArchive {
	BRMenu *menu = [BRMenu new];
	menu.key = @"k";
	menu.title = @"K";
	menu.version = 1;
	
	BRMenuItem *item = [BRMenuItem new];
	item.itemId = 1;
	item.key = @"k";
	item.menu = menu;
	
	BRMenuItemGroup *group = [BRMenuItemGroup new];
	group.key = @"gk";
	
	BRMenuItem *groupedItem = [BRMenuItem new];
	groupedItem.itemId = 2;
	groupedItem.key = @"gik";
	groupedItem.group = group;
	
	BRMenuItemGroup *nestedGroup = [BRMenuItemGroup new];
	nestedGroup.key = @"ng";
	nestedGroup.parentGroup = group;
	
	BRMenuItem *nestedGroupItem = [BRMenuItem new];
	nestedGroupItem.itemId = 3;
	nestedGroupItem.key = @"ngi";
	nestedGroupItem.group = nestedGroup;
	nestedGroupItem.menu = menu;
	
	nestedGroup.items = @[nestedGroupItem];
	
	group.items = @[groupedItem];
	group.groups = @[nestedGroup];

	BRMenuItemTag *tag = [BRMenuItemTag new];
	tag.key = @"t";
	
	menu.items = @[item];
	menu.groups = @[group];
	menu.tags = @[tag];

	BRMenu *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:menu]];
	assertThat(unarchived, notNilValue());
	assertThat(unarchived, isNot(sameInstance(item)));
	assertThat(unarchived.key, equalTo(menu.key));
	assertThat(unarchived.title, equalTo(menu.title));
	assertThatUnsignedInt(unarchived.version, equalToUnsignedInt(menu.version));
	
	assertThat(unarchived.items, hasCountOf(1));
	assertThat([unarchived.items[0] key], equalTo(item.key));
	assertThat([unarchived.items[0] menu], sameInstance(unarchived));
	
	assertThat(unarchived.groups, hasCountOf(1));
	BRMenuItemGroup *g = unarchived.groups[0];
	assertThat(g.key, equalTo(group.key));
	assertThat(g.parentGroup, nilValue());
	assertThat(g.items, hasCountOf(1));
	assertThat([g.items[0] key], equalTo(groupedItem.key));
	assertThat([g.items[0] group], sameInstance(g));
	assertThat(g.groups, hasCountOf(1));
	BRMenuItemGroup *ng = g.groups[0];
	assertThat(ng.key, equalTo(nestedGroup.key));
	assertThat(ng.parentGroup, sameInstance(g));
	assertThat(ng.groups, nilValue());
	assertThat(ng.items, hasCountOf(1));
	assertThat([ng.items[0] key], equalTo(nestedGroupItem.key));
	assertThat([ng.items[0] menu], sameInstance(unarchived));
	assertThat([ng.items[0] group], sameInstance(ng));
	
	assertThat(unarchived.tags, hasCountOf(1));
	assertThat([unarchived.tags [0] key], equalTo(tag.key));
}

@end
