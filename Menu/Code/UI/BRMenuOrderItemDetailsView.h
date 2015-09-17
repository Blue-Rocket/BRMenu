//
//  BRMenuOrderItemDetailsView.h
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylish.h>

@class BRMenuOrderItem;

/**
 View that renders the details of a single @c BRMenuOrderItem.
 */
IB_DESIGNABLE
@interface BRMenuOrderItemDetailsView : UIView <BRUIStylish>

/** The order item to display. */
@property (nonatomic, strong) BRMenuOrderItem *orderItem;

/** Flag to show/hide take away status. */
@property (nonatomic, getter = isShowTakeAway) IBInspectable BOOL showTakeAway;

@end
