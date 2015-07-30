//
//  BRMenuFlipToggleButton.m
//  Menu
//
//  Created by Matt on 4/16/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuFlipToggleButton.h"

#import <BRPDFImage/BRPDFImage.h>
#import "BRMenuUIStylishHost.h"
#import "NSBundle+BRMenuUI.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuFlipToggleButton () <BRMenuUIStylishHost>
@end

static const CGSize kDefaultIconSize = {46.0, 26.0};

@implementation BRMenuFlipToggleButton {
	NSString *frontImageName;
	NSString *backImageName;
	BOOL flipped;
	CGSize iconSize;
	UIImageView *frontView;
	UIImageView *backView;
}

@dynamic uiStyle;
@synthesize frontImageName, backImageName;
@synthesize flipped;
@synthesize iconSize;

- (id)initWithIconSize:(CGSize)theIconSize {
	if ( (self = [super initWithFrame:CGRectMake(0, 0, theIconSize.width + 2, theIconSize.height + 2)]) ) {
		self.iconSize = theIconSize;
		[self setupSubviews];
	}
	return self;
}

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [self initWithIconSize:kDefaultIconSize]) ) {
		self.frame = frame;
	}
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		self.iconSize = CGSizeMake(CGRectGetWidth(self.bounds), CGRectGetHeight(self.bounds));
		[self setupSubviews];
	}
	return self;
}

- (void)awakeFromNib {
	// for historical reasons, this class represent a "dine-in" and "takeaway" toggle button
	if ( frontImageName == nil ) {
		self.frontImageName = @"icon-dinein.pdf";
		self.iconSize = kDefaultIconSize;
	}
	if ( backImageName == nil ) {
		self.backImageName = @"icon-takeaway.pdf";
		self.iconSize = kDefaultIconSize;
	}
}

- (UIImage *)imageForResource:(NSString *)resourceName {
	return [NSBundle iconForBRMenuResource:resourceName size:iconSize color:self.uiStyle.appPrimaryColor];
}

- (void)setupSubviews {
	frontView = [[UIImageView alloc] initWithImage:nil];
	frontView.opaque = NO;
	frontView.contentMode = UIViewContentModeCenter;
	backView = [[UIImageView alloc] initWithImage:nil];
	backView.opaque = NO;
	backView.contentMode = UIViewContentModeCenter;
	[self addSubview:frontView];
	[self addTarget:self action:@selector(animateToNextMode:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)setupImageView:(UIImageView *)imageView withResource:(NSString *)imageName {
	UIImage *image = [self imageForResource:imageName];
	imageView.image = image;
}

- (void)uiStyleDidChange:(BRMenuUIStyle *)style {
	[self setNeedsDisplay];
}

- (void)setIconSize:(CGSize)size {
	if ( !CGSizeEqualToSize(iconSize, size) ) {
		iconSize = size;
		[self setNeedsLayout];
		[self invalidateIntrinsicContentSize];
	}
}

- (void)setFrontImageName:(NSString *)imageName {
	if ( frontImageName != imageName ) {
		frontImageName = imageName;
		[self setNeedsDisplay];
	}
}

- (void)setBackImageName:(NSString *)imageName {
	if ( backImageName != imageName ) {
		backImageName = imageName;
		[self setNeedsDisplay];
	}
}

- (void)invalidateIntrinsicContentSize {
	[super invalidateIntrinsicContentSize];
	[self setNeedsDisplay];
}

- (CGSize)intrinsicContentSize {
	return CGSizeMake(iconSize.width + 2, iconSize.height + 2);
}

- (CGSize)sizeThatFits:(CGSize)size {
	return [self intrinsicContentSize];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	frontView.bounds = CGRectMake(0, 0, iconSize.width, iconSize.height);
	frontView.center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
	backView.bounds = frontView.bounds;
	backView.center = frontView.center;
}

- (void)setFlipped:(BOOL)value {
	[self setFlipped:value animated:NO];
}

- (void)setFlipped:(BOOL)value animated:(BOOL)animated {
	BOOL oldValue = flipped;
	flipped = value;
	if ( oldValue != value ) {
		[self sendActionsForControlEvents:UIControlEventValueChanged];
		UIView *fromView;
		UIView *toView;
		if ( oldValue ) {
			fromView = backView;
			toView = frontView;
		} else {
			fromView = frontView;
			toView = backView;
		}
		if ( animated ) {
			[UIView transitionWithView:self
							  duration:0.2
							   options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionCurveEaseOut
							animations:^{ [fromView removeFromSuperview]; [self addSubview:toView]; }
							completion:NULL];
		} else {
			[fromView removeFromSuperview];
			[self addSubview:toView];
		}
	}
}

- (IBAction)animateToNextMode:(id)sender {
	[self setFlipped:!flipped animated:YES];
}

- (void)drawRect:(CGRect)rect {
	// using this method to batch changes in icon style into a single call
	[self setupImageView:frontView withResource:frontImageName];
	[self setupImageView:backView withResource:backImageName];
}


@end
