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

/// 获取所有进程,遍历进程中的__p_starttime 字段,认为是启动时间
+ (void)test {
    int mib[4] = {CTL_KERN, KERN_PROC, KERN_PROC_ALL, 0};
    size_t miblen = 4;
    
    size_t size;
    int st = sysctl(mib, miblen, NULL, &size, NULL, 0);
    
    struct kinfo_proc * process = NULL;
    struct kinfo_proc * newprocess = NULL;
    
    do {
        size += size / 10;
        newprocess = realloc(process, size);
        
        if (!newprocess){
            if (process)
            {
                free(process);
            }
            return;
//            return nil;
        }
        
        process = newprocess;
        st = sysctl(mib, miblen, process, &size, NULL, 0);
    } while (st == -1 && errno == ENOMEM);
    
    if (st == 0){
        if (size % sizeof(struct kinfo_proc) == 0){
            int nprocess = size / sizeof(struct kinfo_proc);
            if (nprocess)            {
                NSMutableArray * array = [[NSMutableArray alloc] init];
                for (int i = nprocess - 1; i >= 0; i--)
                {
                    NSString * processID = [[NSString alloc] initWithFormat:@"%d", process[i].kp_proc.p_pid];
                    NSString * processName = [[NSString alloc]initWithBytes:(const void *)process[i].kp_proc.p_comm
                                                                     length:strlen(process[i].kp_proc.p_comm)
                                                                   encoding:NSUTF8StringEncoding];
                    
                    if ([processName isEqualToString:@"iOSKnowledgePoin"])
                    {
                        NSTimeInterval time = process[i].kp_proc.p_un.__p_starttime.tv_sec;
                        
                    }
                }
                
                free(process);
//                return array;
            }
        }
    }
}

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
        [StartTimeTest test];
        //        kvoTest.name = @"1234";
    };
    [arr addObject:j1];
    return arr;
}

+ (NSString *)headTitle {
    return @"startTime";
}

@end
