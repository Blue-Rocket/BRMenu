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
@property (nonatomic, readwrite) IBInspectable UIColor *headingColor;

@property (nonatomic, readwrite) IBInspectable UIColor *inverseHeadingColor;

@property (nonatomic, readwrite) IBInspectable UIColor *controlTextColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlBorderColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlBorderGlossColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlHighlightedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlHighlightedShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *controlUnselectedColor;

@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlTextColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlBorderColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlBorderGlossColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlHighlightedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlHighlightedShadowColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlSelectedColor;
@property (nonatomic, readwrite) IBInspectable UIColor *inverseControlUnselectedColor;

@property (nonatomic, strong, readwrite) IBInspectable UIFont *uiFont;
@property (nonatomic, strong, readwrite) IBInspectable UIFont *uiBoldFont;
@end

@implementation BRMenuUIStyle {
	UIColor *headingColor;
	
	UIColor *inverseHeadingColor;
	
	UIColor *controlTextColor;
	UIColor *controlBorderColor;
	UIColor *controlBorderGlossColor;
	UIColor *controlHighlightedColor;
	UIColor *controlHighlightedShadowColor;
	UIColor *controlSelectedColor;
	UIColor *controlUnselectedColor;

	UIColor *inverseControlTextColor;
	UIColor *inverseControlBorderColor;
	UIColor *inverseControlBorderGlossColor;
	UIColor *inverseControlHighlightedColor;
	UIColor *inverseControlHighlightedShadowColor;
	UIColor *inverseControlSelectedColor;
	UIColor *inverseControlUnselectedColor;

	UIFont *uiFont;
	UIFont *uiBoldFont;
}

@synthesize controlTextColor, inverseControlTextColor;
@synthesize controlBorderColor, inverseControlBorderColor;
@synthesize controlBorderGlossColor, inverseControlBorderGlossColor;
@synthesize controlHighlightedColor, inverseControlHighlightedColor;
@synthesize controlHighlightedShadowColor, inverseControlHighlightedShadowColor;
@synthesize controlSelectedColor, inverseControlSelectedColor;
@synthesize controlUnselectedColor, inverseControlUnselectedColor;

@synthesize headingColor, inverseHeadingColor;

@synthesize uiFont;
@synthesize uiBoldFont;

+ (instancetype)defaultStyle {
	if ( !DefaultStyle ) {
		[self setDefaultStyle:[[BRMenuUIStyle alloc] initWithUIStyle:nil]];
	}
	return DefaultStyle;
}

+ (void)setDefaultStyle:(BRMenuUIStyle *)style {
	if ( style ) {
		DefaultStyle = [style copy];
	}
}

+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 16) & 0xFF) / 255.0f)
						   green:(((integer >> 8) & 0xFF) / 255.0f)
							blue:((integer & 0xFF) / 255.0f)
						   alpha:1.0];
}

+ (UIColor *)colorWithRGBAHexInteger:(UInt32)integer {
	return [UIColor colorWithRed:(((integer >> 24) & 0xFF) / 255.0f)
						   green:(((integer >> 16) & 0xFF) / 255.0f)
							blue:(((integer >> 8) & 0xFF) / 255.0f)
						   alpha:((integer & 0xFF) / 255.0f)];
}

+ (UInt32)rgbHexIntegerForColor:(UIColor *)color {
	CGFloat r, g, b, a;
	if ( [color getRed:&r green:&g blue:&b alpha:&a] ) {
		return (
				(((UInt32)roundf(r * 255.0f)) << 16)
				| (((UInt32)roundf(g * 255.0f)) << 8)
				| ((UInt32)roundf(b * 255.0f))
				);
	}
	return 0;
}

