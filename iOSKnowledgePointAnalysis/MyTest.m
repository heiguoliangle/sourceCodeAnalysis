//
//  MyTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/4/14.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "MyTest.h"

@implementation MyTest

- (void)test {
    MyTest * t = [MyTest new];
    
//    bits -> rw-bits
}

- (NSInteger)caluCountWithStri:(NSString *)str
                  separte:(NSString *)sep
                byteCount:(NSInteger)byteCount
                   extendBlock:(NSInteger(^)(NSInteger count))extendBlock {
    if (str.length == 0 || sep.length == 0) {
        return NSNotFound;
    }
    NSInteger count = 0;
    NSArray<NSString *> * arr = [str componentsSeparatedByString:sep];
    for (NSInteger i = arr.count - 1; i >= 0; i --) {
        NSString * numberStr = arr[i];
        NSInteger number = [numberStr integerValue];
        NSInteger tmpResult = number * pow(byteCount, i);
        if (extendBlock) {
            tmpResult = extendBlock(tmpResult);
        }
        count += tmpResult;
    }
    return count;
}

@end
