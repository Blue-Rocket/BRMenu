//
//  BRMenu.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenu.h"

#import "BRMenuItem.h"
#import "BRMenuItemGroup.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemTag.h"

@implementation BRMenu

#pragma mark - NSCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [self init]) ) {
		self.key = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(key))];
		self.title = [aDecoder decodeObjectOfClass:[NSString class] forKey:NSStringFromSelector(@selector(title))];
		self.version = [aDecoder decodeIntForKey:NSStringFromSelector(@selector(version))];
		self.items = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItem class], nil] forKey:NSStringFromSelector(@selector(items))];
		self.groups = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItemGroup class], nil] forKey:NSStringFromSelector(@selector(groups))];
		self.tags = [aDecoder decodeObjectOfClasses:[NSSet setWithObjects:[NSArray class], [BRMenuItemTag class], nil] forKey:NSStringFromSelector(@selector(tags))];
	}
	return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
	[aCoder encodeObject:self.key forKey:NSStringFromSelector(@selector(key))];
	[aCoder encodeObject:self.title forKey:NSStringFromSelector(@selector(title))];
	[aCoder encodeInt:self.version forKey:NSStringFromSelector(@selector(version))];
	[aCoder encodeObject:self.items forKey:NSStringFromSelector(@selector(items))];
	[aCoder encodeObject:self.groups forKey:NSStringFromSelector(@selector(groups))];
	[aCoder encodeObject:self.tags forKey:NSStringFromSelector(@selector(tags))];
}

#pragma mark -

- (BOOL)isEqual:(id)object {
	return (object == self || ([object isKindOfClass:[BRMenu class]] && [self.key isEqualToString:[object key]]));
}

- (NSInteger)groupOrderingIndexForKey:(NSString *)key {
	NSUInteger idx = [self.groups indexOfObjectPassingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
		BRMenuItemGroup *group = obj;
		return [group.key isEqualToString:key];
	}];
	return (idx == NSNotFound ? -1 : idx);
}

- (void)enumerateMenuItemsUsingBlock:(void (^)(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop))block {
	__block NSUInteger index = 0;
	BOOL stop = NO;
	for ( BRMenuItem *item in self.items ) {
		block(item, index++, &stop);
		if ( stop ) {
			return;
		}
	}
	for ( BRMenuItemGroup *group in self.groups ) {
		[group enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *stop) {
			block(menuItem, index, stop);
			index++;
		}];
		if ( stop ) {
			return;
		}
	}
}

- (void)enumerateMenuItemGroupsUsingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block {
	if ( block == NULL ) {
		return;
	}
	NSUInteger index = 0;
	for ( BRMenuItemGroup *group in self.groups ) {
		if ( [BRMenu enumerateMenuItemGroups:group startingAtIndex:&index usingBlock:block] ) {
			break;
		}
	}
}

+ (BOOL)enumerateMenuItemGroups:(BRMenuItemGroup *)group startingAtIndex:(NSUInteger *)index usingBlock:(void (^)(BRMenuItemGroup *menuItemGroup, NSUInteger idx, BOOL *stop))block {
	BOOL stop = NO;
	block(group, (*index)++, &stop);
	if ( stop ) {
		return stop;
	}
	for ( BRMenuItemGroup *nested in group.groups ) {
		stop = [BRMenu enumerateMenuItemGroups:nested startingAtIndex:index usingBlock:block];
		if ( stop ) {
			return stop;
		}
	}
	return stop;
}

- (void)enumerateMenuItemComponentGroupsUsingBlock:(void (^)(BRMenuItemComponentGroup *, NSUInteger, BOOL *))block {
	__block NSUInteger index = 0;
	__block BOOL globalStop = NO;
	[self enumerateMenuItemsUsingBlock:^(BRMenuItem *menuItem, NSUInteger idx, BOOL *itemStop) {
		[menuItem enumerateMenuItemComponentGroupsUsingBlock:^(BRMenuItemComponentGroup *menuItemComponentGroup, NSUInteger idx, BOOL *componentStop) {
			if ( menuItemComponentGroup.extendsKey != nil ) {
				// filter out extending groups
				return;
			}
			block(menuItemComponentGroup, index, &globalStop);
			index++;
			if ( globalStop ) {
				*componentStop = globalStop;
			}
		}];
		if ( globalStop ) {
			*itemStop = globalStop;
		}
	}];
}

- (BRMenuItem *)menuItemForId:(const uint8_t)itemId {
	for ( BRMenuItem *item in self.items ) {
		if ( itemId == item.itemId ) {
			return item;
		}
	}
	for ( BRMenuItemGroup *itemGroup in self.groups ) {
		BRMenuItem *item = [itemGroup menuItemForId:itemId];
		if ( item != nil ) {
			return item;
		}
	}
	return nil;
}

- (BRMenuItem *)menuItemForKey:(NSString *)key {
	if ( key == nil ) {
		return nil;
	}
	for ( BRMenuItem *item in self.items ) {
		if ( [key isEqualToString:item.key] ) {
			return item;
		}
	}
	for ( BRMenuItemGroup *itemGroup in self.groups ) {
		BRMenuItem *item = [itemGroup menuItemForKey:key];
		if ( item != nil ) {
			return item;
		}
	}
	return nil;
}

- (BRMenuItemComponent *)menuItemComponentForId:(const uint8_t)componentId {
	for ( BRMenuItem *item in self.items ) {
		BRMenuItemComponent *component = [item menuItemComponentForId:componentId];
		if ( component != nil ) {
			return component;
		}
	}
	for ( BRMenuItemGroup *itemGroup in self.groups ) {
		BRMenuItemComponent *component = [itemGroup menuItemComponentForId:componentId];
		if ( component != nil ) {
			return component;
		}
	}
	return nil;
}

- (BRMenuItemComponentGroup *)menuItemComponentGroupForKey:(NSString *)key {
	for ( BRMenuItem *item in self.items ) {
		BRMenuItemComponentGroup *group = [item menuItemComponentGroupForKey:key];
		if ( group != nil ) {
			return group;
		}
	}
	for ( BRMenuItemGroup *itemGroup in self.groups ) {
		BRMenuItemComponentGroup *group = [itemGroup menuItemComponentGroupForKey:key];
		if ( group != nil ) {
			return group;
		}
	}
	return nil;
}

- (BRMenuItemGroup *)menuItemGroupForKey:(NSString *)key {
	for ( BRMenuItemGroup *nested in self.groups ) {
		BRMenuItemGroup *group = [nested menuItemGroupForKey:key];
		if ( group != nil ) {
			return group;
		}
	}
	return nil;
}

- (NSArray *)allComponents {
	NSMutableArray *result = [NSMutableArray new];
	for ( BRMenuItem *item in self.items ) {
		[result addObjectsFromArray:[item allComponents]];
	}
	for ( BRMenuItemGroup *itemGroup in self.groups ) {
		[result addObjectsFromArray:[itemGroup allComponents]];
	}
	
	// now filter out duplicates
	NSMutableSet *set = [NSMutableSet new];
	NSMutableIndexSet *dups = [NSMutableIndexSet new];
	NSUInteger index = 0;
	for ( BRMenuItemComponent *component in result ) {
		if ( [set containsObject:component] ) {
			[dups addIndex:index];
		} else {
			[set addObject:component];
		}
		index++;
	}
	[result removeObjectsAtIndexes:dups];
	return [result copy];
}

@end
