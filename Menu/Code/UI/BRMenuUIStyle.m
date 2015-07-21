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
@property (nonatomic, readwrite) IBInspectable UIColor *controlTextColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlBorderColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlBorderGlossColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlHighlightedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlHighlightedShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlUnselectedColor;

@property (nonatomic, readwrite) IBInspectable UIColor *headingColor;

@property (nonatomic, strong, readwrite) IBInspectable UIFont *uiFont;
@property (nonatomic, strong, readwrite) IBInspectable UIFont *uiBoldFont;
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
	return [self initWithUIStyle:nil];
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
			
			uiFont = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
			uiBoldFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
		} else {
			headingColor = other.headingColor;
			
			controlTextColor = other.controlTextColor;
			controlBorderColor = other.controlBorderColor;
			controlBorderGlossColor = other.controlBorderGlossColor;
			controlHighlightedColor = other.controlHighlightedColor;
			controlHighlightedShadowColor = other.controlHighlightedShadowColor;
			controlSelectedColor = other.controlSelectedColor;
			controlUnselectedColor = other.controlUnselectedColor;

			uiFont = other.uiFont;
			uiBoldFont = other.uiBoldFont;
		}
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return [[BRMenuUIStyle allocWithZone:zone] initWithUIStyle:self];
}

#pragma mark - NSMutableCopying

- (id)mutableCopyWithZone:(NSZone *)zone {
	return [[[BRMenuMutableUIStyle class] allocWithZone:zone] initWithUIStyle:self];
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
	return YES;
}

- (id)initWithCoder:(NSCoder *)decoder {
	self = [self init];
	if ( !self ) {
		return nil;
	}
	headingColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(headingColor))];

	controlTextColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlTextColor))];
	controlBorderColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlBorderColor))];
	controlBorderGlossColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlBorderGlossColor))];
	controlHighlightedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlHighlightedColor))];
	controlHighlightedShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlHighlightedShadowColor))];
	controlSelectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlSelectedColor))];
	controlUnselectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlUnselectedColor))];

	uiFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"uiFontName"] size:[decoder decodeFloatForKey:@"uiFontSize"]];
	uiBoldFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"uiBoldFontName"] size:[decoder decodeFloatForKey:@"uiBoldFontSize"]];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:headingColor forKey:NSStringFromSelector(@selector(headingColor))];
	
	[coder encodeObject:controlTextColor forKey:NSStringFromSelector(@selector(controlTextColor))];
	[coder encodeObject:controlBorderColor forKey:NSStringFromSelector(@selector(controlBorderColor))];
	[coder encodeObject:controlBorderGlossColor forKey:NSStringFromSelector(@selector(controlBorderGlossColor))];
	[coder encodeObject:controlHighlightedColor forKey:NSStringFromSelector(@selector(controlHighlightedColor))];
	[coder encodeObject:controlHighlightedShadowColor forKey:NSStringFromSelector(@selector(controlHighlightedShadowColor))];
	[coder encodeObject:controlSelectedColor forKey:NSStringFromSelector(@selector(controlSelectedColor))];
	[coder encodeObject:controlUnselectedColor forKey:NSStringFromSelector(@selector(controlUnselectedColor))];
	
	[coder encodeObject:uiFont.fontName forKey:@"uiFontName"];
	[coder encodeFloat:uiFont.pointSize forKey:@"uiFontSize"];
	[coder encodeObject:uiBoldFont.fontName forKey:@"uiBoldFontName"];
	[coder encodeFloat:uiBoldFont.pointSize forKey:@"uiBoldFontSize"];
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