//
//  FirstViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/5/26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "FirstViewController.h"
#import "WMTabControl.h"
#import "WMDropDownView.h"

@interface FirstViewController ()
{
    NSMutableArray *_one;
    NSMutableArray *_two;
    NSMutableArray *_three;
    NSArray *_total;
    NSMutableArray *_totalIndex;

    NSInteger _segIndex;
}
@property (weak, nonatomic) IBOutlet WMTabControl *tabControl;

@end

@implementation FirstViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    _one = [NSMutableArray arrayWithObjects:@"全部", @"金", @"木", @"水", @"火", nil];
    _two = [NSMutableArray arrayWithObjects:@"区域", @"东", @"南", @"西", @"北", nil];
    _three = [NSMutableArray arrayWithObjects:@"薪资", @"10000", @"20000", @"30000", @"40000", @"110000", @"120000", @"130000", @"140000", nil];
    _total = @[_one, _two, _three];
    _totalIndex = [NSMutableArray arrayWithObjects:@0, @0, @0, nil];
    __weak typeof(self) weakSelf = self;
    [_tabControl setItemsWithTitleArray:@[_one[0], _two[0], _three[0]]
                          selectedBlock:^(NSInteger index) {
        [weakSelf openList:index];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    WMDropDownView *listView = (WMDropDownView *)[self.view viewWithTag:9898];
    if (listView) {
        CGFloat y = CGRectGetMaxY(_tabControl.frame);
        listView.frame = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);
    }
}

- (void)openList:(NSInteger)column
{
    WMDropDownView *listView = (WMDropDownView *)[self.view viewWithTag:9898];
    if (!listView) {
        // 显示
        _segIndex = column;
        NSArray *lists = (NSArray *)_total[column];

        CGFloat y = CGRectGetMaxY(_tabControl.frame);
        CGRect rect = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);

        __weak typeof(self) weakSelf = self;
        WMDropDownView *listView =
            [[WMDropDownView alloc] initWithFrame:rect
                                           titles:lists
                                     defaultIndex:[_totalIndex[column] integerValue]
                                    selectedBlock:^(id title, NSInteger index) {
            [weakSelf changeIndex:index withColumn:column];
        }];
        listView.tag = 9898;
        [self.view addSubview:listView];
        [listView showView];
    } else if (_segIndex != column) {
        // 另展示
        _segIndex = column;
        NSArray *lists = (NSArray *)_total[column];
        __weak typeof(self) weakSelf = self;
        [listView changeWithTitles:lists
                      defaultIndex:[_totalIndex[column] integerValue]
                     selectedBlock:^(id title, NSInteger index) {
            [weakSelf changeIndex:index withColumn:column];
        }];
    } else {
        // 隐藏
        [listView hideView];
    }
}

- (void)changeIndex:(NSInteger)index withColumn:(NSInteger)column
{
    if (index == -1) {
        [_tabControl selectIndex:-1];
        return;
    }
    [_totalIndex replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:index]];

    // 是否想改变标题
    [_tabControl setTitle:_total[column][index] withIndex:column];

    // 改变排序
    [self changeOrder];
}

- (void)changeOrder
{
}

@end
