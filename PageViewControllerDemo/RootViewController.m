//
//  RootViewController.m
//  PageViewControllerDemo
//
//  Created by SACRELEE on 15/4/12.
//  Copyright (c) 2015年 Sumtice：http://sacrelee.me. All rights reserved.
//

#import "RootViewController.h"
#import "DataViewController.h"

@interface RootViewController ()<UIPageViewControllerDelegate,UIPageViewControllerDataSource>

@end

@implementation RootViewController
{
    NSMutableArray *_dataArray;
    UIPageViewController *_pageViewController;
    BOOL _isRequestPrePage;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self createData];
    [self createUI];
}

-(void)createData
{
    // 初始数据，只有前两页
    _dataArray = [[NSMutableArray alloc]init];
    [_dataArray addObject:@"1"];
    [_dataArray addObject:@"2"];
}

-(void)createUI
{
    NSDictionary *options = @{UIPageViewControllerOptionSpineLocationKey:[NSNumber numberWithInt:UIPageViewControllerSpineLocationMin]};
    _pageViewController  = [[UIPageViewController alloc]initWithTransitionStyle:UIPageViewControllerTransitionStylePageCurl navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:options];
    _pageViewController.dataSource = self;
    _pageViewController.delegate = self;
    DataViewController *dvc = [self dataViewControllerAtIndex:0];
    [_pageViewController setViewControllers:@[dvc] direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    [self addChildViewController:_pageViewController];
    [self.view addSubview:_pageViewController.view];
}

// 根据返回dataSource数组中对应的viewController
-(DataViewController *)dataViewControllerAtIndex:(NSUInteger)index
{
    DataViewController *dvc = [[DataViewController alloc]init];
    dvc.index = [_dataArray objectAtIndex:index];
    dvc.backColor = [UIColor colorWithRed:arc4random_uniform(100) / 100.f green:arc4random_uniform(100) / 100.f blue:arc4random_uniform(100) / 100.f alpha:1.0f];
    return dvc;
}

// 返回当前viewController数据在数组中所处位置
-(NSUInteger)indexOfViewController:(DataViewController *)dvc
{
    return [_dataArray indexOfObject:dvc.index];
}


#pragma mark - PageViewController Datasource
-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
{
    _isRequestPrePage = YES;
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    // index为0表示已经翻到最前页
    if (index == 0 || index == NSNotFound) {
        return  nil;
    }
    // 返回数据前关闭交互，确保只允许翻一页（有BUG 已作废，改进在代理方法中）
//    pageViewController.view.userInteractionEnabled = NO;
    index --;
    return [self dataViewControllerAtIndex:index];
}


-(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController
{
    _isRequestPrePage = NO;
    NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
    // index为数组最末表示已经翻至最后页
    if (index == NSNotFound || index == _dataArray.count - 1)
        return nil;
    
    // 返回数据前关闭交互，确保只允许翻一页（有BUG 已作废，改进在代理方法中）
//    pageViewController.view.userInteractionEnabled = NO;
    index ++;
    return [self dataViewControllerAtIndex:index];
}

#pragma - mark PageViewController Delegate
// 翻页控制的改进在此处。
-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray *)pendingViewControllers
{
    // 将要进行动画时才关闭交互，避免上下swipe手势引起永久性失去交互
//    [_pageViewController.view setUserInteractionEnabled:NO];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
{
    // 无论有无翻页，只要动画结束就恢复交互。
    if (finished){
        pageViewController.view.userInteractionEnabled = YES;
    }
    
    if (completed) {
       
        // 通过_isRequestPrePage来判断是翻到了上一页还是下一页，进一步做出对应计算。
        int currentIndex = _isRequestPrePage ? (int)[[_dataArray firstObject] integerValue]: (int)[[_dataArray lastObject] integerValue];
        [_dataArray removeAllObjects];
        for (int i = -1; i < 2; i ++) {
            if (currentIndex + i < 1 || currentIndex + i > 100)
                continue;
            [_dataArray addObject:[NSString stringWithFormat:@"%d",currentIndex + i]];
        }
    }
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
