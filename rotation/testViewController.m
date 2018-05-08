//
//  testViewController.m
//  rotation
//
//  Created by 何泽的mac on 2018/5/2.
//  Copyright © 2018年 何泽的mac. All rights reserved.
//

#import "testViewController.h"
#import <UINavigationBar+Awesome.h>
#import "PhotoScrollView.h"
#import <Masonry.h>
#define kScreenWidth [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface testViewController ()

@end

@implementation testViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"互动相册";
    self.view.backgroundColor = [UIColor colorWithRed:248/255.0 green:208/255.0 blue:0 alpha:1];
    
    UIImageView * imageview = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zeze"]];
    imageview.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
    [self.view addSubview:imageview];
    
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back)];
    
    
    PhotoScrollView *loop = [[PhotoScrollView alloc] initWithFrame:CGRectMake(kScreenWidth, 64, kScreenWidth, kScreenHeight - 64 - 50)];
    [self.view addSubview:loop];
    loop.imageURLStrings = @[@"albumlist_download_img_card-bg_default", @"albumlist_download_img_card-bg_default",@"albumlist_download_img_card-bg_default"];
    loop.clickAction = ^(NSInteger index) {
        NSLog(@"curIndex: %ld", (long)index);
    };
    [UIView animateWithDuration:0.5 animations:^{
        loop.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight- 64 - 50);
    } completion:^(BOOL finished) {
        
    }];
    
    
}




-(void)back{

    if ([_delegate respondsToSelector:@selector(popAnimated:)]) {
        [_delegate popAnimated:self.index];
    }
    [self.navigationController popViewControllerAnimated:NO];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
//    [self.navigationController.navigationBar lt_setBackgroundColor:[UIColor colorWithRed:252/255.0 green:219/255.0 blue:0 alpha:1]];
//    self.navigationController.navigationBar.shadowImage = [self imageWithColor:[UIColor clearColor]];
    
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
//    [self.navigationController.navigationBar lt_reset];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
