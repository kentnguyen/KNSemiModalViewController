
//  Created by YangMeyer on 08.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSObject+YMOptionsAndDefaults.h"
#import <objc/runtime.h>

@implementation NSObject (YMOptionsAndDefaults)

#define kYMStandardOptionsTableName @"YMStandardOptionsTableName"
#define kYMStandardDefaultsTableName @"YMStandardDefaultsTableName"

- (void)ym_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults
{
	objc_setAssociatedObject(self, (__bridge const void *)(kYMStandardOptionsTableName), options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, (__bridge const void *)(kYMStandardDefaultsTableName), defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ym_optionOrDefaultForKey:(NSString*)optionKey
{
	NSDictionary *options = objc_getAssociatedObject(self, (__bridge const void *)(kYMStandardOptionsTableName));
	NSDictionary *defaults = objc_getAssociatedObject(self, (__bridge const void *)(kYMStandardDefaultsTableName));
	NSAssert(defaults, @"Defaults must have been set when accessing options.");
	return options[optionKey] ?: defaults[optionKey];
}

@end
