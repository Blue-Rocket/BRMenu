//
//  BRMenuItemObjectCell.h
//  Menu
//
//  Created by Matt on 4/4/13.
//  Copyright (c) 2013 Blue Rocket, Inc. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuUIStyle.h"

@protocol BRMenuItemObject;

/**
 Table cell for displaying root-level BRMenuItemObject details for the ordering process.
 */
@interface BRMenuItemObjectCell : UITableViewCell <BRMenuUIStylish>

@property (nonatomic, strong) id<BRMenuItemObject> item;

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *desc;
@property (nonatomic, strong) IBOutlet UILabel *price;
@property (nonatomic, strong) IBOutlet UIView *insetSeparatorView;

@end

@interface BRMenuItemObjectCell (ImplementationSupport)

/**
 Configure any required subviews.
 */
- (void)setupSubviews;

/**
 Refresh the styles used by subviews.
 
 @param style The style to refresh with.
 */
- (void)refreshStyle:(BRMenuUIStyle *)style;

@end