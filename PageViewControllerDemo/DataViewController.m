//
//  DataViewController.m
//  PageViewControllerDemo
//
//  Created by SACRELEE on 15/4/12.
//  Copyright (c) 2015年 Sumtice：http://sacrelee.me. All rights reserved.
//

#import "DataViewController.h"

@interface DataViewController ()

@end

@implementation DataViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    CGFloat height = self.view.bounds.size.height;
    CGFloat width = self.view.bounds.size.width;
    self.view.backgroundColor = [UIColor grayColor];
    UIView *view = [[UIView alloc]init];
    view.backgroundColor = _backColor;
    view.frame = self.view.bounds;
    [self.view addSubview:view];
    
    UILabel *label = [[UILabel alloc]init];
    label.frame = CGRectMake( width - 200, height - 45, 200, 60);
    label.textAlignment = NSTextAlignmentRight;
    label.textColor = [UIColor whiteColor];
    label.text = [NSString stringWithFormat:@"第%@页",_index];
    [self.view addSubview:label];
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
