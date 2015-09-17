//
//  BRMenuItemComponentGroupTests.m
//  Menu
//
//  Created by Matt on 16/09/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"

@interface BRMenuItemComponentGroupTests : XCTestCase

@end

@implementation BRMenuItemComponentGroupTests

- (void)testArchive {
	BRMenuItemComponentGroup *group = [BRMenuItemComponentGroup new];
	group.title = @"1";
	group.desc = @"2";
	group.key = @"g";
	group.extendsKey = @"e";
	group.multiSelect = YES;
	group.requiredCount = 1;
	
	BRMenuItemComponentGroup *nestedGroup = [BRMenuItemComponentGroup new];
	nestedGroup.title = @"10";
	nestedGroup.desc = @"20";
	nestedGroup.key = @"g0";
	nestedGroup.extendsKey = @"e0";
	nestedGroup.multiSelect = YES;
	nestedGroup.requiredCount = 10;
	
	BRMenuItemComponent *comp = [BRMenuItemComponent new];
	comp.componentId = 1;
	comp.title = @"1";
	
	group.components = @[comp];
	group.componentGroups = @[nestedGroup];
	
	BRMenuItemComponentGroup *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:group]];
	assertThat(unarchived, notNilValue());
	assertThat(unarchived, isNot(sameInstance(group)));
	assertThat(unarchived.title, equalTo(group.title));
	assertThat(unarchived.desc, equalTo(group.desc));
	assertThat(unarchived.key, equalTo(group.key));
	assertThat(unarchived.extendsKey, equalTo(group.extendsKey));
	assertThatBool(unarchived.multiSelect, isTrue());
	assertThatUnsignedInt(unarchived.requiredCount, equalToUnsignedInt(group.requiredCount));

	assertThat(group.components, hasCountOf(1));
	assertThatUnsignedInt(comp.componentId, equalToUnsignedInt([group.components[0] componentId]));

	assertThat(group.componentGroups, hasCountOf(1));
	assertThat(nestedGroup.key, equalTo([group.componentGroups[0] key]));
}

@end
