//
//  BRMenuOrderItemAttributesProxyTests.m
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>

#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemAttributes.h"
#import "BRMenuOrderItemAttributesProxy.h"

@interface BRMenuOrderItemAttributesProxyTests : XCTestCase

@end

@implementation BRMenuOrderItemAttributesProxyTests

- (void)testProxyTakeAway {
	BRMenuOrderItem *item = [BRMenuOrderItem new];
	[self exerciseTakeAwayFlagTestsWithOrderItem:item atIndex:0];
	[self exerciseTakeAwayFlagTestsWithOrderItem:item atIndex:1];
	[self exerciseTakeAwayFlagTestsWithOrderItem:item atIndex:3]; // skip 2
	
	// at this point, we should have 4 attribute flags set
	XCTAssertEqual((NSUInteger)4, [item.attributes count], @"attributes count");
}

- (void)exerciseTakeAwayFlagTestsWithOrderItem:(BRMenuOrderItem *)orderItem atIndex:(UInt8)index {
	BRMenuOrderItemAttributesProxy *proxy = [[BRMenuOrderItemAttributesProxy alloc] initWithOrderItem:orderItem attributeIndex:index];
	BRMenuOrderItemAttributes *attr = [proxy.target attributesAtIndex:index];
	XCTAssertNil(attr, @"initial attributes value");
	XCTAssertEqual(NO, [(id)proxy isTakeAway], @"initial proxy takeAway value");
	[(id)proxy setTakeAway:YES];
	attr = [proxy.target attributesAtIndex:index];
	XCTAssertNotNil(attr, @"attributes via proxy");
	XCTAssertEqual(YES, attr.takeAway, @"takeAway via proxy");
}

@end
