//
//  AppDelegate.m
//  MenuSampler
//
//  Created by Matt on 23/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "AppDelegate.h"

#import <BRStyle/Core.h>
#import <MenuKit/MenuKit.h>

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)setupAppearance {
	NSDictionary<NSString *, BRUIStyle *> *styles = [BRUIStyle registerDefaultStylesWithJSONResource:@"styles.json" inBundle:nil];
	BRUIStyle *defaultStyle = [BRUIStyle defaultStyle];
	BRUIStyle *navStyle = styles[@"bar-controls-normal"];
	if ( navStyle ) {
		UIBarButtonItem *bbItem = [UIBarButtonItem appearance];
		[bbItem setTitleTextAttributes:@{ NSForegroundColorAttributeName: navStyle.controls.actionColor,
										  NSFontAttributeName: navStyle.fonts.actionFont }
							  forState:UIControlStateNormal];


		UINavigationBar *bar = [UINavigationBar appearance];
		bar.tintColor = navStyle.controls.actionColor;
		bar.barTintColor = defaultStyle.colors.primaryColor;
		[bar setTitleTextAttributes:@{
									  NSForegroundColorAttributeName: navStyle.controls.actionColor,
									  NSFontAttributeName: navStyle.fonts.navigationFont,
									  }];
		
		UIToolbar *toolbar = [UIToolbar appearance];
		toolbar.tintColor = bar.tintColor;
		toolbar.barTintColor = bar.barTintColor;
		
		[BRMenuNavigationTitleView appearanceWhenContainedIn:[UINavigationBar class], nil].uiStyle = navStyle;
		
		[UITableViewCell appearance].tintColor = defaultStyle.colors.primaryColor;
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self setupAppearance];
	return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
	// Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
	// Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
	// Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
	// If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
	// Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	// Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
	// Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
