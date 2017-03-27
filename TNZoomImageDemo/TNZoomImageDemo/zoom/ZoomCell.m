//
//  ZoomCell.m
//  TNZoomImageDemo
//
//  Created by neon on 2017/3/23.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "ZoomCell.h"

@implementation ZoomCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.contentImageView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self addSubview:self.contentImageView];
    }
    return self;
}

- (UIImageView *)contentImageView {
    if (!_contentImageView) {
        _contentImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 90)];
        _contentImageView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _contentImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _contentImageView;
}

@end
