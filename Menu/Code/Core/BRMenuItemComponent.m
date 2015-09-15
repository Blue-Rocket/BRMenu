//
//  BRMenuItemComponent.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemComponent.h"

#import "BRMenuItemComponentGroup.h"

@implementation BRMenuItemComponent

- (id)init {
	if ( (self = [super init]) ) {
		_askPlacement = YES;
		_askQuantity = YES;
		_showWithFoodInformation = YES;
	}
	return self;
}

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [self init]) ) {
		self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))];
		self.desc = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(desc))];
		self.componentId = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(componentId))];
		self.askPlacement = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isAskPlacement))];
		self.askQuantity = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isAskQuantity))];
		self.showWithFoodInformation = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isShowWithFoodInformation))];
		self.absenceOfComponent = [aDecoder decodeBoolForKey:NSStringFromSelector(@selector(isAbsenceOfComponent))];
		self.group = [aDecoder decodeObjectOfClass:[BRMenuItemComponentGroup class] forKey:NSStringFromSelector(@selector(group))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.key forKey:NSStringFromSelector(@selector(key))];
	[aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
	[aCoder encodeObject:self.desc forKey:NSStringFromSelector(@selector(desc))];
	[aCoder encodeInt:self.componentId forKey:NSStringFromSelector(@selector(componentId))];
	[aCoder encodeBool:self.askPlacement forKey:NSStringFromSelector(@selector(isAskPlacement))];
	[aCoder encodeBool:self.askQuantity forKey:NSStringFromSelector(@selector(isAskQuantity))];
	[aCoder encodeBool:self.showWithFoodInformation forKey:NSStringFromSelector(@selector(isShowWithFoodInformation))];
	[aCoder encodeBool:self.absenceOfComponent forKey:NSStringFromSelector(@selector(isAbsenceOfComponent))];
	[aCoder encodeObject:self.group forKey:NSStringFromSelector(@selector(group))];
}

#pragma mark -

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
