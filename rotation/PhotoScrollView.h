//
//  PhotoScrollView.h
//  rotation
//
//  Created by 何泽的mac on 2018/5/3.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PhotoScrollView : UIView <UIScrollViewDelegate>

@property (nonatomic,copy)void(^clickAction)(NSInteger curIndex);

@property (nonatomic, copy) NSArray *imageURLStrings;

@end
