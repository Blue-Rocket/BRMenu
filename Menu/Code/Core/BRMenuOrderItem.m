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

NSString * const BRMenuOrderItemDefaultGroupKey = @"default";

@implementation BRMenuOrderItem {
	NSMutableArray *components;
	NSMutableArray *attributes;
}

@synthesize attributes, components;

+ (NSSet *)keyPathsForValuesAffectingPrice {
	return [NSSet setWithObject:NSStringFromSelector(@selector(quantity))];
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

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	BRMenuItem *i = [aDecoder decodeObjectOfClass:[BRMenuItem class] forKey:NSStringFromSelector(@selector(item))];
	if ( (self = [self initWithMenuItem:i]) ) {
		self.quantity = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(quantity))];
		self.takeAway = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isTakeAway))];
		attributes = [[aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuOrderItemAttributes class], nil] forKey:NSStringFromSelector(@selector(attributes))] mutableCopy];
		components = [[aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuOrderItemComponent class], nil] forKey:NSStringFromSelector(@selector(components))] mutableCopy];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.item forKey:NSStringFromSelector(@selector(item))];
	[aCoder encodeInt:self.quantity forKey:NSStringFromSelector(@selector(quantity))];
	[aCoder encodeBool:self.takeAway forKey:NSStringFromSelector(@selector(isTakeAway))];
	[aCoder encodeObject:attributes forKey:NSStringFromSelector(@selector(attributes))];
	[aCoder encodeObject:components forKey:NSStringFromSelector(@selector(components))];
}

#pragma mark -

- (NSDecimalNumber *)price {
	NSDecimalNumber *itemQuantity = [NSDecimalNumber decimalNumberWithMantissa:self.quantity exponent:0 isNegative:NO];
	NSDecimalNumber *itemPrice = (self.item.price != nil ? self.item.price : self.item.group.price);
	return (itemPrice ? [itemPrice decimalNumberByMultiplyingBy:itemQuantity] : nil);
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

- (void)setAttributes:(BRMenuOrderItemAttributes *)theAttributes atIndex:(uint8_t)index {
	if ( attributes == nil ) {
		attributes = [NSMutableArray arrayWithCapacity:8];
	}
	while ( index >= [attributes count] ) {
		[attributes addObject:[BRMenuOrderItemAttributes new]];
	}
	[attributes replaceObjectAtIndex:index withObject:theAttributes];
}

- (BRMenuOrderItemAttributes *)attributesAtIndex:(uint8_t)index {
	if ( index >= [attributes count] ) {
		return nil;
	}
	return [attributes objectAtIndex:index];
}

- (BRMenuOrderItemAttributes *)getOrAddAttributesAtIndex:(uint8_t)index {
	BRMenuOrderItemAttributes *attr = [self attributesAtIndex:index];
	if ( attr == nil ) {
		attr = [BRMenuOrderItemAttributes new];
		[self setAttributes:attr atIndex:index];
	}
	return attr;
}

- (void)removeAttributesAtIndex:(uint8_t)index {
	if ( index < [attributes count] ) {
		[attributes removeObjectAtIndex:index];
	}
}
- (NSString *)orderGroupKey:(NSDictionary *)groupMapping {
	BRMenuItem *menuItem = self.item;
	NSString *key = (menuItem.group != nil ? [menuItem rootMenuItemGroup].key : menuItem.key);
	if ( key != nil && groupMapping[key] != nil ) {
		key = groupMapping[key];
	} else if ( key == nil ) {
		key = BRMenuOrderItemDefaultGroupKey;
	}
	return key;
}

@end
