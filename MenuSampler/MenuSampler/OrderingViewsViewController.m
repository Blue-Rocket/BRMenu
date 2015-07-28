//
//  OrderingViewsViewController.m
//  MenuSampler
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "OrderingViewsViewController.h"

#import <BRMenu/Core/Core.h>
#import <BRMenu/UI/BRMenuOrderItemComponentDetailsView.h>
#import <BRMenu/UI/BRMenuOrderItemDetailsView.h>
#import <BRMenu/UI/BRMenuOrderItemPlacementDetailsView.h>
#import "BRMenu+MenuSampler.h"

@interface OrderingViewsViewController ()
@property (strong, nonatomic) IBOutlet BRMenuOrderItemComponentDetailsView *orderItemComponentView;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemComponentDetailsView *orderItemComponentView2;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemPlacementDetailsView *placementViewWhole;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemDetailsView *orderItemDetailsView;
@end

@implementation OrderingViewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
	
	BRMenu *menu = [BRMenu sampleMenuForResourceName:@"menu-pizza"];
	BRMenuItemComponentGroup *cheeses = [menu menuItemComponentGroupForKey:@"cheese"];
	BRMenuItemComponent *cheese = [[cheeses allComponents] firstObject];
	self.orderItemComponentView.orderItemComponent = [[BRMenuOrderItemComponent alloc] initWithComponent:cheese];
	cheese = [cheeses allComponents][1];
	self.orderItemComponentView2.orderItemComponent = [[BRMenuOrderItemComponent alloc] initWithComponent:cheese
																								placement:BRMenuOrderItemComponentPlacementWhole
																								 quantity:BRMenuOrderItemComponentQuantityLight];
	
	BRMenuItem *pizza = [menu menuItemForKey:@"pizza"];
	BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] initWithMenuItem:pizza];
	[orderItem addComponent:self.orderItemComponentView.orderItemComponent];
	[orderItem addComponent:self.orderItemComponentView2.orderItemComponent];
	
	self.placementViewWhole.placementToDisplay = BRMenuOrderItemComponentPlacementWhole;
	self.placementViewWhole.orderItem = orderItem;
}

@end
