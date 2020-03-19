//
//  ViewController.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/6.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "ViewController.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "RACMap.h"
#import "CommandVC.h"
#import "AspectVC.h"

@interface ViewController ()
@property(strong)RACDisposable*dis;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [RACMap testRACMulticast];
    // Do any additional setup after loading the view.
}

- (IBAction)commandRac:(id)sender {
    
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    CommandVC *msgVC = [sb instantiateViewControllerWithIdentifier:@"123"];
    [self.navigationController pushViewController:msgVC animated:YES];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.navigationController pushViewController:[AspectVC new] animated:YES];

}



- (IBAction)baseRac:(id)sender {
    [self testBaseRac];
}

- (IBAction)bindRac:(id)sender {
    [self testBind];
}
- (IBAction)concatRac:(id)sender {
    [self testConcat];
}
- (IBAction)zipRac:(id)sender {
    [self testZip];
}

- (IBAction)mapRac:(id)sender {
    [RACMap testMap];
}


#pragma mark - zip

- (void)testZip {
    RACSignal *signal1 = [RACSignal createSignal:
                          ^RACDisposable *(id<RACSubscriber> subscriber)
                          {
        NSLog(@"zip1 sendNext : 1");
        [subscriber sendNext:@1];
        //           NSLog(@"concat1 sendNext : 2");
                      [subscriber sendNext:@2];
        NSLog(@"zip1 sendNext : sendCompleted");
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"zip1 creat signal dispose");
        }];
    }];
    
    RACSignal *signal2 = [RACSignal createSignal:
                          ^RACDisposable *(id<RACSubscriber> subscriber)
                          {
        NSLog(@"zip2 sendNext : 3");
        [subscriber sendNext:@3];
        //           NSLog(@"concat2 sendNext : 4");
        //              [subscriber sendNext:@4];
        NSLog(@"zip2 sendNext : sendCompleted");
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@"zip2 creat signal dispose");
        }];
    }];
    
    RACSignal * zipSignal  = [signal1 zipWith:signal2];
    [zipSignal subscribeNext:^(id x) {
        NSLog(@"zip subscribe value = %@", x);

    } error:^(NSError *error) {
        
    } completed:^{
        NSLog(@"zip completed");

    }];
    
}

#pragma mark - concat

- (void)testConcat {
    RACSignal *signal1 = [RACSignal createSignal:
                               ^RACDisposable *(id<RACSubscriber> subscriber)
          {
           NSLog(@"concat1 sendNext : 1");
              [subscriber sendNext:@1];
//           NSLog(@"concat1 sendNext : 2");
//              [subscriber sendNext:@2];
           NSLog(@"concat1 sendNext : sendCompleted");
              [subscriber sendCompleted];
              return [RACDisposable disposableWithBlock:^{
                  NSLog(@"concat1 creat signal dispose");
              }];
          }];
    
    RACSignal *signal2 = [RACSignal createSignal:
                               ^RACDisposable *(id<RACSubscriber> subscriber)
          {
           NSLog(@"concat2 sendNext : 3");
              [subscriber sendNext:@3];
//           NSLog(@"concat2 sendNext : 4");
//              [subscriber sendNext:@4];
           NSLog(@"concat2 sendNext : sendCompleted");
              [subscriber sendCompleted];
              return [RACDisposable disposableWithBlock:^{
                  NSLog(@"concat2 creat signal dispose");
              }];
          }];
    
    RACSignal *concatSignal = [signal1 concat:signal2];
    [concatSignal subscribeNext:^(id x) {
        NSLog(@"concat subscribe value = %@", x);
    } error:^(NSError *error) {
        
    } completed:^{
        NSLog(@"concat completed");
    }];
}

#pragma mark - bind

- (void)testBind {
    RACSignal *signal = [RACSignal createSignal:
                            ^RACDisposable *(id<RACSubscriber> subscriber)
       {
        NSLog(@"sendNext : 1");
           [subscriber sendNext:@1];
        NSLog(@"sendNext : 2");
           [subscriber sendNext:@2];
        NSLog(@"sendNext : 3");
           [subscriber sendNext:@3];
        NSLog(@"sendNext : sendCompleted");
           [subscriber sendCompleted];
           return [RACDisposable disposableWithBlock:^{
               NSLog(@"bind creat signal dispose");
           }];
       }];
    
    RACSignal *bindSignal = [signal bind:^RACStreamBindBlock{
        
           return ^RACSignal *(NSNumber *value, BOOL *stop){
               
               value = @(value.integerValue * 2);
               return [RACSignal return:value];
           };
       }];
    
    [bindSignal subscribeNext:^(id x) {
           NSLog(@"bind subscribe value = %@", x);
    }];
}

#pragma mark - testBaseRac
- (void)testBaseRac {
    // RACDynamicSignal 实际是这个类型
    RACSignal * signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {// 这里个subscriber 是RACPassthroughSubscriber 订阅者
        [subscriber sendNext:@(1)];
        [subscriber sendNext:@(2)];
        [subscriber sendNext:@(3)];
        [subscriber sendCompleted];
        return [RACDisposable disposableWithBlock:^{
            NSLog(@" base disposableWithBlock");
        }];
    }];
    RACDisposable * disposable = [signal subscribeNext:^(id x) {
        NSLog(@"subscribe value = %@", x);
        
    } error:^(NSError *error) {
        NSLog(@"error: %@", error);
    } completed:^{
        NSLog(@"completed");
    }];
    [disposable dispose];
}


@end
