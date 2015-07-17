//
//  BRMenuOrderItem.h
//  BRMenu
//
//  A line item in an order. Refers to a specific BRMenuItem for the
//  unit price. A collection of BRMenuItemComponents can be supplied
//  to detail specific components of the item.
//
//  For example, a "pizza" item might contain the components
//  [Traditional, Classic Tomato, Housemade Mozzarella] for the
//  dough, sauce, and cheese selections.
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BRMenuItem;
@class BRMenuItemComponent;
@class BRMenuOrderItemAttributes;
@class BRMenuOrderItemComponent;

@interface BRMenuOrderItem : NSObject <NSCopying>

@property (nonatomic) UInt8 quantity;
@property (nonatomic, getter = isTakeAway) BOOL takeAway; // YES == take away, NO == dine in; shortcut for first BRMenuOrderItemAttributes
@property (nonatomic, strong) BRMenuItem *item;
@property (nonatomic, readonly) NSArray *attributes; // BRMenuOrderItemAttributes
@property (nonatomic, readonly) NSArray *components; // BRMenuOrderItemComponent

- (id)init; // designated initializer
- (id)initWithMenuItem:(BRMenuItem *)menuItem;
- (id)initWithOrderItem:(BRMenuOrderItem *)other; // a copy initializer

- (void)addComponent:(BRMenuOrderItemComponent *)component;
- (void)removeComponent:(BRMenuOrderItemComponent *)component;

// get an existing BRMenuOrderItemComponent for a given BRMenuItemComponent, or nil if not found
- (BRMenuOrderItemComponent *)componentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent;

// get the existing BRMenuOrderItemComponent for a given BRMenuItemComponent, or create it and add
- (BRMenuOrderItemComponent *)getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent;

// remove any existing BRMenuOrderItemComponent matching a given BRMenuItemComponent
- (void)removeComponentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent;

// manage the BRMenuOrderItemAttributes
- (void)setAttributes:(BRMenuOrderItemAttributes *)attributes atIndex:(UInt8)index;
- (BRMenuOrderItemAttributes *)attributesAtIndex:(UInt8)index;
- (BRMenuOrderItemAttributes *)getOrAddAttributesAtIndex:(UInt8)index;
- (void)removeAttributesAtIndex:(UInt8)index;

- (NSString *)orderGroupKeyWithSpecialGroupKeys:(NSSet *)pizzaGroupKeys;

@end
