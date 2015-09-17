//
//  BRMenuTagTests.m
//  Menu
//
//  Created by Matt on 16/09/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <XCTest/XCTest.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenuItemTag.h"

@interface BRMenuItemTagTests : XCTestCase

@end

@implementation BRMenuItemTagTests

- (void)testArchive {
	BRMenuItemTag *tag = [BRMenuItemTag new];
	tag.key = @"1";
	tag.title = @"2";
	tag.desc = @"3";
	
	BRMenuItemTag *unarchived = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:tag]];
	assertThat(unarchived, notNilValue());
	assertThat(unarchived, isNot(sameInstance(tag)));
	assertThat(unarchived.key, equalTo(tag.key));
	assertThat(unarchived.title, equalTo(tag.title));
	assertThat(unarchived.desc, equalTo(tag.desc));
}

@end
