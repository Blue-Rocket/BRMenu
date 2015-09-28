//
//  BRMenuOrderItemAttributeProxy.m
//  MenuKit
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrderItemAttributesProxy.h"

#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemAttributes.h"

@implementation BRMenuOrderItemAttributesProxy {
	BRMenuOrderItem *target;
	uint8_t index;
}

@synthesize target, index;

- (id)initWithOrderItem:(BRMenuOrderItem *)item attributeIndex:(uint8_t)idx {
	if ( self ) {
		target = ([item isProxy] ? [(id)item target] : item);
		index = idx;
	}
	return self;
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
	id t = target;
	// if BRMenuOrderItemAttributes responds to the given selector, then invoke the method on that instead
	if ( [[BRMenuOrderItemAttributes class] instancesRespondToSelector:[anInvocation selector]] ) {
		t = [target getOrAddAttributesAtIndex:index];
	}
    [anInvocation setTarget:t];
    [anInvocation invoke];
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    return [target methodSignatureForSelector:aSelector];
}

@end
