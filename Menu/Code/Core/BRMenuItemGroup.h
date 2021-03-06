//
//  BRMenuItemGroup.h
//  MenuKit
//
//  A grouping of BRMenuItem objects, e.g. Suggestions.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

#import "BRMenuGroupObject.h"
#import "BRMenuItemObject.h"

@class BRMenuItem;
@class BRMenuItemComponent;
@class BRMenuItemComponentGroup;

@interface BRMenuItemGroup : NSObject <BRMenuGroupObject, BRMenuItemObject, NSSecureCoding>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *key; // unique key assigned by data
@property (nonatomic, copy) NSArray *items; // BRMenuItem
@property (nonatomic, copy) NSArray *groups; // BRMenuItemGroup

@property (nonatomic, weak) BRMenuItemGroup *parentGroup;

// group-level attributes; all BRMenuItems within group default to these values if specified

@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, getter = isShowItemDelimiters) BOOL showItemDelimiters;

- (BRMenuItem *)menuItemForId:(const uint8_t)itemId;
- (BRMenuItem *)menuItemForKey:(NSString *)key;
- (BRMenuItemGroup *)menuItemGroupForKey:(NSString *)key;
- (BRMenuItemComponent *)menuItemComponentForId:(const uint8_t)componentId;
- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key;

// all unique BRMenuItemComponent objects within this group
- (NSArray *)allComponents;

// iterate over all BRMenuItem objects, in the receiver or any nested groups
- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block;

@end
