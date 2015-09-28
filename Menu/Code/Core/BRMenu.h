//
//  BRMenu.h
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

#import "BRMenuGroupObject.h"

@class BRMenuItem;
@class BRMenuItemComponent;
@class BRMenuItemComponentGroup;
@class BRMenuItemGroup;

@interface BRMenu : NSObject <BRMenuGroupObject, NSSecureCoding>

@property (nonatomic, copy) NSString *key; // unique value between other BRMenu instances, assigned by data
@property (nonatomic) uint16_t version;
@property (nonatomic, copy) NSArray *items; // BRMenuItem
@property (nonatomic, copy) NSArray *groups; // BRMenuItemGroup
@property (nonatomic, copy) NSArray *tags; // BRMenuItemTag

// get the BRMenuItem for the given menu ID, or nil if not found
- (BRMenuItem *)menuItemForId:(uint8_t)menuId;

// get the BRMenuItem for the given key, or nil if not found
- (BRMenuItem *)menuItemForKey:(NSString *)key;

// get the BRMenuItemComponent for the given component ID, or nil if not found
- (BRMenuItemComponent *)menuItemComponentForId:(uint8_t)componentId;

// get the BRMenuItemComponentGroup for the given key, or nil if not found
- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key;

/**
 Get an ordering index for a given group key. Note this may not correlate directly to an index
 from the @c groups array. It should only be used for sorting operations.
 
 @param key The group key to get an ordering index for.
 @return An ordering index.
 */
- (NSInteger)groupOrderingIndexForKey:(NSString *)key;

// get a BRMenuItemGroup for the given key, or nil if not found
- (BRMenuItemGroup *)menuItemGroupForKey:(NSString *)key;

// get an array of all unique BRMenuItemComponent objects from the menu
- (NSArray *)allComponents;

// iterate over all BRMenuItem objects, in the receiver objects or any nested groups
- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block;

// iterate over all BRMenuItemGroup objects, in the receiver or any nested groups
- (void)enumerateMenuItemGroupsUsingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block;

// iterate over all BRMenuItemComponentGroup objects, in all BRMenuItem objects or any nested groups;
// BRMenuItemComponentGroup objects that have non-nil extendsKey values are NOT included, i.e.
// groups that extend other groups are filtered from the iteration
- (void)enumerateMenuItemComponentGroupsUsingBlock:(void (^)(BRMenuItemComponentGroup *menuItemComponentGroup, NSUInteger idx, BOOL *stop))block;

@end
