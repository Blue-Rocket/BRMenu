//
//  BRMenuTagsView.h
//  MenuKit
//
//  Created by Matt on 30/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylish.h>

/**
 Render a set of menu item tags as a grid of icons.
 */
@interface BRMenuTagGridView : UIView <BRUIStylish>

@property (nonatomic, strong) NSArray *tags;  // of MenuItemTag
@property (nonatomic) IBInspectable NSUInteger columnCount; // defaults to 2

/** A size to display the configured images at. Defaults to 16x16. */
@property (nonatomic, assign) IBInspectable CGSize iconSize;

@end
