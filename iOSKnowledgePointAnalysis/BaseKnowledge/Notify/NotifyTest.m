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

@implementation NotifyTest


- (void)testName {
//    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostWhenIdle coalesceMask:NSNotificationNoCoalescing forModes:@[NSDefaultRunLoopMode]];

}


@end
