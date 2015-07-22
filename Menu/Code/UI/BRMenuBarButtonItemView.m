//
//  BRMenuBarButtonItemView.m
//  Menu
//
//  Created by Matt on 4/8/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuBarButtonItemView.h"

#import "BRMenuUIStyle.h"

static const CGFloat kNormalHeight = 32.0f;
static const CGFloat kTextMargins = 10.0f;
static const CGFloat kBadgeTextMargins = 5.0f;
static const CGFloat kBadgeMinWidth = 24.0f;
static const CGFloat kMinWidth = 48.0f;

@implementation BRMenuBarButtonItemView {
	BRMenuUIStyle *uiStyle;
	NSString *title;
	NSString *badgeText;
	BOOL inverse;
}

@synthesize badgeText, title, inverse;

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		self.opaque = NO;
		self.title = @"";
	}
	return self;
}

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

- (CGSize)sizeThatFits:(CGSize)size {
	return [self intrinsicContentSize];
}

- (CGSize)intrinsicContentSize {
	CGSize textSize = [title sizeWithFont:[self.uiStyle uiFont]
						constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
							lineBreakMode:NSLineBreakByWordWrapping];
	CGFloat width = ceilf(textSize.width) + 2 * kTextMargins;
	if ( [badgeText length] > 0 ) {
		CGSize badgeTextSize = [badgeText sizeWithFont:[self.uiStyle uiFont]
									 constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
										 lineBreakMode:NSLineBreakByWordWrapping];
		CGFloat badgeWidth = ceilf(badgeTextSize.width) + 2 * kBadgeTextMargins;
		badgeWidth = MAX(kBadgeMinWidth, badgeWidth);
		width += badgeWidth;
	}
	width = MAX(kMinWidth, width);
	if ( (int)width % 2 == 1 ) {
		width += 1;
	}
	return CGSizeMake(width, kNormalHeight);
}

- (BRMenuUIStyle *)uiStyle {
	return (uiStyle ? uiStyle : [BRMenuUIStyle defaultStyle]);
}

