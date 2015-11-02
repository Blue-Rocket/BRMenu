//
//  BRMenuOrderingItemDetailsViewController.h
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylish.h>

@class BRMenuOrderItem;
@protocol BRMenuOrderingDelegate;

/**
 Show the selected components of an order item, in either a "review before adding to order" mode 
 or a "inspect item details in order" mode. The "review" mode is configured by setting @c showAddToOrder
 to @c YES, and the @c orderingDelegate should be configured to handle adding the order item to
 the order.
 
 If @c showAddToOrder is @c NO, then no @c orderingDelegate is needed, and no "add to order" button is shown.
 */
@interface BRMenuOrderingItemDetailsViewController : UIViewController <BRUIStylish>

@property (nonatomic, strong) BRMenuOrderItem *orderItem;
@property (nonatomic, weak) id<BRMenuOrderingDelegate> orderingDelegate;

/** If @c YES then add an "Add to Order" button in the navigation item right side. */
@property (nonatomic, getter = isShowAddToOrder) IBInspectable BOOL showAddToOrder;

/** If @c YES then add a @c BRMenuStepper control to allow adjusting the quantity of the order item. */
@property (nonatomic, getter = isShowQuantityStepper) IBInspectable BOOL showQuantityStepper;

/**
 Action sent to go backwards in the navigation flow.
 
 @param sender The action sender.
 */
- (IBAction)goBack:(id)sender;

@end
