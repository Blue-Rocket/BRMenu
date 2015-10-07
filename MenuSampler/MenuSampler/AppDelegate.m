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

@implementation AppDelegate {
	id styleChangeObserver;
}

- (void)setupAppearance {
	UINavigationBar *bar = [UINavigationBar appearance];
	bar.tintColor = [UIColor whiteColor];
	bar.barTintColor = [BRUIStyle defaultStyle].colors.primaryColor;
	[bar setTitleTextAttributes:@{
								  NSForegroundColorAttributeName: [UIColor whiteColor],
								  NSFontAttributeName: [BRUIStyle defaultStyle].fonts.navigationFont,
								  }];
	
	UIToolbar *toolbar = [UIToolbar appearance];
	toolbar.tintColor = bar.tintColor;
	toolbar.barTintColor = bar.barTintColor;
	
	BRUIStyle *baseStyle = [BRUIStyle defaultStyle];
	
	BRMenuBackBarButtonItemView *navBackButton = [BRMenuBackBarButtonItemView appearanceWhenContainedIn:[UINavigationBar class], nil];
	BRMenuBackBarButtonItemView *toolbarBackButton = [BRMenuBackBarButtonItemView appearanceWhenContainedIn:[UIToolbar class], nil];
	BRMenuButton *navButton = [BRMenuButton appearanceWhenContainedIn:[UINavigationBar class], nil];
	BRMenuButton *toolbarButton = [BRMenuButton appearanceWhenContainedIn:[UIToolbar class], nil];
	NSArray *inverted = @[navBackButton, toolbarBackButton, navButton, toolbarButton];
	
	// normal settings
	BRMutableUIStyle *inverseStyle = [baseStyle mutableCopy];
	inverseStyle.controls.actionColor = [UIColor whiteColor];
	inverseStyle.controls.borderColor = [BRUIStyle colorWithRGBInteger:0x264891];
	inverseStyle.controls.glossColor = [inverseStyle.controls.glossColor colorWithAlphaComponent:0.4];
	inverseStyle.controls.shadowColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
	BRUIStyle *inverseNormalStyle = [inverseStyle copy];
	for ( UIControl *control in inverted ) {
		[control setUiStyle:inverseNormalStyle forState:UIControlStateNormal];
	}
	
	// highlighted settings
	inverseStyle.controls.shadowColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
	inverseStyle.controls.fillColor = [[UIColor blackColor] colorWithAlphaComponent:0.1];
	BRUIStyle *inverseHighlightedStyle = [inverseStyle copy];
	for ( UIControl *control in inverted ) {
		[control setUiStyle:inverseHighlightedStyle forState:UIControlStateHighlighted];
	}
	
	// disabled settings
	inverseStyle = [inverseNormalStyle mutableCopy];
	inverseStyle.controls.actionColor = [BRUIStyle colorWithRGBInteger:0xCACACA];
	inverseStyle.controls.borderColor = [inverseStyle.controls.borderColor colorWithAlphaComponent:0.8];
	inverseStyle.controls.glossColor = [inverseStyle.controls.glossColor colorWithAlphaComponent:0.3];
	BRUIStyle *inverseDisabled = [inverseStyle copy];
	for ( UIControl *control in inverted ) {
		[control setUiStyle:inverseDisabled forState:UIControlStateDisabled];
	}
}

- (void)refreshAppearance {
	// reapply appearance styles
	for ( UIWindow *window in [UIApplication sharedApplication].windows ) {
		for ( UIView *view in window.subviews ) {
			[view removeFromSuperview];
			[window addSubview:view];
		}
	}
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[self setupAppearance];
	styleChangeObserver = [[NSNotificationCenter defaultCenter] addObserverForName:BRStyleNotificationUIStyleDidChange object:nil queue:nil usingBlock:^(NSNotification *note) {
		[AppDelegate cancelPreviousPerformRequestsWithTarget:self selector:@selector(refreshAppearance) object:nil];
		[self setupAppearance];
		[self performSelector:@selector(refreshAppearance) withObject:nil afterDelay:1];
	}];
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
