//
//  BRMenuMappingRestKitPostProcessor.m
//  Menu
//
//  Created by Matt on 17/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuMappingRestKitPostProcessor.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"

#import "BRMenuMappingRestKit.h"

@implementation BRMenuMappingRestKitPostProcessor

- (void)mapperDidFinishMapping:(RKMapperOperation *)mapper {
	if ( [mapper.targetObject isKindOfClass:[BRMenu class]] ) {
		BRMenu *menu = (BRMenu *)mapper.targetObject;
		[BRMenuMappingRestKitPostProcessor postProcessMenuMapping:menu];
	}
}

+ (void)assignMenu:(BRMenu *)menu menuItemComponentGroupIDs:(BRMenuItemComponentGroup *)group itemCounter:(UInt8 *)itemId componentCounter:(UInt8*)componentId {
	for ( BRMenuItemComponent *component in group.components ) {
		component.group = group;
		component.componentId = ++(*componentId);
	}
	if ( group.extendsKey != nil ) {
		BRMenuItemComponentGroup *ref = [menu menuItemComponentGroupForKey:group.extendsKey];
		if ( ref != nil ) {
			if ( group.title == nil ) {
				group.title = ref.title;
			}
			if ( group.desc == nil ) {
				group.desc = ref.desc;
			}
			group.components = ref.components;
			// NOTE that requiredCount and multiSelect flags are NOT cloned, because there is no way to tell if this was set in
			// the JSON data or just defaulting to 0 at this point.
		}
	}
	for ( BRMenuItemComponentGroup *nested in group.componentGroups ) {
		nested.parentGroup = group;
		[self assignMenu:menu menuItemComponentGroupIDs:nested itemCounter:itemId componentCounter:componentId];
	}
}

+ (void)assignMenu:(BRMenu *)menu menuItemIDs:(BRMenuItem *)item itemCounter:(UInt8 *)itemId componentCounter:(UInt8*)componentId {
	item.itemId = ++(*itemId);
	item.menu = menu;
	for ( BRMenuItemComponentGroup *componentGroup in item.componentGroups ) {
		[self assignMenu:menu menuItemComponentGroupIDs:componentGroup itemCounter:itemId componentCounter:componentId];
	}
}

+ (void)assignMenu:(BRMenu *)menu groupItemIDs:(BRMenuItemGroup *)group itemCounter:(UInt8 *)itemId componentCounter:(UInt8*)componentId {
	for ( BRMenuItem *item in group.items ) {
		item.group = group;
		[self assignMenu:menu menuItemIDs:item itemCounter:itemId componentCounter:componentId];
	}
	for ( BRMenuItemGroup *nested in group.itemGroups ) {
		nested.parentGroup = group;
		[self assignMenu:menu groupItemIDs:nested itemCounter:itemId componentCounter:componentId];
	}
}

+ (void)assignMenuIDs:(BRMenu *)menu {
	UInt8 itemId = 0;
	UInt8 componentId = 0;
	for ( BRMenuItem *item in menu.items ) {
		[self assignMenu:menu menuItemIDs:item itemCounter:&itemId componentCounter:&componentId];
	}
	for ( BRMenuItemGroup *group in menu.groups ) {
		[self assignMenu:menu groupItemIDs:group itemCounter:&itemId componentCounter:&componentId];
	}
}

+ (void)postProcessMenuMapping:(BRMenu *)menu {
	[BRMenuMappingRestKitPostProcessor assignMenuIDs:menu];
}

@end
