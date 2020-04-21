//
//  GCDDataSourceTest.m
//  iOSKnowledgePointAnalysis
//
//  Created by guoliang hao on 2020/4/9.
//  Copyright © 2020 guoliang hao. All rights reserved.
//

#import "GCDDataSourceTest.h"


@interface GCDDataSourceTest ()
@property(nonatomic,strong) dispatch_source_t myTimerSource;
@property(nonatomic,strong) dispatch_source_t mySignalSource;

@property(nonatomic,strong) dispatch_source_t myWriteSource;
@property(nonatomic,strong) dispatch_source_t myReadSource;



@end

@implementation GCDDataSourceTest

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self creatFile];
    }
    return self;
}

- (void)creatFile {
    //创建文件管理器
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [filePath stringByAppendingString:@"/test.txt"];
    
    if (![fileManager fileExistsAtPath:fileName]) {
        
        [fileManager createFileAtPath:fileName contents:nil attributes:nil];
        
    }
    

}

- (void)timerDispatchSource
{
    dispatch_source_t timerSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,0, 0, dispatch_get_global_queue(0, 0));
    
    if (timerSource)
    {
        dispatch_time_t startTime = dispatch_time(DISPATCH_TIME_NOW, 0 * NSEC_PER_SEC);  //1, the timer dispatch source uses the default system clock to determine when to fire. However, the default clock does not advance while the computer is asleep.
        //        dispatch_time_t startTime = dispatch_walltime(NULL, 0 * NSEC_PER_SEC); //2  the timer dispatch source tracks its firing time to the wall clock time
        
        NSString *desc = timerSource.description;
        dispatch_source_set_timer(timerSource, startTime, 1 * NSEC_PER_SEC, 0);
        dispatch_source_set_event_handler(timerSource, ^{
            static NSInteger i = 0;
            ++i;
            NSLog(@"Timer %@ Task: %ld",desc,i);
            //            NSLog(@"Timer %@ Task: %ld",timerSource,i);
            
            
        });
        dispatch_source_set_cancel_handler(timerSource, ^{
            //            NSLog(@"Timer：%@ canceled",timerSource);
            NSLog(@"Timer:%@ canceled",desc);
        });
        dispatch_resume(timerSource);
    }
    
    _myTimerSource = timerSource; ///< 必须要保存，除非在hander中引用timerSource，否则出了作用域，Timer就会被释放
}

- (void)cancelTimer {
    dispatch_source_cancel(_myTimerSource);
}


- (void)signalDispatchSource
{
    signal(SIGCHLD, SIG_IGN);
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t signalSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_SIGNAL, SIGCHLD, 0, queue);
    
    if (signalSource)
    {
        dispatch_source_set_event_handler(signalSource, ^{
            static NSInteger i = 0;
            ++i;
            NSLog(@"Signal Detected: %ld",i);
        });
        dispatch_source_set_cancel_handler(signalSource, ^{
            NSLog(@"Signal canceled");
        });
        
        dispatch_resume(signalSource);
    }
    
    _mySignalSource = signalSource; // 不能省，原因同定时器
}


- (void)writeDispatchSource
{
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [filePath stringByAppendingString:@"/test.txt"];
    int fd = open([fileName UTF8String], O_WRONLY | O_CREAT | O_TRUNC,
                  (S_IRUSR | S_IWUSR | S_ISUID | S_ISGID));
    NSLog(@"Write fd:%d",fd);
    if (fd == -1)
        return ;
    fcntl(fd, F_SETFL); // Block during the write.
    
    dispatch_source_t writeSource = nil;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    writeSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_WRITE,fd, 0, queue);
    
    dispatch_source_set_event_handler(writeSource, ^{
        size_t bufferSize = 100;
        void *buffer = malloc(bufferSize);
        
        static NSString *content = @"Write Data Action: ";
        content = [content stringByAppendingString:@"=New info="];
        
        NSString *writeContent = [content stringByAppendingString:@"\n"];
        void *string = [writeContent UTF8String];
        size_t actual = strlen(string);
        memcpy(buffer, string, actual);
        
        write(fd, buffer, actual);
        NSLog(@"Write to file Finished");
        
        free(buffer);
        // Cancel and release the dispatch source when done.
        //        dispatch_source_cancel(writeSource);
        dispatch_suspend(writeSource);  //不能省,否则只要文件可写，写操作会一直进行，直到磁盘满，本例中，只要超过buffer容量就会崩溃
        //        close(fd);   //会崩溃
    });
    dispatch_source_set_cancel_handler(writeSource, ^{
        NSLog(@"Write to file Canceled");
        close(fd);
    });
    
    if (!writeSource)
    {
        close(fd);
        return;
    }
    
    _myWriteSource = writeSource;
}

