//
//  TimerTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/19.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "TimerTest.h"

@interface TimerTest()
@property(nonatomic,strong) dispatch_source_t timer;

@property(nonatomic,strong) NSTimer *nstimer;


@end

@implementation TimerTest


- (void)nstimerTest {
//    self.nstimer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timerFun:) userInfo:@"参数" repeats:YES];
    self.nstimer = [[NSTimer alloc]initWithFireDate:[NSDate date] interval:1 target:self selector:@selector(timerFun:) userInfo:@"参数" repeats:YES];
    [[NSRunLoop currentRunLoop]addTimer:self.nstimer forMode:NSRunLoopCommonModes];
    [[NSRunLoop currentRunLoop]run];
}


- (void)timerFun:(id)arg {
    NSLog(@"%@ Thread %@",arg,[NSThread currentThread]);
}


- (void)gcdTimerTest {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW , 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    dispatch_source_set_event_handler(timer, ^{
        NSLog(@"GCD thread %@",[NSThread currentThread]);
    });
    //开启定时器
    dispatch_resume(timer);
    self.timer = timer;
}


- (void)cancleGCDTimertest {
    //销毁定时器
    if (self.timer) {
        dispatch_source_cancel(self.timer);
        self.timer = nil;
    }
    
    
    if (self.nstimer) {
        [self.nstimer invalidate];
        self.nstimer = nil;
//        [[NSThread currentThread]cancel];
    }
    
    NSLog(@"销毁计时器");
}


#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block TimerTest * kvcTest = [TimerTest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"gcd timer" obj:kvcTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [kvcTest gcdTimerTest];
        });
    };
    [arr addObject:j1];
    
    JumpModel * j3 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"nstimer timer" obj:kvcTest arg:nil];
    j3.jumpBlock = ^(UIViewController *vc) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [kvcTest nstimerTest];
        });
    };
    [arr addObject:j3];
    
    JumpModel * j = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"cancel gcd timer" obj:kvcTest arg:nil];
    j.jumpBlock = ^(UIViewController *vc) {
        
        [kvcTest cancleGCDTimertest];
    };
    [arr addObject:j];
    
    
    
    
    return arr;
}

+ (NSString *)headTitle {
    return @"timer";
}


@end
