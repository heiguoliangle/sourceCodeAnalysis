# Atomic

## 对于atomic的属性，系统生成的 getter/setter 会保证 get、set 操作的完整性，不受其他线程影响。比如，线程 A 的 getter 方法运行到一半，线程 B 调用了 setter：那么线程 A 的 getter 还是能得到一个完好无损的对象。
## 在修饰数组属性时候,读取操作有可能读取到的是错误的,但是在写的操作有可能导致crash


