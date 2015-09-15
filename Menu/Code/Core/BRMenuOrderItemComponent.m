//
//  BRMenuOrderItemComponent.m
//  MenuKit
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderItemComponent.h"

#import "BRMenuItemComponent.h"

@implementation BRMenuOrderItemComponent

- (id)init {
	return [self initWithComponent:nil
						 placement:BRMenuOrderItemComponentPlacementWhole
						  quantity:BRMenuOrderItemComponentQuantityNormal];
}

- (id)initWithComponent:(BRMenuItemComponent *)menuComponent {
	return [self initWithComponent:menuComponent
						 placement:BRMenuOrderItemComponentPlacementWhole
						  quantity:BRMenuOrderItemComponentQuantityNormal];
}

- (id)initWithComponent:(BRMenuItemComponent *)menuComponent
			  placement:(BRMenuOrderItemComponentPlacement)placement
			   quantity:(BRMenuOrderItemComponentQuantity)quantity {
	if ( (self = [super init]) ) {
		self.component = menuComponent;
		self.placement = placement;
		self.quantity = quantity;
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	return ([object isKindOfClass:[BRMenuOrderItemComponent class]] && [self.component isEqual:[(BRMenuOrderItemComponent *)object component]]);
}

- (NSUInteger)hash {
	return [self.component hash];
}

- (BOOL)isLeftPlacement {
	return (self.placement == BRMenuOrderItemComponentPlacementLeft || self.placement == BRMenuOrderItemComponentPlacementWhole);
}

- (BOOL)isRightPlacement {
	return (self.placement == BRMenuOrderItemComponentPlacementRight || self.placement == BRMenuOrderItemComponentPlacementWhole);
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	BRMenuItemComponent *c = [aDecoder decodeObjectOfClass:[BRMenuItemComponent class] forKey:NSStringFromSelector(@selector(component))];
	BRMenuOrderItemComponentPlacement p = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(placement))];
	BRMenuOrderItemComponentQuantity q = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(quantity))];
	self = [self initWithComponent:c placement:p quantity:q];
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.component forKey:NSStringFromSelector(@selector(component))];
	[aCoder encodeInteger:self.placement forKey:NSStringFromSelector(@selector(placement))];
	[aCoder encodeInteger:self.quantity forKey:NSStringFromSelector(@selector(quantity))];
}

@end