- (void)setUiStyle:(BRMenuUIStyle *)style {
	if ( style != uiStyle ) {
		uiStyle = style;
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
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

- (void)setBadgeText:(NSString *)text {
	if ( badgeText != text ) {
		badgeText = text;
		[self invalidateIntrinsicContentSize];
		[self setNeedsDisplay];
	}
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
	UIColor* innerShadow = insetShadowColor;
	CGSize innerShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat innerShadowBlurRadius = 2;
	
	//// Frames
	CGRect frame = self.bounds;
	
	
	//// Abstracted Attributes
	NSString* textContent = self.title;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	if ( self.fillColor != nil ) {
		[self.fillColor setFill];
		[borderPath fill];
	}
	[highlightedFill setFill];
	[borderPath fill];
	
	////// Border Inner Shadow
	CGRect borderBorderRect = CGRectInset([borderPath bounds], -innerShadowBlurRadius, -innerShadowBlurRadius);
	borderBorderRect = CGRectOffset(borderBorderRect, -innerShadowOffset.width, -innerShadowOffset.height);
	borderBorderRect = CGRectInset(CGRectUnion(borderBorderRect, [borderPath bounds]), -1, -1);
	
	UIBezierPath* borderNegativePath = [UIBezierPath bezierPathWithRect: borderBorderRect];
	[borderNegativePath appendPath: borderPath];
	borderNegativePath.usesEvenOddFillRule = YES;
	
	CGContextSaveGState(context);
	{
		CGFloat xOffset = innerShadowOffset.width + round(borderBorderRect.size.width);
		CGFloat yOffset = innerShadowOffset.height;
		CGContextSetShadowWithColor(context,
									CGSizeMake(xOffset + copysign(0.1, xOffset), yOffset + copysign(0.1, yOffset)),
									innerShadowBlurRadius,
									innerShadow.CGColor);
		
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
	
	[self drawLabel:textContent inFrame:frame withFont:[self.uiStyle uiFont] color:labelColor];
}

- (CGFloat)badgeFrameWidth {
	CGFloat width = 0.0;
	if ( [badgeText length] > 0 ) {
		CGSize badgeTextSize = [badgeText sizeWithFont:[self.uiStyle uiFont]
									 constrainedToSize:CGSizeMake(CGFLOAT_MAX, kNormalHeight)
										 lineBreakMode:NSLineBreakByWordWrapping];
		CGFloat badgeWidth = ceilf(badgeTextSize.width) + 2 * kBadgeTextMargins;
		width = MAX(kBadgeMinWidth, badgeWidth);
	}
	return width;
}

- (void)drawHighlightedWithBadge {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = (inverse ? [self.uiStyle inverseControlBorderColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (inverse ? [self.uiStyle inverseControlTextColor] : [self.uiStyle controlTextColor]);
	UIColor* separatorColor = (inverse? strokeColor  : [strokeColor colorWithAlphaComponent:0.5]);
	UIColor* andPizzaRed = (inverse ? [self.uiStyle inverseHeadingColor] :  [self.uiStyle headingColor]);
	UIColor* insetShadowColor = (inverse ? [self.uiStyle inverseControlHighlightedShadowColor] : [self.uiStyle controlHighlightedShadowColor]);
	UIColor* highlightedFill = (inverse ? [self.uiStyle inverseControlHighlightedColor] : [self.uiStyle controlHighlightedColor]);
	
	//// Shadow Declarations
	UIColor* depressedShadow = insetShadowColor;
	CGSize depressedShadowOffset = CGSizeMake(0.1, 2.1);
	CGFloat depressedShadowBlurRadius = 2;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Subframes
	const CGFloat badgeWidth = [self badgeFrameWidth];
	CGRect badgeFrame = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) - badgeWidth), CGRectGetMinY(frame), badgeWidth, CGRectGetHeight(frame));
	CGRect buttonLabelRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) - badgeWidth, CGRectGetHeight(frame));
	
	//// Abstracted Attributes
	NSString* buttonLabelContent = self.title;
	UIFont* buttonLabelFont = [self.uiStyle uiFont];
	NSString* badgeLabelContent = self.badgeText;
	UIFont* badgeLabelFont = buttonLabelFont;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
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
	
	
	//// Button Label Drawing
	[self drawLabel:buttonLabelContent inFrame:buttonLabelRect withFont:buttonLabelFont color:labelColor];
	
	//// Badge Label Drawing
	[self drawLabel:badgeLabelContent inFrame:badgeFrame withFont:badgeLabelFont color:andPizzaRed];
	
	//// Separator
	[self drawSeparatorWithBadgeFrame:badgeFrame color:separatorColor];
}

- (void)drawSeparatorWithBadgeFrame:(CGRect)badgeFrame color:(UIColor *)separatorColor {
	UIBezierPath* bezierPath = [UIBezierPath bezierPath];
	[bezierPath moveToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMinY(badgeFrame) + 1.5)];
	[bezierPath addLineToPoint: CGPointMake(CGRectGetMinX(badgeFrame) + 0.5, CGRectGetMinY(badgeFrame) + 30.5)];
	[separatorColor setStroke];
	bezierPath.lineWidth = 1;
	[bezierPath stroke];
}

