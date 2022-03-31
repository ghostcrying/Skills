# Carthage



#### 应用

- 选择xcframeworks

  ```
  carthage update --use-xcframeworks 
  ```

- 选择设备

  ```
  carthage update --use-xcframeworks --platform ios
  ```

- 选择本地编译环境

  ```
  carthage update --use-xcframeworks --no-use-binaries
  ```

  - 有时,当您使用较新版本的语言但依赖项是使用旧版本构建时(即使它仍然兼容),然后执行更新将产生错误。您可以使用标志解决这些情况。一个缺点是你需要更长的时间来编译项目而没有这个标志你可以简单地使用预先构建的框架(如果它可用)

- Cathfile

  - git库

    ```
    github "SnapKit/SnapKit" ~> 5.0.0
    ```

  - 本地库(自定义服务器git)

    ```
    git "http://code.putao.io/ios_client/lottie-ios.git" "master"
    ```

    



#### 支持Carthage

在项目根目录运行

```
carthage build --no-skip-current
# 结束后检查 Carthage->Build->iOS->xxx.framework是否存在, 即可
```

