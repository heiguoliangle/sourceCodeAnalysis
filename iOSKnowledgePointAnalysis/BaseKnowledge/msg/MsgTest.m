//
//  MsgTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/17.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "MsgTest.h"
#import <objc/runtime.h>
#import <objc/message.h>

@implementation SubMsgTest

+(void)load {
    NSLog(@"SubMsgTest load");
}

+ (void)initialize {
    [super initialize];
    NSLog(@"SubMsgTest initialize");
}

@end

@implementation MsgTest

+(void)load {

    NSLog(@"MsgTest load");
}

+ (void)initialize {
    [super initialize];
    NSLog(@"MsgTest initialize");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eat)) {
        class_addMethod([self class] , sel, (IMP)myEatMehtod, "v@");
        return YES;
    }else {
        return [super resolveInstanceMethod:sel];
    }
}

- (id)forwardingTargetForSelector:(SEL)aSelector {
    
    if (aSelector == @selector(eat)) {
        return [NSObject new];
    }else {
        return [super forwardingTargetForSelector:aSelector];
    }
}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    NSObject * o = [NSObject new];
    if ([o respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:o];
    }else{
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(eat)) {
        return [NSObject instanceMethodSignatureForSelector:aSelector];
    }else {
        return [super methodSignatureForSelector:aSelector];
    }
}

void myEatMehtod(id self,SEL _cmd){
    NSLog(@"This is added dynamic");
}

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    MsgTest * msgTest = [MsgTest new];
    SubMsgTest * a = [SubMsgTest new];
    //    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
    //    [kvoTest addObserver:kvoTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"发送不存在的方法" obj:msgTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        [msgTest performSelector:@selector(eat)];
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"sendmsg";
}

@end
