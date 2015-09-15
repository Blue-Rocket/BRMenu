//
//  BRMenuItemComponentTests.m
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

@interface BRMenuItemComponentTests : XCTestCase

@end

@implementation BRMenuItemComponentTests

- (void)testArchive {
	BRMenuItemComponent *comp = [BRMenuItemComponent new];
	comp.componentId = 1;
	comp.title = @"1";
	comp.desc = @"2";
	comp.askQuantity = YES;
	comp.askPlacement = NO;
	comp.showWithFoodInformation = YES;
	comp.absenceOfComponent = NO;
	
	BRMenuItemComponent *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:comp]];
	assertThat(unarchived, notNilValue());
	assertThat(unarchived, isNot(sameInstance(comp)));
	assertThatUnsignedInt(unarchived.componentId, equalToUnsignedInt(comp.componentId));
	assertThat(unarchived.title, equalTo(comp.title));
	assertThat(unarchived.desc, equalTo(comp.desc));
	assertThatBool(unarchived.askQuantity, isTrue());
	assertThatBool(unarchived.askPlacement, isFalse());
	assertThatBool(unarchived.showWithFoodInformation, isTrue());
	assertThatBool(unarchived.absenceOfComponent, isFalse());
}

@end
