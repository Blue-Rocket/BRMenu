//
//  BRMenuStepperStepper.m
//  Menu
//
//  Created by Matt on 4/12/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import "BRMenuStepper.h"

#import "BRMenuUIStyle.h"

static const CGFloat kHorizontalPadding = 5.0;
static const CGFloat kVerticalPadding = 5.0;
static const CGFloat kNaturalWidth = 80.0;
static const CGFloat kNaturalHeight = 28.0;
static const CGFloat kBadgeWidth = 28.0;

@interface BRMenuStepperMinusButton : UIControl
@property (weak) BRMenuStepper *stepper;
@end

@interface BRMenuStepperPlusButton : UIControl
@property (weak) BRMenuStepper *stepper;
@end


@implementation BRMenuStepper {
	BRMenuUIStyle *uiStyle;
	__weak UILabel *badgeLabel;
	__weak BRMenuStepperMinusButton *minusButton;
	__weak BRMenuStepperPlusButton *plusButton;
}

@synthesize uiStyle;

- (id)initWithFrame:(CGRect)frame {
    if ( (self = [super initWithFrame:frame]) ) {
		[self initializeStepper];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		[self initializeStepper];
	}
	return self;
}

- (void)initializeStepper {
	UILabel *l = [[UILabel alloc] initWithFrame:CGRectZero];
	l.font = [self.uiStyle uiBoldFont];
	l.font = [l.font fontWithSize:l.font.pointSize + 2.0];
	l.textColor = [self.uiStyle controlBorderColor];
	l.backgroundColor = [UIColor clearColor];
	l.textAlignment = NSTextAlignmentCenter;
	[self addSubview:l];
	badgeLabel = l;
	
	BRMenuStepperMinusButton *minus = [[BRMenuStepperMinusButton alloc] initWithFrame:CGRectZero];
	minus.opaque = NO;
	minus.stepper = self;
	[minus addTarget:self action:@selector(minus:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:minus];
	minusButton = minus;
	
	BRMenuStepperPlusButton *plus = [[BRMenuStepperPlusButton alloc] initWithFrame:CGRectZero];
	plus.opaque = NO;
	plus.stepper = self;
	[plus addTarget:self action:@selector(plus:) forControlEvents:UIControlEventTouchUpInside];
	[self addSubview:plus];
	plusButton = plus;
	
	self.opaque = NO;
	self.value = 0;
	self.minimumValue = 0;
	self.maximumValue = 32;
	self.stepValue = 1;
	
	[self setNeedsLayout];
}

- (BRMenuUIStyle *)uiStyle {
	return (uiStyle ? uiStyle : [BRMenuUIStyle defaultStyle]);
}

- (CGSize)sizeThatFits:(CGSize)size {
	return CGSizeMake(kNaturalWidth + 2 * kHorizontalPadding, kNaturalHeight + 2 * kVerticalPadding);
}

- (void)layoutSubviews {
	[super layoutSubviews];
	CGRect bounds = self.bounds;

	CGRect frame = CGRectMake(CGRectGetMidX(self.bounds) - (kNaturalWidth / 2.0), CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, kNaturalWidth, kNaturalHeight);

	//// Subframes
	CGRect minusFrame = CGRectMake(CGRectGetMinX(frame) - kHorizontalPadding, 0, 25 + kHorizontalPadding * 2.0, bounds.size.height);
	CGRect plusFrame = CGRectMake(CGRectGetMaxX(frame) - 25 - kHorizontalPadding, 0, 25 + kHorizontalPadding * 2.0, bounds.size.height);
	minusButton.frame = minusFrame;
	plusButton.frame = plusFrame;

	CGRect badgeFrame = CGRectMake(CGRectGetMidX(bounds) - (kBadgeWidth / 2.0),
								   CGRectGetMidY(bounds) - (badgeLabel.font.lineHeight / 2.0) + ABS(badgeLabel.font.descender) - 1.0,
								   kBadgeWidth,
								   badgeLabel.font.lineHeight);
	badgeLabel.frame = badgeFrame;
}

- (void)setValue:(NSInteger)newValue {
	NSInteger old = _value;
	_value = newValue;
	badgeLabel.text = [NSString stringWithFormat:@"%ld", (long)_value];
	if ( old != newValue ) {
		badgeLabel.textColor = (newValue > 0 ? [self.uiStyle headingColor] : [self.uiStyle controlBorderColor]);
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		
		// enable the opposite button if we moved off the edge cases
		if ( old == _minimumValue ) {
			[minusButton setNeedsDisplay];
		} else if ( old == _maximumValue ) {
			[plusButton setNeedsDisplay];
		}
	}
}

- (void)minus:(id)sender {
	NSInteger offset = 0;
	if ( _value > _minimumValue ) {
		offset = -_stepValue;
	}
	self.value = MAX(_minimumValue, _value + offset);
}

- (void)plus:(id)sender {
	NSInteger offset = 0;
	if ( _value < _maximumValue ) {
		offset = _stepValue;
	}
	self.value = MIN(_maximumValue, _value + offset);
}

- (void)drawRect:(CGRect)rect {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = [self.uiStyle controlBorderColor];
	
	//// Shadow Declarations
	UIColor* shadow = [self.uiStyle controlBorderGlossColor];
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = CGRectMake(CGRectGetMidX(self.bounds) - (kNaturalWidth / 2.0), CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, kNaturalWidth, kNaturalHeight);
	
	//// Subframes
	CGRect boxFrame = CGRectMake(frame.origin.x + 24.5, frame.origin.y + 0.5, frame.size.width - 49, 25);
	
	
	//// Box Drawing
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	CGContextSetLineWidth(context, 1);
	CGContextStrokeRect(context, boxFrame);
	CGContextRestoreGState(context);
	
}

@end

#pragma mark -

@implementation BRMenuStepperMinusButton

- (void)drawLabelInFrame:(CGRect)minusFrame context:(CGContextRef)context strokeColor:(UIColor *)strokeColor textColor:(UIColor *)labelColor {
	//// Minus Drawing
	UIBezierPath* minusPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(minusFrame) + 7, CGRectGetMinY(minusFrame) + floor((CGRectGetHeight(minusFrame) - 2) * 0.48000 + 0.5), 12, 2)];
	if ( self.stepper.value == self.stepper.minimumValue ) {
		[strokeColor setFill];
	} else {
		[labelColor setFill];
	}
	[minusPath fill];
}

