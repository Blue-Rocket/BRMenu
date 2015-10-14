//
//  BRMenuOrderingViewController.h
//  MenuKit
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuOrderingDelegate.h"
#import <BRStyle/BRUIStylish.h>

@class BRMenu;
@class BRMenuOrder;

/** Cell identifier for top-level menu objects (items and groups). */
extern NSString * const BRMenuOrderingItemObjectCellIdentifier;

/** Segue identifier used to configure the components of a single menu item. */
extern NSString * const BRMenuOrderingConfigureComponentsSegue;

/** Segue identifier used to show all menu items within a group. */
extern NSString * const BRMenuOrderingShowItemGroupSegue;

/**
 Display a single menu and allow adding items from the menu to an order.
 */
@interface BRMenuOrderingViewController : UITableViewController <BRMenuOrderingDelegate, BRUIStylish>

@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

/** 
 If @c YES, then allow removing items from the active order via any menu items that do not contain any components.
 If @c NO, then only allow adding items to the active order.
 */
@property (nonatomic, assign, getter=isAllowRemoveFromOrder) IBInspectable BOOL allowRemoveFromOrder;

/** The menu to order items from. */
@property (nonatomic, strong) BRMenu *menu;

/** The active order. If not specified, a new order will be created as needed. */
@property (nonatomic, strong) BRMenuOrder *order;

@end
