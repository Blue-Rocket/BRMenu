//
//  BRMenuTestingMenuProvider.h
//  Menu
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuProvider.h"

@class BRMenu;

/**
 A testing implementation of BRMenuProvider.
 */
@interface BRMenuTestingMenuProvider : NSObject <BRMenuProvider>

/**
 Initialize with a specific menu.
 
 @param menu The menu to return for all calls in @c BRMenuProvider.
 */
- (instancetype)initWithMenu:(BRMenu *)menu;

@end
