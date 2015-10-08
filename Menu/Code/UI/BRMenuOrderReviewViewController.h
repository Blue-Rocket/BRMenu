//
//  BRMenuOrderReviewTableViewController.h
//  MenuKit
//
//  Created by Matt on 5/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>

#import <BRStyle/BRUIStylish.h>

@class BRMenuButton;
@class BRMenuOrder;

extern NSString * const BRMenuOrderReviewOrderItemCellIdentifier;
extern NSString * const BRMenuOrderReviewGroupHeaderCellIdentifier;

extern NSString * const BRMenuOrderReviewViewOrderItemDetailsSegue;

/**
 Display an entire order, allowing quantities to be adjusted (add/remove).
 */
@interface BRMenuOrderReviewViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, BRUIStylish>

/** The table view to display the order within. */
@property (nonatomic, strong) IBOutlet UITableView *tableView;

/** A button that toggles between editing and normal states. */
@property (nonatomic, strong) IBOutlet id editButton;

/** A button that displays the order total price as the badge text. */
@property (strong, nonatomic) IBOutlet BRMenuButton *checkoutTotalButton;

/** The order to display the items for. */
@property (nonatomic, strong) BRMenuOrder *order;

/**
 A mapping of string group keys to effective key string values. This can be used to combine
 multiple, related groups into a single section.
 */
@property (nonatomic, strong) NSDictionary *groupKeyMapping;

/**
 Refresh based on a specific style.
 
 This method is designed for subclasses to override. Subclasses must call the super implementation at some point within their own implementation.
 
 @param style The style to apply.
 */
- (void)refreshForStyle:(BRUIStyle *)style;

/**
 Refresh views from changes to the order model.
 
 This method is designed for subclasses to override. Subclasses must call the super implementation at some point within their own implementation.
 */
- (void)refreshFromModel;

@end
