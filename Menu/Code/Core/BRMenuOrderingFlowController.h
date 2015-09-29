//
//  BRMenuOrderingFlowController.h
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenu;
@class BRMenuItem;
@class BRMenuItemGroup;
@class BRMenuOrder;
@class BRMenuOrderItem;
@protocol BRMenuItemObject;

typedef enum : NSInteger {
	BRMenuOrderingFlowErrorUnknown,
	BRMenuOrderingFlowErrorComponentOverlap,
	BRMenuOrderingFlowErrorRequiredComponentMissing,
} BRMenuOrderingFlowError;

NS_ASSUME_NONNULL_BEGIN

/**
 A controller object to assist with rendering a menu.
 */
@interface BRMenuOrderingFlowController : NSObject

@property (nonatomic, readonly) BRMenu *menu;
@property (nonatomic, readonly) BRMenuItem *item;
@property (nonatomic, readonly) BRMenuOrderItem *orderItem;
@property (nonatomic, readonly) NSUInteger stepCount;
@property (nonatomic, readonly, getter=isFinalStep) BOOL finalStep;
@property (nonatomic, readonly) BRMenuItemGroup *itemGroup;

/** A temporary order copy that can be used to collect order item changes. */
@property (nonatomic, copy) BRMenuOrder *temporaryOrder;

/**
 Init for the root of a menu.
 
 @param menu The menu.
 @return The new controller instance.
 */
- (id)initWithMenu:(BRMenu *)menu;

/**
 Init for a single menu item.
 
 @param menu The menu.
 @param item The selected menu item to start from, or @c for the root menu.
 @return The new controller instance.
 */
- (id)initWithMenu:(BRMenu *)menu item:(nullable BRMenuItem *)item;

/**
 Init for a single menu item group. The @c temporaryOrder property can be used
 to collect order item changes before committing them to a "real" order if needed.
 
 @param menu The menu.
 @param group The selected menu item group to start from.
 @return The new controller instance.
 */
- (id)initWithMenu:(BRMenu *)menu group:(BRMenuItemGroup *)group;

/// ------------------------
/// @name Collection Support
/// ------------------------

/**
 Get the number of sections to display.
 
 @return The count of available sections.
 */
- (NSInteger)numberOfSections;

/**
 Get a title for a section.
 
 @param section The section to get the title for.
 @return The title, or @c nil if not available.
 */
- (nullable NSString *)titleForSection:(NSInteger)section;

/**
 Get a price for a section.
 
 @param section The section to get the price for.
 @return The group price, or @c nil if there is no group-wide price.
 */
- (nullable NSDecimalNumber *)priceForSection:(NSInteger)section;

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
- (nullable id<BRMenuItemObject>)menuItemObjectAtIndexPath:(NSIndexPath *)indexPath;

/**
 Get an @c NSIndexPath for a given @c BRMenuItemObject instance.
 
 @param item The item to find the index path of.
 @return The found @c IndexPath, or @c nil if not found.
 */
- (nullable NSIndexPath *)indexPathForMenuItemObject:(id<BRMenuItemObject>)item;

/**
 Get an arry of @c NSIndexPath objects for all components selected in the current step.
 
 @return An array of index paths, or @nil if no item is selected.
 */
- (nullable NSArray<NSIndexPath *> *)indexPathsForSelectedComponents;

/// ---------------------
/// @name Navigation Flow
/// ---------------------

/**
 Test if based on the current conditions the user should be allowed to move to the next step in the flow.
 
 @param error An error pointer to obtain the reason for any failure. Pass @c nil if not needed.
 @return Flag indicating the navigation validation result.
 */
- (BOOL)canGotoNextStep:(NSError * __autoreleasing *)error;

/**
 Test if based on the current conditions the user should be allowed to add the active item to an order.
 
 @param error An error pointer to obtain the reason for any failure. Pass @c nil if not needed.
 @return Flag indicating the navigation validation result.
 */
- (BOOL)canAddItemToOrder:(NSError * __autoreleasing *)error;

/**
 Get a new controller instance for the next step;
 
 @return The new controller instance, or @c nil if not appropriate.
 */
- (nullable instancetype)flowControllerForNextStep;

/**
 Get a new flow controller for an item selection.
 
 @param indexPath The index of the item to get the path for.
 @return The new controller instance, or @c nil if not appropriate.
 */
- (instancetype)flowControllerForItemAtIndexPath:(NSIndexPath *)indexPath;

/// -----
/// @name Menu item group support
/// -----

/**
 Test if the configured item, or any menu item in the configured menu item group, does not contain any components.
 This is useful to support showing an "Add to order" button in the user interface when a temporary
 order is used to facilitate an "undo" behavior.
 */
@property (nonatomic, readonly) BOOL hasMenuItemWithoutComponents;

@end

NS_ASSUME_NONNULL_END
