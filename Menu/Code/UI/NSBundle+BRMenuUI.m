//
//  NSBundle+BRMenuUI.m
//  MenuKit
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "NSBundle+BRMenuUI.h"

#import <BRPDFImage/BRPDFImage.h>
#import <BRStyle/Core.h>
#import "BRMenuItemTag.h"
#import "BRMenuStepper.h"
#import "NSBundle+BRMenu.h"

static NSCache *IconCache;

@implementation NSBundle (BRMenuUI)

+ (void)load {
	IconCache = [NSCache new];
	@autoreleasepool {
		NSString *bundlePath;
		
		// register MenuUI.bundle as default extension point
		bundlePath = [[NSBundle mainBundle] pathForResource:@"MenuUI" ofType:@"bundle"];
		if ( bundlePath ) {
			[NSBundle registerBRMenuBundle:[NSBundle bundleWithPath:bundlePath]];
		}
		
		// register BRMenuUI, provided by BRMenu, as default fallback
		bundlePath = [[NSBundle bundleForClass:[BRMenuStepper class]] pathForResource:@"BRMenuUI" ofType:@"bundle"];
		if ( bundlePath ) {
			[NSBundle registerBRMenuBundle:[NSBundle bundleWithPath:bundlePath]];
		}
	}
}

+ (NSString *)cacheKeyForBRMenuIconNamed:(NSString *)iconName size:(CGSize)iconSize color:(UIColor *)color {
	if ( [[iconName lowercaseString] hasSuffix:@".pdf"] ) {
		// key components are: image name, render size, and tint color
		return [NSString stringWithFormat:@"%@-%@-%x", iconName, NSStringFromCGSize(iconSize),
				(unsigned int)[BRUIStyle rgbaIntegerForColor:color]];
	}
	return [NSString stringWithFormat:@"%@-%@", iconName, NSStringFromCGSize(iconSize)];
}

+ (UIImage *)iconForBRMenuResource:(NSString *)resourceName size:(CGSize)iconSize color:(UIColor *)tintColor {
	NSString *cacheKey = [self cacheKeyForBRMenuIconNamed:resourceName size:iconSize color:tintColor];
	UIImage *image = [IconCache objectForKey:cacheKey];
	if ( image == nil ) {
		NSURL *url = [NSBundle URLForBRMenuResourceNamed:resourceName];
		if ( [[[url lastPathComponent] lowercaseString] hasSuffix:@".pdf"] ) {
			image = [[BRPDFImage alloc] initWithURL:url
										 pageNumber:1
										 renderSize:iconSize
									backgroundColor:nil
										  tintColor:tintColor
									  tintBlendMode:kCGBlendModeSourceIn];
		} else {
			image = [[UIImage alloc] initWithContentsOfFile:[url path]];
		}
		if ( image ) {
			[IconCache setObject:image forKey:cacheKey];
		}
	}
	return image;
}

+ (UIStoryboard *)storyboardForBRMenuOrdering {
	NSArray *sbNames = @[@"MenuKitOrdering", @"BRMenuOrdering"];
	for ( NSString *sbName in sbNames ) {
		UIStoryboard *sb = nil;
		
		// try .storyboardc
		NSBundle *bundle = [NSBundle bundleContainingBRMenuResourceNamed:[sbName stringByAppendingString:@".storyboardc"]];
		if ( bundle ) {
			sb = [UIStoryboard storyboardWithName:sbName bundle:bundle];
			if ( sb ) {
				return sb;
			}
		}
		bundle = [NSBundle bundleContainingBRMenuResourceNamed:[sbName stringByAppendingString:@".storyboard"]];
		if ( bundle ) {
			sb = [UIStoryboard storyboardWithName:sbName bundle:bundle];
			if ( sb ) {
				return sb;
			}
		}
	}
	return nil;
}

@end
