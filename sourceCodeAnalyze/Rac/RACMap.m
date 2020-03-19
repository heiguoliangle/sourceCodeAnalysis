//
//  RACMap.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/7.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "RACMap.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@implementation RACMap

+ (void)testMap {
    
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        [subscriber sendNext:@(1)];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"createSignal disposableWithBlock");
        }];
    }];
    
    RACSignal * map = [signal map:^id(id value) {
        return @([(NSNumber *)value intValue] * 2);
    }];
    [map subscribeNext:^(id x) {
        NSLog(@"%@",x);
    } error:^(NSError *error) {
        
    } completed:^{
        NSLog(@"map completed");

    }];
    
}

+ (void)testRACSequence {
    RACSequence * sequence = [RACSequence sequenceWithHeadBlock:^id{
        NSLog(@" 开始 RACSequence");
        return @"head return";
    } tailBlock:^RACSequence *{
        return @[@"12",@"45"].rac_sequence;
    }];
    NSLog(@"head : %@, tail: %@",sequence.head,sequence.tail);
}

+ (void)testRACSequence2 {
    NSArray *array = @[@1,@2,@3,@4,@5];
    
    RACSequence *lazySequence = [array.rac_sequence map:^id(id value) {
        NSLog(@"lazySequence");
        return @(101);
//        return nil;
    }];
    
    RACSequence *eagerSequence = [array.rac_sequence.eagerSequence map:^id(id value) {
        NSLog(@"eagerSequence");
        return @(100);
    }];
    NSLog(@"%@",array);
    [lazySequence array];
}


+ (void)testRACSequence1 {
    NSDictionary * dict = @{@"大吉大利":@"今晚吃鸡",
                            @"666666":@"999999",
                            @"dddddd":@"aaaaaa"
    };
    
    [dict.rac_sequence.signal subscribeNext:^(RACTuple * _Nullable x) {
        RACTupleUnpack(NSString *key,id value) = x;
        NSLog(@"key - %@ value - %@",key,value);
    }];
    
    [dict.rac_keySequence.signal subscribeNext:^(id x) {
        NSLog(@"rac_keySequence - %@ ",x);
    } error:^(NSError *error) {
        
    } completed:^{
        
    } ];
}

+ (void)testRACMulticast {
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        NSLog(@"发送网络请求");
        
        [subscriber sendNext:@"得到网络请求数据"];
        
        return nil;
    }];
    
    RACMulticastConnection *connect = [signal publish];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"1 - %@",x);
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"2 - %@",x);
    }];
    
    [connect.signal subscribeNext:^(id x) {
        NSLog(@"3 - %@",x);
    }];
    
    [connect connect];
}
@end
