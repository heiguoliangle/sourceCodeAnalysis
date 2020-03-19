//
//  FrameBoundsTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "FrameBoundsTest.h"
#import "FrameBoundsTestVC.h"

@implementation FrameBoundsTest

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"bounds" obj:[self alloc] arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        FrameBoundsTestVC * vc1 = [FrameBoundsTestVC new];
        [vc.navigationController pushViewController:vc1 animated:YES];
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"frame-bounds";
}

@end
