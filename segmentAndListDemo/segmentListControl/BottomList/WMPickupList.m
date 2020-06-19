//
//  WMPickerControl.m
//
//  Created by zwm on 15/6/2.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMPickupList.h"
#import "WMMenuCell.h"
#import "WMMenuHead.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kScreen_Height [UIScreen mainScreen].bounds.size.height

static Class _cellClass = nil;
static Class _headClass = nil;

@interface WMPickupList () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, copy) WMPickupListBlock block;
@property (nonatomic, copy) NSArray *titles;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, assign) NSInteger index;

@end

@implementation WMPickupList
+ (void)setCellClass:(Class)cellClass
{
    _cellClass = cellClass;
}

+ (void)setHeadClass:(Class)headClass
{
    _headClass = headClass;
}

+ (void)showWithTitle:(NSString *)title
           WithTitles:(NSArray *)titles
         defaultIndex:(NSInteger)index
        selectedBlock:(WMPickupListBlock)block
{
    WMPickupList *picker = [[WMPickupList alloc] initWithTitle:title WithTitles:titles defaultIndex:index selectedBlock:block];
    [[[UIApplication sharedApplication].windows firstObject] addSubview:picker];
    [picker showView];
}

- (id)initWithTitle:(NSString *)title
         WithTitles:(NSArray *)titles
       defaultIndex:(NSInteger)index
      selectedBlock:(WMPickupListBlock)block
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.2];
        self.block = block;
        self.titles = titles;
        self.clipsToBounds = YES;

        UIButton *baseBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [baseBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:baseBtn];

        if (!_headClass) {
            _headClass = [WMMenuHead class];
        }
        if (!_cellClass) {
            _cellClass = [WMMenuCell class];
        }

        self.baseView = [[UIView alloc] initWithFrame:CGRectMake(0, kScreen_Height, kScreen_Width, [_headClass headHeight] + [_cellClass tableHeight])];
        _baseView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_baseView];

        [_baseView addSubview:[_headClass addHeadTo:self withTitle:title]];

        self.index = index;
        self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, [_headClass headHeight], kScreen_Width, [_cellClass tableHeight])];
        [_baseView addSubview:_tableView];

        [_tableView registerClass:_cellClass forCellReuseIdentifier:NSStringFromClass(_cellClass)];
        _tableView.bounces = FALSE;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return self;
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
    if (_index != indexPath.row) {
        _index = indexPath.row;
        if (self.block) {
            self.block(_titles[indexPath.row], indexPath.row);
        }
    }
    [self hideView];
}

- (void)showView
{
    CGRect frame = _baseView.frame;
    frame.origin.y -= frame.size.height;
    [UIView animateWithDuration:0.25 animations:^{
        self.baseView.frame = frame;
    } completion:^(BOOL finished) {}];
}

- (void)hideView
{
    CGRect frame = _baseView.frame;
    frame.origin.y += frame.size.height;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.baseView.frame = frame;
    } completion:^(BOOL finished) {
        if (self.block) {
            self.block(nil, -1);
        }
        [UIView animateWithDuration:0.15 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end
