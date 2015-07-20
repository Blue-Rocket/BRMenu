//
//  BRMenuTestingMenuProvider.m
//  BRMenu
//
//  Created by Matt on 20/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuTestingMenuProvider.h"

#import "BRMenu.h"

@implementation BRMenuTestingMenuProvider {
	BRMenu *menu;
}

- (instancetype)initWithMenu:(BRMenu *)aMenu {
	if ( (self = [super init]) ) {
		menu = aMenu;
	}
	return self;
}

- (BRMenu *)menu {
	return menu;
}

- (BRMenu *)menuForVersion:(UInt16)version {
	return (version == menu.version ? menu : nil);
}

@end
