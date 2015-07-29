//
//  BRMenuItemCell.m
//  Menu
//
//  Created by Matt on 29/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuItemCell.h"

#import "BRMenuItem.h"

@implementation BRMenuItemCell

- (BRMenuItem *)menuItem {
	return (BRMenuItem *)self.item;
}

- (void)setMenUItem:(BRMenuItem *)menuItem {
	self.item = menuItem;
}

@end
