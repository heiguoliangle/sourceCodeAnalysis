//
//  RuntimeObject.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "RuntimeObject.h"
#import <objc/runtime.h>
#import <objc/message.h>
#import <Aspects.h>

@implementation RuntimeObject

- (void)test {
    NSLog(@"this is super %@",self);
}

//+ (BOOL)resolveClassMethod:(SEL)sel {
//    if (sel == @selector(eat)) {
//        class_addMethod(self, sel, (IMP)myEatMehtod, "v@");
////        return YES;
//        return NO;
//    }else {
//
//        return [super resolveInstanceMethod:sel];
//    }
    
//}

+ (void)eat {
    NSLog(@"这个是基类的类方法实现");
}

+ (BOOL)resolveInstanceMethod:(SEL)sel {
    if (sel == @selector(eat)) {
//        class_addMethod([self class] , sel, (IMP)myEatMehtod, "v@");
//        return YES;
        return NO;
    }else {
        return [super resolveInstanceMethod:sel];
    }
}

//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    if (aSelector == @selector(eat)) {
//        return [SubRuntimeObject new];
//    }else {
//        return [super forwardingTargetForSelector:aSelector];
//    }
//}

- (void)forwardInvocation:(NSInvocation *)anInvocation {
    GrandSonRuntimeObject * o = [GrandSonRuntimeObject new];
    if ([o respondsToSelector:[anInvocation selector]]) {
        [anInvocation invokeWithTarget:o];
    }else{
        [super forwardInvocation:anInvocation];
    }
}

- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
    if (aSelector == @selector(eat)) {
        return [GrandSonRuntimeObject instanceMethodSignatureForSelector:aSelector];
    }else {
        return [super methodSignatureForSelector:aSelector];
    }
}

void myEatMehtod(id self,SEL _cmd){
    NSLog(@"This is added dynamic");
}


//- (id)forwardingTargetForSelector:(SEL)aSelector {
//    NSString * aStr = NSStringFromSelector(aSelector);
//    if (aStr == @"eat") {
//
//    }
//
//    return <#expression#>;
//}
//
//- (NSMethodSignature *)methodSignatureForSelector:(SEL)aSelector {
//
//}
//
//
//- (void)forwardInvocation:(NSInvocation *)anInvocation {
//
//}
//
//- (void)doesNotRecognizeSelector:(SEL)aSelector {
//    NSLog(@"这里是 doesNotRecognizeSelector");
////    [super doesNotRecognizeSelector:aSelector];
//}

//- (void)eat {
//    NSLog(@"类方法的eat");
//}

@end

@implementation SubRuntimeObject

- (void)test {
    NSLog(@"this is sub %@",self);
}

- (void)eat {
    NSLog(@"这个是子类SubRuntimeObject 的eat");
}

@end




@implementation GrandSonRuntimeObject

- (void)test {
    NSLog(@"this is sub %@",self);
}

- (void)eat {
    NSLog(@"这个是孙子类GrandSonRuntimeObject 的eat");
}

@end

