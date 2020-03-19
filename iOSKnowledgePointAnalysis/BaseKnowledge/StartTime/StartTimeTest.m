//
//  StartTimeTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/19.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "StartTimeTest.h"
#import <sys/sysctl.h>
#import <mach/mach.h>

@implementation StartTimeTest

+ (BOOL)processInfoForPID:(int)pid procInfo:(struct kinfo_proc*)procInfo
{
    int cmd[4] = {CTL_KERN, KERN_PROC, KERN_PROC_PID, pid};
    size_t size = sizeof(*procInfo);
    return sysctl(cmd, sizeof(cmd)/sizeof(*cmd), procInfo, &size, NULL, 0) == 0;
}

+ (NSTimeInterval)processStartTime
{
    struct kinfo_proc kProcInfo;
    if ([self processInfoForPID:[[NSProcessInfo processInfo] processIdentifier] procInfo:&kProcInfo]) {
        return kProcInfo.kp_proc.p_un.__p_starttime.tv_sec * 1000.0 + kProcInfo.kp_proc.p_un.__p_starttime.tv_usec / 1000.0;
    } else {
        NSAssert(NO, @"无法取得进程的信息");
        return 0;
    }
}

- (void)test {
    
}

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block StartTimeTest * kvoTest = [StartTimeTest new];
    //    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
    //    [kvoTest addObserver:kvoTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc] initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"获取启动时间" obj:kvoTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
        NSTimeInterval time =  [StartTimeTest processStartTime];
        NSLog(@"启动时间是: %zd",time);
        //        kvoTest.name = @"1234";
    };
    [arr addObject:j1];
    return arr;
}

+ (NSString *)headTitle {
    return @"startTime";
}

@end
