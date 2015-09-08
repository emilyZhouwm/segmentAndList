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

@interface SecondViewController () <UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet WMSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet WMIconSegmentControl *iconSegmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll1;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll2;

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    __weak typeof(self) weakSelf = self;
    [_segmentControl setItemsWithTitleArray:@[@"全部", @"区域", @"薪资"]
                              selectedBlock:^(NSInteger index) {
                                  [weakSelf scrollIndex:index];
                              }];
    NSArray *ary = @[[UIColor greenColor], [UIColor blueColor], [UIColor redColor]];
    for (int i=0; i<3; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll1.frame.size.height)];
        v.backgroundColor = ary[i];
        [_scroll1 addSubview:v];
    }
    _scroll1.contentSize = CGSizeMake(kScreen_Width * 3, 0);
    
    [_iconSegmentControl setItemsWithIconArray:@[@"", @"", @""]// 不填则显示默认图
                                  selectedBlock:^(NSInteger index) {
                                      [weakSelf scrollIndex2:index];
                                  }];
    for (int i=0; i<3; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll1.frame.size.height)];
        v.backgroundColor = ary[i];
        [_scroll2 addSubview:v];
    }
    _scroll2.contentSize = CGSizeMake(kScreen_Width * 3, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

- (void)scrollIndex:(NSInteger)index
{
    [_scroll1 setContentOffset:CGPointMake(_scroll1.frame.size.width * index, 0) animated:YES];
}

- (void)scrollIndex2:(NSInteger)index
{
    [_scroll2 setContentOffset:CGPointMake(_scroll2.frame.size.width * index, 0) animated:YES];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scrollView == _scroll1) {
        [_segmentControl moveIndexWithProgress:index];
    } else if (scrollView == _scroll2) {
        [_iconSegmentControl moveIndexWithProgress:index];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
    if (scrollView == _scroll1) {
        [_segmentControl selectIndex:index];
    } else if (scrollView == _scroll2) {
        [_iconSegmentControl selectIndex:index];
    }
}

@end
