//
//  BRMenuLightHeavyQuantityButton.m
//  Menu
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuLightHeavyQuantityButton.h"

#import <QuartzCore/QuartzCore.h>
#import "BRMenuUIStyle.h"

@implementation BRMenuLightHeavyQuantityButton {
	BRMenuOrderItemComponentQuantity quantity;
}

@synthesize quantity;

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
		[self initializeOrderItemComponentQuantityButtonDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializeOrderItemComponentQuantityButtonDefaults];
	}
	return self;
}

- (void)initializeOrderItemComponentQuantityButtonDefaults {
	quantity = BRMenuOrderItemComponentQuantityNormal;
}
- (void)setQuantity:(BRMenuOrderItemComponentQuantity)value {
	[self setQuantity:value animated:NO];
}

- (void)setQuantity:(BRMenuOrderItemComponentQuantity)value animated:(const BOOL)animated {
	if ( value != quantity ) {
		quantity = value;
		[CATransaction begin];
		if ( animated == NO ) {
			[CATransaction setDisableActions:YES];
		} else {
			[CATransaction setAnimationDuration:self.animationDuration];
		}
		[self layoutSubviews];
		[CATransaction commit];
	}
}

- (void)didBecomeSelectedWithAnimation:(BOOL)animated {
	[super didBecomeSelectedWithAnimation:animated];
	[self setQuantity:BRMenuOrderItemComponentQuantityNormal animated:animated];
}

- (void)animateToNextMode {
	BRMenuOrderItemComponentQuantity next;
	switch ( quantity ) {
		case BRMenuOrderItemComponentQuantityNormal:
			next = BRMenuOrderItemComponentQuantityLight;
			break;
			
			
		case BRMenuOrderItemComponentQuantityLight:
			next = BRMenuOrderItemComponentQuantityHeavy;
			break;
			
		case BRMenuOrderItemComponentQuantityHeavy:
			next = BRMenuOrderItemComponentQuantityNormal;
			break;
	}
	[self setQuantity:next animated:YES];
}

- (void)layoutFillLayer:(CALayer *)fill inShapeLayer:(CALayer *)shape {
	const CGRect fillBounds = shape.bounds;
	
	switch ( quantity ) {
		case BRMenuOrderItemComponentQuantityNormal:
			fill.frame = CGRectIntegral(CGRectMake(CGRectGetMinX(fillBounds), CGRectGetMidY(fillBounds),
												   CGRectGetWidth(fillBounds), CGRectGetHeight(fillBounds) * 0.5));
			break;
			
		case BRMenuOrderItemComponentQuantityLight:
			fill.frame = CGRectIntegral(CGRectMake(CGRectGetMinX(fillBounds), CGRectGetMinY(fillBounds) + CGRectGetHeight(fillBounds) * 0.8,
												   CGRectGetWidth(fillBounds), CGRectGetHeight(fillBounds) * 0.2));
			break;
			
		case BRMenuOrderItemComponentQuantityHeavy:
			fill.frame = CGRectIntegral(CGRectMake(CGRectGetMinX(fillBounds), CGRectGetMinY(fillBounds) + CGRectGetHeight(fillBounds) * 0.25,
												   CGRectGetWidth(fillBounds), CGRectGetHeight(fillBounds) * 0.75));
			break;
	}
}

@end
