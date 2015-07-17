//
//  BRMenuOrderItemAttributesProxy.h
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMenuOrderItem;

@interface BRMenuOrderItemAttributesProxy : NSProxy

@property (nonatomic, readonly) BRMenuOrderItem *target;
@property (nonatomic) UInt8 index;

- (id)initWithOrderItem:(BRMenuOrderItem *)target attributeIndex:(UInt8)index;

@end
