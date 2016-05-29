//
//  ViewController.m
//  ZJSegenment
//
//  Created by MAc on 16/5/28.
//  Copyright © 2016年 李赵杰. All rights reserved.
//

#import "ViewController.h"
#import "ZJSegementView.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     ZJSegementView * segen = [[ZJSegementView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width,50    )];
    segen.ItemWidth = 70;
    segen.titleArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11"];
    segen.titleColor = [UIColor blueColor];
    [self.view addSubview:segen];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
