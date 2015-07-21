//
//  BRMenuOrder.h
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenu;
@class BRMenuItem;
@class BRMenuOrderItem;

extern NSString * const kSpecialGroupKey;

@interface BRMenuOrder : NSObject <NSCopying>

@property (nonatomic, strong) BRMenu *menu;
@property (nonatomic) NSUInteger orderNumber;
@property (nonatomic, copy) NSString *name;
@property (nonatomic, readonly) NSArray *orderItems;

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

// the sum total of all items in the order, accounting for quantities
- (NSDecimalNumber *)totalPrice;

// return an array of arrays of BRMenuOrderItem objects, grouped by the BRMenu set on this instance,
// with BRMenuOrderItemAttributesProxy instances added for take away items where the item quantity > 1
- (NSArray *)orderedGroupsWithSpecialGroupKey:(NSSet *)specialGroupKeys;

@end