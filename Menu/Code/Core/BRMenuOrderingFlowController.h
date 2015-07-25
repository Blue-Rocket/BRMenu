//
//  BRMenuOrderingFlowController.h
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMenu;
@protocol BRMenuItemObject;

/**
 A controller object to assist with rendering a menu.
 */
@interface BRMenuOrderingFlowController : NSObject

@property (nonatomic, readonly) BRMenu *menu;
@property (nonatomic, readonly) id<BRMenuItemObject> item;
@property (nonatomic, readonly) NSUInteger stepCount;

/**
 Init for the root of a menu.
 
 @param menu The menu.
 @return The new controller instance.
 */
- (id)initWithMenu:(BRMenu *)menu;

/**
 Init for the root of a menu.
 
 @param menu The menu.
 @param item The selected menu item or group to start from.
 @return The new controller instance.
 */
- (id)initWithMenu:(BRMenu *)menu item:(id<BRMenuItemObject>)item;

/**
 Get the number of sections to display.
 
 @return The count of available sections.
 */
- (NSInteger)numberOfSections;

/**
 Get the count of items within a given section.
 
 @param section The section to get the count for.
 @return The number of items in the section.
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/**
 Get a @c BRMenuItemObject for a given section and index.
 
 @param indexPath The section and item index path to retrieve.
 @return The BRMenuItemObject for the given index path, or @c nil if not available.
 */
- (id<BRMenuItemObject>)menuItemObjectAtIndexPath:(NSIndexPath *)indexPath;

/**
 Get an @c IndexPath for a given @c BRMenuItemObject instance.
 
 @param pack The item to find the index path of.
 @return The found @c IndexPath, or @c nil if not found.
 */
- (NSIndexPath *)indexPathForMenuItemObject:(id<BRMenuItemObject>)item;


@end
