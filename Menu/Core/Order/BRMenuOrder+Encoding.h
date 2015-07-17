//
//  BRMenuOrder+Encoding.h
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Pervasent Consulting, Inc. All rights reserved.
//

#import "BRMenuOrder.h"
#import "BRMenuProvider.h"

extern const UInt8 APOrderEncodingFormat_v1;

@interface BRMenuOrder (Encoding)

// encode an BRMenuOrder into data suitable for encoding into a barcode
- (NSData *)dataForBarcodeEncoding;

// decode data previously encoded via dataForBarcodeEncoding into an BRMenuOrder instance
+ (BRMenuOrder *)orderWithBarcodeData:(NSData *)data menuProvider:(id<BRMenuProvider>)provider;

@end
