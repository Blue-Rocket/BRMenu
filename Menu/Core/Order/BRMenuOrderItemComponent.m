//
//  BRMenuOrderItemComponent.m
//  BRMenu
//
//  Created by Matt on 4/3/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import "BRMenuOrderItemComponent.h"

#import "BRMenuItemComponent.h"

@implementation BRMenuOrderItemComponent

- (id)init {
	return [self initWithComponent:nil
						 placement:APOrderItemComponentPlacementWhole
						  quantity:APOrderItemComponentQuantityNormal];
}

- (id)initWithComponent:(BRMenuItemComponent *)menuComponent {
	return [self initWithComponent:menuComponent
						 placement:APOrderItemComponentPlacementWhole
						  quantity:APOrderItemComponentQuantityNormal];
}

- (id)initWithComponent:(BRMenuItemComponent *)menuComponent
			  placement:(APOrderItemComponentPlacement)placement
			   quantity:(APOrderItemComponentQuantity)quantity {
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
	return (self.placement == APOrderItemComponentPlacementLeft || self.placement == APOrderItemComponentPlacementWhole);
}

- (BOOL)isRightPlacement {
	return (self.placement == APOrderItemComponentPlacementRight || self.placement == APOrderItemComponentPlacementWhole);
}

@end
