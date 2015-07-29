//
//  BRMenuOrderingDelegate.h
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMenuOrderItem;

@protocol BRMenuOrderingDelegate <NSObject>

@required

- (void)addOrderItemToActiveOrder:(BRMenuOrderItem *)orderItem;

@end
