//
//  ViewController.m
//  rotation
//
//  Created by 何泽的mac on 2018/5/2.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import "ViewController.h"
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height
///图片的宽
#define kWidth (kScreenWidth - 160)/4
///图片的高
#define kHeight (kScreenWidth - 160)/4 * 213 / 147

#define kY (kScreenHeight - kHeight)/2

#import <Masonry.h>
#import <UINavigationBar+Awesome.h>
#import "testViewController.h"
@interface ViewController ()<popDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
///背景图片数据
    NSArray * bgImageArray = @[@"albummenu_img_interaction",@"albummenu_img_static-bg_default",@"albummenu_img_video-bg_default",@"albummenu_img_share-bg_default"];
///背景图片上的小图片
    NSArray * minImageArray = @[@"albummenu_icon_interaction_default",@"albummenu_icon_static_default",@"albummenu_icon_video_default",@"albummenu_icon_share_default"];
    for (int i = 0; i < 4; i ++) {
        UIButton * rotationBut = [UIButton buttonWithType:UIButtonTypeCustom];
        rotationBut.frame = CGRectMake(50 + ((kWidth + 20) * i), kY, kWidth, kHeight);
        rotationBut.tag = 100 + i;
        [rotationBut setBackgroundImage:[UIImage imageNamed:bgImageArray[i]] forState:UIControlStateNormal];
        [rotationBut setImage:[UIImage imageNamed:minImageArray[i]] forState:UIControlStateNormal];
        [rotationBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rotationBut];
    }
    
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor clearColor]];
    self.navigationController.navigationBar.shadowImage = [self imageWithColor:[UIColor clearColor]];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar lt_reset];
}


-(void)butAction:(UIButton *)sender{
///将试图移动到最上层
    [self.view bringSubviewToFront:sender];
    sender.selected =! sender.selected;
    
    float h = ( kScreenHeight - kScreenWidth )/2;
    float w = ( kScreenWidth - kScreenHeight )/2;
    
    NSLog(@"%f",kScreenWidth);
        [UIView animateWithDuration:0.3f animations:^{
        
            sender.frame = CGRectMake(w, h, kScreenHeight, kScreenWidth);
            [sender setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            
        } completion:^(BOOL finished) {
            sender.frame = CGRectMake(w, h, kScreenHeight, kScreenWidth);
            testViewController * test = [[testViewController alloc]init];
            test.delegate = self;
            test.index = sender.tag;
            [self.navigationController pushViewController:test animated:NO];
        }];
}

-(void)popAnimated:(NSInteger)index{
    UIButton * sender = (UIButton *)[self.view viewWithTag:index];
    [UIView animateWithDuration:0.3f animations:^{
        [sender setTransform:CGAffineTransformMakeRotation(0)];
        sender.frame = CGRectMake(50 + ((kWidth + 20) * (sender.tag-100)), kY, kWidth, kHeight);
    } completion:^(BOOL finished) {
        //
        NSLog(@"%f , %f , %f , %f",sender.frame.origin.x,sender.frame.origin.y,sender.frame.size.width,sender.frame.size.height);
    }];
}

- (UIImage *)imageWithColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0, 0, 1, 1);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
