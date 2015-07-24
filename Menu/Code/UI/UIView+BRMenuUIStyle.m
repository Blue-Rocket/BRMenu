//
//  UIView+BRMenuUIStyle.m
//  Menu
//
//  Created by Matt on 24/07/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "UIView+BRMenuUIStyle.h"

#import <objc/runtime.h>
#import "BRMenuUIStylishHost.h"

@interface BRMenuUIStyleObserver : NSObject
@property (nonatomic, assign) __unsafe_unretained id host;
@property (nonatomic, strong) id updateObserver;
@end

@implementation BRMenuUIStyleObserver

- (void)dealloc {
	if ( _updateObserver ) {
		[[NSNotificationCenter defaultCenter] removeObserver:_updateObserver];
	}
}

@end

static void *BRMenuUIStyleObserverKey = &BRMenuUIStyleObserverKey;
static IMP original_willMoveToWindow;//(id, SEL, UIWindow *);

void brmenustyle_willMoveToWindow(id self, SEL _cmd, UIWindow * window) {
	((void(*)(id,SEL,UIWindow *))original_willMoveToWindow)(self, _cmd, window);
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

@implementation UIView (BRMenuUIStyle)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		
		SEL originalSelector = @selector(willMoveToWindow:);
		
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_willMoveToWindow = method_setImplementation(originalMethod, (IMP)brmenustyle_willMoveToWindow);
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
