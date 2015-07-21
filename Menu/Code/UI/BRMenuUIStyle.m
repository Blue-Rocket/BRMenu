//
//  BRMenuUIStyle.m
//  Menu
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuUIStyle.h"

static BRMenuUIStyle *DefaultStyle;

@implementation BRMenuUIStyle

+ (instancetype)defaultStyle {
	if ( !DefaultStyle ) {
		DefaultStyle = [BRMenuUIStyle new]; // TODO: load from environment
	}
	return DefaultStyle;
}

+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 16) & 0xFF) / 255.0f)
						   green:(((integer >> 8) & 0xFF) / 255.0f)
							blue:((integer & 0xFF) / 255.0f)
						   alpha:1.0];
}

#pragma mark - Helpers

- (BOOL)isDefaultStyle {
	return (self == DefaultStyle);
}

#pragma mark - Controls

- (UIColor *)controlTextColor {
	static UIColor *result;
	if ( result == nil ) {
		result = [BRMenuUIStyle colorWithRGBHexInteger:0x555555];
	}
	return result;
}

- (UIColor *)controlBorderColor {
	static UIColor *result;
	if ( result == nil ) {
		result = [BRMenuUIStyle colorWithRGBHexInteger:0xCACACA];
	}
	return result;
}

- (UIColor *)controlBorderGlossColor {
	static UIColor *result;
	if ( result == nil ) {
		result = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
	}
	return result;
}

- (UIColor *)controlHighlightedColor {
	static UIColor *result;
	if ( result == nil ) {
		result = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 0.5];
	}
	return result;
}

- (UIColor *)controlHighlightedShadowColor {
	static UIColor *result;
	if ( result == nil ) {
		result = [[self controlTextColor] colorWithAlphaComponent: 0.5];
	}
	return result;
}

- (UIColor *)controlSelectedColor {
	return [self headingColor];
}

- (UIColor *)controlUnselectedColor {
	return [UIColor darkGrayColor];
}

#pragma mark - Structure

- (UIColor *)headingColor {
	static UIColor *result;
	if ( result == nil ) {
		result = [BRMenuUIStyle colorWithRGBHexInteger:0xcb333b];
	}
	return result;
}

#pragma mark - Fonts

- (UIFont *)uiFont {
	static UIFont *result;
	if ( result == nil ) {
		result = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
	}
	return result;
}

- (UIFont *)uiBoldFont {
	static UIFont *result;
	if ( result == nil ) {
		result = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
	}
	return result;
}

@end
