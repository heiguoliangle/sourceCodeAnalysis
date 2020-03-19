//
//  KVOTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "KVOTest.h"
#import "KVOvc.h"

@interface KVOTest1 : NSObject

@end

@implementation KVOTest1



@end

@interface KVOTest()
///
@property(nonatomic,copy) void (^block)();
@property(nonatomic,strong) KVOTest1 *test;


@end
static dispatch_once_t onceToken;
@implementation KVOTest


- (void)test1 {
    self.block = ^{
        self.test;
    };
    
}

+ (KVOTest *)defaultObj {
    static KVOTest * o;
    
    dispatch_once(&onceToken, ^{
        o = [[KVOTest alloc]init];
        
    });
    return o;
}

- (void)setAge:(int)age
{
    NSLog(@"setAge:");
    _age = age;
}
- (void)willChangeValueForKey:(NSString *)key
{
    NSLog(@"willChangeValueForKey: - begin");
    [super willChangeValueForKey:key];
    NSLog(@"willChangeValueForKey: - end");
}
- (void)didChangeValueForKey:(NSString *)key
{
    NSLog(@"didChangeValueForKey: - begin");
    [super didChangeValueForKey:key];
    NSLog(@"didChangeValueForKey: - end");
}


// 这个关闭kvo 的 方法
//+ (BOOL)automaticallyNotifiesObserversForKey:(NSString *)key {
//    return NO;
//}

+ (BOOL)accessInstanceVariablesDirectly {
    return NO;
}


- (void)setName:(NSString *)name {
    _name = name;
}

- (void)test {
    self.name = @"heiguo";
}

- (void)dealloc {
    NSLog(@"dealloc");
}




#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block KVOTest * kvoTest = [KVOTest new];
//    __block KVOTest * kvoTest1 = [KVOTest defaultObj];
//    [kvoTest addObserver:kvoTest forKeyPath:@"name" options:(NSKeyValueObservingOptionNew|NSKeyValueObservingOptionOld) context:NULL];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"kvo 赋值" obj:kvoTest arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        KVOTest * kvoTest1 = [KVOTest defaultObj];
        kvoTest1 = nil;
        onceToken = 0;
        [vc.navigationController pushViewController:[KVOvc new] animated:YES];
        
//        kvoTest.name = @"1234";
    };
    [arr addObject:j1];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"frame-bounds";
}




@end
