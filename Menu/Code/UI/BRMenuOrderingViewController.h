//
//  BRMenuOrderingViewController.h
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@class BRMenu;

extern NSString * const BRMenuOrderingItemObjectCellIdentifier;

extern NSString * const BRMenuOrderingConfigureComponentsSegue;

@interface BRMenuOrderingViewController : UITableViewController <BRMenuUIStylish>

@property (nonatomic, strong) BRMenu *menu;
@property (nonatomic, assign, getter=isUsePrototypeCells) IBInspectable BOOL usePrototypeCells;

@end
