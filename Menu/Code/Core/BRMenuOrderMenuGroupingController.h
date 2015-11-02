//
//  BRMenuOrderMenuGroupingController.h
//  Menu
//
//  Created by Matt on 15/10/15.
//  Copyright © 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderGroupingConrtroller.h"

@class BRMenuOrder;

NS_ASSUME_NONNULL_BEGIN

@interface BRMenuOrderMenuGroupingController : NSObject <BRMenuOrderGroupingConrtroller>

/**
 Initialize with an order.
 
 @param order The order to use.
 @return The initialized controller instance.
 */
- (id)initWithOrder:(BRMenuOrder *)order NS_DESIGNATED_INITIALIZER;

@end

NS_ASSUME_NONNULL_END
