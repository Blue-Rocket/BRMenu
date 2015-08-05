//
//  BRMenuOrder.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrder.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemAttributesProxy.h"

@implementation BRMenuOrder {
	NSMutableArray *orderItems;
	NSMutableSet *menus;
}

@synthesize orderItems;
@synthesize menus;

+ (NSSet *)keyPathsForValuesAffectingOrderItemCount {
	return [NSSet setWithObject:@"orderItems"];
}

- (id)init {
	if ( (self = [super init]) ) {
		menus = [[NSMutableSet alloc] initWithCapacity:4];
	}
	return self;
}

- (id)initWithOrder:(BRMenuOrder *)order {
	if ( (self = [self init]) ) {
		self.menu = order.menu;
		self.orderNumber = NSNotFound;
		self.name = order.name;
		orderItems = [order.orderItems mutableCopy];
		menus = [order.menus mutableCopy];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[BRMenuOrder alloc] initWithOrder:self];
}

#pragma mark - KVC support for orderItems array

- (void)insertObject:(BRMenuOrderItem *)item inOrderItemsAtIndex:(NSUInteger)index {
	[orderItems insertObject:item atIndex:index];
	if ( item.item.menu && ![menus containsObject:item.item.menu] ) {
		// maintain strong ref to menu, otherwise if menu released during ordering process
		// (i.e. when multiple menus are supported) all menu items will lose their ref to their menu
		[menus addObject:item.item.menu];
	}
}

- (void)insertOrderItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
	[orderItems insertObjects:array atIndexes:indexes];
	for ( BRMenuOrderItem *orderItem in orderItems ) {
		if ( orderItem.item.menu && ![menus containsObject:orderItem.item.menu] ) {
			[menus addObject:orderItem.item.menu];
		}
	}
}

- (void)removeObjectFromOrderItemsAtIndex:(NSUInteger)index {
	[orderItems removeObjectAtIndex:index];
}

- (void)removeOrderItemsAtIndexes:(NSIndexSet *)indexes {
	[orderItems removeObjectsAtIndexes:indexes];
}

#pragma mark - Public API

- (void)addOrderItem:(BRMenuOrderItem *)item {
	if ( orderItems == nil ) {
		[self willChangeValueForKey:@"orderItems"];
		orderItems = [[NSMutableArray alloc] initWithCapacity:5];
		[self didChangeValueForKey:@"orderItems"];
	}
	[self insertObject:item inOrderItemsAtIndex:orderItems.count];
}

- (BRMenuOrderItem *)orderItemForMenuItem:(BRMenuItem *)menuItem {
	for ( BRMenuOrderItem *item in orderItems ) {
		if ( [item.item isEqual:menuItem] ) {
			return item;
		}
	}
	return nil;
}

- (BRMenuOrderItem *)getOrAddItemForMenuItem:(BRMenuItem *)menuItem {
	BRMenuOrderItem *item = [self orderItemForMenuItem:menuItem];
	if ( item == nil ) {
		item = [BRMenuOrderItem new];
		item.item = menuItem;
		[self addOrderItem:item];
	}
	return item;
}

- (void)removeItemForMenuItem:(BRMenuItem *)menuItem {
	BRMenuOrderItem *item = [self orderItemForMenuItem:menuItem];
	if ( item != nil ) {
		NSUInteger index = [orderItems indexOfObjectIdenticalTo:item];
		[self removeObjectFromOrderItemsAtIndex:index];
	}
}

- (void)replaceOrderItems:(NSArray *)newOrderItems {
	[self removeOrderItemsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, orderItems.count)]];
	if ( newOrderItems != nil ) {
		if ( orderItems == nil ) {
			[self willChangeValueForKey:@"orderItems"];
			orderItems = [[NSMutableArray alloc] initWithCapacity:5];
			[self didChangeValueForKey:@"orderItems"];
		}
		NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(orderItems.count, newOrderItems.count)];
		[self insertOrderItems:newOrderItems atIndexes:indexSet];
	}
}

- (NSUInteger)orderItemCount {
	NSUInteger count = 0;
	for ( BRMenuOrderItem *item in orderItems ) {
		count += item.quantity;
	}
	return count;
}

