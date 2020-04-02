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


+ (void)swizzleSEL:(SEL)originalSEL withSEL:(SEL)swizzledSEL {
    
    Class class = [self class];
    
    Method originalMethod = class_getInstanceMethod(class, originalSEL);
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSEL);
    
    BOOL didAddMethod =
    class_addMethod(class,
                    originalSEL,
                    method_getImplementation(swizzledMethod),
                    method_getTypeEncoding(swizzledMethod));
    
    if (didAddMethod) {
        class_replaceMethod(class,
                            swizzledSEL,
                            method_getImplementation(originalMethod),
                            method_getTypeEncoding(originalMethod));
    } else {
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
}
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleSEL:@selector(lyz_ivar) withSEL:@selector(test)];
    });
}

- (void)test {
    [self test];
    NSLog(@"CategoryTest+property 分类的 的");
}

- (void)setName:(NSString *)name {
    objc_setAssociatedObject(self, &nameKey, name, OBJC_ASSOCIATION_COPY);
}

- (NSString *)name {
    return  objc_getAssociatedObject(self, &nameKey);
}
@end
