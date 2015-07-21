//
//  BRMenuOrderItemAttributes.m
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderItemAttributes.h"

@implementation BRMenuOrderItemAttributes

- (id)init {
	return [self initWithTakeAway:NO];
}

- (id)initWithTakeAway:(BOOL)takeAway {
	if ( (self = [super init]) ) {
		self.takeAway = takeAway;
	}
	return self;
}

@end