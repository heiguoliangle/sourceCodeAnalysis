//
//  CategoryTest+test1.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/4/2.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "CategoryTest+test1.h"
#import <objc/runtime.h>

@implementation CategoryTest (test1)
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
        [self swizzleSEL:@selector(lyz_ivar) withSEL:@selector(test1)];
    });
}

- (void)test1 {
    [self test1];
    NSLog(@"CategoryTest 分类test的 的");
}

@end
