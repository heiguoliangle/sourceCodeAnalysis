//
//  CategoryTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/22.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "CategoryTest.h"
#import "CategoryTest+property.h"
#import <objc/message.h>

@implementation CategoryTest

- (void)tes {
    
    void(^ b) (void) = ^ {
        self.age = 11;
    };
    self.age = 12;
    
}

#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block CategoryTest * o = [CategoryTest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"分类添加属性" obj:0 arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
        [o setValue:@"124" forKey:@"name"];
        NSLog(@"%@",o.name);
        
        __weak CategoryTest * b = o;
        
        [o lyz_ivar];
    };
    [arr addObject:j1];
    
    return arr;
}

/** 成员变量 */
- (void)lyz_ivar{
    unsigned int outCount = 0;
    Ivar * ivars = class_copyIvarList([CategoryTest class], &outCount);
    for (unsigned int i = 0; i < outCount; i ++) {
        Ivar ivar = ivars[i];
        const char * name = ivar_getName(ivar);
        const char * type = ivar_getTypeEncoding(ivar);
        NSLog(@"类型为 %s 的 %s ",type, name);
    }
    free(ivars);
    
}

+ (NSString *)headTitle {
    return @"分类";
}

@end
