//
//  BRUIStyle.h
//  BRStyle
//
//  Created by Matt on 21/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRUIStyleSettings.h"

NS_ASSUME_NONNULL_BEGIN

/**
 A notification sent when the default BRUIStyle instance changes. The sender will be the 
 new BRUIStyle instance.
 */
extern NSString * const BRStyleNotificationUIStyleDidChange;

/**
 Encapsulation of style attributes used for drawing BR UI components.
 */
@interface BRUIStyle : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

/// -------------------------------
/// @name Default support
/// -------------------------------

/**
 Get a global shared style instance.
 
 @return A shared global default style instance.
 */
+ (instancetype)defaultStyle;

/**
 Set the global shared style instance.
 
 @param style The new style to set.
 */
+ (void)setDefaultStyle:(BRUIStyle *)style;

/**
 Test if this style represents the default style.
 */
@property (nonatomic, readonly, getter=isDefaultStyle) BOOL defaultStyle;

/// -------------------------------
/// @name Style properties
/// -------------------------------

/** The font style settings. */
@property (nonatomic, readonly) BRUIStyleFontSettings *fonts;

/** The color style settings. */
@property (nonatomic, readonly) BRUIStyleColorSettings *colors;

/// -------------------------------
/// @name Serialization
/// -------------------------------

/**
 Create a style instance from a JSON-encoded bundle resource.
 
 @param resourceName The name of the JSON resource to load.
 @param bundle The bundle to use, or @c nil for the main bundle.
 @return The new style instance, or @c nil if the resource could not be loaded.
 */
+ (nullable BRUIStyle *)styleWithJSONResource:(NSString *)resourceName inBundle:(nullable NSBundle *)bundle;

/**
 Decode a style intance from a dictionary representation.
 
 The dictionary shoud be in the form returned by the @c dictionaryRepresentation method.
 @param dictionary The dictionary to decode.
 @return A new style instance.
 */
+ (BRUIStyle *)styleWithDictionary:(NSDictionary *)dictionary;

/**
 Get a dictionary representation of the receiver.
 
 The resulting dictionary will contain only simple data types, suitable for serializing
 into JSON or other encodings.
 
 @return A dictionary representation.
 @see styleWithDictionary:
 */
- (NSDictionary *)dictionaryRepresentation;

/// -------------------------------
/// @name Utilities
/// -------------------------------

/**
 Create a @c UIColor instance from a 32-bit RGB value.
 
 This is a convenient way to get colors from code, when you can specify a color like full-red
 in hex notation like @c 0xFF0000.
 
 @param integer The color as a 32-bit RGB integer value. Only the last 24 bits are used.
 @return The color object.
 */
+ (UIColor *)colorWithRGBInteger:(UInt32)integer;

/**
 Create a @c UIColor instance from a 32-bit RGBA value.
 
 This is a convenient way to get colors from code, when you can specify a color like full-red
 50% transparent in hex notation like @c 0xFF000080.
 
 @param integer The color as a 32-bit RGBA integer value.
 @return The color object.
 */
+ (UIColor *)colorWithRGBAInteger:(UInt32)integer;

/**
 Create a 32-bit RGB integer value from a @c UIColor instance.
 
 @param color The color to convert.
 @return integer The color as a 32-bit RGB integer value. Only the last 24 bits are used.
 */
+ (UInt32)rgbIntegerForColor:(UIColor *)color;

/**
 Create a 32-bit RGBA integer value from a @c UIColor instance.
 
 @param color The color to convert.
 @return integer The color as a 32-bit RGBA integer value.
 */
+ (UInt32)rgbaIntegerForColor:(UIColor *)color;

@end

#pragma mark - Mutable support

@interface BRMutableUIStyle : BRUIStyle

/** The font style settings. */
@property (nonatomic, readwrite) BRMutableUIStyleFontSettings *fonts;

/** The color style settings. */
@property (nonatomic, readwrite) BRMutableUIStyleColorSettings *colors;

@end

NS_ASSUME_NONNULL_END
