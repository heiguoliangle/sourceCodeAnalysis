//
//  AtomicTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "AtomicTest.h"

@implementation AtomicTest

- (void)test {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0 );
    
    dispatch_apply(1000, queue, ^(size_t c) {
        NSLog(@"当前线程%@ 第%zd次",[NSThread currentThread],c);
        self.count += 1;
    });
    NSLog(@"1000 次后的cont %d",self.count);
}


- (void)test1 {
    dispatch_queue_t queue = dispatch_get_global_queue(0, 0 );
    
    dispatch_apply(100, queue, ^(size_t c) {
//        [NSThread sleepForTimeInterval:2];
        [self.arr addObject:@(c)];
        NSLog(@"write %@",self.arr);
    });
    
    dispatch_apply(100, queue, ^(size_t c) {
        
        NSLog(@"read %@",self.arr);
    });
    
}


- (NSMutableArray *)arr {
    if (!_arr) {
        _arr = [NSMutableArray array];
    }
    return _arr;
}



+ (NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"atomic 属性" obj:[self alloc] arg:nil];
    
    [arr addObject:j1];
    
    JumpModel * j2 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test1) title:@"atomic 修饰数组,更改数组(有几率crash)" obj:[self alloc] arg:nil];
    
    [arr addObject:j2];
    return arr;
}

+ (NSString *)headTitle {
    return @"atomic 是不安全的";
}

@end
