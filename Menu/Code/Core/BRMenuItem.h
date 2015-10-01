//
//  BRMenuItem.h
//  MenuKit
//
//  Something on the menu that has an associated price and can be added to an order.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

#import "BRMenuItemObject.h"

@class BRMenu;
@class BRMenuItemGroup;
@class BRMenuItemComponent;
@class BRMenuItemComponentGroup;

@interface BRMenuItem : NSObject <BRMenuItemObject, NSSecureCoding>

@property (nonatomic) uint8_t itemId;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic) int tags; // bit flags indicating which tags to associate
@property (nonatomic, getter = isAskTakeaway) BOOL askTakeaway; // defaults to NO
@property (nonatomic, getter = isAskQuantity) BOOL askQuantity; // defaults to NO
@property (nonatomic, getter = isNeedsReview) BOOL needsReview; // defaults to NO

@property (nonatomic, copy) NSString *key; // unique key assigned by data
@property (nonatomic, copy) NSString *extendsKey; // key of some other BRMenuItem this item extends

@property (nonatomic, copy) NSArray *componentGroups; // BRMenuItemComponentGroup

@property (nonatomic, weak) BRMenuItemGroup *group;
@property (nonatomic, weak) BRMenu *menu;

- (BRMenuItemComponent *)menuItemComponentForId:(const uint8_t)componentId;
- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key;

// get the root BRMenuItemGroup for this item, i.e. the farthest ancestor, or nil if none available
- (BRMenuItemGroup *)rootMenuItemGroup;

// all unique BRMenuItemComponent objects within this item
- (NSArray *)allComponents;

// array of BRMenuItemTag objects derived from tags property
- (NSArray *)menuItemTags;

// iterate over all BRMenuItemComponentGroup objects, in the receiver or any nested groups
- (void)enumerateMenuItemComponentGroupsUsingBlock:(void (^)(BRMenuItemComponentGroup *menuItemComponentGroup, NSUInteger idx, BOOL *stop))block;

@end
