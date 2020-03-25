//
//  ViewController.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/3/12.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "ViewController.h"
#import "TestBaseModel.h"

#import "AtomicTest.h"
#import "FrameBoundsTest.h"
#import "KVOTest.h"
#import "KVCTest.h"
#import "ThreadTest.h"
#import "MsgTest.h"
#import "StartTimeTest.h"
#import "ProxyTest.h"
#import "AnimationTest.h"


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong) UITableView *tableView;
@property(nonatomic,strong) NSMutableArray<NSMutableArray<JumpModel *>*> *datas;

@property(nonatomic,strong) NSMutableArray *titles;

@end

static NSString * kClass = @"kClass";
static NSString * kSEL = @"kSEL";
static NSString * kTitle = @"kTitle";
static NSString * kIsClass = @"kIsClass";
static NSString * kPart = @"kPart";

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initDatas];
    [self.view addSubview:self.tableView];
}


- (void)initDatas {
    [self addDataWithClass:AtomicTest.class];
    [self addDataWithClass:FrameBoundsTest.class];
    [self addDataWithClass:KVOTest.class];
    [self addDataWithClass:KVCTest.class];
    [self addDataWithClass:ThreadTest.class];
    [self addDataWithClass:MsgTest.class];
    [self addDataWithClass:StartTimeTest.class];
    [self addDataWithClass:ProxyTest.class];
    [self addDataWithClass:AnimationTest.class];
    [self addDataWithStr:@"TimerTest"];
    [self addDataWithStr:@"NotifyTest"];
    [self addDataWithStr:@"InstrumentTest"];
    [self addDataWithStr:@"GCDTest"];
    [self addDataWithStr:@"CategoryTest"];
}

- (void)addNotify {
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(test:) name:NULL object:@"1"];
}

- (void)test:(NSNotification *)noti {
    NSLog(@"%@",noti);
}

- (void)addDataWithStr:(NSString *)classStr {
    Class class = NSClassFromString(classStr);
    [self addDataWithClass:class];
}

- (void)addDataWithClass:(Class)class {
    
    [self.datas addObject:[class performSelector:@selector(addJumpModel)]];
    [self.titles addObject:[class performSelector:@selector(headTitle)]];
}

#pragma mark - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas[section].count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.datas.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSMutableArray<JumpModel *> * arr= self.datas[indexPath.section];
    JumpModel * model = arr[indexPath.row];
    cell.textLabel.text = model.title;
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return self.titles[section];
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray<JumpModel *> * arr= self.datas[indexPath.section];
    JumpModel * model = arr[indexPath.row];
    if (model.jumpBlock) {
        model.jumpBlock(self);
    }else {
        Class class = model.kClass;
        SEL sel = model.sel;
        BOOL isClass = model.isClassMethond;
        NSObject *object = model.arg;
        if (isClass) {
            //        [class performSelector:sel];
            [class performSelector:sel withObject:object];
        }else {
            NSObject* instanceObj = model.instanceObj;
            [instanceObj performSelector:sel withObject:object];
        }
    }
}

#pragma mark - lazy

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas =[NSMutableArray arrayWithCapacity:1];
    }
    return _datas;
}


- (NSMutableArray *)titles {
    if (!_titles) {
        _titles =[NSMutableArray arrayWithCapacity:1];
    }
    return _titles;
}
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"cell"];
    }
    return _tableView;
}



@end
