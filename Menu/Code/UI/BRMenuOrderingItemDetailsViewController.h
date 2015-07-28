//
//  BRMenuOrderingItemDetailsViewController.h
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@class BRMenuOrderItem;

@interface BRMenuOrderingItemDetailsViewController : UIViewController <BRMenuUIStylish>

@property (nonatomic, strong) BRMenuOrderItem *orderItem;

/** If @c YES then add an "Add to Order" button in the navigation item right side. */
@property (nonatomic, getter = isShowAddToOrder) BOOL showAddToOrder;

@end
