//
//  BRMenuOrderItem.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderItem.h"

#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItemAttributes.h"
#import "BRMenuOrderItemComponent.h"


@implementation BRMenuOrderItem {
	NSMutableArray *components;
	NSMutableArray *attributes;
}

@synthesize attributes, components;

- (id)init {
	if ( (self = [super init]) ) {
		self.quantity = (UInt8)1;
	}
	return self;
}

- (id)initWithMenuItem:(BRMenuItem *)menuItem {
	if ( (self = [self init]) ) {
		self.item = menuItem;
	}
	return self;
}

- (id)initWithOrderItem:(BRMenuOrderItem *)other {
	if ( (self = [self init]) ) {
		self.quantity = other.quantity;
		self.takeAway = other.takeAway;
		self.item = other.item;
		components = [other.components mutableCopy];
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	return ([object isKindOfClass:[BRMenuOrderItem class]]
			&& [self.item isEqual:[(BRMenuOrderItem *)object item]]
			&& ((self.components == nil && [(BRMenuOrderItem *)object components] == nil)
				|| [self.components isEqualToArray:[(BRMenuOrderItem *)object components]]));
}

- (NSUInteger)hash {
	NSUInteger result = 31 + [self.item hash];
	for ( BRMenuOrderItemComponent *component in components ) {
		result += [component hash];
	}
	return result;
}

- (id)copyWithZone:(NSZone *)zone {
	return [[BRMenuOrderItem alloc] initWithOrderItem:self];
}

- (void)setTakeAway:(BOOL)takeAway {
	BRMenuOrderItemAttributes *attr = [self attributesAtIndex:0];
	if ( attr == nil ) {
		attr = [BRMenuOrderItemAttributes new];
		[self setAttributes:attr atIndex:0];
	}
	attr.takeAway = takeAway;
}

- (BOOL)isTakeAway {
	return [self attributesAtIndex:0].takeAway;
}

- (void)addComponent:(BRMenuOrderItemComponent *)component {
	if ( components == nil ) {
		components = [[NSMutableArray alloc] initWithCapacity:10];
	}
	// check for existing
	BRMenuOrderItemComponent *existing = [self componentForMenuItemComponent:component.component];
	if ( existing != nil ) {
		[components removeObjectIdenticalTo:existing];
	}
	[components addObject:component];
}

- (void)removeComponent:(BRMenuOrderItemComponent *)component {
	if ( component == nil ) {
		return;
	}
	[components removeObject:component];
}

- (void)removeComponentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent {
	if ( menuItemComponent == nil ) {
		return;
	}
	BRMenuOrderItemComponent *result = nil;
	for ( BRMenuOrderItemComponent *component in components ) {
		if ( [menuItemComponent isEqual:component.component] ) {
			result = component;
			break;
		}
	}
	if ( result != nil ) {
		[components removeObjectIdenticalTo:result];
	}
}

- (BRMenuOrderItemComponent *)componentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent {
	if ( menuItemComponent == nil ) {
		return nil;
	}
	for ( BRMenuOrderItemComponent *component in components ) {
		if ( [menuItemComponent isEqual:component.component] ) {
			return component;
		}
	}
	return nil;
}

- (BRMenuOrderItemComponent *)getOrAddComponentForMenuItemComponent:(BRMenuItemComponent *)menuItemComponent {
	BRMenuOrderItemComponent *component = [self componentForMenuItemComponent:menuItemComponent];
	if ( component == nil ) {
		component = [[BRMenuOrderItemComponent alloc] initWithComponent:menuItemComponent
														placement:BRMenuOrderItemComponentPlacementWhole
														 quantity:BRMenuOrderItemComponentQuantityNormal];
		[self addComponent:component];
	}
	return component;
}

- (void)setAttributes:(BRMenuOrderItemAttributes *)theAttributes atIndex:(UInt8)index {
	if ( attributes == nil ) {
		attributes = [NSMutableArray arrayWithCapacity:8];
	}
	while ( index >= [attributes count] ) {
		[attributes addObject:[BRMenuOrderItemAttributes new]];
	}
	[attributes replaceObjectAtIndex:index withObject:theAttributes];
}

- (BRMenuOrderItemAttributes *)attributesAtIndex:(UInt8)index {
	if ( index >= [attributes count] ) {
		return nil;
	}
	return [attributes objectAtIndex:index];
}

- (BRMenuOrderItemAttributes *)getOrAddAttributesAtIndex:(UInt8)index {
	BRMenuOrderItemAttributes *attr = [self attributesAtIndex:index];
	if ( attr == nil ) {
		attr = [BRMenuOrderItemAttributes new];
		[self setAttributes:attr atIndex:index];
	}
	return attr;
}

- (void)removeAttributesAtIndex:(UInt8)index {
	if ( index < [attributes count] ) {
		[attributes removeObjectAtIndex:index];
	}
}
- (NSString *)orderGroupKeyWithSpecialGroupKeys:(NSSet *)pizzaGroupKeys {
	BRMenuItem *menuItem = self.item;
	NSString *key = (menuItem.group != nil ? [menuItem rootMenuItemGroup].key : menuItem.key);
	if ( key == nil || [pizzaGroupKeys containsObject:key] ) {
		key = kSpecialGroupKey;
	}
	return key;
}

@end
