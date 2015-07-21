//
//  BRMenuUIStyle.m
//  Menu
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuUIStyle.h"

static BRMenuUIStyle *DefaultStyle;

@interface BRMenuUIStyle ()
@property (nonatomic, readwrite) UIColor *controlTextColor;
@property (nonatomic, readwrite) UIColor *controlBorderColor;
@property (nonatomic, readwrite) UIColor *controlBorderGlossColor;
@property (nonatomic, readwrite) UIColor *controlHighlightedColor;
@property (nonatomic, readwrite) UIColor *controlHighlightedShadowColor;
@property (nonatomic, readwrite) UIColor *controlSelectedColor;
@property (nonatomic, readwrite) UIColor *controlUnselectedColor;

@property (nonatomic, readwrite) UIColor *headingColor;

@property (nonatomic, strong, readwrite) UIFont *uiFont;
@property (nonatomic, strong, readwrite) UIFont *uiBoldFont;
@end

@implementation BRMenuUIStyle {
	UIColor *controlTextColor;
	UIColor *controlBorderColor;
	UIColor *controlBorderGlossColor;
	UIColor *controlHighlightedColor;
	UIColor *controlHighlightedShadowColor;
	UIColor *controlSelectedColor;
	UIColor *controlUnselectedColor;
	
	UIColor *headingColor;
	
	UIFont *uiFont;
	UIFont *uiBoldFont;
}

@synthesize controlTextColor;
@synthesize controlBorderColor;
@synthesize controlBorderGlossColor;
@synthesize controlHighlightedColor;
@synthesize controlHighlightedShadowColor;
@synthesize controlSelectedColor;
@synthesize controlUnselectedColor;

@synthesize headingColor;

@synthesize uiFont;
@synthesize uiBoldFont;

+ (instancetype)defaultStyle {
	if ( !DefaultStyle ) {
		DefaultStyle = [[BRMenuUIStyle alloc] initWithUIStyle:nil];
	}
	return DefaultStyle;
}

+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 16) & 0xFF) / 255.0f)
						   green:(((integer >> 8) & 0xFF) / 255.0f)
							blue:((integer & 0xFF) / 255.0f)
						   alpha:1.0];
}

#pragma mark - Memory management

- (id)init {
	return [BRMenuUIStyle defaultStyle];
}

- (id)initWithUIStyle:(BRMenuUIStyle *)other {
	if ( (self = [super init]) ) {
		if ( other == nil ) {
			// apply defaults
			// TODO: load from environment resource
			headingColor = [BRMenuUIStyle colorWithRGBHexInteger:0xcb333b];
			
			controlTextColor = [BRMenuUIStyle colorWithRGBHexInteger:0x555555];
			controlBorderColor = [BRMenuUIStyle colorWithRGBHexInteger:0xCACACA];
			controlBorderGlossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
			controlHighlightedColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 0.5];
			controlHighlightedShadowColor = [controlTextColor colorWithAlphaComponent: 0.5];
			controlSelectedColor = headingColor;
			controlUnselectedColor = [UIColor darkGrayColor];
			
			controlSelectedColor = headingColor;
			controlUnselectedColor = [UIColor darkGrayColor];
			
			uiFont = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
			uiBoldFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
		} else {
			headingColor = other.headingColor;
			uiFont = other.uiFont;
			uiBoldFont = other.uiBoldFont;
		}
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[BRMenuUIStyle alloc] initWithUIStyle:self];
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMenuMutableUIStyle class] allocWithZone:zone] initWithUIStyle:self];
}

#pragma mark - Helpers

- (BOOL)isDefaultStyle {
	return (self == DefaultStyle);
}

#pragma mark - Structural

- (UIColor *)headingColor {
	return (headingColor ? headingColor : [BRMenuUIStyle defaultStyle].headingColor);
}

#pragma mark - Controls

- (UIColor *)controlTextColor {
	return (controlTextColor ? controlTextColor : [BRMenuUIStyle defaultStyle].controlTextColor);
}

- (UIColor *)controlBorderColor {
	return (controlBorderColor ? controlBorderColor : [BRMenuUIStyle defaultStyle].controlBorderColor);
}

- (UIColor *)controlBorderGlossColor {
	return (controlBorderGlossColor ? controlBorderGlossColor : [BRMenuUIStyle defaultStyle].controlBorderGlossColor);
}

- (UIColor *)controlHighlightedColor {
	return (controlHighlightedColor ? controlHighlightedColor : [BRMenuUIStyle defaultStyle].controlHighlightedColor);
}

- (UIColor *)controlHighlightedShadowColor {
	return (controlHighlightedShadowColor ? controlHighlightedShadowColor : [BRMenuUIStyle defaultStyle].controlHighlightedShadowColor);
}

- (UIColor *)controlSelectedColor {
	return (controlSelectedColor ? controlSelectedColor : [BRMenuUIStyle defaultStyle].controlSelectedColor);
}

- (UIColor *)controlUnselectedColor {
	return (controlUnselectedColor ? controlUnselectedColor : [BRMenuUIStyle defaultStyle].controlUnselectedColor);
}

#pragma mark - Fonts

- (UIFont *)uiFont {
	return (uiFont ? uiFont : [BRMenuUIStyle defaultStyle].uiFont);
}

- (UIFont *)uiBoldFont {
	return (uiBoldFont ? uiBoldFont : [BRMenuUIStyle defaultStyle].uiBoldFont);
}

@end

#pragma BRMenuMutableUIStyle support

@implementation BRMenuMutableUIStyle

@dynamic controlTextColor;
@dynamic controlBorderColor;
@dynamic controlBorderGlossColor;
@dynamic controlHighlightedColor;
@dynamic controlHighlightedShadowColor;
@dynamic controlSelectedColor;
@dynamic controlUnselectedColor;

@dynamic headingColor;

@dynamic uiFont;
@dynamic uiBoldFont;

@end