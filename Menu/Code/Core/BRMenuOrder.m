//
//  BRMenuOrder.m
//  BRMenu
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

NSString * const kSpecialGroupKey = @"_special";

@implementation BRMenuOrder {
	NSMutableArray *orderItems;
}

@synthesize orderItems;

+ (NSSet *)keyPathsForValuesAffectingOrderItemCount {
	return [NSSet setWithObject:@"orderItems"];
}

- (id)initWithOrder:(BRMenuOrder *)order {
	if ( (self = [self init]) ) {
		self.menu = order.menu;
		self.orderNumber = NSNotFound;
		self.name = order.name;
		orderItems = [order.orderItems mutableCopy];
	}
	return self;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[BRMenuOrder alloc] initWithOrder:self];
}

#pragma mark - KVC support for orderItems array

- (void)insertObject:(BRMenuOrderItem *)item inOrderItemsAtIndex:(NSUInteger)index {
	[orderItems insertObject:item atIndex:index];
}

- (void)insertOrderItems:(NSArray *)array atIndexes:(NSIndexSet *)indexes {
	[orderItems insertObjects:array atIndexes:indexes];
}

- (void)removeObjectFromOrderItemsAtIndex:(NSUInteger)index {
	[orderItems removeObjectAtIndex:index];
}

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
	[orderItems removeAllObjects];
	if ( newOrderItems != nil ) {
		if ( orderItems == nil ) {
			[self willChangeValueForKey:@"orderItems"];
			orderItems = [newOrderItems mutableCopy];
			[self didChangeValueForKey:@"orderItems"];
		} else {
			NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndexesInRange:NSMakeRange(orderItems.count, newOrderItems.count)];
			[self insertOrderItems:newOrderItems atIndexes:indexSet];
		}
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

- (NSArray *)orderedGroupsWithSpecialGroupKey:(NSSet *)specialGroupKeys {
	const NSUInteger capacity = ([self.menu.items count] + [self.menu.groups count]);
	NSMutableArray *sections = [NSMutableArray arrayWithCapacity:capacity];
	
	// order in same order as BRMenu
	NSMutableDictionary *mapping = [NSMutableDictionary dictionaryWithCapacity:capacity];
	NSMutableArray *sortKeys = [NSMutableArray arrayWithCapacity:capacity];
	[sortKeys addObject:kSpecialGroupKey];
	for ( BRMenuItem *item in self.menu.items ) {
		if ( item.key != nil ) {
			[sortKeys addObject:item.key];
		}
	}
	for ( BRMenuItemGroup *group in self.menu.groups ) {
		[sortKeys addObject:(group.key == nil ? @"" : group.key)];
	}
	for ( BRMenuOrderItem *orderItem in orderItems ) {
		NSString *key = [orderItem orderGroupKeyWithSpecialGroupKeys:specialGroupKeys];
		NSMutableArray *rows = [mapping objectForKey:key];
		if ( rows == nil ) {
			rows = [NSMutableArray arrayWithCapacity:10];
			[mapping setObject:rows forKey:key];
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
	for ( NSString *key in sortKeys ) {
		NSArray *array = [mapping objectForKey:key];
		if ( array != nil ) {
			[sections addObject:array];
		}
	}
	return sections;
}

@end
