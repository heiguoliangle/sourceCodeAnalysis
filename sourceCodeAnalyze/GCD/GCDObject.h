//
//  GCDObject.h
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/10.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface GCDObject : NSObject

+ (void)testGroup;

+ (void)testCreatBlock;

+ (void)testBlockWait;

+ (void)testBlockNotify;

+ (void)testBlockCancel;

+ (void)testBlockSuspendAndResume;

+ (void)testDispatchApply;


@end

NS_ASSUME_NONNULL_END