- (CGRect)minusFrame {
	return CGRectMake(kHorizontalPadding, CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, 25, 27);
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = [self.stepper.uiStyle controlBorderColor];
	
	//// Shadow Declarations
	UIColor* shadow = [self.stepper.uiStyle controlBorderGlossColor];
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Subframes
	CGRect minusFrame = [self minusFrame];
	
	
	//// Minus tab Drawing
	UIBezierPath* minusTabPath = [UIBezierPath bezierPath];
	[minusTabPath moveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 23.71)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 4.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	minusTabPath.lineWidth = 1;
	[minusTabPath stroke];
	CGContextRestoreGState(context);
	
	[self drawLabelInFrame:minusFrame context:context strokeColor:strokeColor textColor:[self.stepper.uiStyle controlTextColor]];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = [self.stepper.uiStyle controlBorderColor];
	UIColor* labelColor = [self.stepper.uiStyle controlTextColor];
	UIColor* insetShadowColor = [labelColor colorWithAlphaComponent: 0.5];
	UIColor* highlightedFill = [self.stepper.uiStyle controlHighlightedColor];
	
	//// Shadow Declarations
	UIColor* shadow = [self.stepper.uiStyle controlBorderGlossColor];
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Subframes
	CGRect minusFrame = [self minusFrame];
	
	
	//// Minus tab Drawing
	UIBezierPath* minusTabPath = [UIBezierPath bezierPath];
	[minusTabPath moveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 23.71)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 4.5)];
	[minusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 4.5, CGRectGetMinY(minusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(minusFrame) + 0.5, CGRectGetMinY(minusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(minusFrame) + 2.29, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 0.5)];
	[minusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(minusFrame) + 24.5, CGRectGetMinY(minusFrame) + 25.5)];
	[minusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	minusTabPath.lineWidth = 1;
	[minusTabPath stroke];
	CGContextRestoreGState(context);
	[highlightedFill setFill];
	[minusTabPath fill];
	
	////// Minus tab Inner Shadow
	CGRect minusTabBorderRect = CGRectInset([minusTabPath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	minusTabBorderRect = CGRectOffset(minusTabBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	minusTabBorderRect = CGRectInset(CGRectUnion(minusTabBorderRect, [minusTabPath bounds]), -1, -1);
	
	UIBezierPath* minusTabNegativePath = [UIBezierPath bezierPathWithRect: minusTabBorderRect];
	[minusTabNegativePath appendPath: minusTabPath];
	minusTabNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(minusTabBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[minusTabPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(minusTabBorderRect.size.width), 0);
		[minusTabNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[minusTabNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	//[strokeColor setStroke];
	//minusTabPath.lineWidth = 1;
	//[minusTabPath stroke];
	
	
	[self drawLabelInFrame:minusFrame context:context strokeColor:strokeColor textColor:labelColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		if ( self.stepper.value > self.stepper.minimumValue ) {
			[self drawHighlighted];
		} else {
			[self drawNormal];
		}
	} else {
		[self drawNormal];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self setNeedsDisplay];
	}
}

@end

#pragma mark - 

@implementation BRMenuStepperPlusButton

- (void)drawLabelInFrame:(CGRect)plusFrame context:(CGContextRef)context strokeColor:(UIColor *)strokeColor textColor:(UIColor *)labelColor {
	//// Plus V Drawing
	UIBezierPath* plusVPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(plusFrame) + CGRectGetWidth(plusFrame) - 14, CGRectGetMinY(plusFrame) + floor((CGRectGetHeight(plusFrame) - 12) * 0.46667 + 0.5), 2, 12)];
	if ( self.stepper.value >= self.stepper.maximumValue ) {
		[strokeColor setFill];
	} else {
		[labelColor setFill];
	}
	[plusVPath fill];
	
	
	//// Plus H Drawing
	UIBezierPath* plusHPath = [UIBezierPath bezierPathWithRect: CGRectMake(CGRectGetMinX(plusFrame) + CGRectGetWidth(plusFrame) - 19, CGRectGetMinY(plusFrame) + floor((CGRectGetHeight(plusFrame) - 2) * 0.48000 + 0.5), 12, 2)];
	if ( self.stepper.value >= self.stepper.maximumValue ) {
		[strokeColor setFill];
	} else {
		[labelColor setFill];
	}
	[plusHPath fill];
}

- (CGRect)plusFrame {
	return CGRectMake(kHorizontalPadding, CGRectGetMidY(self.bounds) - (kNaturalHeight / 2.0) + 1.0, 25, 27);
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = [self.stepper.uiStyle controlBorderColor];
	
	//// Shadow Declarations
	UIColor* shadow = [self.stepper.uiStyle controlBorderGlossColor];
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect plusFrame = [self plusFrame];
	
	
	//// Plus tab Drawing
	UIBezierPath* plusTabPath = [UIBezierPath bezierPath];
	[plusTabPath moveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 23.71)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 4.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	plusTabPath.lineWidth = 1;
	[plusTabPath stroke];
	CGContextRestoreGState(context);
	
	[self drawLabelInFrame:plusFrame context:context strokeColor:strokeColor textColor:[self.stepper.uiStyle controlTextColor]];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = [self.stepper.uiStyle controlBorderColor];
	UIColor* labelColor = [self.stepper.uiStyle controlTextColor];
	UIColor* insetShadowColor = [labelColor colorWithAlphaComponent: 0.5];
	UIColor* highlightedFill = [self.stepper.uiStyle controlHighlightedColor];
	
	//// Shadow Declarations
	UIColor* shadow = [self.stepper.uiStyle controlBorderGlossColor];
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Frames
	CGRect plusFrame = [self plusFrame];
	
	
	//// Plus tab Drawing
	UIBezierPath* plusTabPath = [UIBezierPath bezierPath];
	[plusTabPath moveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 21.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 25.5) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 23.71)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 4.5)];
	[plusTabPath addCurveToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 20.5, CGRectGetMinY(plusFrame) + 0.5) controlPoint1: CGPointMake(CGRectGetMinX(plusFrame) + 24.5, CGRectGetMinY(plusFrame) + 2.29) controlPoint2: CGPointMake(CGRectGetMinX(plusFrame) + 22.71, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 0.5)];
	[plusTabPath addLineToPoint: CGPointMake(CGRectGetMinX(plusFrame) + 0.5, CGRectGetMinY(plusFrame) + 25.5)];
	[plusTabPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	plusTabPath.lineWidth = 1;
	[plusTabPath stroke];
	CGContextRestoreGState(context);
	[highlightedFill setFill];
	[plusTabPath fill];
	
	////// Plus tab Inner Shadow
	CGRect plusTabBorderRect = CGRectInset([plusTabPath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	plusTabBorderRect = CGRectOffset(plusTabBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	plusTabBorderRect = CGRectInset(CGRectUnion(plusTabBorderRect, [plusTabPath bounds]), -1, -1);
	
	UIBezierPath* plusTabNegativePath = [UIBezierPath bezierPathWithRect: plusTabBorderRect];
	[plusTabNegativePath appendPath: plusTabPath];
	plusTabNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(plusTabBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[plusTabPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(plusTabBorderRect.size.width), 0);
		[plusTabNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[plusTabNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	//[strokeColor setStroke];
	//plusTabPath.lineWidth = 1;
	//[plusTabPath stroke];
	
	[self drawLabelInFrame:plusFrame context:context strokeColor:strokeColor textColor:labelColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		if ( self.stepper.value < self.stepper.maximumValue ) {
			[self drawHighlighted];
		} else {
			[self drawNormal];
		}
	} else {
		[self drawNormal];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self setNeedsDisplay];
	}
}

@end