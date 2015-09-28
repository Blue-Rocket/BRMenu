//
//  BRMenuOrder+Encoding.h
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuOrder.h"
#import "BRMenuProvider.h"

extern const uint8_t BRMenuOrderEncodingFormat_v1;

@interface BRMenuOrder (Encoding)

// encode an BRMenuOrder into data suitable for encoding into a barcode
- (NSData *)dataForBarcodeEncoding;

// decode data previously encoded via dataForBarcodeEncoding into an BRMenuOrder instance
+ (BRMenuOrder *)orderWithBarcodeData:(NSData *)data menuProvider:(id<BRMenuProvider>)provider;

@end
