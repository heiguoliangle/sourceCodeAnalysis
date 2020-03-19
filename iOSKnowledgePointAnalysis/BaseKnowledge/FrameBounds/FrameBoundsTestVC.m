//
//  FrameBoundsTestVC.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "FrameBoundsTestVC.h"

@interface FrameBoundsTestVC ()
@property(nonatomic,strong) UIView *redView;
@property(nonatomic,strong) UIView *blueView;

@property(nonatomic,strong) UIViewController *vc;
@end

@implementation FrameBoundsTestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.vc  =[UIViewController new];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Do any additional setup after loading the view.
    [self test1];
}

- (void)test {
    [self.view addSubview:self.redView];
    
    self.redView.frame = CGRectMake(0, 0, 200, 200);
    self.redView.center = self.view.center;
    _redView.bounds = CGRectMake(10, 0, self.redView.frame.size.width, self.redView.frame.size.height);
//    _redView.bounds = CGRectMake(0, 0, 10, 10);
    
    [self.redView addSubview:self.blueView];
    self.blueView.frame = CGRectMake(0, 0, 150, 150);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    self.redView.frame = CGRectMake(100, 100, 50, 50);
    
    UIWindow * w1 = [[UIApplication sharedApplication].delegate  window];
    UIWindow * w2 = [UIApplication sharedApplication].keyWindow;
    
    UIWindow * n1 = [[UIWindow alloc]init];
    n1.backgroundColor = [UIColor grayColor];
    n1.frame = CGRectMake(10, 300, 100, 100);
    n1.rootViewController = self.vc;
    n1.windowLevel = UIWindowLevelStatusBar + 1;
    [n1 setHidden:NO];
    [n1 becomeKeyWindow];
    UIWindow * w11 = [[UIApplication sharedApplication].delegate  window];
    UIWindow * w22 = [UIApplication sharedApplication].keyWindow;
    
    
}

- (void)test1 {
    [self.view addSubview:self.redView];
    
    self.redView.frame = CGRectMake(100, 100, 100, 200);
//    self.redView.center = self.view.center;
//    self.redView.layer.anchorPoint = CGPointMake(0,0);
//    _redView.bounds = CGRectMake(10, 0, self.redView.frame.size.width, self.redView.frame.size.height);
    //    _redView.bounds = CGRectMake(0, 0, 10, 10);
    
    [self.view addSubview:self.blueView];
    self.blueView.frame = CGRectMake(200, 100, 100, 200);
    self.blueView.layer.anchorPoint = CGPointMake(0.0, 0.5);
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;;
}


- (UIView *)blueView {
    if (!_blueView) {
        _blueView = [UIView new];
        _blueView.backgroundColor = [UIColor blueColor];
    }
    return _blueView;;
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
