//
//  KVOvc.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/13.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "KVOvc.h"
#import "KVOTest.h"
#import <objc/runtime.h>
#import "NSObject+KVOBlock.h"

@interface KVOvc ()

@end

@implementation KVOvc

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
    
    KVOTest *p1 = [[KVOTest alloc] init];
    KVOTest *p2 = [[KVOTest alloc] init];
    p1.age = 1;
    p1.age = 2;
    p2.age = 2;
    
    NSLog(@"添加KVO监听之前 - p1 = %p, p2 = %p", [p1 methodForSelector: @selector(setAge:)],[p2 methodForSelector: @selector(setAge:)]);
    
    // self 监听 p1的 age属性
    NSKeyValueObservingOptions options = NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld;
    // p1->isa KVOTest
    // imp (iOSKnowledgePointAnalysis`-[KVOTest setAge:] at KVOTest.h:17)
    [p1 addObserver:self forKeyPath:@"age" options:options context:nil];
    // p1->isa NSKVONotifying_KVOTest
    // imp (Foundation`_NSSetIntValueAndNotify)
    
    NSLog(@"添加KVO监听之后 - p1 = %p, p2 = %p", [p1 methodForSelector: @selector(setAge:)],[p2 methodForSelector: @selector(setAge:)]);
    [self printMethods: object_getClass(p2)]; //- .cxx_destruct     dealloc     name     setName:     willChangeValueForKey:     didChangeValueForKey:     age     setAge:     test
    [self printMethods: object_getClass(p1)]; // - setAge:     class     dealloc     _isKVOA
    p1.age = 10;
    [p1 removeObserver:self forKeyPath:@"age"];
    
    [p1 sw_addObserver:self forKeyPath:@"name" callback:^(id  _Nonnull observedObject, NSString * _Nonnull observedKeyPath, id  _Nonnull oldValue, id  _Nonnull newValue) {
        
    }];
    
}
- (void) printMethods:(Class)cls
{
    unsigned int count ;
    Method *methods = class_copyMethodList(cls, &count);
    NSMutableString *methodNames = [NSMutableString string];
    [methodNames appendFormat:@"%@ - ", cls];
    
    for (int i = 0 ; i < count; i++) {
        Method method = methods[i];
        NSString *methodName  = NSStringFromSelector(method_getName(method));
        
        [methodNames appendString: methodName];
        [methodNames appendString:@"\t "];
        
    }
    
    NSLog(@"%@",methodNames);
    free(methods);
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    NSLog(@"监听到%@的%@改变了%@", object, keyPath,change);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
