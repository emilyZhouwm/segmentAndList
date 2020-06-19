//
//  FourViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "FourViewController.h"
#import "WMPickupList.h"
#import "WMCustomMenuCell.h"
#import "WMTestBtn.h"
#import "FlatDatePicker.h"
#import "WMMaskSegmentControl.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kRandomColor [UIColor colorWithRed:((float)arc4random_uniform(256) / 255.0) green:((float)arc4random_uniform(256) / 255.0) blue:((float)arc4random_uniform(256) / 255.0) alpha:1.0]

@interface FourViewController () <FlatDatePickerDelegate>
{
    NSInteger _index;
    NSArray<DownMenuTitle *> *_jobType;

    NSMutableArray<UIView *> *_views;
}

@property (strong, nonatomic) WMTestBtn *pickerBtn;
@property (strong, nonatomic) WMTestBtn *dateBtn;
@property (strong, nonatomic) WMTestBtn *timeBtn;
@property (strong, nonatomic) WMTestBtn *moreBtn;
@property (strong, nonatomic) FlatDatePicker *flatDatePicker;

@property (weak, nonatomic) IBOutlet WMMaskSegmentControl *segmentControl;
@property (weak, nonatomic) IBOutlet UIScrollView *scroll1;

@end

@implementation FourViewController

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    // 2.转屏时设置一下，不支持转屏可以没有这部分
    _segmentControl.isStop = TRUE;
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    for (int i = 0; i < _views.count; i++) {
        UIView *v = _views[i];
        v.frame = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll1.frame.size.height);
    }
    _scroll1.contentSize = CGSizeMake(kScreen_Width * _views.count, 0);
    _scroll1.contentOffset = CGPointMake(_scroll1.frame.size.width * _segmentControl.currentIndex, 0);
    
    // 3.转屏完设置一下
    _segmentControl.isStop = FALSE;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.

    // 1.设置数据
    NSArray *titleAry = @[@"全部", @"区域一", @"薪资二二", @"全部", @"区域一", @"薪资二二"];
    _segmentControl.segmentType = WMMaskSegmentSize;
    [_segmentControl setItemsWithTitleArray:titleAry andScrollView:_scroll1 selectedBlock:^(NSInteger index, BOOL isRepeat) {
        NSLog(@"_segmentControl : %ld isRepeat : %d", (long)index, isRepeat);
    }];

    // 关联部分，测试用，不必联动可以没有_scroll1
    _views = @[].mutableCopy;
    for (int i = 0; i < titleAry.count; i++) {
        CGRect rect = CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scroll1.frame.size.height);
        UIView *v = [[UIView alloc] initWithFrame:rect];
        v.backgroundColor = kRandomColor;
        [_views addObject:v];
        [_scroll1 addSubview:v];
    }
    _scroll1.contentSize = CGSizeMake(kScreen_Width * titleAry.count, 0);

    /// 其他
    _index = -1;
    _jobType = @[[DownMenuTitle title:@"广场" image:@"nav_tweet_all"],
                 [DownMenuTitle title:@"好友圈" image:@"nav_tweet_friend"],
                 [DownMenuTitle title:@"热门" image:@"nav_tweet_hot"],
                 [DownMenuTitle title:@"我的" image:@"nav_tweet_mine"]];

    self.pickerBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(200, 350, 100, 40)];
    [_pickerBtn addTarget:self action:@selector(pickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerBtn];
    [_pickerBtn setTitle:@"点击" forState:UIControlStateNormal];

    self.dateBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(60, 270, 100, 40)];
    [_dateBtn addTarget:self action:@selector(pickerDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateBtn];
    [_dateBtn setTitle:@"日期" forState:UIControlStateNormal];

    self.timeBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(200, 270, 100, 40)];
    [_timeBtn addTarget:self action:@selector(pickerTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];
    [_timeBtn setTitle:@"时间" forState:UIControlStateNormal];

    self.moreBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(60, 350, 100, 40)];
    [_moreBtn addTarget:self action:@selector(pickerMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreBtn];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)pickerBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;//
    __weak typeof(self) weakSelf = self;
    [WMPickupList setCellClass:[WMCustomMenuCell class]];// 使用自定义类型
    [WMPickupList showWithTitle:@"选择工作类型"
                     WithTitles:_jobType
                   defaultIndex:_index
                  selectedBlock:^(id title, NSInteger index) {
        [weakSelf changeTitle:title toIndex:index];
    }];
}

- (void)changeTitle:(DownMenuTitle *)title toIndex:(NSInteger)index
{
    if (index >= 0 && index < _jobType.count) {
        _index = index;
        [_pickerBtn setTitle:title.titleValue forState:UIControlStateNormal];
    }
    _pickerBtn.selected = FALSE;//
}

#pragma mark - datePicker
- (FlatDatePicker *)flatDatePicker
{
    if (!_flatDatePicker) {
        // 日期选择器
        _flatDatePicker = [[FlatDatePicker alloc] initWithParentView:self.view.window];
        _flatDatePicker.delegate = self;
        _flatDatePicker.title = @"设置时间";

        _flatDatePicker.maximumDate = [NSDate date];      // 最大今年
    }
    return _flatDatePicker;
}

- (void)pickerDateBtnClick:(UIButton *)sender
{
    _timeBtn.selected = FALSE;
    _moreBtn.selected = FALSE;
    sender.selected = !sender.selected;//
    self.flatDatePicker.datePickerMode = FlatDatePickerModeDate;
    _flatDatePicker.title = @"设置日期";
    sender.selected ? [_flatDatePicker show] : [_flatDatePicker dismiss];
}

- (void)pickerTimeBtnClick:(UIButton *)sender
{
    _dateBtn.selected = FALSE;
    _moreBtn.selected = FALSE;
    sender.selected = !sender.selected;//
    self.flatDatePicker.datePickerMode = FlatDatePickerModeTime;
    _flatDatePicker.title = @"设置时间";
    sender.selected ? [_flatDatePicker show] : [_flatDatePicker dismiss];
}

- (void)pickerMoreBtnClick:(UIButton *)sender
{
//    _dateBtn.selected = FALSE;
//    _timeBtn.selected = FALSE;
//    sender.selected = !sender.selected;//
//    self.flatDatePicker.datePickerMode = FlatDatePickerModeDateAndTime;
//    sender.selected ? [_flatDatePicker show] : [_flatDatePicker dismiss];
}

#pragma mark - FlatDatePickerDelegate
- (void)flatDatePicker:(FlatDatePicker *)datePicker dateDidChange:(NSDate *)date
{
}

- (void)flatDatePicker:(FlatDatePicker *)datePicker didCancel:(UIButton *)sender
{
    _dateBtn.selected = FALSE;
    _timeBtn.selected = FALSE;
    _moreBtn.selected = FALSE;
}

- (void)flatDatePicker:(FlatDatePicker *)datePicker didValid:(UIButton *)sender date:(NSDate *)date
{
    if (datePicker.datePickerMode == FlatDatePickerModeDate) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *destDateString = [dateFormatter stringFromDate:date];

        [_dateBtn setTitle:destDateString forState:UIControlStateNormal];
    } else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *destDateString = [dateFormatter stringFromDate:date];

        [_timeBtn setTitle:destDateString forState:UIControlStateNormal];
    } else if (datePicker.datePickerMode == FlatDatePickerModeDateAndTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *destDateString = [dateFormatter stringFromDate:date];

        [_moreBtn setTitle:destDateString forState:UIControlStateNormal];
    }
}

@end
