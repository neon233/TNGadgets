

//  ViewController.m
//  TNZoomImageDemo
//
//  Created by neon on 2017/3/23.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "ViewController.h"
#import "TNZoomView.h"
#import "ZoomCell.h"
#import <Masonry.h>
#import "AppDelegate.h"
#define VIEW_WIDTH  [UIScreen mainScreen].bounds.size.width
#define VIEW_HEIGHT [UIScreen mainScreen].bounds.size.height
typedef void (^TapBlock)();
@interface ViewController () <UITableViewDelegate,UITableViewDataSource,UIScrollViewDelegate>
@property (nonatomic,strong) UITableView *galleryView;
@property (nonatomic,strong) UIScrollView *displayView;
@property (nonatomic,strong) NSMutableArray *displayContentViewList;
@property (nonatomic,strong) NSArray *imageList;
@property (nonatomic,strong) TapBlock tapBlock;
@property (nonatomic) NSInteger currentPage,lastPosition;
@property (nonatomic,strong) UIButton *orientationBtn; //用户在锁定屏幕的情况下，点击旋转


@end

@implementation ViewController

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        

        self.displayContentViewList = [[NSMutableArray alloc]init];
        self.imageList = @[@"234",@"233",@"235",@"236",@"237"];
        self.currentPage = 0;
        
        
    }
    return self;
}


- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    [self.view addSubview:self.galleryView];
    [self.view addSubview:self.displayView];
    [self.view addSubview:self.orientationBtn];
    
    [self.displayView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.height.mas_equalTo(self.view);
        make.width.mas_equalTo(self.view);
    }];
    
    
    [self.orientationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(self.view);
    }];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeAction) name:UIDeviceOrientationDidChangeNotification object:nil];
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}
#pragma mark event
- (void)changeAction {
    self.displayView.contentSize = CGSizeMake(VIEW_WIDTH*self.imageList.count, 0);
    self.displayView.contentOffset = CGPointMake(self.currentPage*VIEW_WIDTH, 0);
    
    for (int i=0;i<self.imageList.count; i++) {
        TNZoomView *zoomView = self.displayContentViewList[i];
        zoomView.frame = CGRectMake(VIEW_WIDTH*i, 0, VIEW_WIDTH, VIEW_HEIGHT);
        zoomView.zoomScrollView.zoomScale = 1;
    }
}

- (void)landScapeAction {
    
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    if (orientation == UIInterfaceOrientationPortrait) {
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationLandscapeRight) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
        
    }else {
        
        [[UIDevice currentDevice] setValue:@(UIDeviceOrientationPortrait) forKey:@"orientation"];
        [UIViewController attemptRotationToDeviceOrientation];
    }
   
    [self changeAction];
}


#pragma mark uitableiview delegte

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.imageList.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZoomCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[ZoomCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.contentImageView.image = [UIImage imageNamed:self.imageList[indexPath.row]];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentPage = indexPath.row;
    [self.displayView setContentOffset:CGPointMake(VIEW_WIDTH*self.currentPage,0) animated:NO];
    __weak typeof(self) weakself = self;
    [UIView animateWithDuration:0.5 animations:^{
        weakself.displayView.alpha = 1;
    }];
}

#pragma mark scrollview delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    self.currentPage = scrollView.contentOffset.x / VIEW_WIDTH;
}

#pragma mark setter && getter

- (UITableView *)galleryView {
    if (!_galleryView) {
        _galleryView = [[UITableView alloc]init];
        _galleryView.frame = self.view.frame;
        _galleryView.delegate = self;
        _galleryView.dataSource = self;
        _galleryView.rowHeight = 90;
    }
    return _galleryView;
}

- (UIScrollView *)displayView {
    if (!_displayView) {
        _displayView = [[UIScrollView alloc]init];
        _displayView.pagingEnabled = YES;
        _displayView.contentSize = CGSizeMake(VIEW_WIDTH*self.imageList.count, 0);
        _displayView.showsVerticalScrollIndicator = YES;
        _displayView.showsHorizontalScrollIndicator = YES;
        _displayView.delegate = self;
        _displayView.bounces = NO;
        _displayView.alpha = 0;
        
        for (int i=0;i<self.imageList.count; i++) {
            TNZoomView *zoomView = [[TNZoomView alloc]initWithFrame:CGRectMake(VIEW_WIDTH*i, 0, VIEW_WIDTH, VIEW_HEIGHT)];
            [zoomView setZoomImage:[UIImage imageNamed:self.imageList[i]]];
            zoomView.backgroundColor = [UIColor orangeColor];
            __weak typeof(self) weakself = self;
            zoomView.tapBlock = ^() {
                [UIView animateWithDuration:0.5 animations:^{
                    weakself.displayView.alpha = 0;
                    weakself.currentPage = 0;
                }];
            };
            [self.displayView addSubview:zoomView];
            [self.displayContentViewList addObject:zoomView];
            
        }
    }
    return _displayView;
}

- (UIButton *)orientationBtn {
    if (!_orientationBtn) {
        _orientationBtn = [[UIButton alloc]init];
        [_orientationBtn setTitle:@"转屏" forState:UIControlStateNormal];
        _orientationBtn.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.5];
        [_orientationBtn addTarget:self action:@selector(landScapeAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _orientationBtn;
}

@end

