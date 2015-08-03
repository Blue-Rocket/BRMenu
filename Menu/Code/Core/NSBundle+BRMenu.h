//
//  NSBundle+BRMenu.h
//  MenuKit
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@interface NSBundle (BRMenu)

/**
 Register an additional bundle to search for resources in.
 
 @param bundle The bundle to register.
 */
+ (void)registerBRMenuBundle:(NSBundle *)bundle;

/**
 Get a localized string for a given key, searching through all registered bundles.
 
 @return The localized string, or @c key if not found.
 */
+ (NSString *)localizedBRMenuString:(NSString *)key;

/**
 Get a bundle resource for a given name, searching through all registered bundles.
 
 @return The URL for the resource, or @c nil if not found.
 */
+ (NSURL *)URLForBRMenuResourceNamed:(NSString *)resourceName;

@end
