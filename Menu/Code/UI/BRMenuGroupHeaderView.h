//
//  BRMenuGroupHeaderView.h
//  Menu
//
//  Created by Matt on 5/23/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@interface BRMenuGroupHeaderView : UIView <BRMenuUIStylish>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UILabel *priceLabel;

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDecimalNumber *price;
@property (nonatomic, getter = isRuleHidden) BOOL ruleHidden;

@end
