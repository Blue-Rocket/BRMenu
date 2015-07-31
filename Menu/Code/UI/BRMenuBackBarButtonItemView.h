//
//  BRMenuBackBarButtonItemView.h
//  Menu
//
//  Created by Matt on 4/9/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

IB_DESIGNABLE
@interface BRMenuBackBarButtonItemView : UIButton <BRMenuUIStylish>

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;

- (id)initWithTitle:(NSString *)text;

@end
