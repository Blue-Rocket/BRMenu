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

NS_ASSUME_NONNULL_BEGIN

/**
 An order object, which is a collection of order items with some additional overall properties.
 */
@interface BRMenuOrder : NSObject <NSCopying, NSSecureCoding>

/** A menu reference. This can be set to any menu needed by the application. */
@property (nonatomic, strong, nullable) BRMenu *menu;

@property (nonatomic) NSUInteger orderNumber;
@property (nonatomic, copy, nullable) NSString *name;
@property (nonatomic, readonly) NSArray<BRMenuOrderItem *> *orderItems;

/**
 A set of all menus used within the order. The property will reflect all the menus used by any item added
 to the receiver, for example via @ref addOrderItem: or @ref replaceOrderItems:.
 */
@property (nonatomic, strong, readonly, nullable) NSOrderedSet<BRMenu *> *menus;

/** The sum total of all items in the order, accounting for quantities. */
@property (nonatomic, readonly) NSDecimalNumber *totalPrice;

/**
 Add a single @c BRMenuOrderItem to the to the receiver.
 
 @param item The item to add.
 
 @return The resulting order item, which might be different from the @c item passed in.
 */
- (BRMenuOrderItem *)addOrderItem:(BRMenuOrderItem *)item;

/**
 Get the count of items, accounting for multiples of items (e.g. 2x of 1 item results in a count of 2).
 
 @return The quantity of items in the receiver.
 */
- (NSUInteger)orderItemCount;

/**
 Get an order item for a given menu item, or @c nil if not available.
 
 @param menuItem The menu item to get the corresponding order item for.
 
 @return The found menu order item, or @c nil if not found.
 */
- (nullable BRMenuOrderItem *)orderItemForMenuItem:(BRMenuItem *)menuItem;

/**
 Get an existing order item for a given menu item, creating a new order item and adding it to the order if no match found.
 
 @param menuItem The menu item to get or add an order item for.
 
 @return The order item associated with the provided menu item.
 */
- (BRMenuOrderItem *)getOrAddItemForMenuItem:(BRMenuItem *)menuItem;

/**
 Remove an order item for a given menu item.
 
 @param menuItem The menu item to remove the associated order item for.
 */
- (void)removeItemForMenuItem:(BRMenuItem *)menuItem;

/**
 Remove an order item.
 
 @param orderItem The order item to remove.
 */
- (void)removeOrderItem:(BRMenuOrderItem *)orderItem;

/**
 Remove any existing order items and then add the provided order items to the receiver. The 
 @c newOrderItems array can be @c nil or empty to simply remove all order items from the receiver.
 
 @param newOrderItems The new order items to apply to the receiver.
 */
- (void)replaceOrderItems:(nullable NSArray<BRMenuOrderItem *> *)newOrderItems;

/**
 Get an array of arrays of @ref BRMenuOrderItem objects, grouped by the @ref BRMenu instances referenced
 by the order items added to the receiver. For order items that support take away then @ref BRMenuOrderItemAttributesProxy
 objects are returned when the item quantity is greater than 1.

 @param groupMapping An optional mapping of order item keys to alternate key values.
 @return An array of arrays of order item objects.
 */
- (NSArray<NSArray<BRMenuOrderItem *> *> *)orderedGroups:(nullable NSDictionary<NSString *, NSString *> *)groupMapping;

@end

NS_ASSUME_NONNULL_END