+ (UInt32)rgbaHexIntegerForColor:(UIColor *)color {
	CGFloat r, g, b, a;
	if ( [color getRed:&r green:&g blue:&b alpha:&a] ) {
		return (
				(((UInt32)roundf(r * 255.0f)) << 24)
				| (((UInt32)roundf(g * 255.0f)) << 16)
				| (((UInt32)roundf(b * 255.0f)) << 8)
				| ((UInt32)roundf(a * 255.0f))
				);
	}
	return 0;
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
			
			inverseHeadingColor = [UIColor whiteColor];
			
			controlTextColor = [BRMenuUIStyle colorWithRGBHexInteger:0x555555];
			controlBorderColor = [BRMenuUIStyle colorWithRGBHexInteger:0xCACACA];
			controlBorderGlossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.66];
			controlHighlightedColor = [UIColor colorWithRed: 0.833 green: 0.833 blue: 0.833 alpha: 0.5];
			controlHighlightedShadowColor = [controlTextColor colorWithAlphaComponent: 0.5];
			controlSelectedColor = headingColor;
			controlUnselectedColor = [UIColor darkGrayColor];
			
			inverseControlTextColor = [UIColor whiteColor];
			inverseControlBorderColor = [BRMenuUIStyle colorWithRGBHexInteger:0x9c1f26];
			inverseControlBorderGlossColor = [[UIColor whiteColor] colorWithAlphaComponent:0.4];
			inverseControlHighlightedColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
			inverseControlHighlightedShadowColor = controlHighlightedShadowColor;
			inverseControlSelectedColor = controlSelectedColor;
			inverseControlUnselectedColor = [BRMenuUIStyle colorWithRGBHexInteger:0x800000];
			
			uiFont = [UIFont fontWithName:@"AvenirNext-Medium" size:12];
			uiBoldFont = [UIFont fontWithName:@"AvenirNext-DemiBold" size:12];
		} else {
			headingColor = other.headingColor;
			
			inverseHeadingColor = other.inverseHeadingColor;
			
			controlTextColor = other.controlTextColor;
			controlBorderColor = other.controlBorderColor;
			controlBorderGlossColor = other.controlBorderGlossColor;
			controlHighlightedColor = other.controlHighlightedColor;
			controlHighlightedShadowColor = other.controlHighlightedShadowColor;
			controlSelectedColor = other.controlSelectedColor;
			controlUnselectedColor = other.controlUnselectedColor;

			inverseControlTextColor = other.inverseControlTextColor;
			inverseControlBorderColor = other.inverseControlBorderColor;
			inverseControlBorderGlossColor = other.inverseControlBorderGlossColor;
			inverseControlHighlightedColor = other.inverseControlHighlightedColor;
			inverseControlHighlightedShadowColor = other.inverseControlHighlightedShadowColor;
			inverseControlSelectedColor = other.inverseControlSelectedColor;
			inverseControlUnselectedColor = other.inverseControlUnselectedColor;
			
			uiFont = other.uiFont;
			uiBoldFont = other.uiBoldFont;
		}
	}
	return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone {
	return self;
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

	inverseHeadingColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseHeadingColor))];

	controlTextColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlTextColor))];
	controlBorderColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlBorderColor))];
	controlBorderGlossColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlBorderGlossColor))];
	controlHighlightedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlHighlightedColor))];
	controlHighlightedShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlHighlightedShadowColor))];
	controlSelectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlSelectedColor))];
	controlUnselectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(controlUnselectedColor))];

	inverseControlTextColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlTextColor))];
	inverseControlBorderColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlBorderColor))];
	inverseControlBorderGlossColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlBorderGlossColor))];
	inverseControlHighlightedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlHighlightedColor))];
	inverseControlHighlightedShadowColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlHighlightedShadowColor))];
	inverseControlSelectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlSelectedColor))];
	inverseControlUnselectedColor = [decoder decodeObjectOfClass:[UIColor class] forKey:NSStringFromSelector(@selector(inverseControlUnselectedColor))];
	
	uiFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"uiFontName"] size:[decoder decodeFloatForKey:@"uiFontSize"]];
	uiBoldFont = [UIFont fontWithName:[decoder decodeObjectOfClass:[NSString class] forKey:@"uiBoldFontName"] size:[decoder decodeFloatForKey:@"uiBoldFontSize"]];
	
	return self;
}

