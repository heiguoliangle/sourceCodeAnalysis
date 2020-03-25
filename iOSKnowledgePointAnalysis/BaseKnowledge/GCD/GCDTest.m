//
//  GCDTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/21.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "GCDTest.h"


@interface GCDTest ()
@property(nonatomic,strong) dispatch_semaphore_t semaphore;

/// <#name#>
@property(nonatomic,assign) int  ticketCount;

@property(nonatomic,assign) GCDTest * t;

@end

@implementation GCDTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        _semaphore = dispatch_semaphore_create(1);
        _ticketCount = 1000;
        
        char autoreleaseActive = 0xa0;
        CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), autoreleaseActive, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
            
            NSLog(@"_wrapRunLoopWithAutoreleasePoolHandler");
            
        });
//        CFRunLoopAddObserver(CFRunLoopGetCurrent(), observer, kCFRunLoopDefaultMode);

        
//        CFRunLoopAddSource(CFRunLoopGetMain(), observer, kCFRunLoopCommonModes);
    }
    return self;
}


- (void)block {
    auto int b = 10;
    void (^myBLock)(void) = ^ {
        
        NSLog(@"123  %zd",b);
        NSLog(@"123  %@",self);

    };
    NSLog(@"------%@",myBLock);
    myBLock();
    NSLog(@"======%@",myBLock);
    
    NSLog(@"a  %zd",b);

    
    
    
}

- (void)alert {
//    [self.t alert];
//    return;
    dispatch_group_t group  = dispatch_group_create();
    dispatch_queue_t queue = dispatch_queue_create("alert", DISPATCH_QUEUE_CONCURRENT);
    dispatch_group_async(group, queue, ^{
        [self serachAlert];
    });
    
    dispatch_group_async(group, queue, ^{
        [self nomalAlert];
    });

    dispatch_group_notify(group, queue, ^{
        NSLog(@"结束");
    });
    
    
}

- (void)serachAlert {
    NSLog(@"开始 search");
     dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:2];
        NSLog(@"结束 search");
//        dispatch_semaphore_signal(sema);
        dispatch_semaphore_signal(self.semaphore);
    });
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER  );
//    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER  );
}

- (void)nomalAlert {
    NSLog(@"开始 nomal");
    dispatch_semaphore_t sema = dispatch_semaphore_create(0);
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        [NSThread sleepForTimeInterval:4];
        NSLog(@"结束 nomal");
        dispatch_semaphore_signal(self.semaphore);
//        dispatch_semaphore_signal(sema);
    });
//    dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER  );
//    NSLog(@"==========");
//    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER  );
   
}


// 调用测试方法
- (void)multiThread {
    
    dispatch_queue_t queue = dispatch_queue_create("QiMultiThreadSafeQueue", DISPATCH_QUEUE_CONCURRENT);
    for (NSInteger i=0; i<2; i++) {
        dispatch_async(queue, ^{
            [self testDispatchSemaphore:i];
        });
    }
}

/*******************************************************************************/

// 测试方法
- (void)testDispatchSemaphore:(NSInteger)num {
    
    while (1) {
        // 参数1为信号量；参数2为超时时间；ret为返回值
        //dispatch_semaphore_wait(_semaphore, DISPATCH_TIME_FOREVER);
        long ret = dispatch_semaphore_wait(_semaphore, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.21*NSEC_PER_SEC)));
        if (ret == 0) {
            if (_ticketCount > 0) {
                NSLog(@"%d 窗口 卖了第%d张票", (int)num, (int)_ticketCount);
                _ticketCount --;
            }
            else {
                dispatch_semaphore_signal(_semaphore);
                NSLog(@"%d 卖光了", (int)num);
                break;
            }
            [NSThread sleepForTimeInterval:0.2];
            dispatch_semaphore_signal(_semaphore);
        }
        else {
            NSLog(@"%d %@", (int)num, @"超时了");
        }
        
        [NSThread sleepForTimeInterval:0.2];
    }
}

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block GCDTest * o = [GCDTest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"gcd 信号量" obj:0 arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
        [o multiThread];
    };
    [arr addObject:j1];
    
    JumpModel * j2 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"弹框系统" obj:0 arg:nil];
    j2.jumpBlock = ^(UIViewController *vc) {
        
        [o alert];
//        [o block];
    };
    [arr addObject:j2];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"GCD";
}

@end
