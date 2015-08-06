//
//  BRMenuOrderingDelegate.h
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuOrderItem;

/**
 A delegate to the ordering process, tasked with managing an active order.
 */
@protocol BRMenuOrderingDelegate <NSObject>

@required

/**
 Add a single item to the active order.
 
 @param orderItem The item to add to the active order.
 */
- (void)addOrderItemToActiveOrder:(BRMenuOrderItem *)orderItem;

/**
 Given an array of @c BRMenuOrderItem objects, update the active order
 by adding or replacing items as necessary.
 
 @param orderItems The array of order items to update the active order with.
 */
- (void)updateOrderItemsInActiveOrder:(NSArray *)orderItems;

@end