- (void)readDataDispatchSource
{
    if (_myReadSource)
    {
        dispatch_source_cancel(_myReadSource);
    }
    
    NSString *filePath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *fileName = [filePath stringByAppendingString:@"/test.txt"];
    // Prepare the file for reading.
    int fd = open([fileName UTF8String], O_RDONLY);
    NSLog(@"read fd:%d",fd);
    if (fd == -1)
        return ;
    fcntl(fd, F_SETFL, O_NONBLOCK);  // Avoid blocking the read operation
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t readSource = dispatch_source_create(DISPATCH_SOURCE_TYPE_READ, fd, 0, dispatch_get_main_queue());
    if (!readSource)
    {
        close(fd);
        return ;
    }
    
    
    // Install the event handler
    //只要文件写入了新内容，就会自动读入新内容
    dispatch_source_set_event_handler(readSource, ^{
        long estimated = dispatch_source_get_data(readSource);
        NSLog(@"Read From File, estimated length: %ld",estimated);
        if (estimated < 0)
        {
            NSLog(@"Read Error:");
            dispatch_source_cancel(readSource);  //如果文件发生了截短，事件处理器会一直不停地重复
        }
        
        // Read the data into a text buffer.
        char *buffer = (char *)malloc(estimated);
        if (buffer)
        {
            ssize_t actual = read(fd, buffer, (estimated));
            NSLog(@"Read From File, actual length: %ld",actual);
            NSLog(@"Readed Data: \n%s",buffer);
            //            Boolean done = MyProcessFileData(buffer, actual);  // Process the data.
            
            // Release the buffer when done.
            free(buffer);
            
            // If there is no more data, cancel the source.
            //            if (done)
            //                dispatch_source_cancel(readSource);
        }
    });
    
    // Install the cancellation handler
    dispatch_source_set_cancel_handler(readSource, ^{
        NSLog(@"Read from file Canceled");
        close(fd);
    });
    
    // Start reading the file.
    dispatch_resume(readSource);
    
    _myReadSource = readSource; //can be omitted
}



#pragma mark - father func

+(NSMutableArray *)addJumpModel {
    NSMutableArray * arr = [super addJumpModel];
    
    __block GCDDataSourceTest * o = [GCDDataSourceTest new];
    JumpModel * j1 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"GCDDataSource timer 测试" obj:0 arg:nil];
    j1.jumpBlock = ^(UIViewController *vc) {
        
        [o timerDispatchSource];
    };
    [arr addObject:j1];
    
    JumpModel * j2 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"GCDDataSource 取消timer" obj:0 arg:nil];
    j2.jumpBlock = ^(UIViewController *vc) {
        
        [o cancelTimer];
    };
    [arr addObject:j2];
    
    JumpModel * j3 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"GCDDataSource signal" obj:0 arg:nil];
    j3.jumpBlock = ^(UIViewController *vc) {
        
        [o signalDispatchSource];
    };
    [arr addObject:j3];
    
    JumpModel * j4 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"GCDDataSource write" obj:0 arg:nil];
    j4.jumpBlock = ^(UIViewController *vc) {
        
        [o writeDispatchSource];
    };
    [arr addObject:j4];
    
    
    JumpModel * j5 = [[JumpModel alloc]initWithIsClassMethond:NO kClass:self sel:@selector(test) title:@"GCDDataSource read" obj:0 arg:nil];
    j5.jumpBlock = ^(UIViewController *vc) {
        
        [o readDataDispatchSource];
    };
    [arr addObject:j5];
    
    return arr;
}

+ (NSString *)headTitle {
    return @"GCDDataSourceTest";
}

@end
