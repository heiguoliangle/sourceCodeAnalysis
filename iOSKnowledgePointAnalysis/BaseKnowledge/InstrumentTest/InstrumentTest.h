//
//  InstrumentTest.h
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/21.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "TestBaseModel.h"

NS_ASSUME_NONNULL_BEGIN
@interface InstrumentATest : TestBaseModel

@property(nonatomic,strong) dispatch_block_t block;
@end
@interface InstrumentTest : TestBaseModel
@property(nonatomic,strong) InstrumentATest *aTest;
- (void)run;
@end

NS_ASSUME_NONNULL_END
