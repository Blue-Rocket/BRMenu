//
//  BRMenuOrderingItemDetailsViewController.m
//  MenuKit
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderingItemDetailsViewController.h"

#import <Masonry/Masonry.h>
#import "BRMenuButton.h"
#import "BRMenuItem.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemDetailsView.h"
#import "BRMenuOrderingDelegate.h"
#import "BRMenuStepper.h"
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
	BRMenuStepper *stepper;
	__weak BRMenuButton *addButton;
}

@dynamic uiStyle;
@synthesize orderItem;
@synthesize stepper;

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
			if ( !self.showQuantityStepper ) {
				make.bottom.equalTo(self.scrollView).with.offset(-10).priorityMedium();
			}
		}];
		self.orderDetailsView = detailsView;
	}
	if ( self.showQuantityStepper && stepper.superview == nil ) {
		BRMenuStepper *stepperControl = self.stepper;
		[self.scrollView addSubview:stepperControl];
		[stepperControl mas_makeConstraints:^(MASConstraintMaker *make) {
			make.top.equalTo(self.orderDetailsView.mas_bottom).offset(20);
			make.left.equalTo(self.orderDetailsView).offset(-BRMenuStepperPadding.width);
			make.bottom.equalTo(self.scrollView).offset(-10).priorityMedium();
		}];
	}
	if ( !self.navigationItem.leftBarButtonItem ) {
		NSArray *leftItems = @[[UIBarButtonItem standardBRMenuBackButtonItemWithTitle:nil target:self action:@selector(goBack:)]];
		self.navigationItem.leftBarButtonItems = [UIBarButtonItem marginAdjustedBRMenuLeftNavigationBarButtonItems:leftItems];
	}
}

- (BRMenuStepper *)stepper {
	if ( !stepper ) {
		BRMenuStepper *stepperControl = [[BRMenuStepper alloc] initWithFrame:CGRectZero];
		stepperControl.value = orderItem.quantity;
		[self refreshAddButton];
		[stepperControl addTarget:self action:@selector(didAdjustQuantity:) forControlEvents:UIControlEventValueChanged];
		stepper = stepperControl;
	}
	return stepper;
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.ordering.item.details.title"], self.orderItem.item.title];
	
	if ( self.showAddToOrder && self.navigationItem.rightBarButtonItem == nil ) {
		UIBarButtonItem *rightItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.add"]
																					target:self
																					action:@selector(addOrderItemToActiveOrder:)];
		addButton = rightItem.customView;
		[self refreshAddButton];
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
	if ( stepper.minimumValue > 0 ) {
		[[[UIAlertView alloc] initWithTitle:nil message:[NSBundle localizedBRMenuString:@"menu.ordering.item.details.addingSimilarItem.message"] delegate:nil
						  cancelButtonTitle:[NSBundle localizedBRMenuString:@"menu.action.ok"] otherButtonTitles:nil] show];
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.scrollView.scrollEnabled = (CGRectGetHeight(self.orderDetailsView.bounds) >
									 (CGRectGetHeight(self.scrollView.frame) - self.scrollView.contentInset.top - self.scrollView.contentInset.bottom));
}

- (void)setOrderItem:(BRMenuOrderItem *)item {
	if ( orderItem == item ) {
		return;
	}
	orderItem = item;
	self.orderDetailsView.orderItem = item;
	self.stepper.value = item.quantity;
}

- (void)refreshAddButton {
	NSUInteger quantityChange = (stepper == nil ? 1 : (stepper.value - stepper.minimumValue)); // minimum value == no change to order
	addButton.badgeText = (quantityChange < 2 ? nil : [NSString stringWithFormat:@"%d", quantityChange]);
	addButton.enabled = (stepper == nil || stepper.value > stepper.minimumValue);
}

#pragma mark - Actions

- (IBAction)goBack:(id)sender {
	[self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)goForward:(id)sender {
	[self addOrderItemToActiveOrder:sender];
}

- (IBAction)addOrderItemToActiveOrder:(id)sender {
	[self.orderingDelegate addOrderItemToActiveOrder:self.orderItem];
}

- (IBAction)didAdjustQuantity:(BRMenuStepper *)sender {
	orderItem.quantity = sender.value;
	[self refreshAddButton];
}

@end
