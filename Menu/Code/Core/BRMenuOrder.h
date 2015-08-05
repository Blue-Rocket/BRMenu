//
//  BRMenuOrder.h
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenu;
@class BRMenuItem;
@class BRMenuOrderItem;

/**
 An order object, which is a collection of order items with some additional overall properties.
 */
@interface BRMenuOrder : NSObject <NSCopying>

/** A menu reference. This can be set to any menu needed by the application. */
@property (nonatomic, strong) BRMenu *menu;

@property (nonatomic) NSUInteger orderNumber;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSArray *orderItems;

/**
 A set of all menus used within the order. The property will reflect all the menus used by any item added
 to the receiver, for example via @ref addOrderItem: or @ref replaceOrderItems:.
 */
@property (nonatomic, strong, readonly) NSOrderedSet *menus;

/** The sum total of all items in the order, accounting for quantities. */
@property (nonatomic, readonly) NSDecimalNumber *totalPrice;

// add a single BRMenuOrderItem to the order
- (void)addOrderItem:(BRMenuOrderItem *)item;

// count of items, accounting for multiples of items (e.g. 2x of 1 item results in a count of 2)
- (NSUInteger)orderItemCount;

// get an BRMenuOrderItem for a given BRMenuItem, or nil if not available
- (BRMenuOrderItem *)orderItemForMenuItem:(BRMenuItem *)menuItem;

// get the existing BRMenuOrderItem for a given BRMenuItem, or create it and add
- (BRMenuOrderItem *)getOrAddItemForMenuItem:(BRMenuItem *)menuItem;

// remove any existing BRMenuOrderItem matching a given BRMenuItem
- (void)removeItemForMenuItem:(BRMenuItem *)menuItem;

// remove any existing BRMenuOrderItems and then add any provided BRMenuOrderItems; newOrderItems can be
// nil or empty to simply remove all BRMenuOrderItems from the BRMenuOrder
- (void)replaceOrderItems:(NSArray *)newOrderItems;

/**
 Get an array of arrays of @ref BRMenuOrderItem objects, grouped by the @ref BRMenu instances referenced
 by the order items added to the receiver. For order items that support take away then @ref BRMenuOrderItemAttributesProxy
 objects are returned when the item quantity is greater than 1.

 @param groupMapping An optional mapping of order item keys to alternate key values.
 @return An array of arrays of order item objects.
 */
- (NSArray *)orderedGroups:(NSDictionary *)groupMapping;

@end
