//
//  StyleExportViewController.m
//  MenuSampler
//
//  Created by Matt on 3/08/15.
//  Copyright (c) 2015 Blue Rocket. All rights reserved.
//

#import "StyleExportViewController.h"

#import <BRCocoaLumberjack/BRCocoaLumberjack.h>
#import <MenuKit/UI/UIViewController+BRMenuUIStyle.h>
#import <MenuKit/RestKit/RestKit.h>
#import <MenuKit/UI-RestKit/BRMenuUIMappingRestKit.h>

@interface StyleExportViewController () <BRMenuUIStylish>
@property (strong, nonatomic) IBOutlet UITextView *textView;
@end

@implementation StyleExportViewController

@dynamic uiStyle;

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	BRMenuUIStyle *style = self.uiStyle;
	NSString *json = [self jsonForStyle:style];
	self.textView.text = json;
}

- (NSString *)jsonForStyle:(BRMenuUIStyle *)style {
	static BRMenuRestKitDataMapper *mapper;
	if ( !mapper ) {
		mapper = [[BRMenuRestKitDataMapper alloc] initWithObjectMapping:[BRMenuUIMappingRestKit uiStyleMapping]];
	}
	
	NSError *error = nil;
	NSDictionary *dict = [mapper performEncodingWithObject:style error:&error];
	if ( error ) {
		log4Error(@"Error mapping JSON: %@", [error localizedDescription]);
		return nil;
	}
	NSData *data = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&error];
	if ( error ) {
		log4Error(@"Error encoding JSON: %@", [error localizedDescription]);
		return nil;
	}
	return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

@end