- (void)drawNormal {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = (self.selected ? [self.uiStyle controlSelectedColor] : inverse ? [self.uiStyle inverseControlBorderColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (self.selected ? [self.uiStyle controlSelectedColor] : inverse ? [self.uiStyle inverseControlTextColor] : [self.uiStyle controlTextColor]);
	
	//// Shadow Declarations
	UIColor* shadow = (inverse ? [self.uiStyle inverseControlBorderGlossColor] : [self.uiStyle controlBorderGlossColor]);
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Abstracted Attributes
	NSString* textContent = self.title;
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	CGContextRestoreGState(context);
	if ( self.fillColor != nil ) {
		[self.fillColor setFill];
		[borderPath fill];
	}
	
	//// Text Drawing
	[self drawLabel:textContent inFrame:frame withFont:[self.uiStyle uiFont] color:labelColor];
}

- (void)drawLabel:(NSString *)labelContent inFrame:(CGRect)frame withFont:(UIFont *)labelFont color:(UIColor *)labelColor {
	CGRect buttonLabelRect = CGRectIntegral(CGRectMake(CGRectGetMinX(frame) + 2,
													   CGRectGetMidY(frame) - (labelFont.ascender - labelFont.capHeight) - (labelFont.capHeight / 2.0),
													   CGRectGetWidth(frame) - 4,
													   labelFont.lineHeight));
	[labelColor setFill];
	[labelContent drawInRect: buttonLabelRect withFont: labelFont lineBreakMode: NSLineBreakByWordWrapping alignment: NSTextAlignmentCenter];
}



- (void)drawNormalWithBadge {
	//// General Declarations
	CGContextRef context = UIGraphicsGetCurrentContext();
	
	//// Color Declarations
	UIColor* strokeColor = (inverse ? [self.uiStyle inverseControlBorderColor] : [self.uiStyle controlBorderColor]);
	UIColor* labelColor = (inverse ? [self.uiStyle inverseControlTextColor] : [self.uiStyle controlTextColor]);
	UIColor* separatorColor = [strokeColor colorWithAlphaComponent: 0.8];
	UIColor* andPizzaRed = (inverse ? [self.uiStyle inverseHeadingColor] :  [self.uiStyle headingColor]);
	
	//// Shadow Declarations
	UIColor* shadow = (inverse ? [self.uiStyle inverseControlBorderGlossColor] : [self.uiStyle controlBorderGlossColor]);
	CGSize shadowOffset = CGSizeMake(0.1, 1.1);
	CGFloat shadowBlurRadius = 0;
	
	//// Frames
	CGRect frame = self.bounds;
	
	//// Subframes
	const CGFloat badgeWidth = [self badgeFrameWidth];
	CGRect badgeFrame = CGRectMake(CGRectGetMinX(frame) + floor(CGRectGetWidth(frame) - badgeWidth), CGRectGetMinY(frame), badgeWidth, CGRectGetHeight(frame));
	CGRect buttonLabelRect = CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame) - badgeWidth, CGRectGetHeight(frame));
	
	
	//// Abstracted Attributes
	NSString* buttonLabelContent = self.title;
	UIFont* buttonLabelFont = [self.uiStyle uiFont];
	NSString* badgeLabelContent = self.badgeText;
	UIFont* badgeLabelFont = buttonLabelFont;
	
	
	//// Border Drawing
	UIBezierPath* borderPath = [UIBezierPath bezierPathWithRoundedRect: CGRectMake(CGRectGetMinX(frame) + 0.5, CGRectGetMinY(frame) + 1.5, CGRectGetWidth(frame) - 1, CGRectGetHeight(frame) - 3) cornerRadius: 3];
	CGContextSaveGState(context);
	CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
	[strokeColor setStroke];
	borderPath.lineWidth = 1;
	[borderPath stroke];
	CGContextRestoreGState(context);
	
	
	//// Button Label Drawing
	[self drawLabel:buttonLabelContent inFrame:buttonLabelRect withFont:buttonLabelFont color:labelColor];
	
	//// Badge Label Drawing
	[self drawLabel:badgeLabelContent inFrame:badgeFrame withFont:badgeLabelFont color:andPizzaRed];
	
	//// Separator
	[self drawSeparatorWithBadgeFrame:badgeFrame color:separatorColor];
}

- (void)drawRect:(CGRect)rect {
	if ( self.highlighted ) {
		if ( [badgeText length] > 0 ) {
			[self drawHighlightedWithBadge];
		} else {
			[self drawHighlighted];
		}
	} else {
		if ( [badgeText length] > 0 ) {
			[self drawNormalWithBadge];
		} else {
			[self drawNormal];
		}
	}
}

@end
