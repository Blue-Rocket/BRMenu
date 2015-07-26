//
//  UIView+BRMenuUIStyle.h
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@interface UIView (BRMenuUIStyle)

/** A BRMenuUIStyle object to use. If not configured, the global default style will be returned. */
@property (nonatomic, strong) IBOutlet BRMenuUIStyle *uiStyle;

@end