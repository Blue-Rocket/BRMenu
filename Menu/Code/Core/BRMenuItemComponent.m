//
//  BRMenuItemComponent.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponent.h"

@implementation BRMenuItemComponent

- (id)init {
	if ( (self = [super init]) ) {
		_askPlacement = YES;
		_askQuantity = YES;
		_showWithFoodInformation = YES;
	}
	return self;
}

- (BOOL)isEqual:(id)object {
	return ([object isKindOfClass:[BRMenuItemComponent class]] && self.componentId == [(BRMenuItemComponent *)object componentId]);
}

- (NSUInteger)hash {
	return ((NSUInteger)31 + (NSUInteger)_componentId);
}

- (NSString *)key {
	// not supported
	return nil;
}

- (BOOL)hasComponents {
	return NO;
}

- (NSDecimalNumber *)price {
	// not supported here
	return nil;
}

@end
