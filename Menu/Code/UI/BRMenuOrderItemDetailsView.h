//
//  BRMenuOrderItemDetailsView.h
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@class BRMenuOrderItem;

/**
 View that renders the details of a single @c BRMenuOrderItem.
 */
IB_DESIGNABLE
@interface BRMenuOrderItemDetailsView : UIView <BRMenuUIStylish>

/** The order item to display. */
@property (nonatomic, strong) BRMenuOrderItem *orderItem;

/** Flag to show/hide take away status. */
@property (nonatomic, getter = isShowTakeAway) IBInspectable BOOL showTakeAway;

@end
