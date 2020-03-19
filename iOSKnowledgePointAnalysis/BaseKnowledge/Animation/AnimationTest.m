//
//  AnimationTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/19.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "AnimationTest.h"
#import "AnimationVC.h"

@implementation AnimationTest
+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block AnimationTest * kvoTest = [AnimationTest new];
    //    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
    //    [kvoTest addObserver:kvoTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc] initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"NSProxy 和 NSObject" obj:kvoTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
        [vc.navigationController pushViewController:[AnimationVC new] animated:YES];
    };
    [arr addObject:j1];
    return arr;
}

+ (NSString *)headTitle {
    return @"NSProxy 和 NSObject";
}

@end
