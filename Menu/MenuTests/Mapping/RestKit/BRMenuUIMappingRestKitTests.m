//
//  BRMenuUIMappingRestKitTests.m
//  Menu
//
//  Created by Matt on 3/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <RestKit/RestKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenuUIMappingRestKit.h"
#import "BRMenuRestKitTestingMapper.h"
#import "BRMenuRestKitTestingSupport.h"
#import "BRMenuUIStyle.h"

@interface BRMenuUIMappingRestKitTests : XCTestCase

@end

@implementation BRMenuUIMappingRestKitTests

- (void)setUp {
	[super setUp];
	NSBundle *bundle = [NSBundle bundleForClass:[self class]];
	[BRMenuRestKitTestingSupport setFixtureBundle:bundle];
}

- (void)testParseUIStyle {
	BRMenuMutableUIStyle *style = [BRMenuMutableUIStyle new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuUIMappingRestKit uiStyleMapping]
								   sourceObject:[BRMenuRestKitTestingSupport parsedObjectWithContentsOfFixture:@"uistyle.json"]
							  destinationObject:style]
	 performMapping];
	assertThat(style.appPrimaryColor, equalTo([BRMenuUIStyle colorWithRGBAHexInteger:0xfd1122FF]));
	assertThat(style.uiFont, equalTo([UIFont fontWithName:@"HelveticaNeue-UltraLight" size:17]));
}


- (void)testEncodeUIStyle {
	BRMenuUIStyle *style = [BRMenuUIStyle defaultStyle];
	NSMutableDictionary *dict = [NSMutableDictionary new];
	[[BRMenuRestKitTestingMapper testForMapping:[BRMenuUIMappingRestKit uiStyleMapping]
								   sourceObject:style
							  destinationObject:dict]
	 performMapping];
	assertThat(dict[@"appPrimaryColor"], equalTo(@0x1247b8ff));
	assertThat(dict[@"textShadowColor"], equalTo(@0xCACACA7F));
	assertThat(dict[@"uiFont"], equalTo(@{@"name" :@"AvenirNext-Medium", @"size":@13}));
}

@end
