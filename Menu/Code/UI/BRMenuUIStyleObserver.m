//
//  BRMenuUIStyleObserver.m
//  Menu
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "BRMenuUIStyleObserver.h"

@implementation BRMenuUIStyleObserver

- (void)dealloc {
	if ( _updateObserver ) {
		[[NSNotificationCenter defaultCenter] removeObserver:_updateObserver];
	}
}

@end
