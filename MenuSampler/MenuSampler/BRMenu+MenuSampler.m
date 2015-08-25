//
//  BRMenu+MenuSampler.m
//  MenuSampler
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenu+MenuSampler.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <MenuKit/Core.h>
#import <MenuKit/RestKit.h>
//#import <RestKit/RestKit.h>


@implementation BRMenu (MenuSampler)

+ (BRMenu *)sampleMenuForResourceName:(NSString *)menuResourceName {
	NSString *jsonPath = [[NSBundle mainBundle] pathForResource:menuResourceName ofType:@"json"];
	NSData *data = [NSData dataWithContentsOfFile:jsonPath];
	NSError *error = nil;
	id object = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
	if ( error ) {
		log4Error(@"Error parsing JSON: %@", [error localizedDescription]);
		return nil;
	}
	// we need the "menu" top-level dictionary object
	object = [object valueForKeyPath:@"menu"];
	static BRMenuRestKitDataMapper *mapper;
	if ( !mapper ) {
		mapper = [[BRMenuRestKitDataMapper alloc] initWithObjectMapping:[BRMenuMappingRestKit menuMapping]];
	}
	BRMenu *menu = [mapper performMappingWithSourceObject:object error:&error];
	if ( error ) {
		log4Error(@"Error mapping JSON: %@", [error localizedDescription]);
		return nil;
	}
	[BRMenuMappingPostProcessor assignMenuIDs:menu];
	return menu;
}

@end
