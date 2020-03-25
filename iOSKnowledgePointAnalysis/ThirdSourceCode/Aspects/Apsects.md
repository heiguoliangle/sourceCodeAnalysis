
# 初始化

```
/// Adds a block of code before/instead/after the current `selector` for a specific class.
///
/// @param block Aspects replicates the type signature of the method being hooked.
/// The first parameter will be `id<AspectInfo>`, followed by all parameters of the method.
/// These parameters are optional and will be filled to match the block signature.
/// You can even use an empty block, or one that simple gets `id<AspectInfo>`.
///
/// @note Hooking static methods is not supported.
/// @return A token which allows to later deregister the aspect.
+ (id<AspectToken>)aspect_hookSelector:(SEL)selector
withOptions:(AspectOptions)options
usingBlock:(id)block
error:(NSError **)error;

/// Adds a block of code before/instead/after the current `selector` for a specific instance.
- (id<AspectToken>)aspect_hookSelector:(SEL)selector
withOptions:(AspectOptions)options
usingBlock:(id)block
error:(NSError **)error;
```

这里有两个类,一个是`+`类 hook,一个是`-`对象hook
其中有一些参数:
1. `AspectOptions`.  hook 的时机,可以选择在原来方法之前,之后,或者是直接替换,同时还 支持是否只hook一次
```

typedef NS_OPTIONS(NSUInteger, AspectOptions) {
AspectPositionAfter   = 0,            /// Called after the original implementation (default)
AspectPositionInstead = 1,            /// Will replace the original implementation.
AspectPositionBefore  = 2,            /// Called before the original implementation.

AspectOptionAutomaticRemoval = 1 << 3 /// Will remove the hook after the first execution.
};
```
2. `block` hook时候执行的操作
3. 返回值`id<AspectToken>` 这个是决定是否要移除 hook
```
- (BOOL)remove;
```

# 源码解析
## 基本数据类
### AspectInfo
```
- (id)initWithInstance:(__unsafe_unretained id)instance invocation:(NSInvocation *)invocation;
@property (nonatomic, unsafe_unretained, readonly) id instance;
@property (nonatomic, strong, readonly) NSArray *arguments;
@property (nonatomic, strong, readonly) NSInvocation *originalInvocation;
```

1. 这里个初始化需要`instance`,调用方法对象(实例对象或者类对象), `invocation` 方法调用对象
2. 同时还保留了原来方法的invocation和参数

> 在消息转发时候回使用这个对象进行消息的调用

### AspectIdentifier

```
+ (instancetype)identifierWithSelector:(SEL)selector object:(id)object options:(AspectOptions)options block:(id)block error:(NSError **)error;
- (BOOL)invokeWithInfo:(id<AspectInfo>)info;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id block;
@property (nonatomic, strong) NSMethodSignature *blockSignature;
@property (nonatomic, weak) id object;
@property (nonatomic, assign) AspectOptions options;
```
> 这个是对外界调用的所有参数进行一次封装,会存储在静态字典中


### AspectTracker

```
- (id)initWithTrackedClass:(Class)trackedClass;
@property (nonatomic, strong) Class trackedClass;
@property (nonatomic, readonly) NSString *trackedClassName;
@property (nonatomic, strong) NSMutableSet *selectorNames;
@property (nonatomic, strong) NSMutableDictionary *selectorNamesToSubclassTrackers;
- (void)addSubclassTracker:(AspectTracker *)subclassTracker hookingSelectorName:(NSString *)selectorName;
- (void)removeSubclassTracker:(AspectTracker *)subclassTracker hookingSelectorName:(NSString *)selectorName;
- (BOOL)subclassHasHookedSelectorName:(NSString *)selectorName;
- (NSSet *)subclassTrackersHookingSelectorName:(NSString *)selectorName;
```

> 一个类对应一个tracker对象,相当于同一个类不管hook多少方法,也只会存储在一个数据结构中,包含了所有hook 的selector

### AspectsContainer

```
- (void)addAspect:(AspectIdentifier *)aspect withOptions:(AspectOptions)injectPosition;
- (BOOL)removeAspect:(id)aspect;
- (BOOL)hasAspects;
@property (atomic, copy) NSArray *beforeAspects;
@property (atomic, copy) NSArray *insteadAspects;
@property (atomic, copy) NSArray *afterAspects;
```

> 对所有添加进来的`AspectIdentifier` 对象进行分类管理,在后期forward时候,直接使用找到对应的`AspectIdentifier`对象进行调用


## 源码解析

```
static id aspect_add(id self, SEL selector, AspectOptions options, id block, NSError **error) {
NSCParameterAssert(self);
NSCParameterAssert(selector);
NSCParameterAssert(block);

__block AspectIdentifier *identifier = nil;
aspect_performLocked(^{
if (aspect_isSelectorAllowedAndTrack(self, selector, options, error)) {
AspectsContainer *aspectContainer = aspect_getContainerForObject(self, selector);
identifier = [AspectIdentifier identifierWithSelector:selector object:self options:options block:block error:error];
if (identifier) {
[aspectContainer addAspect:identifier withOptions:options];

// Modify the class to allow message interception.
aspect_prepareClassAndHookSelector(self, selector, error);
}
}
});
return identifier;
}
```

* 开始会调用`aspect_add`方法,之后检查是否能hook(aspect_isSelectorAllowedAndTrack).

1. 检查当前的selector能否被hook,`[NSSet setWithObjects:@"retain", @"release", @"autorelease", @"forwardInvocation:", nil]`,如果是这个黑名单中的,不行.
2. `dealloc` 方法不能使用`AspectPositionBefore`.
3. 当前类对象或元类对象都不能响应的话,`Unable to find selector`
4. 创建AspectTracker 对象,添加到全局列表中

* 在确认方法可以进行hook时候,用`AspectIdentifier` 对象关联所有的参数,放到container中
1. 在生成`AspectIdentifier`对象时候,会做方法签名的校验,还有block 参数签名校验

* 在生成标识后,会将标识添加到对应的容器中,之后做hook准备工作
1. 确定是对象方法还类方法,通过当前是否是元类来进行判断.如果是元类/对象,替换当前类的`forwardInvocation`,并且返回当前对应的class
2. 判断当前方法,动态添加一个方法,同时将当前方法的imp指针指向了`forwardInvocation`方法,当方法执行时候,会走到`forwardInvocation`方法




