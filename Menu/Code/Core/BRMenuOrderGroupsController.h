//
//  BRMenuOrderGroupsController.h
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

@class BRMenuOrder;
@class BRMenuOrderItem;

/**
 Controller logic for assisting in the display of an order within a table or collection view.
 */
@interface BRMenuOrderGroupsController : NSObject

/**
 A mapping of string group keys to effective key string values. This can be used to combine 
 multiple, related groups into a single section.
 */
@property (nonatomic, strong) NSDictionary *groupKeyMapping;

/** The configured order. */
@property (nonatomic, readonly) BRMenuOrder *order;

/**
 Initialize with an order.
 
 @param order The order to use.
 @return The initialized controller instance.
 */
- (id)initWithOrder:(BRMenuOrder *)order;

/**
 Initialize with an order and mapping.
 
 @param order The order to use.
 @param groupKeyMapping The group key mapping to use.
 @return The initialized controller instance.
 */
- (id)initWithOrder:(BRMenuOrder *)order groupKeyMapping:(NSDictionary *)groupKeyMapping;

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
- (NSString *)titleForSection:(NSInteger)section;

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
- (BRMenuOrderItem *)orderItemAtIndexPath:(NSIndexPath *)indexPath;

/**
 Get an @c NSIndexPath for a given @c BRMenuOrderItem instance.
 
 @param orderItem The item to find the index path of.
 @return The found index path, or @c nil if not found.
 */
- (NSIndexPath *)indexPathForMenuItemObject:(BRMenuOrderItem *)orderItem;

@end
