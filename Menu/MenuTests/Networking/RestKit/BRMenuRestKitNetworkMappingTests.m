//
//  BRMenuItemGroupRestKitMappingTests.m
//  MenuKit
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuNetworkingTestingSupport.h"

#import <AFNetworking/AFNetworking.h>
#import <RestKit/RestKit.h>

#define HC_SHORTHAND
#import <OCHamcrest/OCHamcrest.h>

#import "BRMenu.h"
#import "BRMenuAFHTTPResponseSerializer.h"
#import "BRMenuMappingRestKit.h"
#import "BRMenuRestKitDataMapper.h"

@interface BRMenuRestKitNetworkMappingTests : BRMenuNetworkingTestingSupport

@end

@implementation BRMenuRestKitNetworkMappingTests

- (void)testMenuGET {
	[self.http handleMethod:@"GET" withPath:@"/menus/1.json" block:^(RouteRequest *request, RouteResponse *response) {
		[self respondWithJSONResource:@"menu-shakeshack" response:response status:200];
	}];
	
	NSURL *url = [NSURL URLWithString:@"/menus/1.json" relativeToURL:self.httpURL];
	NSURLRequest *req = [NSURLRequest requestWithURL:url];
	AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
	BRMenuAFHTTPResponseSerializer *ser = [BRMenuAFHTTPResponseSerializer new];
	ser.rootKeyPath = @"menu";
	ser.dataMapper = [[BRMenuRestKitDataMapper alloc] initWithObjectMapping:[BRMenuMappingRestKit menuMapping]];
	op.responseSerializer = ser;
	__block BOOL complete = NO;
	[op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
		assertThat(responseObject, instanceOf([BRMenu class]));
		BRMenu *menu = responseObject;
		assertThatUnsignedInt(menu.version, equalTo(@1));
		complete = YES;
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		XCTFail(@"HTTP operation failed: %@", error);
		complete = YES;
	}];
	[[NSOperationQueue mainQueue] addOperation:op];
	assertThatBool([self processMainRunLoopAtMost:10 stop:&complete], equalTo(@YES));
}

@end
