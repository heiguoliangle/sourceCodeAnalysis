//
//  GCDVC.m
//  sourceCodeAnalyze
//
//  Created by guoliang hao on 2020/3/10.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "GCDVC.h"
#import "GCDObject.h"
#import <objc/runtime.h>


@interface GCDVC ()<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,strong) UITableView *tableView;
/*
 [
 {
 "class" : Persion,
 "SEL" : Run,
 }
 
 */
@property(nonatomic,strong) NSMutableArray *datas;
@end

static NSString * kClass = @"kClass";
static NSString * kSEL = @"kSEL";
static NSString * kTitle = @"kTitle";
static NSString * kIsClass = @"kIsClass";
static NSString * kPart = @"kPart";

@implementation GCDVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDatas];
    [self.view addSubview:self.tableView];
    
    [self performSelector:@selector(dynamicSelector) withObject:nil];

    // Do any additional setup after loading the view.
}

+ (BOOL)resolveInstanceMethod:(SEL)sel{
    if (sel == @selector(dynamicSelector)) {
        class_addMethod([self class],sel, (IMP)myMehtod,"v@:");
        return YES;
    }else{
        return [super resolveInstanceMethod:sel];
    }
    
}


void myMehtod(id self,SEL _cmd){
    NSLog(@"This is added dynamic");
}

- (void)initDatas {
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testGroup",
        kTitle : @"testGroup"
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testCreatBlock",
        kTitle : @"testCreatBlock"
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testBlockWait",
        kTitle : @"testBlockWait"
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testBlockNotify",
        kTitle : @"testBlockNotify"
    }];
    
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testBlockCancel",
        kTitle : @"testBlockCancel"
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testBlockSuspendAndResume",
        kTitle : @"testBlockSuspendAndResume"
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testDispatchApply",
        kTitle : @"testDispatchApply"
    }];
    
    [self.datas addObject:@{
        kClass : @"RuntimeObject",
        kSEL : @"eat",
        kTitle : @"RuntimeObject 类方法执行未实现方法",
        kIsClass : @(1),
//        kIsClass : @(0),
    }];
    
    [self.datas addObject:@{
        kClass : @"RuntimeObject",
        kSEL : @"eat",
        kTitle : @"RuntimeObject 对象方法执行未实现方法",
//        kIsClass : @(1),
                kIsClass : @(0),
    }];
    
    [self.datas addObject:@{
        kClass : @"RuntimeObject",
        kSEL : @"test",
        kTitle : @"RuntimeObject 执行实现方法test",
//        kIsClass : @(1),
                kIsClass : @(0),
    }];
    
    [self.datas addObject:@{
        kClass : @"BLockObject",
        kSEL : @"testBlock",
        kTitle : @"block 添加arr",
        kIsClass : @(1),
    }];
    
    
    
    [self.datas addObject:@{
        kClass : @"Student",
        kSEL : @"test",
        kIsClass : @(0),
        kTitle : @"子类Student的test"
    }];
    
    
    [self.datas addObject:@{
        kClass : @"UItestVC",
        kSEL : @"pushUIVC:",
        kTitle : @"跳转到UItest 页面",
        kIsClass : @(1),
        kPart : self
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testBlockCancel",
        kTitle : @"这个不能点击"
    }];
    
    [self.datas addObject:@{
        kClass : @"GCDObject",
        kSEL : @"testBlockCancel",
        kTitle : @"这个不能点击"
    }];
    
   
    

    
    
    
    
    
    
    
    
}

#pragma mark - dataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    NSDictionary * dict = self.datas[indexPath.row];
    cell.textLabel.text = dict[kTitle];
    return cell;
}

#pragma mark - delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary * dict = self.datas[indexPath.row];
    NSString * kc = dict[kClass];
    Class class = NSClassFromString(kc);
    SEL sel = NSSelectorFromString( dict[kSEL] );
    BOOL isClass = [dict[kIsClass]boolValue];
    NSObject *object = dict[kPart];
    if (isClass) {
//        [class performSelector:sel];
        [class performSelector:sel withObject:object];
    }else {
        NSObject* object = [class alloc];
        [object performSelector:sel withObject:object];
    }
}


#pragma mark - lazy

- (NSMutableArray *)datas {
    if (!_datas) {
        _datas =[NSMutableArray arrayWithCapacity:1];
    }
    return _datas;
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
