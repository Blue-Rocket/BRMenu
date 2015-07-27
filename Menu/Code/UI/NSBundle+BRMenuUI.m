//
//  NSBundle+BRMenuUI.m
//  Menu
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "NSBundle+BRMenuUI.h"

#import "BRMenuUIStyle.h"
#import "NSBundle+BRMenu.h"

@implementation NSBundle (BRMenuUI)

+ (void)load {
	@autoreleasepool {
		NSString *bundlePath;
		
		// register MenuUI.bundle as default extension point
		bundlePath = [[NSBundle mainBundle] pathForResource:@"MenuUI" ofType:@"bundle"];
		if ( bundlePath ) {
			[NSBundle registerBRMenuBundle:[NSBundle bundleWithPath:bundlePath]];
		}
		
		// register BRMenuUI, provided by BRMenu, as default fallback
		bundlePath = [[NSBundle bundleForClass:[BRMenuUIStyle class]] pathForResource:@"BRMenuUI" ofType:@"bundle"];
		if ( bundlePath ) {
			[NSBundle registerBRMenuBundle:[NSBundle bundleWithPath:bundlePath]];
		}
	}
}

@end
