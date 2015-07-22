//
//  BRMenuLeftRightPlacementButton.m
//  Menu
//
//  Created by Matt on 4/10/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import "BRMenuLeftRightPlacementButton.h"

#import <QuartzCore/QuartzCore.h>
#import "BRMenuUIStyle.h"

@implementation BRMenuLeftRightPlacementButton {
	BRMenuUIStyle *uiStyle;
	CALayer *shape;
	CALayer *fill;
	BRMenuOrderItemComponentPlacement placement;
	UIColor *fillColor;
	CGFloat diameter;
	CGFloat cornerRadius;
}

@synthesize uiStyle;
@synthesize placement, diameter, cornerRadius;
@synthesize fillColor;

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
	diameter = 18.0f;
	cornerRadius = 8.0f;
	self.animationDuration = 0.2f;

	shape = [self placementLayer];
	shape.borderWidth = 1.0f;
	shape.backgroundColor = [UIColor clearColor].CGColor;
	shape.cornerRadius = cornerRadius;
	shape.masksToBounds = YES;
	[self.layer addSublayer:shape];
	
	fill = [self placementLayer];
	[shape addSublayer:fill];
	
	[self addTarget:self action:@selector(autoAnimateToNextPlacementMode) forControlEvents:UIControlEventTouchUpInside];
	[self setNeedsLayout];
}

- (CALayer *)placementLayer {
	CALayer *l = [CALayer layer];
	l.contentsScale = [UIScreen mainScreen].scale;
	l.backgroundColor = [UIColor clearColor].CGColor;
	l.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
	l.borderWidth = 0.0f;
	l.borderColor = self.uiStyle.controlBorderColor.CGColor;
	return l;
}

- (BRMenuUIStyle *)uiStyle {
	return (uiStyle ? uiStyle : [BRMenuUIStyle defaultStyle]);
}

- (void)setUiStyle:(BRMenuUIStyle *)style {
	if ( style != uiStyle ) {
		BOOL changed = ([style.controlBorderColor isEqual:uiStyle.controlBorderColor] == NO);
		uiStyle = style;
		if ( changed ) {
			[self setNeedsLayout];
		}
	}
}

- (void)setDiameter:(CGFloat)d {
	if ( ABS(d - diameter) > 0.1 ) {
		diameter = d;
		[self invalidateIntrinsicContentSize];
		[self setNeedsLayout];
	}
}

- (void)setCornerRadius:(CGFloat)r {
	if ( ABS(r - cornerRadius) > 0.1 ) {
		cornerRadius = r;
		[self setNeedsLayout];
	}
}

- (void)setFillColor:(UIColor *)color {
	if ( color != fillColor ) {
		fillColor = color;
		[self setNeedsLayout];
	}
}

- (UIColor *)fillColor {
	return (fillColor ? fillColor : self.uiStyle.headingColor);
}

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

- (void)setSelected:(BOOL)selected {
	[self setSelected:selected animated:NO];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
	if ( selected != self.selected ) {
		[super setSelected:selected];
		[CATransaction begin];
		if ( animated == NO ) {
			[CATransaction setDisableActions:YES];
		} else {
			[CATransaction setAnimationDuration:self.animationDuration];
		}
		if ( selected == NO ) {
			[self setPlacement:BRMenuOrderItemComponentPlacementWhole animated:animated];
		}
		[self layoutSubviews];
		[CATransaction commit];
	}
}

- (void)autoAnimateToNextPlacementMode {
	if ( self.selected == NO ) {
		[self setSelected:YES animated:YES];
	} else {
		[self animateToNextPlacementMode];
	}
}

- (void)animateToNextPlacementMode {
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

- (CGSize)intrinsicContentSize {
	// size to the icon dimensions, plus a 2px padding
	return CGRectInset([self iconFrameInRect:CGRectZero], -2, -2).size;
}


- (CGSize)sizeThatFits:(CGSize)size {
	return [self iconFrameInRect:CGRectMake(0, 0, size.width, size.height)].size;
}

- (CGRect)iconFrameInRect:(CGRect)b {
	return CGRectIntegral(CGRectMake(CGRectGetMidX(b) - diameter * (20.0 / 18.0), CGRectGetMidY(b) - diameter * 0.5, diameter * (20.0 / 9.0), diameter));
}

- (void)layoutSubviews {
	[super layoutSubviews];
	const CGRect b = self.bounds;
	const CGRect frame = [self iconFrameInRect:b];
	CGColorRef color = (self.selected ? self.fillColor.CGColor : self.uiStyle.controlBorderColor.CGColor);
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	shape.cornerRadius = cornerRadius;
	shape.frame = frame;
	[CATransaction commit];
	
	const CGRect fillBounds = shape.bounds;
	
	shape.borderColor = color;
	fill.backgroundColor = color;

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
