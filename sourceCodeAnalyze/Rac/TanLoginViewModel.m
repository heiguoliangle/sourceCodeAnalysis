//
//  TanLoginViewModel.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "TanLoginViewModel.h"
#import "TanNetworker.h"

@implementation TanLoginViewModel
- (instancetype)init
{
    if (self = [super init]) {
        RACSignal *userNameLengthSig = [RACObserve(self, userName)
                                        map:^id(NSString *value) {
//            return @(YES);
            if (value.length > 6) return @(YES);
            return @(NO);
        }];
        RACSignal *passwordLengthSig = [RACObserve(self, password)
                                        map:^id(NSString *value) {
//            return @(YES);
            if (value.length > 6) return @(YES);
            return @(NO);
        }];
        
        _loginBtnEnable = [RACSignal combineLatest:@[userNameLengthSig, passwordLengthSig] reduce:^id(NSNumber *userName, NSNumber *password){
            return @([userName boolValue] && [password boolValue]);
        }];
        
        
        _loginCommand = [[RACCommand alloc]initWithEnabled:_loginBtnEnable signalBlock:^RACSignal *(id input) {
            
            RACSignal * s = [TanNetworker loginWithUserName:self.userName password:self.password];
            [s subscribeNext:^(id x) {
                NSLog(@"%@",x);
            } error:^(NSError *error) {
                
            } completed:^{
                
            }];
            return s;
            
            
        }];
        
    }
    return self;
}
@end
