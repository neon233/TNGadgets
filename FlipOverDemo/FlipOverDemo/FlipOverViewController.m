//
//  FlipOverViewController.m
//  FlipOverDemo
//
//  Created by neon on 2017/3/21.
//  Copyright © 2017年 neon. All rights reserved.
//

#import "FlipOverViewController.h"
#import "FlipDemoCell.h"

#define UIColorFromRGB(rgbValue) ([UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0])
#define VIEWWIDTH [UIScreen mainScreen].bounds.size.width

@interface FlipOverViewController () <UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (nonatomic,strong) UICollectionView *flipView;
@property (nonatomic,strong) UICollectionViewFlowLayout *flipLayout;
@property (nonatomic) NSInteger currentPape;
@property (nonatomic) BOOL firstDisplay;
@end

static NSInteger VIEWCOUNT = 4;
//因为没有做适配，所以在5及5以下的话，可以把cellWidth/cellPadding两个参数改小看效果
static const CGFloat cellWidth = 280;
static const CGFloat cellPadding = 15;

@implementation FlipOverViewController
- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.currentPape = 0;
        self.firstDisplay = YES;
        
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.flipView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

#pragma mark collectionview delegate

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, (VIEWWIDTH-cellWidth)/2, 0, (VIEWWIDTH-cellWidth)/2);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return VIEWCOUNT;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    
    FlipDemoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = UIColorFromRGB(0x668800);
    cell.layer.transform = CATransform3DIdentity;
    cell.flipLabel.text = [NSString stringWithFormat:@"%zd",indexPath.row];
    
    CATransform3D transformChanges = CATransform3DIdentity;
    transformChanges.m34 = -1/500.0;
    transformChanges =CATransform3DTranslate(transformChanges, 0, 0, -50);
    
    cell.layer.transform = transformChanges;
    if (indexPath.row == 0 && self.firstDisplay) { //初始化
        cell.layer.transform = CATransform3DIdentity;
        self.firstDisplay = NO;
    }

    return cell;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset
{
    NSInteger page = (scrollView.contentOffset.x - cellWidth / 2) / (cellWidth + cellPadding) + 1;

    if (velocity.x > 0) {
        page++;
    }
    
    if (velocity.x < 0) {
        page--;
    }
    
    //避免越界
    page = MAX(page,0);
    page = MIN(page, VIEWCOUNT-1);
    
    //一次只滑动一页
    if (page>self.currentPape) {
        self.currentPape++;
    }else if(page<self.currentPape){
        self.currentPape --;
    }
    page = self.currentPape;
    CGFloat newOffset = page*(cellWidth+cellPadding);
    targetContentOffset->x = newOffset;
    
    
    CATransform3D transformChanges = CATransform3DIdentity;
    transformChanges.m34 = -1/500.0;
    transformChanges = CATransform3DTranslate(transformChanges, 0, 0, -50);
    
    UICollectionViewCell *centerCell = [self.flipView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page inSection:0]];
    UICollectionViewCell *leftCell = [self.flipView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page-1 inSection:0]];
    UICollectionViewCell *rightCell = [self.flipView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:page+1 inSection:0]];
    
    NSLog(@"page 是  %zd",page);

    //加上UIView的动画，可以避免滑动时变化不那么突兀
    [UIView animateWithDuration:0.3 animations:^{
        rightCell.layer.transform = transformChanges;
        leftCell.layer.transform = transformChanges;
        centerCell.layer.transform = CATransform3DIdentity;
    }];
}


#pragma mark getter&&setter

- (UICollectionView *)flipView {
    if (!_flipView) {
        _flipView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:self.flipLayout];
        _flipView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        [_flipView registerClass:[FlipDemoCell class] forCellWithReuseIdentifier:@"cell"];
        _flipView.delegate = self;
        _flipView.dataSource = self;
    }
    return _flipView;
}

- (UICollectionViewFlowLayout *)flipLayout {
    if (!_flipLayout) {
        _flipLayout = [[UICollectionViewFlowLayout alloc]init];
        _flipLayout.itemSize = CGSizeMake(cellWidth, 450);
        _flipLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flipLayout.minimumLineSpacing = cellPadding;
    }
    return _flipLayout;
}



@end
