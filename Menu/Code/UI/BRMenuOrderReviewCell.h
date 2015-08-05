//
//  BRMenuOrderReviewCell.h
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuItemObjectCell.h"

@class BRMenuBarButtonItemView;
@class BRMenuFlipToggleButton;
@class BRMenuOrderItem;
@class BRMenuPlusMinusButton;

/** Table cell to display a single order item for review, allowing for adjustments to quantity. */
@interface BRMenuOrderReviewCell : BRMenuItemObjectCell

/** A label to display the quantity in. */
@property (nonatomic, strong) IBOutlet UILabel *quantity;

/** A toggle button to change bettween dine-in and take-away. */
@property (nonatomic, strong) IBOutlet BRMenuFlipToggleButton *takeAwayButton;

/** A button to decrease the quantity of items. */
@property (nonatomic, strong) IBOutlet BRMenuPlusMinusButton *minusButton;

/** A button to increase the quantity of items. */
@property (nonatomic, strong) IBOutlet BRMenuPlusMinusButton *plusButton;

/** A button to delete the item. */
@property (nonatomic, strong) IBOutlet BRMenuBarButtonItemView *deleteButton;

/** The order item to display. This also will set the @ref item property to the associated @ref BRMenuItem. */
@property (nonatomic, strong) BRMenuOrderItem *orderItem;

@end
