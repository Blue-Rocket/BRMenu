//
//  BRMenuOrderItemDetailsView.m
//  Menu
//
//  Created by Matt on 28/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuOrderItemDetailsView.h"

#import "BRMenuOrderItem.h"
#import "BRMenuUIStylishHost.h"
#import "UIView+BRMenuUIStyle.h"

@interface BRMenuOrderItemDetailsView () <BRMenuUIStylishHost>
@end

@implementation BRMenuOrderItemDetailsView {
	BRMenuOrderItem *orderItem;
	BOOL showTakeAway;
}

@dynamic uiStyle;
@synthesize orderItem;
@synthesize showTakeAway;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
