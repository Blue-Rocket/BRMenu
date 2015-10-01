//
//  BRMenuOrderingGroupViewController.h
//  MenuKit
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuOrderingDelegate.h"
#import <BRStyle/BRUIStylish.h>

@class BRMenuOrderingFlowController;
@class BRMenuStepper;

extern NSString * const BRMenuOrderingItemCellIdentifier;
extern NSString * const BRMenuOrderingItemWithoutComponentsCellIdentifier;
extern NSString * const BRMenuOrderingItemGroupHeaderCellIdentifier;

/**
 Present a list of menu item groups as sections of menu items.
 */
@interface BRMenuOrderingGroupViewController : UITableViewController <BRMenuOrderingDelegate, BRUIStylish>

@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

@property (nonatomic, strong) BRMenuOrderingFlowController *flowController;
@property (nonatomic, weak) id<BRMenuOrderingDelegate> orderingDelegate;

/**
 Action sent to go backwards in the navigation flow.
 
 @param sender The action sender.
 */
- (IBAction)goBack:(id)sender;

/**
 Action when changes are requested to be saved into the active order.
 
 @param sender The action sender.
 */
- (IBAction)saveToOrder:(id)sender;

/**
 Action sent when the quantity should be adjusted via a stepper.
 
 @param sender The stepper.
 */
- (IBAction)didAdjustQuantity:(BRMenuStepper *)sender;

@end
