//
//  TNZoomView.h
//  TNZoomImageDemo
//
//  Created by neon on 2017/3/24.
//  Copyright © 2017年 neon. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^SingleTapBlock)();
@interface TNZoomView : UIView <UIScrollViewDelegate>
@property (nonatomic,strong) UIScrollView *zoomScrollView;
@property (nonatomic,strong) UIImageView *zoomImageView;
@property (nonatomic,copy) SingleTapBlock tapBlock;
- (void)setZoomImage:(UIImage *)zoomImage ;

@end
