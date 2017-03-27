
# GadgetsDemo
日常写的一些小玩意的合集。代码写的很拙劣，如果有任何问题欢迎issue，（不出意外应该）会长期更新这个合集（立个flag）。

### TNZoomImageDemo
![image](https://github.com/neon233/TNGadgets/blob/master/TNZoomImageDemo/zoomdemo.gif)
#####功能点
- 支持图片放大缩小（横竖屏）
- 支持单击图片消逝
- 支持用户锁定旋转时，用户可以点击转屏按钮来横屏/竖屏查看图片、放大图片

#####日常说明
整个demo比较麻烦的点是在横竖屏切换的时候，需要更新整个布局的frame。所以布局这一块，可以多采用Autolayout，横竖屏切换的布局变化，交给Autolayout来处理。图片放大缩小的时候，需要保证始终处于居中状态，所以在scrollViewDidZoom要实时更新frame，并且为了保证每一张图片能够完整的显示在屏幕上，会在updateZoomImageViewFrame方法中等比缩放图片。

### FlipOverDemo
![image](https://github.com/neon233/GadgetsDemo/blob/master/FlipOverDemo/demo.gif)  
视觉效果的实现基于CoreAnimation的3d变化，demo中用到是m34属性（透视效果）和CATransform3DTranslate（主要是修改tz参数来控制视图与屏幕的距离）函数。

