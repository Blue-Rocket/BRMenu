//
//  BRMenuOrderItem.h
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuItem;
@class BRMenuItemComponent;
@class BRMenuOrderItemAttributes;
@class BRMenuOrderItemComponent;

/** A default group key to use if no other key is defined for an order item. */
extern NSString * const BRMenuOrderItemDefaultGroupKey;

/**
 A line item in an order. Refers to a specific @ref BRMenuItem for the
 unit price. A collection of @ref BRMenuItemComponents can be supplied
 to detail specific components of the item.
 
 For example, a "pizza" item might contain the components
 [Traditional, Classic Tomato, Housemade Mozzarella] for the
 dough, sauce, and cheese selections.
 */
@interface BRMenuOrderItem : NSObject <NSCopying, NSSecureCoding>

@property (nonatomic) uint8_t quantity;
@property (nonatomic, getter = isTakeAway) BOOL takeAway; // YES == take away, NO == dine in; shortcut for first BRMenuOrderItemAttributes
@property (nonatomic, strong) BRMenuItem *item;
@property (nonatomic, readonly) NSArray<BRMenuOrderItemAttributes *> *attributes;
@property (nonatomic, readonly) NSArray<BRMenuOrderItemComponent *> *components;

/** The calculated price, based on the @ref BRMenuItem @c price and the receiver's @c quantity. */
@property (nonatomic, readonly) NSDecimalNumber *price;

- (id)initWithMenuItem:(BRMenuItem *)menuItem;
- (id)initWithOrderItem:(BRMenuOrderItem *)other; // a copy initializer

/**
 Add a component to the order item.
 
 If the component is already included in the receiver, this method does nothing.
 
 @param component The component to add.
 */
- (void)addComponent:(BRMenuOrderItemComponent *)component;

/**
 Remove a component from the order item.
 
 If the component is not already included in the receiver, this method does nothing.
 
 @param component The component to remove.
 */
- (void)removeComponent:(BRMenuOrderItemComponent *)component;

/**
 Get an existing @ref BRMenuOrderItemComponent for a given @ref BRMenuItemComponent.
 
 @param menuItemComponent The menu item component to search with.
 @return The order item component matching the menu item component, or @c nil if not found.
 */
- (BRMenuOrderItemComponent *)componentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent;

/**
 Get the existing @ref BRMenuOrderItemComponent for a given @ref BRMenuItemComponent, creating a new
 order item compoent if no match is found.
 
 @param menuItemComponent The menu item component to search with.
 @return The order item component (possibly newly created) matching the menu item component.
 */
- (BRMenuOrderItemComponent *)getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent;

/**
 Remove any existing @ref BRMenuOrderItemComponent matching a given @ref BRMenuItemComponent.
 
 @param menuItemComponent The menu item component to search with.
 */
- (void)removeComponentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent;

// manage the BRMenuOrderItemAttributes
- (void)setAttributes:(BRMenuOrderItemAttributes *)attributes atIndex:(uint8_t)index;
- (BRMenuOrderItemAttributes *)attributesAtIndex:(uint8_t)index;
- (BRMenuOrderItemAttributes *)getOrAddAttributesAtIndex:(uint8_t)index;
- (void)removeAttributesAtIndex:(uint8_t)index;

/**
 Get a grouping key for this item.
 
 @param groupMapping An optional mapping of keys to alternate key values.
 @return The grouping key for this item. If a key is not defined for the item then @ref BRMenuOrderItemDefaultGroupKey will be returned.
 */
- (NSString *)orderGroupKey:(NSDictionary *)groupMapping;

@end
