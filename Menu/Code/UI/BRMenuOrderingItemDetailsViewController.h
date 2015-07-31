//
//  BRMenuOrderingItemDetailsViewController.h
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@class BRMenuOrderItem;
@protocol BRMenuOrderingDelegate;

@interface BRMenuOrderingItemDetailsViewController : UIViewController <BRMenuUIStylish>

@property (nonatomic, strong) BRMenuOrderItem *orderItem;
@property (nonatomic, weak) id<BRMenuOrderingDelegate> orderingDelegate;

/** If @c YES then add an "Add to Order" button in the navigation item right side. */
@property (nonatomic, getter = isShowAddToOrder) BOOL showAddToOrder;

@end
