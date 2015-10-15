//
//  BRMenuOrderGroupingConrtroller.h
//  Menu
//
//  Created by Matt on 15/10/15.
//  Copyright © 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuOrder;
@class BRMenuOrderItem;

NS_ASSUME_NONNULL_BEGIN

/**
 Controller API for assisting in the display of an order within a table or collection view, with order items grouped into sections.
 */
@protocol BRMenuOrderGroupingConrtroller <NSObject>

/** The order to work with. */
@property (nonatomic, readonly) BRMenuOrder *order;

/**
 Refresh the calculated sections for the configured order, for example after the order is updated.
 */
- (void)refresh;

/**
 Get the number of sections to display.
 
 @return The count of available sections.
 */
- (NSInteger)numberOfSections;

/**
 Get a title for a section.
 
 @param section The section to get the title for.
 @return The title.
 */
- (nullable NSString *)titleForSection:(NSInteger)section;

/**
 Get the count of items within a given section.
 
 @param section The section to get the count for.
 @return The number of items in the section.
 */
- (NSInteger)numberOfItemsInSection:(NSInteger)section;

/**
 Get a @c BRMenuOrderItem for a given section and index.
 
 @param indexPath The section and item index path to retrieve.
 @return The BRMenuOrderItem for the given index path, or @c nil if not available.
 */
- (nullable BRMenuOrderItem *)orderItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Get an @c NSIndexPath for a given @c BRMenuOrderItem instance.
 
 @param orderItem The item to find the index path of.
 @return The found index path, or @c nil if not found.
 */
- (nullable NSIndexPath *)indexPathForMenuItemObject:(BRMenuOrderItem *)orderItem;

@end

NS_ASSUME_NONNULL_END
