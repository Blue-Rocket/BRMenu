//
//  BRMenuBackBarButtonItemView.h
//  MenuKit
//
//  Created by Matt on 4/9/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStyle.h>

IB_DESIGNABLE
@interface BRMenuBackBarButtonItemView : UIButton <BRUIStylish>

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;

- (id)initWithTitle:(NSString *)text;

@end
