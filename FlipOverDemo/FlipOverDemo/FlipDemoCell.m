//
//  FlipDemoCell.m
//  FlipOverDemo
//
//  Created by neon on 2017/3/21.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "FlipDemoCell.h"

@implementation FlipDemoCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self addSubview:self.flipLabel];
    }
    return self;
}
- (UILabel *)flipLabel {
    if (!_flipLabel) {
        _flipLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 100, 60)];
        _flipLabel.backgroundColor = [UIColor whiteColor];
    }
    return _flipLabel;
}


@end
