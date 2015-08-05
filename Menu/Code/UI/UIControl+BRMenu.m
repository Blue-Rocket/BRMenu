//
//  UIControl+BRMenu.m
//  Menu
//
//  Created by Matt on 6/08/15.
//  Copyright (c) 2015 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "UIControl+BRMenu.h"

#import <objc/runtime.h>
#import "BRMenuUIControl.h"
#import "BRMenuUIStyleObserver.h"

const UIControlState BRMenuUIControlStateDestructive = (1 << 16);

static void *BRMenuUIControlStateKey = &BRMenuUIControlStateKey;
static IMP original_state;//(id, SEL);

UIControlState brmenucontrol_state(id self, SEL _cmd) {
	UIControlState orig = ((UIControlState(*)(id,SEL))original_state)(self, _cmd);
	if ( ![self conformsToProtocol:@protocol(BRMenuUIControl)] ) {
		return orig;
	}
	NSNumber *val = objc_getAssociatedObject(self, BRMenuUIControlStateKey);
	return (orig | [val unsignedIntegerValue]);
}

@implementation UIControl (BRMenu)

+ (void)load {
	static dispatch_once_t onceToken;
	dispatch_once(&onceToken, ^{
		Class class = [self class];
		
		SEL originalSelector = @selector(state);
		
		Method originalMethod = class_getInstanceMethod(class, originalSelector);
		original_state = method_setImplementation(originalMethod, (IMP)brmenucontrol_state);
	});
}

- (BOOL)isDestructive {
	NSNumber *val = objc_getAssociatedObject(self, BRMenuUIControlStateKey);
	return (([val unsignedIntegerValue] & BRMenuUIControlStateDestructive) == BRMenuUIControlStateDestructive);
}

- (void)setDestructive:(BOOL)destructive {
	UIControlState appState = [objc_getAssociatedObject(self, BRMenuUIControlStateKey) unsignedIntegerValue];
	if ( destructive ) {
		appState |= BRMenuUIControlStateDestructive;
	} else {
		appState &= ~BRMenuUIControlStateDestructive;
	}
	objc_setAssociatedObject(self, BRMenuUIControlStateKey, @(appState), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	if ( [self respondsToSelector:@selector(controlStateDidChange:)] ) {
		[(id<BRMenuUIControl>)self controlStateDidChange:self.state];
	}
}

@end
