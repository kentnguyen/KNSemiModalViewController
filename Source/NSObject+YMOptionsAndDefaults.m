
//  Created by YangMeyer on 08.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import "NSObject+YMOptionsAndDefaults.h"
#import <objc/runtime.h>

@implementation NSObject (YMOptionsAndDefaults)

static char const * const kYMStandardOptionsTableName = "YMStandardOptionsTableName";
static char const * const kYMStandardDefaultsTableName = "YMStandardDefaultsTableName";

- (void)ym_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults
{
	objc_setAssociatedObject(self, kYMStandardOptionsTableName, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, kYMStandardDefaultsTableName, defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)ym_optionOrDefaultForKey:(NSString*)optionKey
{
	NSDictionary *options = objc_getAssociatedObject(self, kYMStandardOptionsTableName);
	NSDictionary *defaults = objc_getAssociatedObject(self, kYMStandardDefaultsTableName);
	NSAssert(defaults, @"Defaults must have been set when accessing options.");
	return options[optionKey] ?: defaults[optionKey];
}

@end
