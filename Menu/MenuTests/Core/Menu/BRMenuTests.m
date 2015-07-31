//
//  BRMenuTests.m
//  Menu
//
//  Created by Matt on 31/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"

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

@end
