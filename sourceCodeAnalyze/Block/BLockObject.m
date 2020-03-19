//
//  BLockObject.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/11.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "BLockObject.h"

@interface TestBLockObject : NSObject {
    NSString * _type;
}
@property(nonatomic,copy) NSString *name;
@property(nonatomic,copy) NSString *age;

- (void)test;
@end

@implementation TestBLockObject

- (void)test {
    NSLog(@"%@",self.name);
}

@end
@implementation BLockObject

+ (void)testBlock {
    NSMutableArray * arr = [NSMutableArray array];
    TestBLockObject * o1 = [TestBLockObject new];
    
    o1.name = @"1123";
    NSString * b = @"asdfas";
    NSString * c = @"asdfasasdfasasdfasasdfasasdfasasdfasasdfasasdfas";
    o1.age = @"heiguo";
    [arr addObject:o1];
    TestBLockObject * o12 = [TestBLockObject new];
    o1.name = @"2";
    [arr addObject:o12];
    TestBLockObject * o13 = [TestBLockObject new];
    o1.name = @"3";
    [arr addObject:o13];
 
    void (^ changeArr) (void) = ^ {
        TestBLockObject * o1 = arr[0];
        o1.name = @"block-1";
        
    };
    changeArr();
    
    NSLog(@"%@",arr);
    
    [self testArg:@"1" arg1:@"2" arg2:@"3" arg3:@"4" arg4:@"5" arg5:@"6" arg6:@"7" arg7:@"8" arg8:@"9"];
    
    
}

+ (void)testArg:(id)arg arg1:(id)arg1 arg2:(id)arg2 arg3:(id)arg3 arg4:(id)arg4 arg5:(id)arg5 arg6:(id)arg6 arg7:(id)arg7 arg8:(id)arg8{
    
    NSLog(@"这个多个参数%@",arg7);
}


@end
