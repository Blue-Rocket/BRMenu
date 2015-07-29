//
//  BRMenuItemCell.h
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuItemObjectCell.h"

@class BRMenuItem;

/**
 Table cell for displaying a single menu item. The display varies depending on 
 if the item has components or not.
 */
@interface BRMenuItemCell : BRMenuItemObjectCell

@property (nonatomic, strong) BRMenuItem *menuItem;

@end
