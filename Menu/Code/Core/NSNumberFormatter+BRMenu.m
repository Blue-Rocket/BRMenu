//
//  NSNumberFormatter+BRMenu.m
//  Menu
//
//  Created by Matt on 25/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "NSNumberFormatter+BRMenu.h"

@implementation NSNumberFormatter (BRMenu)

+ (NSNumberFormatter *)standardBRMenuPriceFormatter {
	static NSNumberFormatter *result;
	if ( result == nil ) {
		// always format prices in US locale, regardless of device locale
		// this WILL need to be updated if other countries are to be supported... could be from environment setting
		NSLocale *usLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
		NSNumberFormatter *fmt = [[NSNumberFormatter alloc] init];
		[fmt setLocale:usLocale];
		[fmt setNumberStyle:NSNumberFormatterCurrencyStyle];
		result = fmt;
	}
	return result;
}

@end
