//
//  BRMenuOrderItemAttributesProxy.h
//  MenuKit
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuOrderItem;

@interface BRMenuOrderItemAttributesProxy : NSProxy

@property (nonatomic, readonly) BRMenuOrderItem *target;
@property (nonatomic) UInt8 index;

- (id)initWithOrderItem:(BRMenuOrderItem *)target attributeIndex:(UInt8)index;

@end
