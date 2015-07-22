//
//  BRMenuBackBarButtonItemView.m
//  Menu
//
//  Created by Matt on 4/9/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import "BRMenuBackBarButtonItemView.h"

#import "BRMenuUIStyle.h"

static const CGFloat kNormalHeight = 32.0f;
static const CGFloat kArrowMargin = 10.0f;
static const CGFloat kTextMargins = 5.0f;

@implementation BRMenuBackBarButtonItemView {
	BRMenuUIStyle *uiStyle;
	NSString *title;
	BOOL inverse;
}

@synthesize title, inverse;

- (id)initWithFrame:(CGRect)frame {
	return [self initWithTitle:@""];
}

- (id)initWithTitle:(NSString *)text {
	if ( (self = [super initWithFrame:CGRectZero]) ) {
		self.title = text;
		self.backgroundColor = [UIColor clearColor];
		self.opaque = NO;
	}
	return self;
}

- (void)sizeToText {
	CGSize textSize = [title sizeWithFont:[self.uiStyle uiFont]
						constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
							lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat width = ceilf(textSize.width) + 2 * kTextMargins + kArrowMargin;
	self.bounds = CGRectMake(0, 0, width, kNormalHeight);
}

- (BRMenuUIStyle *)uiStyle {
	return (uiStyle ? uiStyle : [BRMenuUIStyle defaultStyle]);
}

- (void)setUiStyle:(BRMenuUIStyle *)style {
	if ( style != uiStyle ) {
		uiStyle = style;
		[self sizeToText];
		[self setNeedsDisplay];
	}
}
- (void)setTitle:(NSString *)text {
	if ( title != text ) {
		title = text;
		[self sizeToText];
	}
}

- (void)setHighlighted:(BOOL)highlighted {
	BOOL old = self.highlighted;
	[super setHighlighted:highlighted];
	if ( old != highlighted ) {
		[self setNeedsDisplay];
	}
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = (inverse ? [self.uiStyle inverseControlBorderColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (inverse ? [self.uiStyle inverseControlTextColor] : [self.uiStyle controlTextColor]);
	
	//// Shadow Declarations
	UIColor* shadow = (inverse ?[self.uiStyle inverseControlBorderGlossColor] : [self.uiStyle controlBorderGlossColor]);
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Subframes
	CGRect arrowFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 15, 5);
	CGRect arrowFrame2 = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + CGRectGetHeight(frame) - 5, 15, 5);
	CGRect arrowFrame3 = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 5) * 0.51852 + 0.5), 5, 5);
	
	
	//// Abstracted Attributes
	NSString* buttonLabelContent = self.title;
	UIFont* buttonLabelFont = [self.uiStyle uiFont];
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPath];
	[borderPath moveToPoint: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 2.5)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(arrowFrame) - 1.75, CGRectGetMinY(arrowFrame) + 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 1.84) controlPoint2: CGPointMake(CGRectGetMaxX(arrowFrame) - 5.15, CGRectGetMinY(arrowFrame) + 1.5)];
	[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 3.69, CGRectGetMinY(frame) + 1.5)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 4.88) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 1.93, CGRectGetMinY(frame) + 1.5) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 3.01)];
	[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMaxY(frame) - 4.88)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 3.69, CGRectGetMaxY(frame) - 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMaxY(frame) - 3.01) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 1.93, CGRectGetMaxY(frame) - 1.5)];
	[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(arrowFrame2) - 1.75, CGRectGetMinY(arrowFrame2) + 3.5)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 2.5) controlPoint1: CGPointMake(CGRectGetMaxX(arrowFrame2) - 5.17, CGRectGetMinY(arrowFrame2) + 3.5) controlPoint2: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 3.16)];
	[borderPath closePath];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	CGContextRestoreGState(context);
	
	
	[self drawLabel:buttonLabelContent inFrame:frame withFont:buttonLabelFont color:labelColor];
}

