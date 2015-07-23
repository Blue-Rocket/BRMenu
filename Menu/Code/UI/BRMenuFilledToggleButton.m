//
//  BRMenuFilledToggleButton.m
//  Menu
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuFilledToggleButton.h"

#import <QuartzCore/QuartzCore.h>
#import "BRMenuUIStyle.h"

@implementation BRMenuFilledToggleButton {
	BRMenuUIStyle *uiStyle;
	CALayer *shape;
	CALayer *fill;
	UIColor *fillColor;
	CGFloat diameter;
	CGFloat cornerRadius;
	CGFloat aspectRatio;
}

@synthesize diameter, cornerRadius;
@synthesize aspectRatio;

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		[self initializeFilledToggleButtonDefaults];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializeFilledToggleButtonDefaults];
	}
	return self;
}

- (void)initializeFilledToggleButtonDefaults {
	diameter = 18.0f;
	cornerRadius = 8.0f;
	aspectRatio = 20.0f / 9.0f; // rounded rect default for historical reasons
	self.animationDuration = 0.2f;
	
	shape = [self placementLayer];
	shape.borderWidth = 1.0f;
	shape.backgroundColor = [UIColor clearColor].CGColor;
	shape.cornerRadius = cornerRadius;
	shape.masksToBounds = YES;
	[self.layer addSublayer:shape];
	
	fill = [self placementLayer];
	[shape addSublayer:fill];
	
	[self addTarget:self action:@selector(autoAnimateToNextMode) forControlEvents:UIControlEventTouchUpInside];
	[self setNeedsLayout];
}

- (CALayer *)placementLayer {
	CALayer *l = [CALayer layer];
	l.contentsScale = [UIScreen mainScreen].scale;
	l.backgroundColor = [UIColor clearColor].CGColor;
	l.bounds = CGRectMake(0, 0, self.diameter, self.diameter);
	l.borderWidth = 0.0f;
	l.borderColor = self.uiStyle.controlDisabledColor.CGColor;
	return l;
}

- (BRMenuUIStyle *)uiStyle {
	return (uiStyle ? uiStyle : [BRMenuUIStyle defaultStyle]);
}

- (void)setUiStyle:(BRMenuUIStyle *)style {
	if ( style != uiStyle ) {
		BOOL changed = !([style.controlDisabledColor isEqual:uiStyle.controlDisabledColor]
						 && [style.appPrimaryColor isEqual:uiStyle.appPrimaryColor]);
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

- (void)setAspectRatio:(CGFloat)r {
	if ( ABS(r - aspectRatio) > 0.1 ) {
		aspectRatio = r;
		[self invalidateIntrinsicContentSize];
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
	return (fillColor ? fillColor : self.uiStyle.appPrimaryColor);
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
			[self didBecomeSelectedWithAnimation:animated];
		}
		[self layoutSubviews];
		[CATransaction commit];
	}
}

- (void)didBecomeSelectedWithAnimation:(BOOL)animated {
	// extending classes should implement
	// [self setPlacement:BRMenuOrderItemComponentPlacementWhole animated:animated];
}

- (void)autoAnimateToNextMode {
	if ( self.selected == NO ) {
		[self setSelected:YES animated:YES];
	} else {
		[self animateToNextMode];
	}
}

- (void)animateToNextMode {
	// extending classes should implement
}

- (CGSize)intrinsicContentSize {
	// size to the icon dimensions, plus a 2px padding
	return CGRectInset([self iconFrameInRect:CGRectZero], -2, -2).size;
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [self iconFrameInRect:CGRectMake(0, 0, size.width, size.height)].size;
}

- (CGRect)iconFrameInRect:(CGRect)b {
	return CGRectIntegral(CGRectMake(CGRectGetMidX(b) - diameter * aspectRatio * 0.5, CGRectGetMidY(b) - diameter * 0.5, diameter * aspectRatio, diameter));
}

- (void)layoutSubviews {
	[super layoutSubviews];
	const CGRect b = self.bounds;
	const CGRect frame = [self iconFrameInRect:b];
	CGColorRef color = (self.selected ? self.fillColor.CGColor : self.uiStyle.controlDisabledColor.CGColor);
	
	[CATransaction begin];
	[CATransaction setDisableActions:YES];
	shape.cornerRadius = cornerRadius;
	shape.frame = frame;
	[CATransaction commit];
	
	shape.borderColor = color;
	fill.backgroundColor = color;
	
	[self layoutFillLayer:fill inShapeLayer:shape];
}

- (void)layoutFillLayer:(CALayer *)fill inShapeLayer:(CALayer *)shape {
	// extending classes should configure the fill frame
}

@end
