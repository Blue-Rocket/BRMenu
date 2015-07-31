//
//  BRMenuItemCell.h
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemObjectCell.h"

@class BRMenuItem;

/**
 Table cell for displaying a single menu item that includes components.
 */
@interface BRMenuItemCell : BRMenuItemObjectCell

/** The menu item to display. */
@property (nonatomic, strong) BRMenuItem *menuItem;

@end
