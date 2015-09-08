//
//  FourViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "FourViewController.h"
#import "WMPickerControl.h"
#import "WMCustomMenuCell.h"
#import "WMTestBtn.h"
#import "FlatDatePicker.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface FourViewController () <FlatDatePickerDelegate>
{
    NSInteger _index;
    NSArray *_jobType;
}

@property (strong, nonatomic) WMTestBtn *pickerBtn;
@property (strong, nonatomic) WMTestBtn *dateBtn;
@property (strong, nonatomic) WMTestBtn *timeBtn;
@property (strong, nonatomic) WMTestBtn *moreBtn;
@property (strong, nonatomic) FlatDatePicker *flatDatePicker;

@end

@implementation FourViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _index = -1;
    _jobType = @[[DownMenuTitle title:@"广场" image:@"nav_tweet_all"],
                 [DownMenuTitle title:@"好友圈" image:@"nav_tweet_friend"],
                 [DownMenuTitle title:@"热门" image:@"nav_tweet_hot"],
                 [DownMenuTitle title:@"我的" image:@"nav_tweet_mine"]];
    
    self.pickerBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(100, 270, 100, 40)];
    [_pickerBtn addTarget:self action:@selector(pickerBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_pickerBtn];
    [_pickerBtn setTitle:@"点击" forState:UIControlStateNormal];
    
    self.dateBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(100, 100, 100, 40)];
    [_dateBtn addTarget:self action:@selector(pickerDateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_dateBtn];
    [_dateBtn setTitle:@"日期" forState:UIControlStateNormal];
    
    self.timeBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(100, 150, 100, 40)];
    [_timeBtn addTarget:self action:@selector(pickerTimeBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_timeBtn];
    [_timeBtn setTitle:@"时间" forState:UIControlStateNormal];
    
    self.moreBtn = [[WMTestBtn alloc] initWithFrame:CGRectMake(100, 200, 100, 40)];
    [_moreBtn addTarget:self action:@selector(pickerMoreBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:_moreBtn];
    [_moreBtn setTitle:@"更多" forState:UIControlStateNormal];
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

- (void)pickerBtnClick:(UIButton *)sender
{
    sender.selected = !sender.selected;//
    __weak typeof(self)weakSelf = self;
    [WMPickerControl setCellClass:[WMCustomMenuCell class]];// 使用自定义类型
    [WMPickerControl showWithTitle:@"选择工作类型"
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
    }
    else if (datePicker.datePickerMode == FlatDatePickerModeTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"HH:mm:ss"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        
        [_timeBtn setTitle:destDateString forState:UIControlStateNormal];
    }
    else if (datePicker.datePickerMode == FlatDatePickerModeDateAndTime) {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSString *destDateString = [dateFormatter stringFromDate:date];
        
        [_moreBtn setTitle:destDateString forState:UIControlStateNormal];
    }
}

@end
