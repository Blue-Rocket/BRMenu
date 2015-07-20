//
//  BRMenuOrder+Encoding.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrder+Encoding.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuOrderItem.h"
#import "BRMenuOrderItemAttributes.h"
#import "BRMenuOrderItemComponent.h"


const UInt8 APOrderEncodingFormat_v1 = 0x1;

static const int kBufSize = 1024;

@implementation BRMenuOrder (Encoding)

- (NSData *)dataForBarcodeEncoding {
	UInt8 buf[kBufSize];
	NSMutableData *data = [[NSMutableData alloc] initWithCapacity:1024];
	
	// first byte is the data format... only type 1 supported now
	buf[0] = APOrderEncodingFormat_v1;
	
	// add menu version, 16 bits as hi, lo bytes
	buf[1] = (UInt8)((self.menu.version >> 8) & 0xF);
	buf[2] = (UInt8)(self.menu.version & 0xF);
	[data appendBytes:buf length:3];
	
	// encode order name
	if ( self.name.length > 0 ) {
		[data appendData:[self.name dataUsingEncoding:NSISOLatin1StringEncoding allowLossyConversion:YES]];
	}
	
	// add NULL name terminator byte to mark end of name
	buf[0] = (UInt8)0;
	[data appendBytes:&buf length:1];
	
	// add item count
	buf[0] = (UInt8)[self.orderItems count];
	[data appendBytes:&buf length:1];
	
	// add items
	for ( BRMenuOrderItem *item in self.orderItems ) {
		int len = (3 + (2 * (int)[item.components count]) + item.quantity);
		if ( len >= kBufSize ) {
			NSLog(@"Too many item components: %lu", (unsigned long)[item.components count]);
			continue;
		}
		
		// quantity allowed 6 bits (0-63) and takeAway flag stored on bit 7; bit 8 free still
		buf[0] = item.item.itemId;
		buf[1] = (item.quantity & 0x3F);
		buf[2] = (UInt8)[item.components count];
		int idx = 3;
		for ( BRMenuOrderItemComponent *component in item.components ) {
			buf[idx++] = component.component.componentId;
			
			// placement in bits 2-3, quantity in bits 0-2
			buf[idx++] = (((component.placement & 0x3) << 2) | (component.quantity & 0x3));
		}
		for ( int i = 0; i < item.quantity; i++ ) {
			BRMenuOrderItemAttributes *attr = [item attributesAtIndex:i];
			buf[idx++] = (attr.takeAway);
		}
		[data appendBytes:buf length:len];
	}
	return data;
}

+ (BRMenuOrder *)orderWithBarcodeData:(NSData *)data menuProvider:(id<BRMenuProvider>)provider {
	const NSUInteger dataLength = [data length];
	if ( dataLength < 3 ) {
		NSLog(@"Data too short (%lu) to decode BRMenuOrder", (unsigned long)dataLength);
		return nil;
	}
	
	UInt8 *buf = malloc(sizeof(UInt8) * dataLength);
	if ( buf == NULL ) {
		NSLog(@"Unable to malloc buffer of size %lu", (unsigned long)dataLength);
		return nil;
	}

	BRMenu *menu = nil;
	BRMenuOrder *result = nil;
	int i = 0, j, k, len;
	NSString *string = nil;
	UInt16 menuVersion = 0;
	@try {
		[data getBytes:buf length:dataLength];
		// encoding format is byte 1, must be v1
		if ( buf[0] != APOrderEncodingFormat_v1 ) {
			NSLog(@"Encoding format %u not supported", buf[0]);
			return nil;
		}
		
		// get menu version (bytes 2 and 3)
		menuVersion = (UInt16)buf[++i] << 8;
		menuVersion |= (UInt16)buf[++i];
		menu = [provider menuForVersion:menuVersion];
		if ( menu == nil ) {
			NSLog(@"No menu provided for version %u", menuVersion);
			return nil;
		}
		
		// find null character, after version bytes
		for ( j = ++i; i < dataLength; i++ ) {
			if ( buf[i] == 0 ) {
				if ( i == 0 ) {
					string = @"";
				} else {
					string = [NSString stringWithCString:(const char *)&buf[j] encoding:NSISOLatin1StringEncoding];
				}
				break;
			}
		}
		
		if ( string == nil ) {
			NSLog(@"Name not found, cannot decode BRMenuOrder from data");
			return nil;
		}
		
		result = [[BRMenuOrder alloc] init];
		result.name = string;
		result.menu = menu;
		
		// increment index to get past null character and read item count
		const int itemCount = (int)buf[++i];
		UInt8 quantity, itemId, compCount;
		if ( (++i) < dataLength ) {
			// decode order items, at most itemCount but also checking against buffer length
			for ( j = 0; j < itemCount && i < (dataLength - 3); j++ ) {
				itemId = buf[i++];
				quantity = buf[i++];
				compCount = buf[i++];
				BRMenuOrderItem *orderItem = [[BRMenuOrderItem alloc] init];
				orderItem.quantity = (quantity & 0x3F);
				orderItem.item = [menu menuItemForId:itemId];
				
				// read in any components
				if ( compCount > 0 ) {
					for ( k = 0, len = i + (compCount * 2); i < len && i < dataLength; i += 2, k++ ) {
						BRMenuItemComponent *comp = [menu menuItemComponentForId:buf[i]];
						if ( comp != nil ) {
							APOrderItemComponentPlacement placement = ((buf[i+1] >> 2) & 0x3);
							APOrderItemComponentQuantity quantity = (buf[i+1] & 0x3);
							BRMenuOrderItemComponent *orderComp = [[BRMenuOrderItemComponent alloc] initWithComponent:comp
																								placement:placement
																								 quantity:quantity];
							[orderItem addComponent:orderComp];
						} else {
							NSLog(@"BRMenuItemComponent %u not found in BRMenu version %u for BRMenuOrderItem %d component %d",
								  buf[i], menuVersion, j, k);
						}
					}
					if ( i > len ) {
						i--; // back up from i += 2 executed in for loop
					}
				}
				
				// read in attributes (one per quantity)
				for ( k = 0, len = i + orderItem.quantity; i < len && i < dataLength; i++, k++ ) {
					BRMenuOrderItemAttributes *attr = [[BRMenuOrderItemAttributes alloc] init];
					attr.takeAway = buf[i] & 0x1;
					[orderItem setAttributes:attr atIndex:k];
				}
				
				if ( orderItem.item == nil ) {
					NSLog(@"BRMenuItem %u not found in BRMenu version %u for BRMenuOrderItem %d", itemId, menuVersion, j);
					continue;
				}
				[result addOrderItem:orderItem];
			}
		}
		
	} @finally {
		free(buf);
	}
	return result;
}

@end
