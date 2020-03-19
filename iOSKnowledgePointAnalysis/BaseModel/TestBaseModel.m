//
//  TestBaseModel.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "TestBaseModel.h"


@implementation JumpModel

- (instancetype)initWithIsClassMethond:(BOOL)isClassMethond kClass:(NSString *)kClass sel:(SEL)sel title:(NSString *)title obj:(NSObject *)obj arg:(id)arg {
    self = [super init];
    if ( self ) {
        self.isClassMethond = isClassMethond;
        self.kClass = kClass;
        self.sel = sel;
        self.title = title;
        self.instanceObj = obj;
        self.arg = arg;
    }
    return self;
}
@end

@implementation TestBaseModel

+ (NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [NSMutableArray array];
    return arr;
}

+ (NSString *)headTitle {
    return @"未定义";
}

@end
