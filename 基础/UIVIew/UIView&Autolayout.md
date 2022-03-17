# Autolayout



### 前言

#### translatesAutoresizingMaskIntoConstraints

- 默认为`true`
- 把 autoresizingMask 转换为 Constraints
- 即：可以把 frame ，bouds，center 方式布局的视图自动转化为约束形式。（此时该视图上约束已经足够 不需要手动去添加别的约束）

------

- 用代码创建的所有view ， translatesAutoresizingMaskIntoConstraints 默认是 YES
- 用 IB 创建的所有 view ，translatesAutoresizingMaskIntoConstraints 默认是 ~~NO~~ (autoresize 布局:YES , autolayout布局 :NO)

> translatesAutoresizingMaskIntoConstraints 的本意是将 frame 布局自动转化为 约束布局，转化的结果是为这个视图自动添加所有需要的约束，如果我们这时给视图添加自己创建的约束就一定会约束冲突。
>
> 为了避免上面说的约束冲突，我们在代码创建 约束布局 的控件时 直接指定这个视图不能用frame 布局（即translatesAutoresizingMaskIntoConstraints=NO），可以放心的去使用约束了



### 方式

```
// 初始化UI
label = UILabel()
label.textAlignment = .center
label.text = "Autolayout"
label.layer.borderWidth = 1
label.layer.cornerRadius = 10
label.backgroundColor = UIColor.black
view.addSubview(label)
// 启用代码约束
label.translatesAutoresizingMaskIntoConstraints = false
```



#### 方式一

```
// layout
label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100).isActive = true
label.heightAnchor.constraint(equalToConstant: 50).isActive = true
label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100).isActive = true
label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100).isActive = true
```

#### 方式二

```
let cs1 = NSLayoutConstraint(item: self.label!, attribute: .top, relatedBy: .equal, toItem: self.view, attribute: .top, multiplier: 1.0, constant: 100)
let cs4 = NSLayoutConstraint(item: self.label!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: 50)
let cs2 = NSLayoutConstraint(item: self.label!, attribute: .leading, relatedBy: .equal, toItem: self.view, attribute: .leading, multiplier: 1.0, constant: 100.0)
let cs3 = NSLayoutConstraint(item: self.label!, attribute: .centerX, relatedBy: .equal,    toItem: self.view, attribute: .centerX, multiplier: 1, constant: 0)

view.addConstraints([cs1, cs2, cs3, cs4])
```

#### 方式三

```
NSLayoutConstraint.activate([
    label.topAnchor.constraint(equalTo: view.topAnchor, constant: 100)
    label.heightAnchor.constraint(equalToConstant: 50),
    label.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 100),
    label.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -100),
])
```

