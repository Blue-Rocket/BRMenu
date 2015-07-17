//
//  BRMenuItemComponent.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
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

@end
