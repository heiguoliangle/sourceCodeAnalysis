//
//  NotifyTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/18.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "NotifyTest.h"


void addOber (void) {
    CFRunLoopRef runloop = CFRunLoopGetCurrent();
    CFRunLoopObserverRef observer = CFRunLoopObserverCreateWithHandler(CFAllocatorGetDefault(), kCFRunLoopAllActivities, YES, 0, ^(CFRunLoopObserverRef observer, CFRunLoopActivity activity) {
        switch (activity) {
            case kCFRunLoopEntry:
                NSLog(@"进入runLoop");
                break;
            case kCFRunLoopBeforeTimers:
                NSLog(@"处理timer事件");
                break;
            case kCFRunLoopBeforeSources:
                NSLog(@"处理source事件");
                break;
            case kCFRunLoopBeforeWaiting:
                NSLog(@"进入睡眠");
                break;
            case kCFRunLoopAfterWaiting:
                NSLog(@"被唤醒");
                break;
            case kCFRunLoopExit:
                NSLog(@"退出");
                break;
            default:
                break;
        }
    });
    CFRunLoopAddObserver(runloop, observer, kCFRunLoopCommonModes);
    CFRelease(observer);
}

@interface NotifyCenter : TestBaseModel

@end
@implementation NotifyCenter

+ (instancetype) defaultCenter {
    static NotifyCenter * center = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        center = [NotifyCenter new];
    });
    return center;
}
@end


@implementation NotifyTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addNotify];
    }
    return self;
}

- (void)addNotify {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(test:) name:@"1234" object:[NotifyCenter defaultCenter]];
}

- (void)test:(NSNotification *)noti {
    NSLog(@"%@",noti);
}


- (void)testName {
//    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:@[NSDefaultRunLoopMode]];

}

- (void)test {
    [[NSNotificationCenter defaultCenter]postNotificationName:NULL object:[NotifyCenter defaultCenter]];
}

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block NotifyTest * o = [NotifyTest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"通知练习" obj:0 arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        [o test];
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"通知";
}




@end
