//
//  BRMenuOrderMenuGroupingController.m
//  Menu
//
//  Created by Matt on 15/10/15.
//  Copyright © 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderMenuGroupingController.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuOrderItemAttributesProxy.h"
#import "BRMenuItemGroup.h"
#import "BRMenuOrder.h"
#import "BRMenuOrderItem.h"
#import "NSBundle+BRMenu.h"

@implementation BRMenuOrderMenuGroupingController {
	BRMenuOrder *order;
	NSArray<NSArray<BRMenuOrderItem *> *> *sections;
}

@synthesize order;

- (id)init {
	return [self initWithOrder:[BRMenuOrder new]];
}

- (id)initWithOrder:(BRMenuOrder *)theOrder {
	if ( (self = [super init]) ) {
		order = theOrder;
		[self generateSectionsForOrder:theOrder];
	}
	return self;
}

- (void)generateSectionsForOrder:(BRMenuOrder *)theOrder {
	NSOrderedSet<BRMenu *> *menus = theOrder.menus;
	NSMutableArray<NSMutableArray<BRMenuOrderItem *> *> *result = [[NSMutableArray alloc] initWithCapacity:menus.count];
	[theOrder.orderItems enumerateObjectsUsingBlock:^(BRMenuOrderItem * _Nonnull orderItem, NSUInteger idx, BOOL * _Nonnull stop) {
		NSUInteger sectionIdx = [menus indexOfObject:orderItem.item.menu];
		if ( sectionIdx == NSNotFound ) {
			return;
		}
		while ( !(sectionIdx < result.count) ) {
			[result addObject:[[NSMutableArray alloc] initWithCapacity:8]];
		}
		
		[result[sectionIdx] addObject:orderItem];

		// if BRMenuItem supports take away, and quantity is > 0, we must add additional items for all quantities
		if ( orderItem.item.askTakeaway ) {
			if ( orderItem.quantity > 1 ) {
				uint8_t index;
				for ( index = 1; index < orderItem.quantity; index++ ) {
					BRMenuOrderItemAttributesProxy *proxy = [[BRMenuOrderItemAttributesProxy alloc] initWithOrderItem:orderItem attributeIndex:index];
					[result[sectionIdx] addObject:(id)proxy];
				}
			} else if ( [orderItem.attributes count] == 0 ) {
				// make sure an attributes object exits so our calculations elsewhere are consistent
				[orderItem getOrAddAttributesAtIndex:0];
			}
		}
	}];
	sections = result;
}

- (void)refresh {
	[self generateSectionsForOrder:order];
}

- (NSInteger)numberOfSections {
	return sections.count;
}

- (NSString *)titleForSection:(NSInteger)section {
	BRMenu *menu = order.menus[section];
	return menu.title;
}

- (NSInteger)numberOfItemsInSection:(NSInteger)section {
	return sections[section].count;
}

- (BRMenuOrderItem *)orderItemAtIndexPath:(NSIndexPath *)indexPath {
	NSUInteger section = [indexPath indexAtPosition:0];
	NSUInteger index = [indexPath indexAtPosition:1];
	return sections[section][index];
}

- (NSIndexPath *)indexPathForMenuItemObject:(BRMenuOrderItem *)orderItem {
	NSUInteger section = 0;
	NSUInteger index = NSNotFound;
	for ( NSArray *row in sections ) {
		index = [row indexOfObject:orderItem];
		if ( index != NSNotFound ) {
			break;
		}
		section++;
	}
	if ( index == NSNotFound ) {
		section = NSNotFound;
	}
	NSUInteger indexArr[] = {section, index};
	return [NSIndexPath indexPathWithIndexes:indexArr length:2];
}

@end
