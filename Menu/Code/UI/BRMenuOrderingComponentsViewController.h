//
//  BRMenuOrderingComponentsViewController.h
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylish.h>

@class BRMenuOrderingFlowController;
@protocol BRMenuOrderingDelegate;

extern NSString * const BRMenuOrderingItemComponentCellIdentifier;
extern NSString * const BRMenuOrderingGroupHeaderCellIdentifier;

extern NSString * const BRMenuOrderingReviewOrderItemSegue;

/**
 Present a list of order item component groups for a single order item, pushing
 new instances of this class for each step required based on the menu item component groupings.
 */
@interface BRMenuOrderingComponentsViewController : UITableViewController <BRUIStylish>

@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

@property (nonatomic, strong) BRMenuOrderingFlowController *flowController;
@property (nonatomic, weak) id<BRMenuOrderingDelegate> orderingDelegate;

/**
 Action sent to go backwards in the navigation flow.
 
 @param sender The action sender.
 */
- (IBAction)goBack:(id)sender;

/**
 Action sent to go forwards in the navigation flow, if possible.
 
 @param sender The action sender.
 */
- (IBAction)gotoNextFlowStep:(id)sender;

@end
