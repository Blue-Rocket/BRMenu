//
//  main.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import <UIKit/UIKit.h>
#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
	@autoreleasepool {
		BRLoggingSetupDefaultLogging();
	    return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
	}
}
