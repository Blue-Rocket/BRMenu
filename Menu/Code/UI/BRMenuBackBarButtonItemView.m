//
//  BRMenuBackBarButtonItemView.m
//  MenuKit
//
//  Created by Matt on 4/9/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuBackBarButtonItemView.h"

#import <BRLocalize/Core.h>
#import <BRStyle/BRUIStylishHost.h>
#import "UIView+BRUIStyle.h"

static const CGFloat kNormalHeight = 32.0f;
static const CGFloat kCompactHeight = 26.0f;
static const CGFloat kArrowMargin = 10.0f;
static const CGFloat kTextMargins = 5.0f;

@interface BRMenuBackBarButtonItemView () <BRUIStylishHost>
@end

@implementation BRMenuBackBarButtonItemView {
	NSString *title;
	BOOL inverse;
}

@dynamic uiStyle;
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

- (void)localizeWithAppStrings:(NSDictionary *)strings {
	self.title = [self.title localizedStringWithAppStrings:strings];
}

- (CGSize)intrinsicContentSize {
	CGSize textSize = [title sizeWithFont:self.uiStyle.fonts.actionFont
						constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
							lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat width = ceilf(textSize.width) + 2 * kTextMargins + kArrowMargin;
	return CGSizeMake(width, (self.traitCollection.verticalSizeClass == UIUserInterfaceSizeClassCompact
							  ? kCompactHeight : kNormalHeight));
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
	[super traitCollectionDidChange:previousTraitCollection];
	if ( self.traitCollection.verticalSizeClass != previousTraitCollection.verticalSizeClass ) {
		UIView *barView = nil;
		// if we're in a nav bar or tool bar, size ourselves according to our vertical size class
		if ( (barView = [self nearestAncestorViewOfType:[UINavigationBar class]]) != nil || (barView = [self nearestAncestorViewOfType:[UIToolbar class]]) != nil ) {
			CGSize s = [self intrinsicContentSize];
			CGRect b = self.bounds;
			b.origin.y = 0;
			b.size.height = s.height;
			self.bounds = b;
			[self setNeedsDisplay];
		}
	}
}

- (void)uiStyleDidChange:(BRUIStyle *)style {
	[self invalidateIntrinsicContentSize];
	[self setNeedsDisplay];
}

- (void)setTitle:(NSString *)text {
	if ( title != text ) {
		title = text;
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
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
	
	BRUIStyleControlStateColorSettings *controlSettings = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);
	
	//// Color Declarations
	UIColor* strokeColor = controlSettings.normalColorSettings.borderColor;
 	UIColor* labelColor = controlSettings.normalColorSettings.actionColor;
	
	//// Shadow Declarations
	UIColor* shadow = controlSettings.normalColorSettings.glossColor;
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
	UIFont* buttonLabelFont = self.uiStyle.fonts.actionFont;
	
	
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
													   CGRectGetMidY(frame) - (buttonLabelFont.ascender - buttonLabelFont.capHeight) - (buttonLabelFont.capHeight / 2.0),
													   CGRectGetWidth(frame) - 12,
													   buttonLabelFont.lineHeight));
	[labelColor setFill];
	[buttonLabelContent drawInRect: buttonLabelRect withFont: buttonLabelFont lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}

- (void)drawHighlighted {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();

	BRUIStyleControlStateColorSettings *controlSettings = (inverse ? self.uiStyle.colors.inverseControlSettings : self.uiStyle.colors.controlSettings);

	//// Color Declarations
	UIColor* strokeColor = controlSettings.highlightedColorSettings.borderColor;
	UIColor* labelColor = controlSettings.highlightedColorSettings.actionColor;
	UIColor* insetShadowColor = controlSettings.highlightedColorSettings.shadowColor;
	UIColor* highlightedFill = controlSettings.highlightedColorSettings.fillColor;
	
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
	UIFont* buttonLabelFont = self.uiStyle.fonts.actionFont;
	
	
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
