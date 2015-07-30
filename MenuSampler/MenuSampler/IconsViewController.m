//
//  IconsViewController.m
//  MenuSampler
//
//  Created by Matt on 30/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "IconsViewController.h"

#import <BRMenuKit/Core/Core.h>
#import <BRMenuKit/UI/BRMenuTagGridView.h>
#import "BRMenu+MenuSampler.h"

@interface IconsViewController ()
@property (strong, nonatomic) IBOutlet BRMenuTagGridView *tagsView;
@end

@implementation IconsViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	BRMenu *menu = [BRMenu sampleMenuForResourceName:@"menu-pizza"];
	self.tagsView.tags = menu.tags;
}

@end
