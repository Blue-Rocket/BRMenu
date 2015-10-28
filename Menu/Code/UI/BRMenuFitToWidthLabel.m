//
//  BRMenuFitToWidthLabel.m
//  MenuKit
//
//  Created by Matt on 12/2/14.
//  Copyright (c) 2014 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuFitToWidthLabel.h"

@implementation BRMenuFitToWidthLabel

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		self.numberOfLines = 0;
		self.lineBreakMode = NSLineBreakByWordWrapping;
		self.backgroundColor = [UIColor clearColor];
		[self setContentCompressionResistancePriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
		[self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
		[self setContentHuggingPriority:UILayoutPriorityDefaultLow forAxis:UILayoutConstraintAxisHorizontal];
		[self setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	}
	return self;
}

@end
