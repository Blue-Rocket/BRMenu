//
//  BRMenuMappingRestKitPostProcessor.m
//  MenuKit
//
//  Created by Matt on 17/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
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
