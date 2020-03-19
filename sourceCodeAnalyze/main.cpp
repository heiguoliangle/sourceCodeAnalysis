

struct __Block_byref_intValue_0 {
  void *__isa;
__Block_byref_intValue_0 *__forwarding; // // 指向自己的指针
 int __flags;
 int __size;
 int intValue;
};

struct __main_block_impl_0 {
  struct __block_impl impl;
  struct __main_block_desc_0* Desc;
  __Block_byref_intValue_0 *intValue; // by ref
    
  __main_block_impl_0(void *fp,
                      struct __main_block_desc_0 *desc,
                      __Block_byref_intValue_0 *_intValue,
                      int flags=0) : intValue(_intValue->__forwarding) {
    impl.isa = &_NSConcreteStackBlock;
    impl.Flags = flags;
    impl.FuncPtr = fp;
    Desc = desc;
  }
};
static void __main_block_func_0(struct __main_block_impl_0 *__cself) {
    
  __Block_byref_intValue_0 *intValue = __cself->intValue; // bound by ref

        (intValue->__forwarding->intValue) = 1;
    }
static void __main_block_copy_0(struct __main_block_impl_0*dst, struct __main_block_impl_0*src) {
    
    _Block_object_assign(
                         (void*)&dst->intValue,
                         (void*)src->intValue, 8/*BLOCK_FIELD_IS_BYREF*/);
    
}

static void __main_block_dispose_0(struct __main_block_impl_0*src) {
    
    _Block_object_dispose((void*)src->intValue,
                          8/*BLOCK_FIELD_IS_BYREF*/);
    
}

static struct __main_block_desc_0 {
  size_t reserved;
  size_t Block_size;
  void (*copy)(struct __main_block_impl_0*, struct __main_block_impl_0*);
  void (*dispose)(struct __main_block_impl_0*);
} __main_block_desc_0_DATA = {
    
    0,
    sizeof(struct __main_block_impl_0),
    __main_block_copy_0,
    __main_block_dispose_0
    
};
int main()
{
    
    
    __attribute__((__blocks__(byref))) __Block_byref_intValue_0 intValue = {
        (void*)0,
        (__Block_byref_intValue_0 *)&intValue,
        0,
        sizeof(__Block_byref_intValue_0),
        0};
    
    void (*blk)(void) = (
                         (void (*)())&__main_block_impl_0
                         (
                          (void *)__main_block_func_0,
                          &__main_block_desc_0_DATA,
                          (__Block_byref_intValue_0 *)&intValue,
                          570425344)
                         
                         );
    
    
    return 0;
}
static struct IMAGE_INFO { unsigned version; unsigned flag; } _OBJC_IMAGE_INFO = { 0, 2 };


/*
 全局block:
 1. 当 block 字面量写在全局作用域时，即为 global block；
 2. 当 block 字面量不获取任何外部变量时，即为 global block；
 
 _NSConcreteStackBlock:
 声明在栈上,作用域结束,block也会结束,变量也销毁,新增了copy功能,将 block 和 __block 变量从栈拷贝到堆，就是下面要说的 _NSConcreteMallocBlock。
 
 
 */
