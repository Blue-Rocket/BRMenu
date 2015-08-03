//
//  BRMenu.m
//  MenuKit
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket. Distributable under the terms of the Apache License, Version 2.0.
//

#import "BRMenuAFHTTPResponseSerializer.h"

#import "BRMenuMappingRestKit.h"

@implementation BRMenuAFHTTPResponseSerializer

- (id)responseObjectForResponse:(NSURLResponse *)response
						   data:(NSData *)data
						  error:(NSError *__autoreleasing *)error {
	id json = [super responseObjectForResponse:response data:data error:error];
	id resultObject = json;
	if ( json ) {
		resultObject = [self.dataMapper performMappingWithSourceObject:(self.rootKeyPath ? [json valueForKeyPath:self.rootKeyPath] : json)
																 error:error];
	}
	return resultObject;
}

@end
