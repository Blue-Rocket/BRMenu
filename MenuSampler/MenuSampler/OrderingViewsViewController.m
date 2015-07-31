//
//  OrderingViewsViewController.m
//  MenuSampler
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "OrderingViewsViewController.h"

#import <MenuKit/Core/Core.h>
#import <MenuKit/UI/BRMenuOrderItemComponentDetailsView.h>
#import <MenuKit/UI/BRMenuOrderItemDetailsView.h>
#import <MenuKit/UI/BRMenuOrderItemPlacementDetailsView.h>
#import "BRMenu+MenuSampler.h"

@interface OrderingViewsViewController ()
@property (strong, nonatomic) IBOutlet BRMenuOrderItemComponentDetailsView *orderItemComponentView;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemComponentDetailsView *orderItemComponentView2;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemPlacementDetailsView *placementViewWhole;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemPlacementDetailsView *placementViewLeft;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemPlacementDetailsView *placementViewRight;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemDetailsView *orderItemDetailsView;
@end

@implementation OrderingViewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	BRMenu *menu = [BRMenu sampleMenuForResourceName:@"menu-pizza"];
	BRMenuItemComponentGroup *sauces = [menu menuItemComponentGroupForKey:@"sauce"];
	BRMenuItemComponent *sauce = [sauces allComponents][0];
	self.orderItemComponentView.orderItemComponent = [[BRMenuOrderItemComponent alloc] initWithComponent:sauce];
	sauce = [sauces allComponents][1];
	self.orderItemComponentView2.orderItemComponent = [[BRMenuOrderItemComponent alloc] initWithComponent:sauce
																								placement:BRMenuOrderItemComponentPlacementWhole
																								 quantity:BRMenuOrderItemComponentQuantityLight];
	
	// set up a demo pizza order to showcase various order views
	BRMenuItem *pizza = [menu menuItemForKey:@"pizza"];
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizza];
	[orderItem addComponent:self.orderItemComponentView.orderItemComponent];
	[orderItem addComponent:self.orderItemComponentView2.orderItemComponent];
	[orderItem addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[sauces allComponents][2]
																	  placement:BRMenuOrderItemComponentPlacementLeft
																	   quantity:BRMenuOrderItemComponentQuantityNormal]];
	[orderItem addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[sauces allComponents][3]
																	  placement:BRMenuOrderItemComponentPlacementLeft
																	   quantity:BRMenuOrderItemComponentQuantityHeavy]];
	[orderItem addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[sauces allComponents][4]
																	  placement:BRMenuOrderItemComponentPlacementRight
																	   quantity:BRMenuOrderItemComponentQuantityNormal]];
	[orderItem addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[sauces allComponents][5]
																	  placement:BRMenuOrderItemComponentPlacementRight
																	   quantity:BRMenuOrderItemComponentQuantityLight]];
	[orderItem addComponent:[[BRMenuOrderItemComponent alloc] initWithComponent:[sauces allComponents][6]
																	  placement:BRMenuOrderItemComponentPlacementRight
																	   quantity:BRMenuOrderItemComponentQuantityNormal]];
	
	self.placementViewWhole.placementToDisplay = BRMenuOrderItemComponentPlacementWhole;
	self.placementViewWhole.orderItem = orderItem;
	self.placementViewLeft.placementToDisplay = BRMenuOrderItemComponentPlacementLeft;
	self.placementViewLeft.orderItem = orderItem;
	self.placementViewRight.placementToDisplay = BRMenuOrderItemComponentPlacementRight;
	self.placementViewRight.orderItem = orderItem;
	self.orderItemDetailsView.orderItem = orderItem;
}

@end
