//
//  GCDObject.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/10.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "GCDObject.h"

@implementation GCDObject

+ (void)testGroup {
    dispatch_group_t group = dispatch_group_create();
    dispatch_queue_t myQueue = dispatch_queue_create("com.example.MyQueue", DISPATCH_QUEUE_CONCURRENT);
    dispatch_queue_t finishQueue = dispatch_queue_create("com.example.finishQueue", NULL);
    
    dispatch_group_async(group, myQueue, ^{NSLog(@"Task 1");});
    dispatch_group_async(group, myQueue, ^{NSLog(@"Task 2");});
    dispatch_group_async(group, myQueue, ^{NSLog(@"Task 3");});
    
    
    dispatch_group_notify(group, finishQueue, ^{
        NSLog(@"All Done!");
    });
    
    
    dispatch_group_wait(group, 2);
}


+ (void)testCreatBlock {
    dispatch_queue_attr_t attr_t = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,  QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    dispatch_queue_t queue1 = dispatch_queue_create("com.zhaomu.test1", attr_t);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zhaomu.test2", attr_t);
    dispatch_block_t block1 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第一只熊猫宝宝向你奔来...");
    });
    dispatch_block_t block2 = dispatch_block_create_with_qos_class(DISPATCH_BLOCK_ENFORCE_QOS_CLASS, QOS_CLASS_USER_INTERACTIVE, -1, ^{
        NSLog(@"第二只熊猫宝宝向你奔来...");
    });
    dispatch_block_t block3 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第三只熊猫宝宝向你奔来...");
    });
    dispatch_async(queue1, block1);
    dispatch_async(queue2, block2);
    dispatch_async(queue2, block3);
}

+ (void)testBlockWait {
    dispatch_queue_attr_t attr_t = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,  QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    dispatch_queue_t queue1 = dispatch_queue_create("com.zhaomu.test1", attr_t);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zhaomu.test2", attr_t);
    dispatch_block_t block1 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第一只熊猫宝宝向你奔来...");
    });
    dispatch_block_t block2 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第二只熊猫宝宝向你奔来...");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"第二只熊猫宝宝已经抱住你大腿...");
    });
    
    dispatch_block_t block3 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第三只熊猫宝宝向你奔来...");
    });
    
    dispatch_async(queue1, block1);
    dispatch_async(queue2, block2);
    
    dispatch_block_wait(block2, DISPATCH_TIME_FOREVER);
    
    dispatch_async(queue2, block3);
    NSLog(@"熊猫妈妈在找熊猫宝宝...");
}

+ (void)testBlockNotify {
    dispatch_queue_attr_t attr_t = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,  QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    dispatch_queue_t queue1 = dispatch_queue_create("com.zhaomu.test1", attr_t);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zhaomu.test2", attr_t);
    dispatch_block_t block1 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第一只熊猫宝宝向你奔来...");
    });
    dispatch_block_t block2 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第二只熊猫宝宝向你奔来...");
//        [NSThread sleepForTimeInterval:5];
        NSLog(@"第二只熊猫宝宝已经抱住你大腿...");
    });
    
    dispatch_block_t block3 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第三只熊猫宝宝向你奔来1...");
        NSLog(@"第三只熊猫宝宝向你奔来2...");
    });
    
    dispatch_async(queue1, block1);
    dispatch_async(queue2, block2);
    
    dispatch_block_notify(block2, queue2, ^{
        NSLog(@"捕获一个熊猫宝宝...");
    });
    
    dispatch_async(queue2, block3);
    NSLog(@"熊猫妈妈在找熊猫宝宝...");
}


+ (void)testBlockCancel {
    dispatch_queue_attr_t attr_t = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,  QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    dispatch_queue_t queue1 = dispatch_queue_create("com.zhaomu.test1", attr_t);
    dispatch_queue_t queue2 = dispatch_queue_create("com.zhaomu.test2", attr_t);
    dispatch_block_t block1 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第一只熊猫宝宝向你奔来...");
    });
    dispatch_block_t block2 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第二只熊猫宝宝向你奔来...");
        [NSThread sleepForTimeInterval:3];
        NSLog(@"第二只熊猫宝宝已经抱住你大腿...");
    });
    
    dispatch_block_t block3 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第三只熊猫宝宝向你奔来...");
    });
    
    dispatch_async(queue1, block1);
    dispatch_async(queue2, block2);
    dispatch_async(queue2, block3);
    
    dispatch_block_cancel(block3);
}

+ (void)testBlockSuspendAndResume {
    dispatch_queue_t queue = dispatch_queue_create("com.zhaomu.test", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_block_t block1 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第一只熊猫宝宝向你奔来...");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"第一只熊猫宝宝抱住你的大腿...");
    });
    
    dispatch_block_t block2 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第二只熊猫宝宝向你奔来...");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"第二只熊猫宝宝抱住你的大腿...");
    });
    
    dispatch_block_t block3 = dispatch_block_create(DISPATCH_BLOCK_DETACHED, ^{
        NSLog(@"第三只熊猫宝宝向你奔来...");
        [NSThread sleepForTimeInterval:5];
        NSLog(@"第三只熊猫宝宝抱住你的大腿...");
    });
    
    dispatch_suspend(queue);
    
    dispatch_async(queue, block1);
    dispatch_async(queue, block2);
    dispatch_async(queue, block3);
    
    NSLog(@"熊猫妈妈正在找熊猫宝宝....");
    [NSThread sleepForTimeInterval:3];
    dispatch_resume(queue);
}


+ (void)testDispatchApply {
    dispatch_queue_attr_t attr_t = dispatch_queue_attr_make_with_qos_class(DISPATCH_QUEUE_CONCURRENT,  QOS_CLASS_UTILITY, QOS_MIN_RELATIVE_PRIORITY);
    dispatch_queue_t queue = dispatch_queue_create("com.zhaomu.test", attr_t);
    
    
    dispatch_apply(10, queue, ^(size_t idx) {
        NSLog(@"%@ --> 第%@只熊猫宝宝向你奔来...", [NSThread currentThread],@(idx));
    });
}

- (void)testDispatchTask {
    dispatch_queue_t queue = dispatch_queue_create("test1", 0);
    dispatch_queue_t queue2 = dispatch_queue_create("test2", 0);
    
    
}
@end
