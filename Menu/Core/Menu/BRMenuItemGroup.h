//
//  BRMenuItemGroup.h
//  BRMenu
//
//  A grouping of BRMenuItem objects, e.g. Suggestions.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BRMenuItemObject.h"

@class BRMenuItem;
@class BRMenuItemComponent;
@class BRMenuItemComponentGroup;

@interface BRMenuItemGroup : NSObject <BRMenuItemObject>

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *key; // unique key assigned by data
@property (nonatomic, copy) NSArray *items; // BRMenuItem
@property (nonatomic, copy) NSArray *itemGroups; // BRMenuItemGroup

@property (nonatomic, weak) BRMenuItemGroup *parentGroup;

// group-level attributes; all BRMenuItems within group default to these values if specified

@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, getter = isShowItemDelimiters) BOOL showItemDelimiters;

- (BRMenuItem *)menuItemForId:(const UInt8)itemId;
- (BRMenuItem *)menuItemForKey:(NSString *)key;
- (BRMenuItemGroup *)menuItemGroupForKey:(NSString *)key;
- (BRMenuItemComponent *)menuItemComponentForId:(const UInt8)componentId;
- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key;

// all unique BRMenuItemComponent objects within this group
- (NSArray *)allComponents;

// iterate over all BRMenuItem objects, in the receiver or any nested groups
- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block;

@end
