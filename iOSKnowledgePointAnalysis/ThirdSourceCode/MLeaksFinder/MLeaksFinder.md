# MLeaksFinder

## 问题
1. 如何检测内存泄漏
2. 内存泄漏堆栈如何找出来
3. 针对数据类型有哪些

## 核心类
1. `UIViewController+MemoryLeak`
2. `UINavigationController+MemoryLeak`
3. `NSObject+MemoryLeak`
4. `UITouch+MemoryLeak`
5. `MLeakedObjectProxy`

------

## 解决第一个问题: 如何检测内存泄漏

## UIViewController+MemoryLeak

```
+ (void)load {
static dispatch_once_t onceToken;
dispatch_once(&onceToken, ^{
[self swizzleSEL:@selector(viewDidDisappear:) withSEL:@selector(swizzled_viewDidDisappear:)];
[self swizzleSEL:@selector(viewWillAppear:) withSEL:@selector(swizzled_viewWillAppear:)];
[self swizzleSEL:@selector(dismissViewControllerAnimated:completion:) withSEL:@selector(swizzled_dismissViewControllerAnimated:completion:)];
});
}
```
针对`UIViewController` 的,hook了vc 的`viewDidDisappear`,`viewWillAppear`,`dismissViewControllerAnimated`这三个方法.
1. `viewWillAppear`.这个方法主要是在push时候起作用,添加一个是否出栈的标记为`kHasBeenPoppedKey`,这个在`UINavigationController+MemoryLeak`的`pop`方法时候会置为YES.
2. `swizzled_viewDidDisappear`,这个方法就是在判断是否是`pop`的.如果发现是pop的,会调用`[self willDealloc];`

```

- (BOOL)willDealloc {
if (![super willDealloc]) {
return NO;
}

[self willReleaseChildren:self.childViewControllers];
[self willReleaseChild:self.presentedViewController];

if (self.isViewLoaded) {
[self willReleaseChild:self.view];
}

return YES;
}
```

> 这里做了两个事情:
1. 判断通知父类将要进行dealloc,并且在2s后进行检测是否有内存泄漏,如果发现有,就进行弹框展示,否则内存正常释放
2. 串行执行,构建当前vc的`viewStack`,主要是通过`NSObject+MemoryLeak`,将view层级添加到了`viewStack`和`parentPtrs`


总结:
这里主要是添加一个认为是dealloc的时机,在这三个时机,认为会dealloc,如果2s之后还能执行弹框,那就认为他是有内存泄漏

## NSObject+MemoryLeak

核心方法:
```
- (BOOL)willDealloc {
NSString *className = NSStringFromClass([self class]);
if ([[NSObject classNamesWhitelist] containsObject:className]) // 白名单直接忽略掉
return NO;

NSNumber *senderPtr = objc_getAssociatedObject([UIApplication sharedApplication], kLatestSenderKey);
if ([senderPtr isEqualToNumber:@((uintptr_t)self)]) // 如果是当前对象,就忽略掉,这个在target-aciton里面去处理
return NO;

__weak id weakSelf = self;
dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
__strong id strongSelf = weakSelf;
// 在2秒后依然调用,说明这里有泄漏,self没有被释放
[strongSelf assertNotDealloc];
}); 

return YES;
}
```
1. 做白名单,匹配白名单就不做处理,例如可以添加一些单利之类的
2. 为了防止重复调用,采用了target-aciton方法,如果发现当前是点击的对象,也不做
3. 延迟2s检查是否泄漏










