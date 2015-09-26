//
//  BRMenuOrderingItemDetailsViewController.m
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingItemDetailsViewController.h"

#import <Masonry/Masonry.h>
#import "BRMenuItem.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemDetailsView.h"
#import "BRMenuOrderingDelegate.h"
#import <BRStyle/BRUIStylishHost.h>
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIView+BRUIStyle.h"
#import "UIViewController+BRUIStyle.h"

@interface BRMenuOrderingItemDetailsViewController () <BRUIStylishHost>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet BRMenuOrderItemDetailsView *orderDetailsView;
@end

@implementation BRMenuOrderingItemDetailsViewController {
	BRMenuOrderItem *orderItem;
}

@dynamic uiStyle;
@synthesize orderItem;

- (void)viewDidLoad {
    [super viewDidLoad];
	if ( !self.orderDetailsView ) {
		BRMenuOrderItemDetailsView *detailsView = [[BRMenuOrderItemDetailsView alloc] initWithFrame:CGRectZero];
		detailsView.orderItem = orderItem;
		[self.scrollView addSubview:detailsView];
		[detailsView mas_makeConstraints:^(MASConstraintMaker *make) {
			make.width.equalTo(self.scrollView).with.offset(-20);
			make.centerX.equalTo(self.scrollView);
			make.top.equalTo(self.scrollView).with.offset(10);
			make.bottom.equalTo(self.scrollView).with.offset(-10).priorityMedium();
		}];
		self.orderDetailsView = detailsView;
	}
	if ( !self.navigationItem.leftBarButtonItem ) {
		NSArray *leftItems = @[[UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil target:self action:@selector(goBack:)]];
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuLeftNavigationBarButtonItems:leftItems];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.ordering.item.details.title"], self.orderItem.item.title];
	
	if ( self.showAddToOrder && self.navigationItem.rightBarButtonItem == nil ) {
		UIBarButtonItem *rightItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.add"]
																					target:self
																					action:@selector(addOrderItemToActiveOrder:)];
		self.navigationItem.rightBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuRightNavigationBarButtonItems:@[rightItem]];
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ( self.scrollView.scrollEnabled ) {
		[self.scrollView flashScrollIndicators];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.scrollView.scrollEnabled = (CGRectGetHeight(self.orderDetailsView.bounds) > CGRectGetHeight(self.view.bounds));
}

- (void)setOrderItem:(BRMenuOrderItem *)item {
	if ( orderItem == item ) {
		return;
	}
	orderItem = item;
	self.orderDetailsView.orderItem = item;
}

#pragma mark - Actions

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)addOrderItemToActiveOrder:(id)sender {
	[self.orderingDelegate addOrderItemToActiveOrder:self.orderItem];
}

@end
