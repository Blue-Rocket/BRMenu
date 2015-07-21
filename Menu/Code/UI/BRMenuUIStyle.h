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
@interface BRMenuUIStyle : NSObject

/**
 Get a global shared style instance.
 
 @return A shared global default style instance.
 */
+ (instancetype)defaultStyle;

/**
 Create a @c UIColor instance from  a 32-bit RGB hex value.
 
 @param integer The color as a 32-bit RGB hex value. Only the last 24 bits are used.
 */
+ (UIColor *)colorWithRGBHexInteger:(UInt32)integer;

/**
 Test if this style represents the default style.
 */
@property (nonatomic, readonly, getter=isDefaultStyle) BOOL defaultStyle;

- (UIColor *)controlTextColor;
- (UIColor *)controlBorderColor;
- (UIColor *)controlBorderGlossColor;
- (UIColor *)controlHighlightedColor;
- (UIColor *)controlHighlightedShadowColor;
- (UIColor *)controlSelectedColor;
- (UIColor *)controlUnselectedColor;

- (UIColor *)headingColor;

- (UIFont *)uiFont;
- (UIFont *)uiBoldFont;

@end
