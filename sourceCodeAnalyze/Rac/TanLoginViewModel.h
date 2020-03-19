//
//  TanLoginViewModel.h
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TanLoginViewModel : NSObject
@property(nonatomic, copy) NSString *userName;
@property(nonatomic, copy) NSString *password;
@property(nonatomic, strong, readonly) RACCommand   *loginCommand;

@property(nonatomic, strong) RACSignal *loginBtnEnable;
@end

NS_ASSUME_NONNULL_END
