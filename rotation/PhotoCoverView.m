//
//  PhotoCoverView.m
//  rotation
//
//  Created by 何泽的mac on 2018/5/7.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import "PhotoCoverView.h"
#import <Masonry.h>
@interface PhotoCoverView ()

///相册的封面
@property(nonatomic,strong)UIImageView * imageView;

@end

@implementation PhotoCoverView

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
        ///懒加载
        [self addSubview:self.imageView];
        [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).mas_offset(10);
            make.right.mas_equalTo(self.mas_right).mas_offset(-10);
            make.top.mas_equalTo(self.mas_top).mas_offset(10);
            make.bottom.mas_equalTo(self.mas_bottom).offset(-10);
        }];
        
    }
    return self;
}

///相册封面
-(UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        _imageView.image = [UIImage imageNamed:@"albumlist_download_img_cover_default"];
        _imageView.backgroundColor = [UIColor clearColor];
    }
    return _imageView;
}


@end
