//
//  BRMenuGroup.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponentGroup.h"

#import "BRMenuItemComponent.h"

@implementation BRMenuItemComponentGroup

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [self init]) ) {
		self.key = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(key))];
		self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))];
		self.desc = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(desc))];
		self.multiSelect = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isMultiSelect))];
		self.requiredCount = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(requiredCount))];
		self.extendsKey = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(extendsKey))];
		self.parentGroup = [aDecoder decodeObjectOfClass:[BRMenuItemComponentGroup class] forKey:NSStringFromSelector(@selector(parentGroup))];
		self.components = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItemComponent class], nil] forKey:NSStringFromSelector(@selector(components))];
		self.componentGroups = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItemComponentGroup class], nil] forKey:NSStringFromSelector(@selector(componentGroups))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.key forKey:NSStringFromSelector(@selector(key))];
	[aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
	[aCoder encodeObject:self.desc forKey:NSStringFromSelector(@selector(desc))];
	[aCoder encodeBool:self.multiSelect forKey:NSStringFromSelector(@selector(isMultiSelect))];
	[aCoder encodeInt:self.requiredCount forKey:NSStringFromSelector(@selector(requiredCount))];
	[aCoder encodeObject:self.extendsKey forKey:NSStringFromSelector(@selector(extendsKey))];
	[aCoder encodeObject:self.parentGroup forKey:NSStringFromSelector(@selector(parentGroup))];
	[aCoder encodeObject:self.components forKey:NSStringFromSelector(@selector(components))];
	[aCoder encodeObject:self.componentGroups forKey:NSStringFromSelector(@selector(componentGroups))];
}

#pragma mark -

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
