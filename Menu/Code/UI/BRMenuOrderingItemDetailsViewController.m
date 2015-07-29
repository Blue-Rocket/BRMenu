//
//  BRMenuOrderingItemDetailsViewController.m
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderingItemDetailsViewController.h"

#import <Masonry/Masonry.h>
#import "BRMenuItem.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemDetailsView.h"
#import "BRMenuOrderingDelegate.h"
#import "BRMenuUIStylishHost.h"
#import "NSBundle+BRMenu.h"
#import "UIBarButtonItem+BRMenu.h"
#import "UIView+BRMenuUIStyle.h"
#import "UIViewController+BRMenuUIStyle.h"

@interface BRMenuOrderingItemDetailsViewController () <BRMenuUIStylishHost>
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
	}
	if ( !self.navigationItem.leftBarButtonItem ) {
		self.navigationItem.leftBarButtonItem = [UIBarButtonItem standardBRMenuBackButtonItemWithWithTitle:nil
																									target:self
																									action:@selector(goBack:)];
	}
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	self.navigationItem.title = [NSString stringWithFormat:[NSBundle localizedBRMenuString:@"menu.ordering.item.details.title"], self.orderItem.item.title];
	
	if ( self.showAddToOrder && self.navigationItem.rightBarButtonItem == nil ) {
		UIBarButtonItem *rightItem = [UIBarButtonItem standardBRMenuBarButtonItemWithTitle:[NSBundle localizedBRMenuString:@"menu.action.add"]
																					target:self
																					action:@selector(addOrderItemToActiveOrder:)];
		self.navigationItem.rightBarButtonItem = rightItem;
	} else {
		self.navigationItem.rightBarButtonItem = nil;
	}
}

- (void)viewDidLayoutSubviews {
	[super viewDidLayoutSubviews];
	self.scrollView.scrollEnabled = (CGRectGetMaxY(self.orderDetailsView.frame) > CGRectGetHeight(self.view.bounds));
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