- (void)encodeWithCoder:(NSCoder *)coder {
	[coder encodeObject:headingColor forKey:NSStringFromSelector(@selector(headingColor))];
	[coder encodeObject:inverseHeadingColor forKey:NSStringFromSelector(@selector(inverseHeadingColor))];
	
	[coder encodeObject:controlTextColor forKey:NSStringFromSelector(@selector(controlTextColor))];
	[coder encodeObject:controlBorderColor forKey:NSStringFromSelector(@selector(controlBorderColor))];
	[coder encodeObject:controlBorderGlossColor forKey:NSStringFromSelector(@selector(controlBorderGlossColor))];
	[coder encodeObject:controlHighlightedColor forKey:NSStringFromSelector(@selector(controlHighlightedColor))];
	[coder encodeObject:controlHighlightedShadowColor forKey:NSStringFromSelector(@selector(controlHighlightedShadowColor))];
	[coder encodeObject:controlSelectedColor forKey:NSStringFromSelector(@selector(controlSelectedColor))];
	[coder encodeObject:controlUnselectedColor forKey:NSStringFromSelector(@selector(controlUnselectedColor))];
	
	[coder encodeObject:inverseControlTextColor forKey:NSStringFromSelector(@selector(inverseControlTextColor))];
	[coder encodeObject:inverseControlBorderColor forKey:NSStringFromSelector(@selector(inverseControlBorderColor))];
	[coder encodeObject:inverseControlBorderGlossColor forKey:NSStringFromSelector(@selector(inverseControlBorderGlossColor))];
	[coder encodeObject:inverseControlHighlightedColor forKey:NSStringFromSelector(@selector(inverseControlHighlightedColor))];
	[coder encodeObject:inverseControlHighlightedShadowColor forKey:NSStringFromSelector(@selector(inverseControlHighlightedShadowColor))];
	[coder encodeObject:inverseControlSelectedColor forKey:NSStringFromSelector(@selector(inverseControlSelectedColor))];
	[coder encodeObject:inverseControlUnselectedColor forKey:NSStringFromSelector(@selector(inverseControlUnselectedColor))];
	
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

- (UIColor *)inverseHeadingColor {
	return (inverseHeadingColor ? inverseHeadingColor : [BRMenuUIStyle defaultStyle].inverseHeadingColor);
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

- (UIColor *)inverseControlTextColor {
	return (inverseControlTextColor ? inverseControlTextColor : [BRMenuUIStyle defaultStyle].inverseControlTextColor);
}

- (UIColor *)inverseControlBorderColor {
	return (inverseControlBorderColor ? inverseControlBorderColor : [BRMenuUIStyle defaultStyle].inverseControlBorderColor);
}

- (UIColor *)inverseControlBorderGlossColor {
	return (inverseControlBorderGlossColor ? inverseControlBorderGlossColor : [BRMenuUIStyle defaultStyle].inverseControlBorderGlossColor);
}

- (UIColor *)inverseControlHighlightedColor {
	return (inverseControlHighlightedColor ? inverseControlHighlightedColor : [BRMenuUIStyle defaultStyle].inverseControlHighlightedColor);
}

- (UIColor *)inverseControlHighlightedShadowColor {
	return (inverseControlHighlightedShadowColor ? inverseControlHighlightedShadowColor : [BRMenuUIStyle defaultStyle].inverseControlHighlightedShadowColor);
}

- (UIColor *)inverseControlSelectedColor {
	return (inverseControlSelectedColor ? inverseControlSelectedColor : [BRMenuUIStyle defaultStyle].inverseControlSelectedColor);
}

- (UIColor *)inverseControlUnselectedColor {
	return (inverseControlUnselectedColor ? inverseControlUnselectedColor : [BRMenuUIStyle defaultStyle].inverseControlUnselectedColor);
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

@dynamic headingColor, inverseHeadingColor;

@dynamic controlTextColor, inverseControlTextColor;
@dynamic controlBorderColor, inverseControlBorderColor;
@dynamic controlBorderGlossColor, inverseControlBorderGlossColor;
@dynamic controlHighlightedColor, inverseControlHighlightedColor;
@dynamic controlHighlightedShadowColor, inverseControlHighlightedShadowColor;
@dynamic controlSelectedColor, inverseControlSelectedColor;
@dynamic controlUnselectedColor, inverseControlUnselectedColor;

@dynamic uiFont;
@dynamic uiBoldFont;

- (id)copyWithZone:(NSZone *)zone {
	return [[BRMenuUIStyle allocWithZone:zone] initWithUIStyle:self];
}

@end