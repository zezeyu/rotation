//
//  PhotoScrollView.m
//  rotation
//
//  Created by 何泽的mac on 2018/5/3.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import "PhotoScrollView.h"
#import "PhotoCoverView.h"
#import <Masonry.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PhotoScrollView ()
@property (nonatomic, strong) UIScrollView *scrollView;
///左边的View
@property(nonatomic,strong)UIView *leftView;
///中间的View
@property(nonatomic,strong)UIView *middleView;
///右边的View
@property(nonatomic,strong)UIView *rightView;

///下面三个对应的view上的image
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSInteger curIndex;
///中间封面的底片
@property(nonatomic,strong)UIView * middlePhotographicFilmView;
///左边封面的底片
@property(nonatomic,strong)UIView * leftPhotographicFilmView;
///右边封面的底片
@property(nonatomic,strong)UIView * rightPhotographicFilmView;
///中间相册封面
@property(nonatomic, strong) PhotoCoverView * middleCoverView;
///左边相册封面
@property(nonatomic, strong) PhotoCoverView * leftCoverView;
///右边相册封面
@property(nonatomic, strong) PhotoCoverView * rightCoverView;
@end

@implementation PhotoScrollView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

#pragma mark - setupViews
- (void)setupViews {
    ///加载三个view
    [self.scrollView addSubview:self.leftView];
    [self.scrollView addSubview:self.middleView];
    [self.scrollView addSubview:self.rightView];
    ///加载三个view上的imageview
    [self.leftView addSubview:self.leftImageView];
    [self.middleView addSubview:self.middleImageView];
    [self.rightView addSubview:self.rightImageView];
    [self addSubview:self.scrollView];
    
    ///中间的相册底色
    [self.middleView addSubview:self.middlePhotographicFilmView];
    [self.middlePhotographicFilmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.middleImageView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.middleImageView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.middleImageView.mas_bottom).offset(-10);
        make.width.equalTo(self.middlePhotographicFilmView.mas_height);
    }];
    ///左边的相册底色
    [self.leftView addSubview:self.leftPhotographicFilmView];
    [self.leftPhotographicFilmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.leftImageView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.leftImageView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.leftImageView.mas_bottom).offset(-10);
        make.width.equalTo(self.leftPhotographicFilmView.mas_height);
    }];
    ///右边的相册底色
    [self.rightView addSubview:self.rightPhotographicFilmView];
    [self.rightPhotographicFilmView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.rightImageView.mas_left).mas_offset(10);
        make.top.mas_equalTo(self.rightImageView.mas_top).mas_offset(10);
        make.bottom.mas_equalTo(self.rightImageView.mas_bottom).offset(-10);
        make.width.equalTo(self.rightPhotographicFilmView.mas_height);
    }];
    ///中间的相册封面
    [self addSubview:self.middleCoverView];
    ///左边的相册封面
    [self addSubview:self.leftCoverView];
    ///右边的相册封面
    [self addSubview:self.rightCoverView];
    
    [self placeSubviews];
}

- (void)placeSubviews {
    self.scrollView.frame = self.bounds;
    //455.5   235
    CGFloat ViewWidth = CGRectGetWidth(self.scrollView.bounds);
    CGFloat ViewHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageWidth = imageHeight * 458.5 / 235;
    CGFloat imageX = (kScreenWidth-imageWidth)/2;
    
    self.leftView.frame    = CGRectMake(ViewWidth * 0, 0, ViewWidth, ViewHeight);
    self.middleView.frame  = CGRectMake(ViewWidth * 1, 0, ViewWidth, ViewHeight);
    self.rightView.frame   = CGRectMake(ViewWidth * 2, 0, ViewWidth, ViewHeight);
    
    self.leftImageView.frame    = CGRectMake((kScreenWidth - imageWidth/2) -imageX, imageHeight/4, imageWidth/2, imageHeight/2);
    self.middleImageView.frame  = CGRectMake(imageX, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageX, imageHeight/4, imageWidth/2, imageHeight/2);
    self.scrollView.contentSize = CGSizeMake(ViewWidth*3, 0);
    
    [self setScrollViewContentOffsetCenter];
}

