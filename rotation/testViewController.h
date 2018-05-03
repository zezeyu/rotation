//
//  testViewController.h
//  rotation
//
//  Created by 何泽的mac on 2018/5/2.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol popDelegate <NSObject>

//@optional

-(void)popAnimated:(NSInteger)index;

@end

@interface testViewController : UIViewController
@property(nonatomic,assign)NSInteger index;
@property(nonatomic,assign)id<popDelegate>delegate;

@end
