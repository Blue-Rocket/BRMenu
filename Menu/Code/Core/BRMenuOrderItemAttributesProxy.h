//
//  BRMenuOrderItemAttributesProxy.h
//  MenuKit
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuOrderItem;

/**
 A proxy for @ref BRMenuOrderItem instances, to support multiple quantities of an order item where the attributes vary between each physical item.
 
 For example if a menu item supports the @c takeAway attribute and a customer wants two of that item, one for take away and one not, a proxy instance can be created for managing the @c takeAway flag for both distinctly.
 
 Internally a single @ref BRMenuOrderItem instance is used, and this proxy class manages a specific attribute index of that order item.

 @see BRMenuOrderItem -setAttributes:atIndex:
 */
@interface BRMenuOrderItemAttributesProxy : NSProxy

/** The order item to proxy. Any number of proxies can be created for the same order item instance. */
@property (nonatomic, readonly) BRMenuOrderItem *target;

/** The attribute index to manage in this proxy. */
@property (nonatomic) UInt8 index;

/**
 Initialize a new proxy instance.
 
 @param target The order item to proxy.
 @param index The attribute index to manage.
 @return The initialized instance.
 */
- (id)initWithOrderItem:(BRMenuOrderItem *)target attributeIndex:(UInt8)index;

@end
