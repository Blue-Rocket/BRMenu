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

@interface BRMenuItemCellWithoutComponents : BRMenuItemObjectCell

/** A stepper, to enable adding/subtracting from order. */
@property (nonatomic, strong) IBOutlet BRMenuStepper *stepper;

/** The menu item to display. */
@property (nonatomic, strong) BRMenuItem *menuItem;

@end
