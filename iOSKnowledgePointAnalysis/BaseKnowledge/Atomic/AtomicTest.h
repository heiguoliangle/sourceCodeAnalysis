//
//  AtomicTest.h
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TestBaseModel.h"



@interface AtomicTest : TestBaseModel
/// name
@property(atomic,assign) int count;

@property(nonatomic,strong) NSMutableArray *arr;
@end


