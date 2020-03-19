# KVC

> '[kvcTest setValue:@"heiguo" forKey:@"name"];
1. 先去查找`- (void)setName:(NSString *)name1 {` 方法是否实现,如果实现了就去调用这个方法,不管里面怎么实现的
2. 如果set方法未实现,调用`+ (BOOL)accessInstanceVariablesDirectly {`,看是否可以进行KVC赋值,如果返回NO,不能进行赋值,调用`- (void)setValue:(id)value forUndefinedKey:(NSString *)key {`方法进行提示,如果未重写该方法,抛出throw
3. 如果返回`YES`,对该对象进行查找,是否有`_name`,`_isName`,`name`这样的属性,如果有的话,对成员变量进行赋值,如果没有抛出异常

4. 在 `[kvcTest setValue:@"heiguo" forKey:@"name"];` 时候不能直接set nil,但是可以重写
