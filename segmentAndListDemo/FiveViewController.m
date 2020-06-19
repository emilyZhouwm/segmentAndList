//
//  FiveViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/9/8.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "FiveViewController.h"
#import "WMTabControl.h"
#import "WMDropDown2View.h"

@interface FiveViewController ()
{
    NSMutableArray *_one;
    NSMutableArray *_two;
    NSMutableArray *_three;
    NSArray *_total;
    NSMutableArray *_totalIndex;
    NSMutableArray *_secondIndex;

    NSInteger _segIndex;
}

@property (weak, nonatomic) IBOutlet WMTabControl *tabControl;

@end

@implementation FiveViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _one = [NSMutableArray arrayWithObjects:@{@"left" : @"全部分类"},
            @{@"left" : @"美食", @"right" : @[@"所有美食", @"日韩", @"火锅", @"自助餐", @"川菜", @"上海菜", @"湖南菜", @"台湾", @"地方小吃"]},
            @{@"left" : @"休闲娱乐", @"right" : @[@"休闲娱乐", @"1", @"2", @"3", @"4"]},
            @{@"left" : @"电影", @"right" : @[@"所有电影", @"1", @"2", @"3", @"4"]},
            @{@"left" : @"酒店", @"right" : @[@"所有酒店", @"1", @"2", @"3", @"4"]},
            @{@"left" : @"旅游", @"right" : @[@"所有旅游", @"1", @"2", @"3", @"4"]},
            @{@"left" : @"生活服务", @"right" : @[@"所有生活", @"1", @"2", @"3", @"4"]},
            @{@"left" : @"购物", @"right" : @[@"所有购物", @"1", @"2", @"3", @"4"]}, nil];
    _two = [NSMutableArray arrayWithObjects:@{@"left" : @"全部城市"},
            @{@"left" : @"北京", @"right" : @[@"所有区域", @"朝阳", @"海淀", @"丰台", @"昌平", @"顺义", @"房乡", @"通州", @"石景山"]},
            @{@"left" : @"上海", @"right" : @[@"所有区域", @"上海1", @"上海2", @"上海3", @"上海4"]},
            @{@"left" : @"纽约", @"right" : @[@"所有区域", @"纽约1", @"纽约2", @"纽约3", @"纽约4"]},
            @{@"left" : @"洛杉矶", @"right" : @[@"所有区域", @"洛杉矶1", @"洛杉矶2", @"洛杉矶3", @"洛杉矶4"]},
            @{@"left" : @"华盛顿", @"right" : @[@"所有区域", @"华盛顿1", @"华盛顿2", @"华盛顿3", @"华盛顿4"]},
            @{@"left" : @"旧金山", @"right" : @[@"所有区域", @"旧金山1", @"旧金山2", @"旧金山3", @"旧金山4"]},
            @{@"left" : @"芝加哥", @"right" : @[@"所有区域", @"芝加哥1", @"芝加哥2", @"芝加哥3", @"芝加哥4"]}, nil];
    _three = [NSMutableArray arrayWithObjects:@"智能", @"距离最近", @"人气最高", @"最新开业", @"评价最好", @"评价最差", @"味道", @"服务", @"卫生", @"人均", nil];
    _total = @[_one, _two, _three];
    _totalIndex = [NSMutableArray arrayWithObjects:@0, @0, @0, nil];
    _secondIndex = [NSMutableArray arrayWithObjects:@0, @0, @0, nil];
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
    WMDropDown2View *listView = (WMDropDown2View *)[self.view viewWithTag:9898];
    if (listView) {
        CGFloat y = CGRectGetMaxY(_tabControl.frame);
        listView.frame = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);
    }
}

- (void)openList:(NSInteger)column
{
    WMDropDown2View *listView = (WMDropDown2View *)[self.view viewWithTag:9898];
    if (!listView) {
        // 显示
        _segIndex = column;
        NSArray *lists = (NSArray *)_total[column];

        CGFloat y = CGRectGetMaxY(_tabControl.frame);
        CGRect rect = CGRectMake(0, y, CGRectGetWidth(_tabControl.frame), CGRectGetHeight(self.view.frame) - y - 49);

        __weak typeof(self) weakSelf = self;
        WMDropDown2View *listView =
            [[WMDropDown2View alloc] initWithFrame:rect
                                            titles:lists
                                      defaultIndex:[_totalIndex[column] integerValue]
                                       secondIndex:[_secondIndex[column] integerValue]
                                     selectedBlock:^(NSInteger index, NSInteger secondIndex, NSString *title) {
            [weakSelf changeIndex:index secondIndex:secondIndex andTitle:title withColumn:column];
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
                       secondIndex:[_secondIndex[column] integerValue]
                     selectedBlock:^(NSInteger index, NSInteger secondIndex, NSString *title) {
            [weakSelf changeIndex:index secondIndex:secondIndex andTitle:title withColumn:column];
        }];
    } else {
        // 隐藏
        [listView hideView];
    }
}

- (void)changeIndex:(NSInteger)index secondIndex:(NSInteger)secondIndex andTitle:(NSString *)title withColumn:(NSInteger)column
{
    if (index == -1) {
        [_tabControl selectIndex:-1];
        return;
    }
    [_totalIndex replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:index]];
    [_secondIndex replaceObjectAtIndex:column withObject:[NSNumber numberWithInteger:secondIndex]];

    // 是否想改变标题
    [_tabControl setTitle:title withIndex:column];

    // 改变排序
    [self changeOrder];
}

- (void)changeOrder
{
}

@end