- (void)drawLabel:(NSString *)buttonLabelContent inFrame:(CGRect)frame withFont:(UIFont *)buttonLabelFont color:(UIColor *)labelColor {
	//// Button Label Drawing
	CGRect buttonLabelRect = CGRectIntegral(CGRectMake(CGRectGetMinX(frame) + 10,
													   CGRectGetMidY(frame) - (buttonLabelFont.lineHeight / 2.0) + ABS(buttonLabelFont.descender),
													   CGRectGetWidth(frame) - 12,
													   buttonLabelFont.lineHeight));
	[labelColor setFill];
	[buttonLabelContent drawInRect: buttonLabelRect withFont: buttonLabelFont lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = (inverse ? [self.uiStyle inverseControlBorderColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (inverse ? [self.uiStyle inverseControlTextColor] : [self.uiStyle controlTextColor]);
	UIColor* insetShadowColor = (inverse ? [self.uiStyle inverseControlHighlightedShadowColor] : [self.uiStyle controlHighlightedShadowColor]);
	UIColor* highlightedFill = (inverse ? [self.uiStyle inverseControlHighlightedColor] : [self.uiStyle controlHighlightedColor]);
	
	//// Shadow Declarations
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Subframes
	CGRect arrowFrame = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), 15, 5);
	CGRect arrowFrame2 = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + CGRectGetHeight(frame) - 5, 15, 5);
	CGRect arrowFrame3 = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + floor((CGRectGetHeight(frame) - 5) * 0.51852 + 0.5), 5, 5);
	
	
	//// Abstracted Attributes
	NSString* buttonLabelContent = self.title;
	UIFont* buttonLabelFont = [self.uiStyle uiFont];
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPath];
	[borderPath moveToPoint: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 2.5)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(arrowFrame) - 1.75, CGRectGetMinY(arrowFrame) + 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 1.84) controlPoint2: CGPointMake(CGRectGetMaxX(arrowFrame) - 5.15, CGRectGetMinY(arrowFrame) + 1.5)];
	[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 3.69, CGRectGetMinY(frame) + 1.5)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 4.88) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 1.93, CGRectGetMinY(frame) + 1.5) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMinY(frame) + 3.01)];
	[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMaxY(frame) - 4.88)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(frame) - 3.69, CGRectGetMaxY(frame) - 1.5) controlPoint1: CGPointMake(CGRectGetMaxX(frame) - 0.5, CGRectGetMaxY(frame) - 3.01) controlPoint2: CGPointMake(CGRectGetMaxX(frame) - 1.93, CGRectGetMaxY(frame) - 1.5)];
	[borderPath addLineToPoint: CGPointMake(CGRectGetMaxX(arrowFrame2) - 1.75, CGRectGetMinY(arrowFrame2) + 3.5)];
	[borderPath addCurveToPoint: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 2.5) controlPoint1: CGPointMake(CGRectGetMaxX(arrowFrame2) - 5.17, CGRectGetMinY(arrowFrame2) + 3.5) controlPoint2: CGPointMake(CGRectGetMaxX(arrowFrame3) - 4.5, CGRectGetMinY(arrowFrame3) + 3.16)];
	[borderPath closePath];
	[highlightedFill setFill];
	[borderPath fill];
	
	////// Border Inner Shadow
	CGRect borderBorderRect = CGRectInset([borderPath bounds], -depressedShadowBlurRadius, -depressedShadowBlurRadius);
	borderBorderRect = CGRectOffset(borderBorderRect, -depressedShadowOffset.width, -depressedShadowOffset.height);
	borderBorderRect = CGRectInset(CGRectUnion(borderBorderRect, [borderPath bounds]), -1, -1);
	
	UIBezierPath* borderNegativePath = [UIBezierPath bezierPathWithRect: borderBorderRect];
	[borderNegativePath appendPath: borderPath];
	borderNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = depressedShadowOffset.width + round(borderBorderRect.size.width);
		CGFloat yOffset = depressedShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									depressedShadowBlurRadius,
									depressedShadow.CGColor);
		
		[borderPath addClip];
		CGAffineTransform transform = CGAffineTransformMakeTranslation(-round(borderBorderRect.size.width), 0);
		[borderNegativePath applyTransform: transform];
		[[UIColor grayColor] setFill];
		[borderNegativePath fill];
	}
	CGContextRestoreGState(context);
	
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	
	
	[self drawLabel:buttonLabelContent inFrame:frame withFont:buttonLabelFont color:labelColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		[self drawHighlighted];
	} else {
		[self drawNormal];
	}
}

@end
