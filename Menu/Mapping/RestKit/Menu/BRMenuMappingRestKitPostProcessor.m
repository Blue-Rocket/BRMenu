//
//  BRMenuMappingRestKitPostProcessor.m
//  Menu
//
//  Created by Matt on 17/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuMappingRestKitPostProcessor.h"

#import "BRMenu.h"
#import "BRMenuMappingPostProcessor.h"

@implementation BRMenuMappingRestKitPostProcessor

- (void)mapperDidFinishMapping:(RKMapperOperation *)mapper {
	if ( [mapper.targetObject isKindOfClass:[BRMenu class]] ) {
		BRMenu *menu = (BRMenu *)mapper.targetObject;
		[BRMenuMappingPostProcessor assignMenuIDs:menu];
	}
}

@end
