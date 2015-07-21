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
 Create a @c UIColor instance from  a 32-bit RGB hex value.
 
 @param integer The color as a 32-bit RGB hex value. Only the last 24 bits are used.
 */
+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer;

///-------------------------------
/// @name Default support
///-------------------------------

/**
 Get a global shared style instance.
 
 @return A shared global default style instance.
 */
+ (instancetype)defaultStyle;

/**
 Test if this style represents the default style.
 */
@property (nonatomic, readonly, getter=isDefaultStyle) BOOL defaultStyle;

///-------------------------------
/// @name Structural color styles
///-------------------------------

@property (nonatomic, readonly) UIColor *headingColor;

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

///-------------------------------
/// @name Font styles
///-------------------------------

@property (nonatomic, readwrite) UIFont *uiFont;
@property (nonatomic, readwrite) UIFont *uiBoldFont;

@end
