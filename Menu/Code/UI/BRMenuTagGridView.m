//
//  BRMenuTagsView.m
//  Menu
//
//  Created by Matt on 30/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuTagGridView.h"

#import "BRMenuItemTag.h"
#import "BRMenuUIStylishHost.h"
#import "NSBundle+BRMenuUI.h"
#import "UIView+BRMenuUIStyle.h"

static const CGFloat kIconMargin = 4;

@interface BRMenuTagGridView () <BRMenuUIStylishHost>
@end

@implementation BRMenuTagGridView {
	NSArray *tags;
	NSArray *views;
	NSUInteger columnCount;
	CGSize iconSize;
}

@dynamic uiStyle;
@synthesize tags, columnCount, iconSize;

- (id)initWithFrame:(CGRect)frame {
	if ( (self = [super initWithFrame:frame]) ) {
		columnCount = 2;
		iconSize = CGSizeMake(16, 16);
		[self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
		[self setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisVertical];
	}
	return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
	if ( (self = [super initWithCoder:aDecoder]) ) {
		if ( !columnCount ) {
			columnCount = 2;
		}
		if ( !(iconSize.width > 0) ) {
			iconSize = CGSizeMake(16, 16);
		}
	}
	return self;
}

- (void)setTags:(NSArray *)array {
	tags = array;
	[views makeObjectsPerformSelector:@selector(removeFromSuperview)];
	NSMutableArray *newViews = [[NSMutableArray alloc] initWithCapacity:[tags count]];
	for ( BRMenuItemTag *tag in tags ) {
		NSString *iconResource = [NSString stringWithFormat:@"icon-%@.pdf", tag.key];
		UIImage *icon = [NSBundle iconForBRMenuResource:iconResource size:iconSize color:self.uiStyle.appPrimaryColor];
		if ( icon != nil ) {
			UIImageView *image = [[UIImageView alloc] initWithImage:icon];
			[newViews addObject:image];
			[self addSubview:image];
		}
	}
	views = [newViews copy];
	[self invalidateIntrinsicContentSize];
	[self setNeedsLayout];
}

- (void)setIconSize:(CGSize)size {
	if ( !CGSizeEqualToSize(iconSize, size) ) {
		iconSize = size;
		[self invalidateIntrinsicContentSize];
		[self refreshIcons];
	}
}

- (void)setColumnCount:(NSUInteger)count {
	if ( count != columnCount ) {
		columnCount = count;
		[self invalidateIntrinsicContentSize];
		[self setNeedsLayout];
	}
}

- (void)refreshIcons {
	NSUInteger i = 0;
	for ( UIImageView *imageView in views ) {
		BRMenuItemTag *tag = nil;
		if ( i < tags.count ) {
			tag = tags[i];
		}
		if ( tag ) {
			NSString *iconResource = [NSString stringWithFormat:@"icon-%@.pdf", tag.key];
			UIImage *icon = [NSBundle iconForBRMenuResource:iconResource size:iconSize color:self.uiStyle.appPrimaryColor];
			imageView.image = icon;
			i++;
		}
	}
}

- (void)uiStyleDidChange:(BRMenuUIStyle *)style {
	[self refreshIcons];
}

- (void)layoutSubviews {
	[super layoutSubviews];
	const CGRect bounds = self.bounds;
	// first row might not have columnCount cols in it
	const NSUInteger firstRowColumnCount = ([views count] > columnCount ? [views count] % columnCount : [views count]);
	const NSUInteger rowCount = ceilf((CGFloat)[views count] / (CGFloat)columnCount);
	const CGPoint firstRowOrigin = CGPointMake(floorf(CGRectGetMidX(bounds) - (firstRowColumnCount * iconSize.width + (firstRowColumnCount - 1) * kIconMargin) * 0.5),
											   floorf(CGRectGetMidY(bounds) - (rowCount * iconSize.height + (rowCount - 1) * kIconMargin) * 0.5));
	const CGFloat rowXPosition = floorf(CGRectGetMidX(bounds) - (columnCount * iconSize.width + (columnCount - 1) * kIconMargin) * 0.5);
	CGPoint origin = firstRowOrigin;
	NSUInteger row = 0;
	NSUInteger col = 0;
	for ( UIView *iconView in views ) {
		iconView.center = CGPointMake(origin.x + iconSize.width * 0.5, origin.y + iconSize.height * 0.5);
		col++;
		if ( col >= (row == 0 ? firstRowColumnCount : columnCount) ) {
			row++;
			col = 0;
			origin.x = rowXPosition;
			origin.y += iconSize.height + kIconMargin;
		} else {
			origin.x += iconSize.width + kIconMargin;
		}
	}
}

- (CGSize)intrinsicContentSize {
	const NSUInteger rowCount = ceilf((CGFloat)[views count] / (CGFloat)columnCount);
	const NSUInteger iconCount = views.count;
	if ( iconCount < 1 ) {
		return CGSizeZero;
	}
	if ( rowCount == 1 && iconCount < columnCount ) {
		// return partial width, one row
		return CGSizeMake(iconSize.width * iconCount + ((iconCount - 1) * kIconMargin), iconSize.height);
	}
	return CGSizeMake(iconSize.width * columnCount + ((columnCount - 1) * kIconMargin),
					  iconSize.height * rowCount + ((rowCount - 1) * kIconMargin));
}

@end
