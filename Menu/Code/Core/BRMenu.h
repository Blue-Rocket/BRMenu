//
//  BRMenu.h
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

#import "BRMenuGroupObject.h"

NS_ASSUME_NONNULL_BEGIN

@class BRMenuItem;
@class BRMenuItemComponent;
@class BRMenuItemComponentGroup;
@class BRMenuItemGroup;
@class BRMenuItemTag;

/**
 A menu object, which is structured as a hierarchy of menu items and groups of menu items with this
 object serving as the root of the hierarchy.
 */
@interface BRMenu : NSObject <BRMenuGroupObject, NSSecureCoding>

/** A unique value to distinguish from other @c BRMenu instances from other sources. */
@property (nonatomic, copy) NSString *key;

/** A display-friendly title for this menu. */
@property (nonatomic, copy) NSString *title;

/** A version counter to distinguish from different versions of @c BRMenu from the same source. */
@property (nonatomic) uint16_t version;

/** A root-level list of menu items. */
@property (nonatomic, copy) NSArray<BRMenuItem *> *items;

/** A root-level list of menu item groups. */
@property (nonatomic, copy) NSArray<BRMenuItemGroup *> *groups;

/** A menu-wide list of all available tags, which can be referenced by any number of menu items. */
@property (nonatomic, copy) NSArray<BRMenuItemTag *> *tags;

// get the BRMenuItem for the given menu ID, or nil if not found
- (nullable BRMenuItem *)menuItemForId:(uint8_t)menuId;

// get the BRMenuItem for the given key, or nil if not found
- (nullable BRMenuItem *)menuItemForKey:(NSString *)key;

// get the BRMenuItemComponent for the given component ID, or nil if not found
- (nullable BRMenuItemComponent *)menuItemComponentForId:(uint8_t)componentId;

// get the BRMenuItemComponentGroup for the given key, or nil if not found
- (nullable BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key;

/**
 Get an ordering index for a given group key. Note this may not correlate directly to an index
 from the @c groups array. It should only be used for sorting operations.
 
 @param key The group key to get an ordering index for.
 @return An ordering index.
 */
- (NSInteger)groupOrderingIndexForKey:(NSString *)key;

// get a BRMenuItemGroup for the given key, or nil if not found
- (nullable BRMenuItemGroup *)menuItemGroupForKey:(NSString *)key;

// get an array of all unique BRMenuItemComponent objects from the menu
- (NSArray *)allComponents;

// iterate over all BRMenuItem objects, in the receiver objects or any nested groups
- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block;

// iterate over all BRMenuItemGroup objects, in the receiver or any nested groups
- (void)enumerateMenuItemGroupsUsingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block;

/**
 Iterate over all @c BRMenuItemComponentGroup objects in the complete menu hierarchy, in all @c BRMenuItem objects or any nested groups.
 
 Any @c BRMenuItemComponentGroup object that has a non-nil @c extendsKey value are NOT included, that is to say 
 groups that extend other groups are filtered from the iteration.
 
 @param block A callback block to handle the iteration. Set @c stop to @c YES to stop iterating.
 */
- (void)enumerateMenuItemComponentGroupsUsingBlock:(void (^)(BRMenuItemComponentGroup *menuItemComponentGroup, NSUInteger idx, BOOL *stop))block;

@end

NS_ASSUME_NONNULL_END
