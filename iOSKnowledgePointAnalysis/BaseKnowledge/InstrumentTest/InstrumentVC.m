//
//  InstrumentVC.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/21.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "InstrumentVC.h"
#import "InstrumentTest.h"

@interface InstrumentVC ()

@end

@implementation InstrumentVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    InstrumentTest * o = [InstrumentTest new];
    o.aTest = [InstrumentATest new];
    [o run];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)dealloc {
    NSLog(@"InstrumentVC dealloc");
}

@end
