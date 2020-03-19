//
//  CommandVC.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/8.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "CommandVC.h"
#import "TanLoginViewModel.h"
@interface CommandVC ()
@property (weak, nonatomic) IBOutlet UITextField *userNameTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *juhuaView;
@property (strong, nonatomic) TanLoginViewModel *viewModel;

@end

@implementation CommandVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.viewModel = [TanLoginViewModel new];
    RAC(self.viewModel, userName) = self.userNameTF.rac_textSignal;
    RAC(self.viewModel, password) = self.passwordTF.rac_textSignal;
    RAC(self.loginBtn,enabled) = self.viewModel.loginBtnEnable;
    
//    self.loginBtn.rac_command = self.viewModel.loginCommand;
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self test];
}


- (void)test {
    @weakify(self)
  
//    [[self.viewModel.loginCommand executionSignals]
//     subscribeNext:^(RACSignal *x) {
//        @strongify(self)
//        self.juhuaView.hidden = NO;
//        [x subscribeNext:^(NSString *x) {
//            self.juhuaView.hidden = YES;
//            NSLog(@"%@",x);
//        }];
//    }];
    
    [self.viewModel.loginCommand execute:@{@"account":_userNameTF.text,@"password":_passwordTF.text}];
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
