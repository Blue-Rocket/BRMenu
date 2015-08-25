//
//  IconsViewController.m
//  MenuSampler
//
//  Created by Matt on 30/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "IconsViewController.h"

#import <MenuKit/Core.h>
#import <MenuKit/BRMenuTagGridView.h>
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
