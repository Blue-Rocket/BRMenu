//
//  BRMenuOrderingViewController.h
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuOrderingDelegate.h"
#import "BRMenuUIStyle.h"

@class BRMenu;
@class BRMenuOrder;

extern NSString * const BRMenuOrderingItemObjectCellIdentifier;

extern NSString * const BRMenuOrderingConfigureComponentsSegue;

/**
 Display a single menu and allow adding items from the menu to an order.
 */
@interface BRMenuOrderingViewController : UITableViewController <BRMenuOrderingDelegate, BRMenuUIStylish>

@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

/** The menu to order items from. */
@property (nonatomic, strong) BRMenu *menu;

/** The active order. If not specified, a new order will be created as needed. */
@property (nonatomic, strong) BRMenuOrder *order;

@end
