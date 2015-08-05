//
//  BRMenuBarButtonItemView.h
//  MenuKit
//
//  Created by Matt on 4/8/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIControl.h"
#import "BRMenuUIStyle.h"

/**
 Button that renders a standard menu button with support for a title and badge value (for example count).
 */
IB_DESIGNABLE
@interface BRMenuBarButtonItemView : UIButton <BRMenuUIControl, BRMenuUIStylish>

/** A title to display as the button text. */
@property (nonatomic, copy) IBInspectable NSString *title;

/** An optional "badge" to display next to the title. This has been designed with displaying a "count" integer in mind. */
@property (nonatomic, copy) IBInspectable NSString *badgeText;

/** Flag to render the button in "inverse" mode, to support use within a UINavigationBar or UIToolbar. */
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;

/** A custom fill color to use. */
@property (nonatomic, strong) IBInspectable UIColor *fillColor;

/**
 Initialize a bar button with a title.
 
 This is the designated initializer.
 
 @param text The title to display.
 @return A new button instance.
 */
- (id)initWithTitle:(NSString *)text;

@end
