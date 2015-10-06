//
//  NSNumberFormatter+BRMenu.h
//  MenuKit
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <Foundation/Foundation.h>

/**
 BRMenu utilities for NSNumberFormatter.
 */
@interface NSNumberFormatter (BRMenu)

/**
 Get a formatter suitable for formatting prices in the US locale.
 
 The formatter will be configured to return @c NSDecimalNumber values when parsing strings.
 
 @return A number formatter instance.
 */
+ (NSNumberFormatter *)standardBRMenuPriceFormatter;

@end
