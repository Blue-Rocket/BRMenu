//
//  BRMenuLeftRightPlacementButton.m
//  MenuKit
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuLeftRightPlacementButton.h"

#import <QuartzCore/QuartzCore.h>
#import "BRMenuUIStyle.h"

@implementation BRMenuLeftRightPlacementButton {
	BRMenuOrderItemComponentPlacement placement;
}

@synthesize placement;

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
		[self initializeOrderItemComponentPlacementButtonDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializeOrderItemComponentPlacementButtonDefaults];
	}
	return self;
}

- (void)initializeOrderItemComponentPlacementButtonDefaults {
	placement = BRMenuOrderItemComponentPlacementWhole;
}

#pragma - Accessors

- (void)setPlacement:(BRMenuOrderItemComponentPlacement)value {
	[self setPlacement:value animated:NO];
}

- (void)setPlacement:(BRMenuOrderItemComponentPlacement)value animated:(const BOOL)animated {
	if ( value != placement ) {
		placement = value;
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

#pragma mark - BRMenuModelPropertyEditor

- (NSString *)propertyEditorKeyPathForModel:(Class)modelClass {
	return @"placement";
}

- (id)propertyEditorValue {
	return @(placement);
}

- (void)setPropertyEditorValue:(id)value {
	placement = [value intValue];
}

#pragma mark - Internal API

- (void)animateToNextMode {
	[super animateToNextMode];
	BRMenuOrderItemComponentPlacement next;
	switch ( placement ) {
		case BRMenuOrderItemComponentPlacementWhole:
			next = BRMenuOrderItemComponentPlacementLeft;
			break;
			
			
		case BRMenuOrderItemComponentPlacementLeft:
			next = BRMenuOrderItemComponentPlacementRight;
			break;
			
		case BRMenuOrderItemComponentPlacementRight:
			next = BRMenuOrderItemComponentPlacementWhole;
			break;
	}
	[self setPlacement:next animated:YES];
}

- (void)layoutFillLayer:(CALayer *)fill inShapeLayer:(CALayer *)shape {
	const CGRect fillBounds = shape.bounds;
	switch ( placement ) {
		case BRMenuOrderItemComponentPlacementWhole:
			fill.frame = fillBounds;
			break;
			
		case BRMenuOrderItemComponentPlacementLeft:
			fill.frame = CGRectIntegral(CGRectMake(CGRectGetMinX(fillBounds), CGRectGetMinY(fillBounds),
												   CGRectGetWidth(fillBounds) * 0.5, CGRectGetHeight(fillBounds)));
			break;
			
		case BRMenuOrderItemComponentPlacementRight:
			fill.frame = CGRectIntegral(CGRectMake(CGRectGetMidX(fillBounds), CGRectGetMinY(fillBounds),
												   CGRectGetWidth(fillBounds) * 0.5, CGRectGetHeight(fillBounds)));
			break;
	}
}

@end
