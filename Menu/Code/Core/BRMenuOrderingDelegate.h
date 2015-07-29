//
//  BRMenuOrderingDelegate.h
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuOrderItem;

@protocol BRMenuOrderingDelegate <NSObject>

@required

- (void)addOrderItemToActiveOrder:(BRMenuOrderItem *)orderItem;

@end
