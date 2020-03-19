
# 同步异步任务
##  同步
1. 同步任务不开启线程,只是在当前线程进行执行某一个队列的任务

## 异步
1. 异步任务会开启线程,所有的任务都会在新开线程上执行

# 串行队列,并行队列
## 串行队列
1. 所有的任务都是顺序执行,前一个执行不完,下一个不会执行

## 并行队列
2. 所有的任务对齐,可以同时执行,互不影响

# 组合

## 同步任务 + 串行队列 (有序执行任务)
1. 在同一个线程任务顺序执行

## 同步任务 + 并行队列 (有序执行任务)
1. 同步任务都在同一个线程执行, 并行队列虽然可以创建多个线程并发执行,但是为创建多余队列,只能在同一个线程执行,串行执行

## 异步任务 + 串行队列(有序执行任务,会在多个子线程,但是顺序执行)
1. 异步开启子线程 , 串行队列任务顺序出队列
 
## 异步任务 + 并行队列
1. 异步开启子线程, 在子线程并发请求