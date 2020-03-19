# main 函数

```
int main(int argc, char * argv[]) {
NSString * appDelegateClassName;
@autoreleasepool {
// Setup code that might create autoreleased objects goes here.
appDelegateClassName = NSStringFromClass([AppDelegate class]);
}
return UIApplicationMain(argc, argv, nil, appDelegateClassName);
}
```

## 1. 首先创建了一个`autoreleasepool`;
## 2. 调用UIApplicationMain函数
这个方法将根据第三个参数初始化一个 UIApplication 或其子类的对象并开始接收事件 (在这个例子中传入 nil，意味使用默认的 UIApplication)。最后一个参数指定了 AppDelegate 类作为应用的委托，它被用来接收类似 didFinishLaunching 或者 didEnterBackground 这样的与应用生命周期相关的委托方法。另外，虽然这个方法标明为返回一个 int，但是其实它并不会真正返回。它会一直存在于内存中，直到用户或者系统将其强制终止。

## 3. 释放自动释放池



