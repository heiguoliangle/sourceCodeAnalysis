//
//  RuntimeObject.h
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RuntimeObject : NSObject

- (void)test;

@end

@interface SubRuntimeObject : RuntimeObject



@end


@interface GrandSonRuntimeObject : RuntimeObject



@end



NS_ASSUME_NONNULL_END
