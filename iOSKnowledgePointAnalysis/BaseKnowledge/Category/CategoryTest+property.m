//
//  CategoryTest+property.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/22.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "CategoryTest+property.h"
#import <objc/runtime.h>

static NSString * nameKey = @"nameKey";

@implementation CategoryTest (property)

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name {
    return  objc_getAssociatedObject(self, &nameKey);
}
@end
