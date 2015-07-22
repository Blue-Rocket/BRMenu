//
//  BRMenuBackBarButtonItemView.h
//  Menu
//
//  Created by Matt on 4/9/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BRMenuUIStyle;

IB_DESIGNABLE
@interface BRMenuBackBarButtonItemView : UIButton

@property (nonatomic, strong) IBOutlet BRMenuUIStyle *uiStyle;

@property (nonatomic, copy) IBInspectable NSString *title;
@property (nonatomic, getter = isInverse) IBInspectable BOOL inverse;

- (id)initWithTitle:(NSString *)text;

@end
