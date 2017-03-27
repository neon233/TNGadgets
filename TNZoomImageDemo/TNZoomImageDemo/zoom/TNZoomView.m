//
//  TNZoomView.m
//  TNZoomImageDemo
//
//  Created by neon on 2017/3/24.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "TNZoomView.h"
#import <Masonry.h>
@implementation TNZoomView

- (void)drawRect:(CGRect)rect {
    [self addSubview:self.zoomScrollView];
    [self.zoomScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self);
        make.left.mas_equalTo(self);
        make.center.mas_equalTo(self);
    }];
}

- (void)layoutSubviews {
    [self updateZoomImageViewFrame:self.zoomImageView.image.size];
}

#pragma mark event
- (void)tapAction:(UITapGestureRecognizer *)gesture {
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation != UIInterfaceOrientationPortrait) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
    
    self.zoomScrollView.zoomScale = 1.0;
    self.tapBlock();
}

- (void)setZoomImage:(UIImage *)zoomImage {
    self.zoomImageView.image = zoomImage;
    [self updateZoomImageViewFrame:zoomImage.size];
}

//因为不同的图片大小不一样，可能会超过屏幕尺寸，这里做一个缩放的处理，让图片能够完整的显示在屏幕上
- (void)updateZoomImageViewFrame:(CGSize)zoomImageSize {
    
    CGFloat calScale = 1;
    CGSize calSize = CGSizeMake(zoomImageSize.width*self.zoomScrollView.zoomScale, zoomImageSize.height*self.zoomScrollView.zoomScale);
    if (self.zoomScrollView.zoomScale == 1.0) {
        if (zoomImageSize.height > self.bounds.size.height || zoomImageSize.width > self.bounds.size.width) {
            CGFloat xScale = self.bounds.size.width*1.0 / zoomImageSize.width;
            CGFloat yScale = self.bounds.size.height*1.0 / zoomImageSize.height;
            xScale < yScale ? (calScale = xScale):(calScale = yScale);
            calSize = CGSizeMake(zoomImageSize.width*calScale*self.zoomScrollView.zoomScale, zoomImageSize.height*calScale*self.zoomScrollView.zoomScale);
        }
        self.zoomImageView.frame = CGRectMake((self.bounds.size.width-calSize.width)/2.0, (self.bounds.size.height-calSize.height)/2.0, calSize.width, calSize.height);
    }
    //每设置一次图片，就重置一次contentsize
    self.zoomScrollView.contentSize = CGSizeZero;
}



#pragma mark scrollview delegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.zoomImageView;
}

//图片放大后也居中显示
- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) /2 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) /2 : 0.0;
    self.zoomImageView.center = CGPointMake(scrollView.contentSize.width /2 + offsetX,
                                            scrollView.contentSize.height /2 + offsetY);
}


#pragma mark getter & setter
- (UIScrollView *)zoomScrollView {
    if (!_zoomScrollView) {
        _zoomScrollView = [[UIScrollView alloc]init];
        _zoomScrollView.maximumZoomScale = 2.0;
        _zoomScrollView.minimumZoomScale = 1.0;
        _zoomScrollView.backgroundColor = [UIColor grayColor];
        _zoomScrollView.delegate = self;
        [_zoomScrollView addSubview:self.zoomImageView];
    }
    return _zoomScrollView;
}

- (UIImageView *)zoomImageView {
    if (!_zoomImageView) {
        _zoomImageView = [[UIImageView alloc]init];
        _zoomImageView.userInteractionEnabled = YES;
        [_zoomImageView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapAction:)]];
    }
    return _zoomImageView;
}

@end
