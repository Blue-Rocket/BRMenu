//
//  BRMenuOrderItemAttributeProxy.m
//  BRMenu
//
//  Created by Matt on 4/18/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import "BRMenuOrderItemAttributesProxy.h"

#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemAttributes.h"

@implementation BRMenuOrderItemAttributesProxy {
	BRMenuOrderItem *target;
	UInt8 index;
}

@synthesize target, index;

- (id)initWithOrderItem:(BRMenuOrderItem *)item attributeIndex:(UInt8)idx {
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
