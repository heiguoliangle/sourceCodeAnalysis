//
//  KVCTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/16.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "KVCTest.h"

@interface KVCTest(){
    NSString * _isName;
}

@end

@implementation KVCTest

- (void)test {
    NSLog(@"name: %@",_isName);
}

//+ (BOOL)accessInstanceVariablesDirectly {
//    return NO;
//}

- (void)setNilValueForKey:(NSString *)key {
    NSLog(@"set nil");
}

//- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
//
//}

- (void)setName:(NSString *)name1 {
//    name = name1;
    NSLog(@"setName:");
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    NSLog(@"%@",change);
}

- (void)dealloc {
    [self removeObserver:self forKeyPath:@"name"];
}



#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block KVCTest * kvcTest = [KVCTest new];
    
    //    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
        [kvcTest addObserver:kvcTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"kvc 属性 name" obj:kvcTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
//        [kvcTest setValue:nil forKey:@"name"];
        [kvcTest setValue:@"水电费" forKey:@"name"];
        [kvcTest test];
        
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"kvc";
}

@end
