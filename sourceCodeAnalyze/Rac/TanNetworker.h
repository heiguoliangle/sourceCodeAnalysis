//
//  TanNetworker.h
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

NS_ASSUME_NONNULL_BEGIN

@interface TanNetworker : NSObject

+ (RACSignal *)loginWithUserName:(NSString *) name password:(NSString *)password;
@end

NS_ASSUME_NONNULL_END
