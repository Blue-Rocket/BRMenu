//
//  BRMenuGroupObject.h
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuItem;
@class BRMenuItemGroup;

/**
 Protocol for objects that are containers for menu items and other groups.
 */
@protocol BRMenuGroupObject <NSObject>

/** The menu items in this group. */
@property (nonatomic, copy, readonly) NSArray *items; // BRMenuItemObject

/** The nested groups in this group. */
@property (nonatomic, copy, readonly) NSArray *groups; // BRMenuGroupObject

/**
 Iterate over all BRMenuItem objects, in the receiver or any nested groups.
 
 @param block The callback block.
 */
- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block;

/**
 Iterate over all BRMenuItemGroup objects, in the receiver or any nested groups.
 
 @param block The callback block.
 */
- (void)enumerateMenuItemGroupsUsingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block;

@end
