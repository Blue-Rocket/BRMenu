//
//  UIViewController+BRMenuUIStyle.m
//  Menu
//
//  Created by Matt on 27/07/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIViewController+BRMenuUIStyle.h"
#import <objc/runtime.h>
#import "BRMenuUIStylishHost.h"
#import "BRMenuUIStyleObserver.h"

static void *BRMenuUIStyleObserverKey = &BRMenuUIStyleObserverKey;
static IMP original_viewDidLoad;//(id, SEL);

void brmenustyle_viewDidLoad(id self, SEL _cmd) {
	((void(*)(id,SEL))original_viewDidLoad)(self, _cmd);
	if ( ![self conformsToProtocol:@protocol(BRMenuUIStylish)] ) {
		return;
	}
	BRMenuUIStyleObserver *obs = objc_getAssociatedObject(self, BRMenuUIStyleObserverKey);
	if ( !obs ) {
		obs = [BRMenuUIStyleObserver new];
		obs.host = self;
		objc_setAssociatedObject(self, BRMenuUIStyleObserverKey, obs, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	}
	if ( !obs.updateObserver ) {
		__weak id weakSelf = self;
		obs.updateObserver = [[NSNotificationCenter defaultCenter] addObserverForName:BRMenuNotificationUIStyleDidChange object:nil queue:nil usingBlock:^(NSNotification *note) {
			BRMenuUIStyle *myStyle = [weakSelf uiStyle];
			if ( myStyle.defaultStyle && [weakSelf respondsToSelector:@selector(uiStyleDidChange:)] ) {
				[(id<BRMenuUIStylishHost>)weakSelf uiStyleDidChange:myStyle];
			}
		}];
	}
}

@implementation UIViewController (BRMenuUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		
		SEL originalSelector = @selector(viewDidLoad);
		
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_viewDidLoad = method_setImplementation(originalMethod, (IMP)brmenustyle_viewDidLoad);
	});
}

- (BRMenuUIStyle *)uiStyle {
	BRMenuUIStyle *style = objc_getAssociatedObject(self, @selector(uiStyle));
	
	// if this view doesn't define a custom style, search the responder chain for the closest defined style
	UIResponder *responder = self;
	while ( !style && [responder nextResponder] ) {
		responder = [responder nextResponder];
		if ( [responder respondsToSelector:@selector(uiStyle)] ) {
			style = [(id)responder uiStyle];
		}
	}
	if ( !style ) {
		style = [BRMenuUIStyle defaultStyle];
	}
	return style;
}

- (void)setUiStyle:(BRMenuUIStyle *)style {
	objc_setAssociatedObject(self, @selector(uiStyle), style, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self respondsToSelector:@selector(uiStyleDidChange:)] ) {
		[(id<BRMenuUIStylishHost>)self uiStyleDidChange:style];
	}
}

@end
