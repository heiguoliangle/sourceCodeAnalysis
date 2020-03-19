//
//  UItestVC.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/11.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "UItestVC.h"

@interface UItestVC ()
@property(nonatomic,strong) UIView *redView;
@property(nonatomic,strong) UIView *blueView;
@end

@implementation UItestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.redView];
    self.redView.frame = CGRectMake(0, 0, 200, 200);
    self.redView.center = self.view.center;
    _redView.bounds = CGRectMake(0, 0, 10, 10);
    
    [self.redView addSubview:self.blueView];
    self.blueView.frame = CGRectMake(0, 0, 150, 150);
    
    

    // Do any additional setup after loading the view.
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



+ (void)pushUIVC:(UIViewController *)vc {
    UItestVC * testVC = [UItestVC new];
    [vc.navigationController pushViewController:testVC animated:YES];
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
