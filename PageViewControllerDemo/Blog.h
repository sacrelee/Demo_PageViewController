//
//  BlogViewController.h
//  PageViewControllerDemo
//
//  Created by SACRELEE on 15/4/15.
//  Copyright (c) 2015年 Sumtice：http://sacrelee.me. All rights reserved.
//

/*
 
 最近使用UIPageViewController发现一个问题，由于每次翻页后需要重新计算数据数组。过快翻页时系统会打印一条调
 试信息：unbalanced calls to begin/end appearance transitions uipageviewcontroller，有时会出现空白页。打印这条log的原因上一个动画还没有结束就执行了下一个动画，同时会有一定几率触发空白页。
 解决这个问题只需要控制PageViewController的翻页速度。做法是返回上页或者下页后立即关闭用户交互，当动画完成时（这个动作的结果不一定是完成翻页）再恢复交互即可。
 代码实现
 
 此方法是返回前一个ViewController的方法，在return视图控制器之前关闭PageViewController的交互即可。返回后一个ViewController的方法与这个相同，这样就能保证一次只翻一页。
 -(UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController
 {
 _isRequestPrePage = YES;
 NSUInteger index = [self indexOfViewController:(DataViewController *)viewController];
 // index为0表示已经翻到最前页
 if (index == 0 || index == NSNotFound) {
 return  nil;
 }
 // 返回数据前关闭交互，确保只允许翻一页
 pageViewController.view.userInteractionEnabled = NO;
 index --;
 return [self dataViewControllerAtIndex:index];
 }
 
 
 此代理方法当操作PageViewController即触发，finished参数是当前动画是否结束的状态。这个finished仅表示动画完成与否，包括翻页和不翻页。当finished为YES的时候恢复交互就可以了。
 -(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray *)previousViewControllers transitionCompleted:(BOOL)completed
 {
 // 无论有无翻页，只要动画结束就恢复交互。
 if (finished){
 pageViewController.view.userInteractionEnabled = YES;
 }
 }
 
 PS：1.之前写过一篇关于PageViewController的文章（点这里），懒得改进去了。所以开了这篇。
 2.查看和下载Demo：
 3.Demo不止包括这一个问题，但有注释标记
 
 
 */
