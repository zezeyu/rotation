//
//  PhotoScrollView.m
//  rotation
//
//  Created by 何泽的mac on 2018/5/3.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import "PhotoScrollView.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface PhotoScrollView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIImageView *leftImageView;
@property (nonatomic, strong) UIImageView *middleImageView;
@property (nonatomic, strong) UIImageView *rightImageView;
@property (nonatomic, assign) NSInteger curIndex;
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
    [self.scrollView addSubview:self.leftImageView];
    [self.scrollView addSubview:self.middleImageView];
    [self.scrollView addSubview:self.rightImageView];
    [self addSubview:self.scrollView];
    
    [self placeSubviews];
}

- (void)placeSubviews {
    self.scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64 - 50);
    //455.5   235
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageWidth = imageHeight * 458.5 / 235;
    CGFloat imageX = (kScreenWidth-imageWidth)/2;
    self.leftImageView.frame    = CGRectMake(imageX , 0, imageWidth, imageHeight);
    self.middleImageView.frame  = CGRectMake(kScreenWidth - 10, 0, imageWidth, imageHeight);
    self.rightImageView.frame   = CGRectMake(self.middleImageView.frame.origin.x + imageWidth + imageX - 10, 0, imageWidth, imageHeight);
    self.scrollView.contentSize = CGSizeMake(imageWidth * 3 + imageX * 2 + (imageX-10)*2, 0);
    
    [self setScrollViewContentOffsetCenter];
}

#pragma mark - set scrollView contentOffset to center
- (void)setScrollViewContentOffsetCenter {
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageWidth = imageHeight * 458.5 / 235;
    CGFloat imageX = (kScreenWidth-imageWidth)/2;
    self.scrollView.contentOffset = CGPointMake(kScreenWidth - imageX, 0);
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [UIScrollView new];
        _scrollView.delegate = self;
        _scrollView.pagingEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
    }
    
    return _scrollView;
}

- (UIImageView *)leftImageView {
    if (!_leftImageView) {
        _leftImageView = [UIImageView new];
        _leftImageView.contentMode = UIViewContentModeScaleAspectFit;
//        _leftImageView.backgroundColor = [UIColor yellowColor];
    }
    
    return _leftImageView;
}

- (UIImageView *)middleImageView {
    if (!_middleImageView) {
        _middleImageView = [UIImageView new];
        _middleImageView.contentMode = UIViewContentModeScaleAspectFit;
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClicked:)];
//        [_middleImageView addGestureRecognizer:tap];
//        _middleImageView.backgroundColor = [UIColor redColor];
        _middleImageView.userInteractionEnabled = YES;
    }
    
    return _middleImageView;
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
        [self setScrollViewContentOffsetCenter];
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
//    NSLog(@"%f",self.scrollView.contentOffset.x);
    CGFloat imageHeight = CGRectGetHeight(self.scrollView.bounds);
    CGFloat imageWidth = imageHeight * 458.5 / 235;
    CGFloat imageX = (kScreenWidth-imageWidth)/2;
    
//    self.rightImageView.transform = CGAffineTransformMakeScale(1.0f, 1.0f);//将要显示的view按照正常比例显示出来
    
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self setScrollViewContentOffsetCenter];
}

@end
