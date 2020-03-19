//
//  KVOTest.h
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "TestBaseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface KVOTest : TestBaseModel
/// name
@property(nonatomic,copy) NSString *name;
/// name
@property(nonatomic,assign) int age;
@end

NS_ASSUME_NONNULL_END
