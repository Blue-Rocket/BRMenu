//
//  BRMenuOrderingComponentsViewController.h
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@class BRMenuOrderingFlowController;

extern NSString * const BRMenuOrderingItemComponentCellIdentifier;
extern NSString * const BRMenuOrderingGroupHeaderCellIdentifier;

@interface BRMenuOrderingComponentsViewController : UITableViewController

@property (nonatomic, strong) BRMenuOrderingFlowController *flowController;
@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

@end
