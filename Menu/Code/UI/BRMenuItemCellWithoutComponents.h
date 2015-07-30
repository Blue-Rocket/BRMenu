//
//  BRMenuItemCellWithoutComponents.h
//  Menu
//
//  Created by Matt on 30/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuItemObjectCell.h"

@class BRMenuItem;
@class BRMenuStepper;

/** 
 A cell for rendering a menu itme that has no components, and thus shows a stepper to
 allow adding and removing that item from an order directly.
 */
@interface BRMenuItemCellWithoutComponents : BRMenuItemObjectCell

/** A stepper, to enable adding/subtracting from order. */
@property (nonatomic, strong) IBOutlet BRMenuStepper *stepper;

/** The menu item to display. */
@property (nonatomic, strong) BRMenuItem *menuItem;

@end
