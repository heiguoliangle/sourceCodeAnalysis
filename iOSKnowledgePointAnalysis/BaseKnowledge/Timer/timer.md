
# NSTimer 
```

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti invocation:(NSInvocation *)invocation repeats:(BOOL)yesOrNo;

+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)ti target:(id)aTarget selector:(SEL)aSelector userInfo:(nullable id)userInfo repeats:(BOOL)yesOrNo;


/// Creates and returns a new NSTimer object initialized with the specified block object. This timer needs to be scheduled on a run loop (via -[NSRunLoop addTimer:]) before it will fire.
/// - parameter:  timeInterval  The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// - parameter:  repeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// - parameter:  block  The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
+ (NSTimer *)timerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

/// Creates and returns a new NSTimer object initialized with the specified block object and schedules it on the current run loop in the default mode.
/// - parameter:  ti    The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// - parameter:  repeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// - parameter:  block  The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
+ (NSTimer *)scheduledTimerWithTimeInterval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

/// Initializes a new NSTimer object using the block as the main body of execution for the timer. This timer needs to be scheduled on a run loop (via -[NSRunLoop addTimer:]) before it will fire.
/// - parameter:  fireDate   The time at which the timer should first fire.
/// - parameter:  interval  The number of seconds between firings of the timer. If seconds is less than or equal to 0.0, this method chooses the nonnegative value of 0.1 milliseconds instead
/// - parameter:  repeats  If YES, the timer will repeatedly reschedule itself until invalidated. If NO, the timer will be invalidated after it fires.
/// - parameter:  block  The execution body of the timer; the timer itself is passed as the parameter to this block when executed to aid in avoiding cyclical references
- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)interval repeats:(BOOL)repeats block:(void (^)(NSTimer *timer))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

- (instancetype)initWithFireDate:(NSDate *)date interval:(NSTimeInterval)ti target:(id)t selector:(SEL)s userInfo:(nullable id)ui repeats:(BOOL)rep NS_DESIGNATED_INITIALIZER;

- (void)fire;

@property (copy) NSDate *fireDate;
@property (readonly) NSTimeInterval timeInterval;

// Setting a tolerance for a timer allows it to fire later than the scheduled fire date, improving the ability of the system to optimize for increased power savings and responsiveness. The timer may fire at any time between its scheduled fire date and the scheduled fire date plus the tolerance. The timer will not fire before the scheduled fire date. For repeating timers, the next fire date is calculated from the original fire date regardless of tolerance applied at individual fire times, to avoid drift. The default value is zero, which means no additional tolerance is applied. The system reserves the right to apply a small amount of tolerance to certain timers regardless of the value of this property.
// As the user of the timer, you will have the best idea of what an appropriate tolerance for a timer may be. A general rule of thumb, though, is to set the tolerance to at least 10% of the interval, for a repeating timer. Even a small amount of tolerance will have a significant positive impact on the power usage of your application. The system may put a maximum value of the tolerance.
@property NSTimeInterval tolerance API_AVAILABLE(macos(10.9), ios(7.0), watchos(2.0), tvos(9.0));

- (void)invalidate;
@property (readonly, getter=isValid) BOOL valid;

@property (nullable, readonly, retain) id userInfo;
```

timer 有两种初始化方法
1. `timerWithTimeInterval` ,使用这个中时候就是创建一个timer,但是并未加入到runloop,如果在子线程执行的话,需要手动开启runloop
2. `scheduledTimerWithTimeInterval` , 自动创建一个并加入runloop,实际还是要看是否开启了runloop了

> 在使用时候,runloop已经对timer有强引用了,timer对target又引用,有可能造成循环引用

# runloop

