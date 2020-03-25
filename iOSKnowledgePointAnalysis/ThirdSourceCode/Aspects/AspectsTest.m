//
//  AspectsTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/25.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "AspectsTest.h"
#import "Aspects.h"
#import "objc/runtime.h"


@interface SonAspectsTest : TestBaseModel

@end
@implementation SonAspectsTest
+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class catMetal = objc_getMetaClass(NSStringFromClass(AspectsTest.class).UTF8String);
        
        
        [SonAspectsTest aspect_hookSelector:@selector(testRun) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
            NSLog(@"这个是hook后的");
        } error:nil];
        
    });
}

@end


@implementation AspectsTest

- (void)testRun {
    NSLog(@"父类 AspectsTest run");
}
//+ (void)load {
//    static dispatch_once_t onceToken;
//    dispatch_once(&onceToken, ^{
//        Class catMetal = objc_getMetaClass(NSStringFromClass(AspectsTest.class).UTF8String);
//
//
//        [AspectsTest aspect_hookSelector:@selector(testRun) withOptions:AspectPositionBefore usingBlock:^(id<AspectInfo> info) {
//            NSLog(@"这个是hook后的");
//        } error:nil];
//
//    });
//}


#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block AspectsTest * o = [AspectsTest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"Aspects hook" obj:0 arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        SonAspectsTest * t = [SonAspectsTest new];
        BOOL a = [t respondsToSelector:@selector(testRun)];
        BOOL a1 = [t.class instancesRespondToSelector:@selector(testRun)];
        BOOL b = [o respondsToSelector:@selector(testRun)];
        BOOL b1 = [o.class instancesRespondToSelector:@selector(testRun)];
        [o testRun];
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"Aspects hook";
}

@end
