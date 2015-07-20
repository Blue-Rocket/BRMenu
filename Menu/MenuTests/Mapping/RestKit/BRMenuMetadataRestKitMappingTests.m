//
//  BRMenuMetadataRestKitMappingTests.m
//  Menu
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenuMetadata.h"
#import "BRMenuMappingPostProcessor.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"

@interface BRMenuMetadataRestKitMappingTests : XCTestCase

@end

@implementation BRMenuMetadataRestKitMappingTests

- (void)setUp {
	[super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRMenuRestKitTestingSupport setFixtureBundle:bundle];
}

- (void)testParseMetadata {
	BRMenuMetadata *m = [BRMenuMetadata new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuMappingRestKit menuMetadataMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"menumetadata.json"]
							  destinationObject:m]
	 performMapping];
	assertThatUnsignedInt(m.latestMenuVersion, equalTo(@1));
}

@end
