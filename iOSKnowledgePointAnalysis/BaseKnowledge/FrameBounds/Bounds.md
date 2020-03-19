
# bounds
当进行
```
_redView.bounds = CGRectMake(10, 0, 10, 10);
```
这个操作时候,实际是将_redView 的左上角的坐标变为了CGPoint(10,0),但是子控件自能是相对于CGPoint(0,0)来布局的,所以此时父控件的原点变为了CGPoint(-10,0).当子控件在add时候,就会显示在左边10个位置开始.


# frame
初始化时候,frame 的宽高是相等,当做旋转后,frame是最大宽高,bounds的宽高还是原来的

# position & anchorPoint

position 觉得的是layer 的anchorPoint(初始化时候,anchorPoint == center)在哪里,

