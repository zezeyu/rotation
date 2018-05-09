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
{
    NSArray * minImageArray;
    UIImageView *imageview;
    NSArray * bgImageArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
///背景图片数据
    bgImageArray = @[@"albummenu_img_interaction-bg_default",@"albummenu_img_static-bg_default",@"albummenu_img_video-bg_default",@"albummenu_img_share-bg_default"];
///背景图片上的小图片
    minImageArray = @[@"albummenu_icon_interaction_default",@"albummenu_icon_static_default",@"albummenu_icon_video_default",@"albummenu_icon_share_default"];
    for (int i = 0; i < 4; i ++) {
        UIButton * rotationBut = [UIButton buttonWithType:UIButtonTypeCustom];
        rotationBut.frame = CGRectMake(50 + ((kWidth + 20) * i), kY, kWidth, kHeight);
        rotationBut.tag = 100 + i;
        [rotationBut setBackgroundImage:[UIImage imageNamed:bgImageArray[i]] forState:UIControlStateNormal];
        [rotationBut setImage:[UIImage imageNamed:minImageArray[i]] forState:UIControlStateNormal];
        [rotationBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:rotationBut];
    }
    float h = ( kScreenHeight - kScreenWidth )/2;
    float w = ( kScreenWidth - kScreenHeight )/2;
///添加这个图片的原因是，pop回来时button执行旋转回来的方法时，实际尺寸，和button背景图片的尺寸不一致，有一个疑难杂症的bug！超奇葩，不知道怎么解决，这是我想到的避免这个问题的方法
    imageview = [[UIImageView alloc]initWithFrame:CGRectMake(w, h, kScreenHeight, kScreenWidth)];
    [imageview setTransform:CGAffineTransformMakeRotation(M_PI_2)];
    imageview.hidden = YES;
    [self.view addSubview:imageview];
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
    
//    [self.navigationController.navigationBar lt_reset];
}


-(void)butAction:(UIButton *)sender{
///将点击过后的view移动到最上层
    [self.view bringSubviewToFront:sender];
    ///计算一下改变后的坐标
    float h = ( kScreenHeight - kScreenWidth )/2;
    float w = ( kScreenWidth - kScreenHeight )/2;

    imageview.image = [UIImage imageNamed:bgImageArray[sender.tag-100]];
    ///点击的时候将按钮的image设置为空
    [sender setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.5f animations:^{
            ///修改坐标尺寸大小（改变frame的放大动画）
            sender.frame = CGRectMake(w, h, kScreenHeight, kScreenWidth);
            ///这个就是旋转动画了  M_PI_2(顺时针旋转90度)
            [sender setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            
        } completion:^(BOOL finished) {
            ///这两句是多加的，用来容错的！动画结束后确定下坐标值
            [sender setImage:[UIImage imageNamed:minImageArray[sender.tag-100]] forState:UIControlStateNormal];
            sender.frame = CGRectMake(w, h, kScreenHeight, kScreenWidth);
            ///当动画执行完毕后，push到下一个控制器
            testViewController * test = [[testViewController alloc]init];
            test.delegate = self;
            test.index = sender.tag;///将按钮tag值传递过去
            ///push方法的 animated设置为NO，这个很关键！！！（取消自带的push动画）
            [self.navigationController pushViewController:test animated:NO];
            
            ///将imageView放到最上面，为了pop回来的旋转回来的动画能够衔接
            [self.view bringSubviewToFront:imageview];
            ///每次旋转动画完毕后让imageView重新回到之前状态,等待回来时的旋转动画
            imageview.frame=CGRectMake(w, h, kScreenHeight, kScreenWidth);
            [imageview setTransform:CGAffineTransformMakeRotation(M_PI_2)];
        }];
}

-(void)popAnimated:(NSInteger)index{
    ///将iamgeView显示
    imageview.hidden = NO;
    UIButton * sender = (UIButton *)[self.view viewWithTag:index];
    ///pop回来先将button隐藏
    sender.hidden = YES;
    [UIView animateWithDuration:0.5f animations:^{
        ///imageView和Button一起完成回来时的旋转变小的动画，但我们只会看到imageView的
        [imageview setTransform:CGAffineTransformMakeRotation(0)];
        imageview.frame = CGRectMake(50 + ((kWidth + 20) * (sender.tag-100)), kY, kWidth, kHeight);
        [sender setTransform:CGAffineTransformMakeRotation(0)];
        sender.frame = CGRectMake(50 + ((kWidth + 20) * (sender.tag-100)), kY, kWidth, kHeight);
    } completion:^(BOOL finished) {
        ///动画执行完毕  将button显示，imageView隐藏
        sender.hidden = NO;
        imageview.hidden = YES;
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
