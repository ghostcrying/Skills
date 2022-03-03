# RunTime

#### 简析

> 运行时系统充当Objc的操作系统, 它使语言能够工作。
>
> 将尽可能多的决策从编译时、链接时推迟到运行时。

###### 特性

- 编写的代码具有运行时、动态特性



#### 运用

###### **Runtime在Object-C的使用**

> Objective-C程序在三个不同的层次上与运行时系统交互
>
> - 通过Object-C源代码进行交互
> - 通过NSObject类中定义的方法进行交互
> - 通过直接调用运行时函数

###### 基本作用

> - 程序运行过程中： 动态的创建类，动态添加修改这个类的属性和方法。
>
> - 遍历一个类中的所有成员变量、属性以及所有方法
>
> - 消息传递、转发

###### 具体运用

> - 系统分类添加方法、属性
> - 方法交换
>
> - 获取对象的属性、私有属性
> - 字典转模型
> - KVO / KVC
> - 归档（编码、解码）
> - 映射（NSClassFromString class<->String）
> - block
> - 类的自我检测
> - NSTimer循环打破
> - ...



#### 定义

###### 源码

```
@interface NSObject <NSObject> {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wobjc-interface-ivars"
    Class isa  OBJC_ISA_AVAILABILITY;
#pragma clang diagnostic pop
}

/// An opaque type that represents an Objective-C class.
typedef struct objc_class *Class;

/// Represents an instance of a class. 实例
struct objc_object {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY; // isa指针指向类
};

/// A pointer to an instance of a class.
typedef struct objc_object *id;

以上可知： 
- OC中的类是由Class类型来表示的，它实际是一指向objc_class结构体的指针。
- Class是类， id是指向objc_object的一个指针，而objc_object有个isa指向objc_class的指针。
  - 因此无论是Class还是id， 最终都指向objc_class这个结构体

# objc_class结构体源码
struct objc_class {
    Class _Nonnull isa  OBJC_ISA_AVAILABILITY;

#if !__OBJC2__
    Class _Nullable super_class                              OBJC2_UNAVAILABLE;
    const char * _Nonnull name                               OBJC2_UNAVAILABLE;
    long version                                             OBJC2_UNAVAILABLE;
    long info                                                OBJC2_UNAVAILABLE;
    long instance_size                                       OBJC2_UNAVAILABLE;
    struct objc_ivar_list * _Nullable ivars                  OBJC2_UNAVAILABLE;
    struct objc_method_list * _Nullable * _Nullable methodLists                    OBJC2_UNAVAILABLE;
    struct objc_cache * _Nonnull cache                       OBJC2_UNAVAILABLE;
    struct objc_protocol_list * _Nullable protocols          OBJC2_UNAVAILABLE;
#endif

} OBJC2_UNAVAILABLE;
/* Use `Class` instead of `struct objc_class *` */
```

###### isa

> `Class`对象， 指向`objc_class`结构体的指针， 也就是这个`Class`的`MetaClass`（元类）
>
> - 类的实例对象的 `isa` 指向该类;该类的` isa` 指向该类的 `MetaClass`
> - `MetaCalss`的isa对象指向`RootMetaCalss`
>
> **super_class** Class对象指向父类对象
>
> - 如果该类的对象已经是RootClass，那么这个`super_class`指向nil
>
> - `MetaCalss`的`SuperClass`指向父类的`MetaCalss`
>
> - `MetaCalss`是`RootMetaCalss`，那么该`MetaClass`的`SuperClass`指向该对象的`RootClass `
> - 元类(MetaClass): 类对象的isa指向元类, super_class指向父类的类对象, 而元类的super_class指向了父类的元类, 元类的isa指向自己(形成闭环)

