//
//  ThreadTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/16.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "ThreadTest.h"
// 异步并发队列
void asyncConcurrent() {
    NSLog(@"current thread %@",[NSThread currentThread]);
    /* 1. 创建一条并发队列 */
    
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("concurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    /* 2. 把任务放到队列中 */
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue task1 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue2 task2 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue task3 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue2 task4 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue task5 exe thread--------%@",[NSThread currentThread]);
    });
}

/// 同步并发队列
void syncConcurrent() {
    NSLog(@"current thread %@",[NSThread currentThread]);
    /* 1. 创建一条并发队列 */
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("concurrentQueue2", DISPATCH_QUEUE_CONCURRENT);
    /* 2. 把任务放到队列中 */
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"concurrentQueue task1 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue2, ^{
        NSLog(@"concurrentQueue2 task1 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"concurrentQueue task2 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue2, ^{
        NSLog(@"concurrentQueue2 task2 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_sync(concurrentQueue, ^{
        NSLog(@"concurrentQueue task3 exe thread--------%@",[NSThread currentThread]);
    });
}

/// 异步串行队列
void asyncSerial() {
    NSLog(@"current thread %@",[NSThread currentThread]);
    /* 1. 创建一条并发队列 */
    dispatch_queue_t concurrentQueue = dispatch_queue_create("concurrentQueue", DISPATCH_QUEUE_SERIAL);
    dispatch_queue_t concurrentQueue2 = dispatch_queue_create("concurrentQueue2", DISPATCH_QUEUE_SERIAL);
    /* 2. 把任务放到队列中 */
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue task1 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue2, ^{
        NSLog(@"concurrentQueue2 task1 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue task2 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue2, ^{
        NSLog(@"concurrentQueue2 task2 exe thread--------%@",[NSThread currentThread]);
    });
    dispatch_async(concurrentQueue, ^{
        NSLog(@"concurrentQueue task3 exe thread--------%@",[NSThread currentThread]);
    });
}

void nsthreadTest(void) {
    NSLog(@"开始创建线程");
//    @autoreleasepool {
//        for (int i = 0; i < 1000000; i++) {
//            NSThread * t = [[NSThread alloc]initWithBlock:^{
//                NSLog(@"initWithBlock 初始化 %@",[NSThread currentThread]);
//
//            }];
//            t.name = [NSString stringWithFormat:@"%d",i];
//            [t start];
//        }
//    }
    NSLog(@"创建线程完了");
   
}

@implementation ThreadTest

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block ThreadTest * kvoTest = [ThreadTest new];
    //    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
    //    [kvoTest addObserver:kvoTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"异步并行队列" obj:kvoTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
      
        asyncConcurrent();
        //        kvoTest.name = @"1234";
    };
    [arr addObject:j1];
    
    JumpModel * j3 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"同步并行队列" obj:kvoTest arg:nil];
    j3.jumpBlock = ^(UIViewController *vc) {
        
        syncConcurrent();
        //        kvoTest.name = @"1234";
    };
    [arr addObject:j3];
    
    JumpModel * j2 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"异步串行队列" obj:kvoTest arg:nil];
    j2.jumpBlock = ^(UIViewController *vc) {
        
        asyncSerial();
        //        kvoTest.name = @"1234";
    };
    [arr addObject:j2];
    
    
    JumpModel * t1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"nsthread" obj:kvoTest arg:nil];
    t1.jumpBlock = ^(UIViewController *vc) {
        
        nsthreadTest();
        //        kvoTest.name = @"1234";
    };
    [arr addObject:t1];
    
//    JumpModel * j4 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"异步串行队列" obj:kvoTest arg:nil];
//    j4.jumpBlock = ^(UIViewController *vc) {
//
//        asyncSerial();
//        //        kvoTest.name = @"1234";
//    };
//    [arr addObject:j4];
    
    
   
    
    return arr;
}

+ (NSString *)headTitle {
    return @"thread";
}

@end
