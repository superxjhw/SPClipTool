# SPClipTool
图片裁剪工具

类似iOS原生裁剪，支持裁剪对象缩放平移，支持裁剪框拖拽缩放，边缘交互

![(效果图)](./demo.gif)

使用
```objc
[[SPClipTool shareClipTool] sp_clipOriginImage:pickerImage complete:^(UIImage * _Nonnull image) {
    // image 裁剪后的图片
}];
```
