//
//  BRMenuNavigationTitleView.h
//  MenuKit
//
//  Created by Matt on 5/8/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStyle.h>

/**
 A custom navigation bar title view that attempts to keep the title centered 
 within the screen width, but adjusts the position when there are left or 
 right bar buttons items so that more of the title text appears.
 */
IB_DESIGNABLE
@interface BRMenuNavigationTitleView : UIView <BRUIStylish>

/** The title to display. */
@property (nonatomic) IBInspectable NSString *title;

@end
