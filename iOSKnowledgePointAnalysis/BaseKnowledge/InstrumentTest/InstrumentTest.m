//
//  InstrumentTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/21.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "InstrumentTest.h"

#import "InstrumentVC.h"

@implementation InstrumentATest

@end

@interface InstrumentTest()


@end
@implementation InstrumentTest


- (void)run {
    self.aTest.block = ^{
        NSLog(@"%@",self);
    };
    
    
}

- (void)dealloc {
//    NSLog(@"dealloc");
}

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block InstrumentTest * o = [InstrumentTest new];
    o.aTest = [InstrumentATest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"内存泄漏" obj:0 arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
//        [o run];
        [vc.navigationController pushViewController:[InstrumentVC new] animated:YES];
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"Instrument";
}

@end
