//
//  UIBarButtonItem+BRMenu.m
//  Menu
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIBarButtonItem+BRMenu.h"

#import "BRMenuBackBarButtonItemView.h"
#import "BRMenuBarButtonItemView.h"
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

#pragma mark - Support

+ (BRMenuBarButtonItemView *)standardBarButtonItemCustomViewWithTitle:(NSString *)title target:(id)target action:(SEL)action {
	BRMenuBarButtonItemView *view = [[BRMenuBarButtonItemView alloc] initWithTitle:title];
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
