//
//  BRMenuMappingRestKitPostProcessor.h
//  Menu
//
//  Created by Matt on 17/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMenu;

/**
 Helper class to post-process objects after mapping has been performed.
 */
@interface BRMenuMappingPostProcessor : NSObject

/**
 Assigning menu IDs to all @c BRMenuItem, @c BRMenuItemComponent, etc.
 objects and wire up child to parent relationships.
 
 @param menu The menu to process and update.
 */
+ (void)assignMenuIDs:(BRMenu *)menu;

@end