#pragma mark - set scrollView contentOffset to center
- (void)setScrollViewContentOffsetCenter {
    self.scrollView.contentOffset = CGPointMake(CGRectGetWidth(self.scrollView.bounds), 0);
}

#pragma mark - kvo
- (void)addObservers {
    [self.scrollView addObserver:self forKeyPath:@"contentOffset" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)removeObservers {
    [self.scrollView removeObserver:self forKeyPath:@"contentOffset"];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"contentOffset"]) {
        [self caculateCurIndex];
    }
}
///懒加载scrollView
- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    return _scrollView;
}

///中间的封面
-(PhotoCoverView *)middleCoverView{
    if (!_middleCoverView) {
        _middleCoverView = [[PhotoCoverView alloc]init];
    }
    return _middleCoverView;
}
///左边的封面
-(PhotoCoverView *)leftCoverView{
    if (!_leftCoverView) {
        _leftCoverView = [[PhotoCoverView alloc]init];
    }
    return _leftCoverView;
}
///右边的封面
-(PhotoCoverView *)rightCoverView{
    if (!_rightCoverView) {
        _rightCoverView = [[PhotoCoverView alloc]init];
    }
    return _rightCoverView;
}

///中间相册底色
-(UIView *)middlePhotographicFilmView{
    if (!_middlePhotographicFilmView) {
        _middlePhotographicFilmView = [[UIView alloc]init];//0 194 129
        _middlePhotographicFilmView.backgroundColor = [UIColor colorWithRed:0/255.0 green:194/255.0 blue:129/255.0 alpha:1.0];
        _middlePhotographicFilmView.layer.cornerRadius = 14;
        _middlePhotographicFilmView.layer.masksToBounds = YES;
    }
    return _middlePhotographicFilmView;
}
///左边相册底色
-(UIView *)leftPhotographicFilmView{
    if (!_leftPhotographicFilmView) {
        _leftPhotographicFilmView = [[UIView alloc]init];
        _leftPhotographicFilmView.backgroundColor = [UIColor colorWithRed:0/255.0 green:194/255.0 blue:129/255.0 alpha:1.0];
        _leftPhotographicFilmView.layer.cornerRadius = 14;
        _leftPhotographicFilmView.layer.masksToBounds = YES;
    }
    return _leftPhotographicFilmView;
}
///右边相册底色
-(UIView *)rightPhotographicFilmView{
    if (!_rightPhotographicFilmView) {
        _rightPhotographicFilmView = [[UIView alloc]init];
        _rightPhotographicFilmView.backgroundColor = [UIColor colorWithRed:0/255.0 green:194/255.0 blue:129/255.0 alpha:1.0];
        _rightPhotographicFilmView.layer.cornerRadius = 14;
        _rightPhotographicFilmView.layer.masksToBounds = YES;
    }
    return _rightPhotographicFilmView;
}


-(UIView *)leftView{
    if (!_leftView) {
        _leftView = [UIView new];
    }
    return _leftView;
}
- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _leftImageView.backgroundColor = [UIColor yellowColor];
    }
    
    return _leftImageView;
}

-(UIView *)middleView{
    if (!_middleView) {
        _middleView = [UIView new];
    }
    return _middleView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
        [_middleImageView addGestureRecognizer:tap];
//        _middleImageView.backgroundColor = [UIColor redColor];
        _middleImageView.userInteractionEnabled = YES;
    }
    
    return _middleImageView;
}

-(UIView *)rightView{
    if (!_rightView) {
        _rightView = [UIView new];
    }
    return _rightView;
}

- (UIImageView *)rightImageView {
    if (!_rightImageView) {
        _rightImageView = [UIImageView new];
        _rightImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _rightImageView.backgroundColor = [UIColor greenColor];
    }
    
    return _rightImageView;
}


#pragma mark - setters
- (void)setImageURLStrings:(NSArray *)imageURLStrings {
    if (imageURLStrings) {
        _imageURLStrings = imageURLStrings;
        self.curIndex = 0;
        
        if (imageURLStrings.count > 1) {
            // auto scroll
        } else {
            [self.leftImageView removeFromSuperview];
            [self.rightImageView removeFromSuperview];
            self.scrollView.contentSize = CGSizeMake(CGRectGetWidth(self.scrollView.bounds), 0);
        }
    }
}

