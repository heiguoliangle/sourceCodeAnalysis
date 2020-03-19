//
//  TestBaseModel.h
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface JumpModel : NSObject

@property(nonatomic,copy) NSString *kClass;
@property(nonatomic,assign) SEL sel;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,assign) BOOL isClassMethond;
@property(nonatomic,weak) UIViewController *vc;
@property(nonatomic,strong) NSObject *instanceObj;
@property(nonatomic,strong) id arg;

/// 跳转blcok
@property(nonatomic,copy) void(^ jumpBlock)(UIViewController *vc);

- (instancetype)initWithIsClassMethond:(BOOL)isClassMethond kClass:(NSString *)kClass sel:(SEL)sel title:(NSString *)title obj:(NSObject *)obj arg:(id)arg;

@end

@interface TestBaseModel : NSObject

+ (NSMutableArray *)addJumpModel;

+ (NSString *)headTitle;

@end


