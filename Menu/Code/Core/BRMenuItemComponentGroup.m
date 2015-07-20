//
//  BRMenuGroup.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponentGroup.h"

#import "BRMenuItemComponent.h"

@implementation BRMenuItemComponentGroup

- (BRMenuItemComponent *)menuItemComponentForId:(const UInt8)componentId {
	for ( BRMenuItemComponent *component in self.components ) {
		if ( componentId == component.componentId ) {
			return component;
		}
	}
	for ( BRMenuItemComponentGroup *nested in self.componentGroups ) {
		BRMenuItemComponent *component = [nested menuItemComponentForId:componentId];
		if ( component != nil ) {
			return component;
		}
	}
	return nil;
}

- (NSArray *)allComponents {
	NSMutableArray *result = [NSMutableArray new];
	[result addObjectsFromArray:self.components];
	for ( BRMenuItemComponentGroup *nested in self.componentGroups ) {
		[result addObjectsFromArray:[nested allComponents]];
	}
	return result;
}

@end
