//
//  BRMenuTestingMenuProvider.h
//  Menu
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
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
