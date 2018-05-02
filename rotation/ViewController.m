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
@interface ViewController ()

@property(nonatomic,strong)UIButton * rotationBut;
@property(nonatomic,strong)UIImageView * imageView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    // Do any additional setup after loading the view, typically from a nib.
    self.rotationBut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.rotationBut.frame = CGRectMake(100, 100, 221/2, 320/2);
    self.rotationBut.backgroundColor = [UIColor yellowColor];
    [self.rotationBut addTarget:self action:@selector(butAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.rotationBut];

    ///图片
    self.imageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"albummenu_img_interaction"]];
    self.imageView.frame = CGRectMake(0, 0, self.rotationBut.frame.size.width, self.rotationBut.frame.size.height);
    [self.rotationBut addSubview:self.imageView];
    ///图片上的小图片 （算了懒得写）
//    UIImageView * minImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"albummenu_icon_interaction"]];
//    minImageView.frame = CGRectMake(0, 0, <#CGFloat width#>, <#CGFloat height#>)
    
    
}

-(void)butAction:(UIButton *)sender{
    
 
    sender.selected =! sender.selected;
    
    float f = ( kScreenHeight - kScreenWidth )/2;
    float w = ( kScreenWidth - kScreenHeight )/2;
    
    NSLog(@"%f",kScreenWidth);
    if (sender.selected) {
        [UIView animateWithDuration:0.3f animations:^{
            self.imageView.frame = CGRectMake(0, 0, kScreenHeight, kScreenWidth);
            self.rotationBut.frame = CGRectMake(w, f, kScreenHeight, kScreenWidth);
            [self.rotationBut setTransform:CGAffineTransformMakeRotation(M_PI_2)];
            
        } completion:^(BOOL finished) {
            //
            
        }];
    }else{
        [UIView animateWithDuration:0.3f animations:^{
            [self.rotationBut setTransform:CGAffineTransformMakeRotation(0)];
            self.imageView.frame = CGRectMake(0, 0, 221/2, 320/2);
            self.rotationBut.frame = CGRectMake(100, 100, 221/2, 320/2);
        } completion:^(BOOL finished) {
            //
            NSLog(@"%f , %f , %f , %f",self.rotationBut.frame.origin.x,self.rotationBut.frame.origin.y,self.rotationBut.frame.size.width,self.rotationBut.frame.size.height);
        }];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