![](https://upload-images.jianshu.io/upload_images/7980283-2d02894c178d3582.png?imageMogr2/auto-orient/strip|imageView2/2/w/651)

###### 消息发送过程

> 主线：
>
> - 实例 --(isa)--> 类 --(super_class)--> 父类  --(super_class)--> ...  --(super_class)--> 根类(NSObject) --(super_class)--> nil
> - **可以说：isa指针建立起了实例与他所属的类之间的关系，super_class指针建立起了类与其父类之间的关系。**
>
> 具体过程：
>
> - 检测selector是否需要忽略（macOS的垃圾回收机制可以忽略retain release函数）
> - 检测target是否为nil， oc对nil对象发送消息会被忽略
> - 查找selector：
>   - cache中查找
>   - methodLists查找
>   - 父类 -> 超类
>
> - 消息转发
>   - 动态解析resolveInstanceMethod/resolveClassMethod， 制定新的IMP（未处理继续向下执行）
>   - 备用接受者： forwardingTargetForSelector， 指定新的接受者（返回nil， 继续向下执行）
>   - 完整消息转发： methodSignatureForSelector:返回一个方法签名，forwardInvocation:处理消息执行
>     - methodSignatureForSelector如果返回nil 直接crash
>     - methodSignatureForSelector返回只要是非nil且是NSMethodSignature类型的任何值都ok，
>     - forwardInvocation的参数anInvocation中的signature即为上一步返回的方法签名，
>     - forwardInvocation的参数anInvocation中的selector为导致crash的方法，target为导致crash的对象
>     - forwardInvocation方法可以啥都不处理，或者做任何不会出问题的事，至此本次消息转发结束，也不会crash。
>   - 抛出异常: - (void)doesNotRecognizeSelector:(SEL)aSelector
> - 最终发送
>   - objc_msgSend("对象","SEL","参数"...)
>   - objc_msgSend( id self, SEL op, ... )



#### 应用

###### isKindOfClass 与 isMemberOfClass

```
// 源码
+ (BOOL)isMemberOfClass:(Class)cls {
    return object_getClass((id)self) == cls;
}

- (BOOL)isMemberOfClass:(Class)cls {
    return [self class] == cls;
}

/// 可以看到self会继续遍历， 但是cls是固定的，因此只需要针对闭环查找self的最终isa是否与cls相同即可。
+ (BOOL)isKindOfClass:(Class)cls {
    for (Class tcls = object_getClass((id)self); tcls; tcls = tcls->super_class) {
        if(tcls == cls) return YES;
    }
    return NO；
}
-（BOOL)isKindOfClass:(Class)cls {
    for(Class tcls = [self class]; tcls; tcls = tcls->super_class) {
        if(tcls == cls) return YES;
    }
    return NO;
}
```



>  解析: 说白了就是判定isa指针指向是否相等
>
> - isKind: 检测当前对象是否属于某个类或者派生类 (可以检测根类)
>
> - isMember: 检测当前对象是否是当前类的实例
>
> - isMember: 不能检测任何类都是基于NSObject这一事实,但是isKindk可以
>
> - 对于类簇的判定要谨慎: 使用iskind of, 但是isMember可能得不到正确结果

```
举例: 判定指针
- [(id)[s class]] isKindOfClass:[Student class]]
  - [s class] 的isa指向Student的metaClass
  - 后者指向Class

- [(id)[Student class] isKindOfClass:[Student class]]
  - 后者不变, 指向Class
  - 前者本身为Class, isa指向metaClass, 逐层遍历, 是查找不到的, 所以NO

- [(id)[Student class] isMemberOfClass:[Student class]]
  - 同上, 直接判定第一层即可, 所以NO

- [(id)[NSObject class] isMemberOfClass:[NSObject class]]
  - 这个判定, 不会逐层便利, 所以同上NO
 
- [(id)[NSObject class] isKindOfClass:[NSObject class]]
  - 这个判定, 逐层遍历, 最终指向自身, 所以YES
  - 实例化后, student1的isa指针指向Class, 以此来进行判定

isKindOf： 调用者A，传入参数B， A可以继续向上遍历找到合适的isa， 但是B不会的，
```

