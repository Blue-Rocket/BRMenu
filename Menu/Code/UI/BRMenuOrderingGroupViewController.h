//
//  BRMenuOrderingGroupViewController.h
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@class BRMenuOrderingFlowController;
@protocol BRMenuOrderingDelegate;

extern NSString * const BRMenuOrderingItemCellIdentifier;
extern NSString * const BRMenuOrderingItemGroupHeaderCellIdentifier;

/**
 Present a list of menu item groups as sections of menu items.
 */
@interface BRMenuOrderingGroupViewController : UITableViewController <BRMenuUIStylish>

@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

@property (nonatomic, strong) BRMenuOrderingFlowController *flowController;
@property (nonatomic, weak) id<BRMenuOrderingDelegate> orderingDelegate;

@end
