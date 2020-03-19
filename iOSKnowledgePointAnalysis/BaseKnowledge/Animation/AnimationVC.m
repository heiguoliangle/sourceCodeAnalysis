//
//  AnimationVC.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/19.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "AnimationVC.h"

@interface AnimationVC ()

@property(nonatomic,strong) UIView *redView;

@end

@implementation AnimationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.redView];
    self.redView.frame = CGRectMake(100, 100, 100, 100);
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CABasicAnimation *positionAnima = [CABasicAnimation animationWithKeyPath:@"position.y"];
    positionAnima.duration = 0.8;
    positionAnima.fromValue = @(self.redView.center.y);
    positionAnima.toValue = @(self.redView.center.y+100);
    positionAnima.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    positionAnima.repeatCount = 1;
    positionAnima.repeatDuration = 2;
    positionAnima.removedOnCompletion = NO;
    positionAnima.fillMode = kCAFillModeForwards;
    
    [self.redView.layer addAnimation:positionAnima forKey:@"AnimationMoveY"];
    
    NSLog(@"%@",self.redView);
}

- (UIView *)redView {
    if (!_redView) {
        _redView = [UIView new];
        _redView.backgroundColor = [UIColor redColor];
    }
    return _redView;;
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
