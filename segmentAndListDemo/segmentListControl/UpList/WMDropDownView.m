//
//  WMDropDownView.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMDropDownView.h"
#import "WMMenuCell.h"

#define kCellH (34)

static Class _cellClass = nil;

@interface WMDropDownView () <UITableViewDataSource, UITableViewDelegate>
{
    UIButton *_baseBtn;
}

@property (nonatomic, copy) WMDropDownViewBlock block;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation WMDropDownView

+ (void)setCellClass:(Class)cellClass
{
    _cellClass = cellClass;
}

- (void)dealloc
{
    _tableView.delegate = nil;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_tableView) {
        _baseBtn.frame = self.bounds;

        NSInteger count = _titles.count;
        while (count * kCellH > self.frame.size.height) {
            count--;
        }
        CGFloat sH = count * kCellH;
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, sH);
    }
}

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)titles
       defaultIndex:(NSInteger)index
      selectedBlock:(WMDropDownViewBlock)block
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4];
        self.block = block;
        self.titles = titles;
        self.clipsToBounds = YES;

        _baseBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [_baseBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_baseBtn];

        _index = index;
        NSInteger count = _titles.count;
        while (count * kCellH > self.frame.size.height) {
            count--;
        }
        CGFloat sH = count * kCellH;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, -sH, self.frame.size.width, sH)];
        [self addSubview:_tableView];

        if (!_cellClass) {
            _cellClass = [WMMenuCell class];
        }
        [_tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
        _tableView.bounces = FALSE;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95];//
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
}

- (void)changeWithTitles:(NSArray *)titles
            defaultIndex:(NSInteger)index
           selectedBlock:(WMDropDownViewBlock)selectedHandle
{
    CGRect frame = _tableView.frame;
    frame.origin.y = -frame.size.height;
    [UIView animateWithDuration:0.2 animations:^{
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        self.block = selectedHandle;
        self.titles = titles;

        self.index = index;
        NSInteger count = self.titles.count;
        while (count * kCellH > self.frame.size.height) {
            count--;
        }
        CGFloat sH = count * kCellH;
        self.tableView.frame = CGRectMake(0, -sH, self.frame.size.width, sH);
        [self.tableView reloadData];

        [self showView];
    }];
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    WMMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass(_cellClass)];
    [cell setInfo:_titles[indexPath.row]];
    [cell setIsSelect:(_index == indexPath.row)];
    cell.tag = indexPath.row + 1000;
    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [_cellClass cellHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    NSArray *cells = [tableView visibleCells];
    for (WMMenuCell *cell in cells) {
        [cell setIsSelect:(cell.tag == indexPath.row + 1000)];
    }
    if (_index != indexPath.row && self.block) {
        _index = indexPath.row;
        self.block(_titles[indexPath.row], indexPath.row);
    }
    [self hideView];
}

#pragma mark -
- (void)showView
{
    CGRect frame = _tableView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {}];
}

- (void)hideView
{
    CGRect frame = _tableView.frame;
    frame.origin.y = -frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.tableView.frame = frame;
    } completion:^(BOOL finished) {
        if (self.block) {
            self.block(nil, -1);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end
