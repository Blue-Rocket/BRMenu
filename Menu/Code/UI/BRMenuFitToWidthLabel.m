//
//  BRMenuFitToWidthLabel.m
//  Menu
//
//  Created by Matt on 12/2/14.
//  Copyright (c) 2014 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuFitToWidthLabel.h"

@implementation BRMenuFitToWidthLabel

- (void)setBounds:(CGRect)bounds {
	[super setBounds:bounds];
	if ( self.numberOfLines == 0 && bounds.size.width != self.preferredMaxLayoutWidth ) {
		self.preferredMaxLayoutWidth = self.bounds.size.width;
		[self setNeedsUpdateConstraints];
	}
}

@end