- (NSDecimalNumber *)totalPrice {
	NSDecimalNumber *total = [NSDecimalNumber decimalNumberWithMantissa:0 exponent:0 isNegative:NO];
	for ( BRMenuOrderItem *item in orderItems ) {
		NSDecimalNumber *itemQuantity = [NSDecimalNumber decimalNumberWithMantissa:item.quantity exponent:0 isNegative:NO];
		NSDecimalNumber *itemPrice = (item.item.price != nil ? item.item.price : item.item.group.price);
		if ( itemPrice != nil ) {
			NSDecimalNumber *itemTotal = [itemPrice decimalNumberByMultiplyingBy:itemQuantity];
			total = [total decimalNumberByAdding:itemTotal];
		}
	}
	return total;
}

- (BRMenu *)menuForKey:(NSString *)key {
	for ( BRMenu *menu in menus ) {
		NSString *menuKey = menu.key;
		if ( !menuKey ) {
			menuKey = @"";
		}
		if ( [key isEqualToString:menuKey] ) {
			return menu;
		}
	}
	return nil;
}

- (NSArray *)orderedGroups:(NSDictionary *)groupMapping {
	// order sections in same order as BRMenu groups
	NSMutableDictionary *mapping = [NSMutableDictionary new];

	for ( BRMenuOrderItem *orderItem in orderItems ) {
		// mapping is a dictionary of menu keys to dictionaries of group keys to arrays of order items for that group
		NSMutableDictionary *menuMapping = mapping;
		NSString *menuKey = orderItem.item.menu.key;
		if ( !menuKey ) {
			menuKey = @"";
		}
		menuMapping = mapping[menuKey];
		if ( !menuMapping ) {
			menuMapping = [NSMutableDictionary new];
			mapping[menuKey] = menuMapping;
		}
		NSString *key = [orderItem orderGroupKey:groupMapping];
		NSMutableArray *rows = [menuMapping objectForKey:key];
		if ( rows == nil ) {
			rows = [[NSMutableArray alloc] initWithCapacity:10];
			[menuMapping setObject:rows forKey:key];
		}
		[rows addObject:orderItem];
		
		// if BRMenuItem supports take away, and quantity is > 0, we must add additional items for all quantities
		if ( orderItem.item.askTakeaway ) {
			if ( orderItem.quantity > 1 ) {
				UInt8 index;
				for ( index = 1; index < orderItem.quantity; index++ ) {
					BRMenuOrderItemAttributesProxy *proxy = [[BRMenuOrderItemAttributesProxy alloc] initWithOrderItem:orderItem attributeIndex:index];
					[rows addObject:proxy];
				}
			} else if ( [orderItem.attributes count] == 0 ) {
				// make sure an attributes object exits so our calculations elsewhere are consistent
				[orderItem getOrAddAttributesAtIndex:0];
			}
		}
	}
	
	NSMutableArray *sections = [NSMutableArray new];
	for ( NSString *menuKey in mapping ) {
		NSDictionary *menuMapping = mapping[menuKey];
		BRMenu *menu = [self menuForKey:menuKey];
		NSArray *sortedGroupKeys = [[menuMapping allKeys] sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
			if ( [obj1 isEqualToString:obj2] ) {
				return NSOrderedSame;
			}
			if ( [obj1 isEqualToString:BRMenuOrderItemDefaultGroupKey] ) {
				return NSOrderedAscending;
			}
			if ( [obj2 isEqualToString:BRMenuOrderItemDefaultGroupKey] ) {
				return NSOrderedDescending;
			}
			NSInteger idx1 = [menu groupOrderingIndexForKey:obj1];
			NSInteger idx2 = [menu groupOrderingIndexForKey:obj2];;
			return (idx1 < idx2 ? NSOrderedAscending : idx1 > idx2 ? NSOrderedDescending : NSOrderedSame);
		}];
		for ( NSString *groupKey in sortedGroupKeys ) {
			NSMutableArray *section = menuMapping[groupKey];
			[sections addObject:section];
		}
	}
	
	return sections;
}

@end