- (void)setCurIndex:(NSInteger)curIndex {
    if (_curIndex >= 0) {
        _curIndex = curIndex;
        
        // caculate index
        NSInteger imageCount = self.imageURLStrings.count;
        NSInteger leftIndex = (curIndex + imageCount - 1) % imageCount;
        NSInteger rightIndex= (curIndex + 1) % imageCount;
        
        // TODO: if need use image from server, can import SDWebImage SDK and modify the codes below.
        // fill image
        self.leftImageView.image = [UIImage imageNamed:self.imageURLStrings[leftIndex]];
        self.middleImageView.image = [UIImage imageNamed:self.imageURLStrings[curIndex]];
        self.rightImageView.image = [UIImage imageNamed:self.imageURLStrings[rightIndex]];
        
        // every scrolled, move current page to center
//        [self setScrollViewContentOffsetCenter];
    }
}

#pragma mark - caculate curIndex
- (void)caculateCurIndex {
    if (self.imageURLStrings && self.imageURLStrings.count > 0) {
        CGFloat pointX = self.scrollView.contentOffset.x;
        
        // judge critical value，first and third imageView's contentoffset
        CGFloat criticalValue = .2f;
        
        // scroll right, judge right critical value
        if (pointX > 2 * CGRectGetWidth(self.scrollView.bounds) - criticalValue) {
            self.curIndex = (self.curIndex + 1) % self.imageURLStrings.count;
        } else if (pointX < criticalValue) {
            // scroll left，judge left critical value
            self.curIndex = (self.curIndex + self.imageURLStrings.count - 1) % self.imageURLStrings.count;
        }
    }
}
#pragma mark - UIScrollViewDelegate
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.imageURLStrings.count > 1) {

    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (self.imageURLStrings.count > 1) {
        
    }
}
#pragma mark - button actions
- (void)imageClicked:(UITapGestureRecognizer *)tap {
    if (self.clickAction) {
        self.clickAction (self.curIndex);
    }
}
#pragma -- scrollView实时滑动代理方法
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    NSLog(@"%f",self.scrollView.contentOffset.x);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageWidth = imageHeight * 458.5 / 235;
    CGFloat imageX = (kScreenWidth-imageWidth)/2;
    CGFloat viewCenter = kScreenWidth;
    CGFloat rightH = scrollView.contentOffset.x - viewCenter;
    CGFloat Y = imageHeight/4;
    CGFloat RY = Y*rightH/viewCenter;
    CGFloat W = imageWidth/2;
    CGFloat RW = W * rightH/viewCenter;
//    CGFloat MX ;
    self.leftImageView.frame = CGRectMake((kScreenWidth - imageWidth/2) -imageX + RW, imageHeight/4 + RY, imageWidth/2 - RW, imageHeight/2 - RY *2);
    if (self.scrollView.contentOffset.x > kScreenWidth) {
        self.middleImageView.frame  = CGRectMake(imageX + RW, 0 + RY, imageWidth - RW, imageHeight - RY *2);
    }
    self.rightImageView.frame = CGRectMake(imageX, imageHeight/4 - RY, imageWidth/2 + RW, imageHeight/2+ RY *2);
}

#pragma -- 停止滑动代理方法
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    ///停止滑动调用方法
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageWidth = imageHeight * 458.5 / 235;
    CGFloat imageX = (kScreenWidth-imageWidth)/2;
    self.leftImageView.frame    = CGRectMake((kScreenWidth - imageWidth/2) -imageX, imageHeight/4, imageWidth/2, imageHeight/2);
    self.middleImageView.frame  = CGRectMake(imageX, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(imageX, imageHeight/4, imageWidth/2, imageHeight/2);
    if (scrollView.contentOffset.x < kScreenWidth) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    }
    if (scrollView.contentOffset.x == kScreenWidth*2 ) {
        [self.scrollView setContentOffset:CGPointMake(kScreenWidth, 0) animated:NO];
    }
}

@end
