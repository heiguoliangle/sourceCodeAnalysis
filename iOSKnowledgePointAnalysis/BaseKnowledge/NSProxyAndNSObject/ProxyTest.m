//
//  ProxyTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/19.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "ProxyTest.h"


@interface ProxyA : NSProxy
@property (nonatomic, strong) id target;
@end

@implementation ProxyA

- (id)initWithObject:(id)object {
    self.target = object;
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.target methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}

@end



@interface ProxyB : NSObject
@property (nonatomic, strong) id target;
@end

@implementation ProxyB

- (id)initWithObject:(id)object {
    self = [super init];
    if (self) {
        self.target = object;
    }
    return self;
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector {
    return [self.target methodSignatureForSelector:selector];
}

- (void)forwardInvocation:(NSInvocation *)invocation {
    [invocation invokeWithTarget:self.target];
}


@end

@implementation ProxyTest



#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block ProxyTest * kvoTest = [ProxyTest new];
    //    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
    //    [kvoTest addObserver:kvoTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc] initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"NSProxy 和 NSObject" obj:kvoTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        NSString *string = @"test";
        ProxyA *proxyA = [[ProxyA alloc] initWithObject:string];
        ProxyB *proxyB = [[ProxyB alloc] initWithObject:string];
        
        NSLog(@"%d", [proxyA respondsToSelector:@selector(length)]);
        NSLog(@"%d", [proxyB respondsToSelector:@selector(length)]);
        
        NSLog(@"%d", [proxyA isKindOfClass:[NSString class]]);
        NSLog(@"%d", [proxyB isKindOfClass:[NSString class]]);
        
    };
    [arr addObject:j1];
    return arr;
}

+ (NSString *)headTitle {
    return @"NSProxy 和 NSObject";
}


@end

