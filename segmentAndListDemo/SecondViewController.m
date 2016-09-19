//
//  SecondViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/5/26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "SecondViewController.h"
#import "WMSegmentControl.h"
#import "WMIconSegmentControl.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kRandomColor [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]

@interface SecondViewController ()
{
    NSMutableArray<UIView *> *_views1;
    NSMutableArray<UIView *> *_views2;
}

@property (weak, nonatomic) IBOutlet WMSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet WMIconSegmentControl *iconSegmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll1;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll2;

@end

@implementation SecondViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    {
        // 1.设置数据
        NSArray *titleAry = @[@"全部", @"区域", @"薪资", @"全部", @"区域", @"薪资"];
        _segmentControl.segmentType = WMSegmentWidth;
        [_segmentControl setItemsWithTitleArray:titleAry andScrollView:_scroll1 selectedBlock:^(NSInteger index, BOOL isRepeat) {
            NSLog(@"_segmentControl : %ld isRepeat : %d", (long)index, isRepeat);
        }];

        // 关联部分，测试用，不必联动可以没有_scroll1
        _views1 = @[].mutableCopy;
        for (int i = 0; i < titleAry.count; i++) {
            CGRect rect = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll1.frame.size.height);
            UIView *v = [[UIView alloc] initWithFrame:rect];
            v.backgroundColor = kRandomColor;
            [_views1 addObject:v];
            [_scroll1 addSubview:v];
        }
        _scroll1.contentSize = CGSizeMake(kScreen_Width * titleAry.count, 0);
    }

    {
        // 2.设置数据
        NSArray *iconAry = @[@"", @"", @"", @"", @"", @"", @"", @"", @""];// 不填则显示默认图
        [_iconSegmentControl setItemsWithIconArray:iconAry andScrollView:_scroll2 selectedBlock:^(NSInteger index, BOOL isRepeat) {
            NSLog(@"_iconSegmentControl : %ld isRepeat : %d", (long)index, isRepeat);
        }];

        // 关联部分，测试用，不必联动可以没有_scroll2
        _views2 = @[].mutableCopy;
        for (int i = 0; i < iconAry.count; i++) {
            CGRect rect = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll2.frame.size.height);
            UIView *v = [[UIView alloc] initWithFrame:rect];
            v.backgroundColor = kRandomColor;
            [_views2 addObject:v];
            [_scroll2 addSubview:v];
        }
        _scroll2.contentSize = CGSizeMake(kScreen_Width * iconAry.count, 0);
    }
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // 1.1 转屏时设置一下，不支持转屏可以没有这部分
    _segmentControl.isStop = TRUE;
    // 2.1 转屏时设置一下，不支持转屏可以没有这部分
    _iconSegmentControl.isStop = TRUE;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    // 关联部分，测试用
    for (int i = 0; i < _views1.count; i++) {
        UIView *v = _views1[i];
        v.frame = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll1.frame.size.height);
    }
    _scroll1.contentSize = CGSizeMake(kScreen_Width * _views1.count, 0);
    _scroll1.contentOffset = CGPointMake(_scroll1.frame.size.width * _segmentControl.currentIndex, 0);

    for (int i = 0; i < _views2.count; i++) {
        UIView *v = _views2[i];
        v.frame = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll2.frame.size.height);
    }
    _scroll2.contentSize = CGSizeMake(kScreen_Width * _views2.count, 0);
    _scroll2.contentOffset = CGPointMake(_scroll2.frame.size.width * _iconSegmentControl.currentIndex, 0);
    
    // 1.2 转屏完设置一下
    _segmentControl.isStop = FALSE;
    // 2.2 转屏完设置一下
    _iconSegmentControl.isStop = FALSE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
