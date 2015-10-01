//
//  UIBarButtonItem+BRMenu.m
//  MenuKit
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIBarButtonItem+BRMenu.h"

#import "BRMenuBackBarButtonItemView.h"
#import "BRMenuButton.h"
#import "NSBundle+BRMenu.h"

@implementation UIBarButtonItem (BRMenu)

+ (UIBarButtonItem *)standardBRMenuBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	return [[UIBarButtonItem alloc] initWithCustomView:[self standardBarButtonItemCustomViewWithTitle:title target:target action:action]];

}

+ (UIBarButtonItem *)standardBRMenuBackButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	if ( !title ) {
		title = [NSBundle localizedBRMenuString:@"menu.action.back"];
	}
	return [[UIBarButtonItem alloc] initWithCustomView:[self standardBackBarButtonItemCustomViewWithTitle:title target:target action:action]];
}

+ (NSArray *)insertMarginAdjustment:(CGFloat)amount forBRMenuNavigationBarButtonItems:(NSArray *)barButtonItems {
	UIBarButtonItem *adjustLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	adjustLeft.width = amount;
	NSMutableArray *result = [[NSMutableArray alloc] initWithObjects:adjustLeft, nil];
	[result addObjectsFromArray:barButtonItems];
	return result;
}

+ (NSArray *)marginAdjustedBRMenuLeftNavigationBarButtonItems:(NSArray *)barButtonItems {
	return [self insertMarginAdjustment:-12 forBRMenuNavigationBarButtonItems:barButtonItems];
}

+ (NSArray *)marginAdjustedBRMenuRightNavigationBarButtonItems:(NSArray *)barButtonItems {
	return [self insertMarginAdjustment:-8 forBRMenuNavigationBarButtonItems:barButtonItems];
}

+ (NSArray *)marginAdjustedBRMenuLeftToolbarBarButtonItems:(NSArray *)barButtonItems {
	UIBarButtonItem *adjustLeft = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	adjustLeft.width = -8;
	NSMutableArray *result = [[NSMutableArray alloc] initWithObjects:adjustLeft, nil];
	[result addObjectsFromArray:barButtonItems];
	return result;
}

+ (NSArray *)marginAdjustedBRMenuRightToolbarBarButtonItems:(NSArray *)barButtonItems {
	UIBarButtonItem *adjustRight = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
	adjustRight.width = -8;
	NSMutableArray *result = [[NSMutableArray alloc] initWithArray:barButtonItems];
	[result addObject:adjustRight];
	return result;
}

#pragma mark - Support

+ (BRMenuButton *)standardBarButtonItemCustomViewWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	BRMenuButton *view = [[BRMenuButton alloc] initWithTitle:title];
	CGSize size = [view intrinsicContentSize];
	view.frame = CGRectMake(0, 0, size.width, size.height);
	if ( target && action ) {
		[view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	}
	view.inverse = YES;
	return view;
}

+ (BRMenuBackBarButtonItemView *)standardBackBarButtonItemCustomViewWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	BRMenuBackBarButtonItemView *view = [[BRMenuBackBarButtonItemView alloc] initWithTitle:title];
	CGSize size = [view intrinsicContentSize];
	view.frame = CGRectMake(0, 0, size.width, size.height);
	if ( target && action ) {
		[view addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
	}
	view.inverse = YES;
	return view;
}

@end
