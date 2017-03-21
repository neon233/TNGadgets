# GadgetsDemo
日常写的一些小玩意的合集。代码写的很拙劣，如果有任何问题欢迎issue，（不出意外应该）会长期更新这个合集（立个flag）。
### FlipOverDemo（一个滑动效果）
![image](https://github.com/neon233/GadgetsDemo/blob/master/FlipOverDemo/demo.gif)  
图方便用了UICollectionView,效果基本上是*在(void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset;*
方法中完成。
如果需要在别的工程里实现这个滑动效果，只要把demo里的方法拷过去就可以了。
视觉效果的实现基于CoreAnimation的3d变化，demo中用到是m34属性（透视效果）和CATransform3DTranslate（主要是修改tz参数来控制视图与屏幕的距离）函数。
