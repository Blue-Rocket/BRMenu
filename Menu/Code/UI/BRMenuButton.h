//
//  BRMenuButton.h
//  Menu
//
//  Created by Matt on 1/10/15.
//  Copyright © 2015 Blue Rocket. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIControl.h"
#import <BRLocalize/BRLocalizable.h>
#import <BRStyle/BRUIStylish.h>

@interface BRMenuButton : UIButton <BRLocalizable, BRMenuUIControl, BRUIStylish>

/** A title to display as the button text. */
@property (nonatomic, copy) IBInspectable NSString *title;

/** An optional "badge" to display next to the title. This has been designed with displaying a "count" integer in mind. */
@property (nonatomic, copy) IBInspectable NSString *badgeText;

/** Flag to render the button in "inverse" mode, to support use within a UINavigationBar or UIToolbar. */
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;

/** Manage a destructive state. */
@property (nonatomic, assign, getter=isDestructive) IBInspectable BOOL destructive;

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
