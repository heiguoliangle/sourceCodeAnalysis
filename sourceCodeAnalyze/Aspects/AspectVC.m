//
//  AspectVC.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "AspectVC.h"
#import "RuntimeObject.h"
#import <objc/runtime.h>
#import <objc/message.h>

@interface AspectVC ()

@end

@implementation AspectVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    RuntimeObject * o = [RuntimeObject new];
    [o performSelector:@selector(eat)];
}

- (void)test {
    
    Class sup = [RuntimeObject class];
    Class sub = [SubRuntimeObject class];
    Class grandSon = [GrandSonRuntimeObject class];
    
    NSLog(@"+class = > sup : %@",sup);
    NSLog(@"+class = > sub : %@",sub);
    NSLog(@"+class = > grandSon : %@",grandSon);
    
    NSLog(@"=============");
    
    RuntimeObject * supO = [[RuntimeObject alloc]init];
    SubRuntimeObject * subO = [[SubRuntimeObject alloc]init];
    SubRuntimeObject * subO1 = [[SubRuntimeObject alloc]init];
    GrandSonRuntimeObject * grandSonO = [[GrandSonRuntimeObject alloc]init];
    Class getSup = object_getClass(SubRuntimeObject.class);
    Class getSubO = object_getClass(subO);
    Class getGrandSonO = object_getClass(grandSonO);
    
    NSLog(@"object_getClass => getSup : %@",getSup);
    NSLog(@"object_getClass => getSubO : %@",getSubO);
    NSLog(@"object_getClass => getGrandSonO : %@",getGrandSonO);
    
    NSLog(@"=============");
    
    Class supOClass = [supO class];
    Class subOClass = [subO class];
    Class grandSonOClass = [grandSonO class];
    
    NSLog(@"-class => getSup : %@",supOClass);
    NSLog(@"-class => getSubO : %@",subOClass);
    NSLog(@"-class => getGrandSonO : %@",grandSonOClass);
    
    NSLog(@"=============");
    
    
    Class superMeta = objc_getMetaClass("RuntimeObject");
    Class grandSonMeta = objc_getMetaClass("GrandSonRuntimeObject");
    Class sonMeta = objc_getMetaClass("SubRuntimeObject");
    NSLog(@"objc_getMetaClass => getSup : %@",superMeta);
    NSLog(@"objc_getMetaClass => getSubO : %@",sonMeta);
    NSLog(@"objc_getMetaClass => getGrandSonO : %@",grandSonMeta);

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
