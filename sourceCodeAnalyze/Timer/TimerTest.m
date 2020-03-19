//
//  TimerTest.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "TimerTest.h"

static int count = 0;
static NSTimer * staticTimer;

@implementation TimerTest

+ (void)testNSTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(testNSTimerAction:) userInfo:nil repeats:YES];
    staticTimer = timer;
}

- (void)testNSTimerAction:(NSObject *)info {
    count ++;
    NSLog(@"这个是第几次调用 %d",count);
}

+ (void)testInvalidateNSTimer {
    [staticTimer invalidate];
    staticTimer = nil;
}

@end
