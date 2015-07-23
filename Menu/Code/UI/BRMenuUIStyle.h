//
//  BRMenuUIStyle.h
//  Menu
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 Encapsulation of style attributes used for drawing BRMenu UI components.
 */
IB_DESIGNABLE
@interface BRMenuUIStyle : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

///-------------------------------
/// @name Utilities
///-------------------------------

/**
 Create a @c UIColor instance from a 32-bit RGB hex value.
 
 @param integer The color as a 32-bit RGB hex value. Only the last 24 bits are used.
 @return The color object.
 */
+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer;

/**
 Create a @c UIColor instance from a 32-bit RGBA hex value.
 
 @param integer The color as a 32-bit RGBA hex value.
 @return The color object.
 */
+ (UIColor *)colorWithRGBAHexInteger:(UInt32)integer;

/**
 Create a 32-bit RGB hex value from a @c UIColor instance.
 
 @param color The color to convert.
 @return integer The color as a 32-bit RGB hex value. Only the last 24 bits are used.
 */
+ (UInt32)rgbHexIntegerForColor:(UIColor *)color;

/**
 Create a 32-bit RGBA hex value from a @c UIColor instance.
 
 @param color The color to convert.
 @return integer The color as a 32-bit RGBA hex value.
 */
+ (UInt32)rgbaHexIntegerForColor:(UIColor *)color;

///-------------------------------
/// @name Default support
///-------------------------------

/**
 Get a global shared style instance.
 
 @return A shared global default style instance.
 */
+ (instancetype)defaultStyle;

/**
 Set the global shared style instance.
 
 @param style The new style to set.
 */
+ (void)setDefaultStyle:(BRMenuUIStyle *)style;

/**
 Test if this style represents the default style.
 */
@property (nonatomic, readonly, getter=isDefaultStyle) BOOL defaultStyle;

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *headingColor;

@property (nonatomic, readonly) UIColor *inverseHeadingColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *controlTextColor;
@property (nonatomic, readonly) UIColor *controlBorderColor;
@property (nonatomic, readonly) UIColor *controlBorderGlossColor;
@property (nonatomic, readonly) UIColor *controlHighlightedColor;
@property (nonatomic, readonly) UIColor *controlHighlightedShadowColor;
@property (nonatomic, readonly) UIColor *controlSelectedColor;
@property (nonatomic, readonly) UIColor *controlUnselectedColor;

@property (nonatomic, readonly) UIColor *inverseControlTextColor;
@property (nonatomic, readonly) UIColor *inverseControlBorderColor;
@property (nonatomic, readonly) UIColor *inverseControlBorderGlossColor;
@property (nonatomic, readonly) UIColor *inverseControlHighlightedColor;
@property (nonatomic, readonly) UIColor *inverseControlHighlightedShadowColor;
@property (nonatomic, readonly) UIColor *inverseControlSelectedColor;
@property (nonatomic, readonly) UIColor *inverseControlUnselectedColor;

///-------------------------------
/// @name Font styles
///-------------------------------

@property (nonatomic, readonly) UIFont *uiFont;
@property (nonatomic, readonly) UIFont *uiBoldFont;

@end

@interface BRMenuMutableUIStyle : BRMenuUIStyle

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *headingColor;

@property (nonatomic, readwrite) UIColor *inverseHeadingColor;

///-------------------------------
/// @name Control color styles
///-------------------------------

@property (nonatomic, readwrite) UIColor *controlTextColor;
@property (nonatomic, readwrite) UIColor *controlBorderColor;
@property (nonatomic, readwrite) UIColor *controlBorderGlossColor;
@property (nonatomic, readwrite) UIColor *controlHighlightedColor;
@property (nonatomic, readwrite) UIColor *controlHighlightedShadowColor;
@property (nonatomic, readwrite) UIColor *controlSelectedColor;
@property (nonatomic, readwrite) UIColor *controlUnselectedColor;

@property (nonatomic, readwrite) UIColor *inverseControlTextColor;
@property (nonatomic, readwrite) UIColor *inverseControlBorderColor;
@property (nonatomic, readwrite) UIColor *inverseControlBorderGlossColor;
@property (nonatomic, readwrite) UIColor *inverseControlHighlightedColor;
@property (nonatomic, readwrite) UIColor *inverseControlHighlightedShadowColor;
@property (nonatomic, readwrite) UIColor *inverseControlSelectedColor;
@property (nonatomic, readwrite) UIColor *inverseControlUnselectedColor;

///-------------------------------
/// @name Font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *uiFont;
@property (nonatomic, readwrite) UIFont *uiBoldFont;

@end
