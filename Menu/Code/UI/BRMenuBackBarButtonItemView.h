//
//  BRMenuBackBarButtonItemView.h
//  MenuKit
//
//  Created by Matt on 4/9/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRLocalize/BRLocalizable.h>
#import <BRStyle/BRUIStylish.h>

@interface BRMenuBackBarButtonItemView : UIButton <BRLocalizable, BRUIStylish>

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;

- (id)initWithTitle:(NSString *)text;

@end
