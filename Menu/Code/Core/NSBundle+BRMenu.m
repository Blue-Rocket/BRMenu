//
//  NSBundle+BRMenu.m
//  MenuKit
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "NSBundle+BRMenu.h"

#import "BRMenu.h"

static NSArray *registeredBundles;

@implementation NSBundle (BRMenu)

+ (void)load {
	@autoreleasepool {
		NSMutableArray *bundles = [[NSMutableArray alloc] initWithCapacity:2];
		NSString *bundlePath;

		// first add the main bundle as the default extension point
		NSBundle *mainBundle = [NSBundle mainBundle];
		if ( mainBundle ) {
			[bundles addObject:mainBundle];
		}
		
		// then add Menu.bundle... not provided by BRMenu, but provided as an extension point
		bundlePath = [[NSBundle mainBundle] pathForResource:@"Menu" ofType:@"bundle"];
		if ( bundlePath ) {
			[bundles addObject:[NSBundle bundleWithPath:bundlePath]];
		}

		// last add BRMenu.bundle... provided by BRMenu as the default fallback bundle
		bundlePath = [[NSBundle bundleForClass:[BRMenu class]] pathForResource:@"BRMenu" ofType:@"bundle"];
		if ( bundlePath ) {
			[bundles addObject:[NSBundle bundleWithPath:bundlePath]];
		}
		
		registeredBundles = [bundles copy];
	}
}

+ (void)registerBRMenuBundle:(NSBundle *)bundle {
	if ( bundle != nil ) {
		NSMutableArray *bundles = [registeredBundles mutableCopy];
		[bundles insertObject:bundle atIndex:1]; // just after the main bundle
		registeredBundles = [bundles copy];
	}
}

#pragma mark - Public API

+ (NSString *)localizedBRMenuString:(NSString *)key {
	__block NSString *result = nil;
	[registeredBundles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSBundle *bundle = obj;
		result = [bundle localizedStringForKey:key value:nil table:nil];
		if ( ![result isEqualToString:key] ) {
			*stop = YES;
		}
	}];
	return result;
}

+ (NSURL *)URLForBRMenuResourceNamed:(NSString *)resourceName {
	__block NSURL *url = nil;
	[registeredBundles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSBundle *bundle = obj;
		url = [bundle URLForResource:resourceName withExtension:nil];
		if ( url ) {
			*stop = YES;
		}
	}];
	return url;
}

+ (NSBundle *)bundleContainingBRMenuResourceNamed:(NSString *)resourceName {
	__block NSBundle *bundle = nil;
	[registeredBundles enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
		NSBundle *b = obj;
		NSURL *url = [b URLForResource:resourceName withExtension:nil];
		if ( url ) {
			bundle = b;
			*stop = YES;
		}
	}];
	return bundle;
}

@end
