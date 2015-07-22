//
//  BRMenuBarButtonItemView.h
//  Menu
//
//  Created by Matt on 4/8/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

@class BRMenuUIStyle;

IB_DESIGNABLE
@interface BRMenuBarButtonItemView : UIButton

@property (nonatomic, strong) IBOutlet BRMenuUIStyle *uiStyle;

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, copy) IBInspectable NSString *badgeText;
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;
@property (nonatomic, strong) IBInspectable UIColor *fillColor;

- (id)initWithTitle:(NSString *)text;

@end
