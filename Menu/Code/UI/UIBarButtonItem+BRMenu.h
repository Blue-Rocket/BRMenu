//
//  UIBarButtonItem+BRMenu.h
//  Menu
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

/**
 Utilities for bar buttons.
 */
@interface UIBarButtonItem (BRMenu)

/**
 Create a standard BRMenu navigation bar button.
 
 @param title The title to use in the button.
 @param target A target object to invoke when tapped.
 @param action The action method to invoke when tapped.
 @return A new bar button item.
 */
+ (UIBarButtonItem *)standardBRMenuBarButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

/**
 Create a standard BRMenu navigation bar back button.
 
 @param title The title to use in the button. Defaults to @c Back.
 @param target A target object to invoke when tapped.
 @param action The action method to invoke when tapped.
 @return A new bar button item.
 */
+ (UIBarButtonItem *)standardBRMenuBackButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

@end
