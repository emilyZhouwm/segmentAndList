//
//  ThreeViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/5/27.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "ThreeViewController.h"
#import "WMNavTabBar.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kRandomColor [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]

@interface ThreeViewController () <WMNavTabBarDelegate>
{
    NSMutableArray<UIView *> *_views1;
    NSMutableArray<UIView *> *_views2;
}

@property (weak, nonatomic) IBOutlet WMNavTabBar *navTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet WMNavTabBar *navTabBarSamp;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;

@end

@implementation ThreeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    {
        NSArray *titleAry = @[@"精选", @"优惠", @"海淘", @"精选", @"优惠", @"海淘", @"精选", @"优惠", @"海淘"];
        _navTabBar.delegate = self;
        _navTabBar.isFont = TRUE;
        [_navTabBar setItemTitles:titleAry andScrollView:_scrollView1 selectedBlock:nil];

        _views1 = @[].mutableCopy;
        for (int i = 0; i < titleAry.count; i++) {
            CGRect rect = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scrollView1.frame.size.height);
            UIView *v = [[UIView alloc] initWithFrame:rect];
            v.backgroundColor = kRandomColor;
            [_views1 addObject:v];
            [_scrollView1 addSubview:v];
        }
        _scrollView1.contentSize = CGSizeMake(kScreen_Width * titleAry.count, 0);
    }

    {
        NSArray *titleAry = @[@"精选", @"优惠", @"海淘"];
        _navTabBarSamp.isSamp = TRUE;// !!!选择平摊
        _navTabBarSamp.delegate = self;
        [_navTabBarSamp setItemTitles:titleAry andScrollView:_scrollView2 selectedBlock:nil];

        _views2 = @[].mutableCopy;
        for (int i = 0; i < 3; i++) {
            CGRect rect = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scrollView2.frame.size.height);
            UIView *v = [[UIView alloc] initWithFrame:rect];
            v.backgroundColor = kRandomColor;
            [_views2 addObject:v];
            [_scrollView2 addSubview:v];
        }
        _scrollView2.contentSize = CGSizeMake(kScreen_Width * titleAry.count, 0);
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _navTabBar.isStop = TRUE;
    _navTabBarSamp.isStop = TRUE;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    for (int i = 0; i < _views1.count; i++) {
        UIView *v = _views1[i];
        v.frame = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scrollView1.frame.size.height);
    }
    _scrollView1.contentSize = CGSizeMake(kScreen_Width * _views1.count, 0);
    _scrollView1.contentOffset = CGPointMake(_scrollView1.frame.size.width * _navTabBar.currentItemIndex, 0);
    _navTabBar.isStop = FALSE;

    for (int i = 0; i < _views2.count; i++) {
        UIView *v = _views2[i];
        v.frame = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scrollView2.frame.size.height);
    }
    _scrollView2.contentSize = CGSizeMake(kScreen_Width * _views2.count, 0);
    _scrollView2.contentOffset = CGPointMake(_scrollView2.frame.size.width * _navTabBarSamp.currentItemIndex, 0);
    _navTabBarSamp.isStop = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - WMNavTabBarDelegate
- (void)itemDidSelected:(WMNavTabBar *)tabBar withIndex:(NSInteger)index isRepeat:(BOOL)isRepeat
{
    if (tabBar == _navTabBarSamp) {
    } else if (tabBar == _navTabBar) {
    }
    if (isRepeat) {
        [self scrollHead:index];
    } else {
        [self loadData:index];
    }
}

- (void)scrollHead:(NSInteger)index
{
    // 回滚到头部
}

- (void)loadData:(NSInteger)index
{
    // 如果没加载数据则加载数据
}

@end
