
//  Created by YangMeyer on 08.10.12.
//  Copyright (c) 2012 Yang Meyer. All rights reserved.

#import <Foundation/Foundation.h>

@interface NSObject (YMOptionsAndDefaults)

- (void)ym_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults;

- (id)ym_optionOrDefaultForKey:(NSString*)optionKey;

@end
