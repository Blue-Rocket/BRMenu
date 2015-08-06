//
//  BRMenuGroupTableHeaderView.h
//  MenuKit
//
//  Created by Matt on 4/11/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@interface BRMenuGroupTableHeaderView : UITableViewHeaderFooterView <BRMenuUIStylish>

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSDecimalNumber *price;

@end