```

@class NSTimer, NSPort, NSArray<ObjectType>, NSString;

NS_ASSUME_NONNULL_BEGIN

FOUNDATION_EXPORT NSRunLoopMode const NSDefaultRunLoopMode;
FOUNDATION_EXPORT NSRunLoopMode const NSRunLoopCommonModes API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@interface NSRunLoop : NSObject {
@private
id          _rl;
id          _dperf;
id          _perft;
id          _info;
id        _ports;
void    *_reserved[6];
}

@property (class, readonly, strong) NSRunLoop *currentRunLoop;
@property (class, readonly, strong) NSRunLoop *mainRunLoop API_AVAILABLE(macos(10.5), ios(2.0), watchos(2.0), tvos(9.0));

@property (nullable, readonly, copy) NSRunLoopMode currentMode;

- (CFRunLoopRef)getCFRunLoop CF_RETURNS_NOT_RETAINED;

- (void)addTimer:(NSTimer *)timer forMode:(NSRunLoopMode)mode;

- (void)addPort:(NSPort *)aPort forMode:(NSRunLoopMode)mode;
- (void)removePort:(NSPort *)aPort forMode:(NSRunLoopMode)mode;

- (nullable NSDate *)limitDateForMode:(NSRunLoopMode)mode;
- (void)acceptInputForMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;

@end

@interface NSRunLoop (NSRunLoopConveniences)

- (void)run; 
- (void)runUntilDate:(NSDate *)limitDate;
- (BOOL)runMode:(NSRunLoopMode)mode beforeDate:(NSDate *)limitDate;

#if TARGET_OS_OSX
- (void)configureAsServer API_DEPRECATED("Not supported", macos(10.0,10.5), ios(2.0,2.0), watchos(2.0,2.0), tvos(9.0,9.0));
#endif

/// Schedules the execution of a block on the target run loop in given modes.
/// - parameter: modes   An array of input modes for which the block may be executed.
/// - parameter: block   The block to execute
- (void)performInModes:(NSArray<NSRunLoopMode> *)modes block:(void (^)(void))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

/// Schedules the execution of a block on the target run loop.
/// - parameter: block   The block to execute
- (void)performBlock:(void (^)(void))block API_AVAILABLE(macosx(10.12), ios(10.0), watchos(3.0), tvos(10.0));

@end

/****************     Delayed perform     ******************/

@interface NSObject (NSDelayedPerforming)

- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay inModes:(NSArray<NSRunLoopMode> *)modes;
- (void)performSelector:(SEL)aSelector withObject:(nullable id)anArgument afterDelay:(NSTimeInterval)delay;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget selector:(SEL)aSelector object:(nullable id)anArgument;
+ (void)cancelPreviousPerformRequestsWithTarget:(id)aTarget;

@end

@interface NSRunLoop (NSOrderedPerform)

- (void)performSelector:(SEL)aSelector target:(id)target argument:(nullable id)arg order:(NSUInteger)order modes:(NSArray<NSRunLoopMode> *)modes;
- (void)cancelPerformSelector:(SEL)aSelector target:(id)target argument:(nullable id)arg;
- (void)cancelPerformSelectorsWithTarget:(id)target;

@end
```

1. 这需要说的是`performSelector`这个方法是放在runloop 这里的,实际是在runloop中添加了个nstimer,以保证之后会在after 的方法中执行
2. 使用第一种启动方式，runloop会一直运行下去，在此期间会处理来自输入源的数据，并且会在NSDefaultRunLoopMode模式下重复调用runMode:beforeDate:方法；
3. 使用第二种启动方式，可以设置超时时间，在超时时间到达之前，runloop会一直运行，在此期间runloop会处理来自输入源的数据，并且也会在NSDefaultRunLoopMode模式下重复调用runMode:beforeDate:方法；

4. 使用第三种启动方式，runloop会运行一次，超时时间到达或者第一个input source被处理，则runloop就会退出。


# GCDTimer

```
dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
dispatch_source_set_timer(timer, DISPATCH_TIME_NOW , 1 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
dispatch_source_set_event_handler(timer, ^{
NSLog(@"GCD thread %@",[NSThread currentThread]);
});
//开启定时器
dispatch_resume(timer);
self.timer = timer;
```



