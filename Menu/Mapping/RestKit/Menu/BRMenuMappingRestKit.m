//
//  BRMenuJSON.m
//  BRMenu
//
//  Created by Matt on 4/2/13.
//  Copyright (c) 2013 Blue Rocket, Inc. All rights reserved.
//

#import "BRMenuMappingRestKit.h"

#import "BRMenu.h"
#import "BRMenuItem.h"
#import "BRMenuItemComponent.h"
#import "BRMenuItemComponentGroup.h"
#import "BRMenuItemGroup.h"
#import "BRMenuItemTag.h"

@implementation BRMenuMappingRestKit

+ (RKObjectMapping *)menuItemComponentMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRMenuItemComponent class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"title" : @"title",
     @"description" : @"desc",
	 @"askQuantity" : @"askQuantity",
	 @"askPlacement" : @"askPlacement",
     @"showWithFoodInformation" : @"showWithFoodInformation",
	 @"absenceOfComponent" : @"absenceOfComponent",
	 }];
	return mapping;
}

+ (RKObjectMapping *)menuItemComponentGroupMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRMenuItemComponentGroup class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"title" : @"title",
	 @"description" : @"desc",
	 @"key": @"key",
	 @"extends": @"extendsKey",
	 @"multiSelect" : @"multiSelect",
	 @"requiredCount" : @"requiredCount",
	 }];
	[mapping addRelationshipMappingWithSourceKeyPath:@"components" mapping:[self menuItemComponentMapping]];
	[mapping addRelationshipMappingWithSourceKeyPath:@"componentGroups" mapping:mapping];
	return mapping;
}

+ (RKObjectMapping *)menuItemMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRMenuItem class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"title" : @"title",
	 @"description" : @"desc",
	 @"key": @"key",
	 @"extends": @"extendsKey",
	 @"price" : @"price",
	 @"tags" : @"tags",
	 @"askTakeaway" : @"askTakeaway",
	 @"needsReview" : @"needsReview",
	 }];
	
	[mapping addRelationshipMappingWithSourceKeyPath:@"componentGroups" mapping:[self menuItemComponentGroupMapping]];
	return mapping;
}

+ (RKObjectMapping *)menuItemGroupMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRMenuItemGroup class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"title" : @"title",
	 @"description" : @"desc",
	 @"key": @"key",
	 @"price" : @"price",
	 @"showItemDelimiters": @"showItemDelimiters",
	 }];
	[mapping addRelationshipMappingWithSourceKeyPath:@"items" mapping:[self menuItemMapping]];
	[mapping addRelationshipMappingWithSourceKeyPath:@"itemGroups" mapping:mapping];
	return mapping;
}

+ (RKObjectMapping *)menuItemTagMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRMenuItemTag class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"title" : @"title",
	 @"description" : @"desc",
	 @"key": @"key",
	 }];
	return mapping;
}

+ (RKObjectMapping *)menuMapping {
	RKObjectMapping* mapping = [RKObjectMapping mappingForClass:[BRMenu class]];
	[mapping addAttributeMappingsFromDictionary:@{
	 @"version" : @"version"
	 }];
	[mapping addRelationshipMappingWithSourceKeyPath:@"items" mapping:[self menuItemMapping]];
	[mapping addRelationshipMappingWithSourceKeyPath:@"groups" mapping:[self menuItemGroupMapping]];
	[mapping addRelationshipMappingWithSourceKeyPath:@"tags" mapping:[self menuItemTagMapping]];
	return mapping;
}

@end
