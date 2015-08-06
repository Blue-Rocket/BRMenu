//
//  BRMenuOrderItemPlacementDetailsView.h
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import "BRMenuOrderItemComponent.h"
#import "BRMenuUIStyle.h"

@class BRMenuOrderItem;
@protocol BRMenuUIModelPropertyEditor;

@interface BRMenuOrderItemPlacementDetailsView : UIView <BRMenuUIStylish>

@property (nonatomic, strong) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UIControl<BRMenuUIModelPropertyEditor> *placement;

@property (nonatomic, strong) BRMenuOrderItem *orderItem;
@property (nonatomic, assign) BRMenuOrderItemComponentPlacement placementToDisplay;

@end
