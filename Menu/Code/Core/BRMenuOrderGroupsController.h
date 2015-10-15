//
//  BRMenuOrderGroupsController.h
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderGroupingConrtroller.h"

@class BRMenuOrder;
@class BRMenuOrderItem;

NS_ASSUME_NONNULL_BEGIN

/**
 Controller logic for assisting in the display of an order within a table or collection view.
 */
@interface BRMenuOrderGroupsController : NSObject <BRMenuOrderGroupingConrtroller>

/**
 A mapping of string group keys to effective key string values. This can be used to combine 
 multiple, related groups into a single section.
 */
@property (nonatomic, strong) NSDictionary *groupKeyMapping;

/**
 Initialize with an order.
 
 @param order The order to use.
 @return The initialized controller instance.
 */
- (id)initWithOrder:(BRMenuOrder *)order;

/**
 Initialize with an order and mapping.
 
 @param order The order to use.
 @param groupKeyMapping The group key mapping to use.
 @return The initialized controller instance.
 */
- (id)initWithOrder:(BRMenuOrder *)order groupKeyMapping:(nullable NSDictionary<NSString *, NSString *> *)groupKeyMapping NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
