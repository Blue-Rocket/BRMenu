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
@class BRMenuOrderCountButton;
@class BRMenuOrder;

NS_ASSUME_NONNULL_BEGIN

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

/** Flag if prototype cells are being used, otherwise cells will be created progamatically. */
@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

/**
 If @c YES, then allow removing items from the active order via any menu items that do not contain any components.
 If @c NO, then only allow adding items to the order.
 */
@property (nonatomic, assign, getter=isAllowRemoveFromOrder) IBInspectable BOOL allowRemoveFromOrder;

/**
 If @c YES then if any menu item has components, a temporary order is created and changes are made to that until an explicit
 @b Add action is performed; the @b Back button can be used to cancel any pending changes to the active order.
 If @c NO, then all changes are applied to the active order, which also implies @c allowRemoveFromOrder is @c YES.
 */
@property (nonatomic, assign, getter=isEnableUndoSupport) IBInspectable BOOL enableUndoSupport;

/**
 If configured and @c enableUndoSupport is @c YES new count buttons will be created on view controllers pushed by this controller.
 The targets of this button will be copied onto the newly created buttons.
 */
@property (nonatomic, strong, nullable) IBOutlet BRMenuOrderCountButton *orderCountButton;

/** The menu to order items from. */
@property (nonatomic, strong) BRMenu *menu;

/** The active order. If not specified, a new order will be created as needed. */
@property (nonatomic, strong) BRMenuOrder *order;

/**
 Action sent to go backwards in the navigation flow.
 
 @param sender The action sender.
 */
- (IBAction)goBack:(id)sender;

@end

NS_ASSUME_NONNULL_END
