//
//  MsgSwizzingTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/25.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "MsgSwizzingTest.h"

@implementation MsgSwizzingTest
- (void)sayHello {
    NSLog(@"person say hello");
}


@end


@interface MsgSonSwizzingTest : MsgSwizzingTest

@end

@implementation MsgSonSwizzingTest

+ (void)load {
    
}

- (void)s_sayHello {
    [self s_sayHello];
    
    NSLog(@"Student + swizzle say hello");
}

@end

@implementation MsgSwizzingTest (swizzle)

+ (void)load {
}

- (void)p_sayHello {
    [self p_sayHello];
    NSLog(@"Person + swizzle say hello");
}

@end
