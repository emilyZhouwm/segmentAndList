//
//  WMDropDown2View.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMDropDown2View.h"

#define kCellH (34)
#define kTextColor [UIColor colorWithRed:102/255.0 green:102/255.0 blue:102/255.0 alpha:1.0]
#define kLineColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]
#define kGreenColor [UIColor colorWithRed:0/255.0 green:198/255.0 blue:12/255.0 alpha:1.0]
#define kTextFont [UIFont systemFontOfSize:14]
#define kIconImage [UIImage imageNamed:@"tag_list_s"]
#define kIconW (18)
#define kIconH (18)
#define kIconSpace (15)

@interface WMDropDown2Cell : UITableViewCell

@property (nonatomic, strong) UIView *bottomLine;

+ (CGFloat)cellHeight;

@end

@implementation WMDropDown2Cell

+ (CGFloat)cellHeight
{
    return kCellH;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = kTextColor;
        self.textLabel.font = kTextFont;
        self.textLabel.textAlignment = NSTextAlignmentCenter;

        self.imageView.image = kIconImage;

        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellH - 0.6, self.frame.size.width, 0.6)];
        _bottomLine.backgroundColor = kLineColor;
        [self addSubview:_bottomLine];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _bottomLine.frame = CGRectMake(0, kCellH - 0.6, self.frame.size.width, 0.6);
    self.imageView.frame = CGRectMake(self.frame.size.width - kIconW - kIconSpace, (kCellH - kIconH) * 0.5, kIconW, kIconH);
    self.textLabel.frame = CGRectMake(kIconW + 2 * kIconSpace, 0, self.frame.size.width - 2 * (kIconW + 2 * kIconSpace), kCellH);
}

@end

@interface WMDropDownLeftCell : UITableViewCell

@property (nonatomic, strong) UIView *bottomLine;

+ (CGFloat)cellHeight;

@end

@implementation WMDropDownLeftCell

+ (CGFloat)cellHeight
{
    return kCellH;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = kTextColor;
        self.textLabel.font = kTextFont;
        self.textLabel.textAlignment = NSTextAlignmentCenter;

        _bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, kCellH - 0.6, self.frame.size.width, 0.6)];
        _bottomLine.backgroundColor = kLineColor;
        [self addSubview:_bottomLine];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    _bottomLine.frame = CGRectMake(0, kCellH - 0.6, self.frame.size.width, 0.6);
    self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, kCellH);
}

@end

@interface WMDropDownRightCell : UITableViewCell

+ (CGFloat)cellHeight;

@end

@implementation WMDropDownRightCell

+ (CGFloat)cellHeight
{
    return kCellH;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.textLabel.backgroundColor = [UIColor clearColor];
        self.textLabel.textColor = kGreenColor;
        self.textLabel.font = kTextFont;
        self.textLabel.textAlignment = NSTextAlignmentCenter;

        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];

    self.textLabel.frame = CGRectMake(0, 0, self.frame.size.width, kCellH);
}

@end

@interface WMDropDown2View () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, copy) WMDropDown2ViewBlock block;
@property (nonatomic, copy) NSArray *titles;

@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger secondIndex;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *baseView;
@property (nonatomic, strong) UIButton *baseBtn;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UITableView *rightTableView;
@property (nonatomic, strong) UITableView *leftTableView;

@end

@implementation WMDropDown2View

- (void)dealloc
{
    _tableView.delegate = nil;
    _rightTableView.delegate = nil;
    _leftTableView.delegate = nil;
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
        _baseView.frame = CGRectMake(0, 0, self.frame.size.width, sH);
        _tableView.frame = CGRectMake(0, 0, self.frame.size.width, sH);
        _leftTableView.frame = CGRectMake(0, 0, self.frame.size.width / 3, sH);
        _rightTableView.frame = CGRectMake(self.frame.size.width / 3, 0, self.frame.size.width / 3 * 2, sH);
        _lineView.frame = CGRectMake(self.frame.size.width / 3, 0, 0.5f, sH);
    }
}

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)titles
       defaultIndex:(NSInteger)index
        secondIndex:(NSInteger)secondIndex
      selectedBlock:(WMDropDown2ViewBlock)block
{
    self = [super initWithFrame:frame];
    if (self && titles.count > 0) {
        self.backgroundColor = [UIColor colorWithRed:0.4 green:0.4 blue:0.4 alpha:0.4];
        self.block = block;
        self.titles = titles;
        self.clipsToBounds = YES;

        _baseBtn = [[UIButton alloc] initWithFrame:self.bounds];
        [_baseBtn addTarget:self action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_baseBtn];

        _index = index;
        if (_index < 0 || _index >= _titles.count) {
            _index = 0;
        }
        _secondIndex = secondIndex;
        if (![titles[0] isKindOfClass:[NSString class]]) {
            NSArray *ary = [_titles[_index] objectForKey:@"right"];
            if (_secondIndex < 0 || _secondIndex >= ary.count) {
                _secondIndex = 0;
            }
        }

        NSInteger count = _titles.count;
        while (count * kCellH > self.frame.size.height) {
            count--;
        }
        CGFloat sH = count * kCellH;
        _baseView = [[UIView alloc] initWithFrame:CGRectMake(0, -sH, self.frame.size.width, sH)];
        _baseView.backgroundColor = [UIColor colorWithWhite:1.0f alpha:0.95];
        [self addSubview:_baseView];

        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, sH)];
        [_baseView addSubview:_tableView];
        [_tableView registerClass:[WMDropDown2Cell class] forCellReuseIdentifier:@"WMDropDown2Cell"];
        _tableView.bounces = FALSE;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.backgroundColor = [UIColor clearColor];//
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _leftTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width / 3, sH)];
        [_baseView addSubview:_leftTableView];
        [_leftTableView registerClass:[WMDropDownLeftCell class] forCellReuseIdentifier:@"WMDropDownLeftCell"];
        _leftTableView.bounces = FALSE;
        _leftTableView.delegate = self;
        _leftTableView.dataSource = self;
        _leftTableView.backgroundColor = [UIColor clearColor];//
        _leftTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _rightTableView = [[UITableView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3, 0, self.frame.size.width, sH)];
        [_baseView addSubview:_rightTableView];
        [_rightTableView registerClass:[WMDropDownRightCell class] forCellReuseIdentifier:@"WMDropDownRightCell"];
        _rightTableView.bounces = FALSE;
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.backgroundColor = [UIColor clearColor];//
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(self.frame.size.width / 3, 0, 0.5f, sH)];
        _lineView.backgroundColor = kLineColor;
        [_baseView addSubview:_lineView];

        _lineView.hidden = [titles[0] isKindOfClass:[NSString class]] ? YES : NO;
        _leftTableView.hidden = _lineView.hidden;
        _rightTableView.hidden = _lineView.hidden;
        _tableView.hidden = !_lineView.hidden;
    }
    return self;
}

- (void)changeWithTitles:(NSArray *)titles
            defaultIndex:(NSInteger)index
             secondIndex:(NSInteger)secondIndex
           selectedBlock:(WMDropDown2ViewBlock)block
{
    if (titles.count > 0 && _baseView) {
        CGRect frame = _baseView.frame;
        frame.origin.y = -frame.size.height;
        [UIView animateWithDuration:0.2 animations:^{
            self.baseView.frame = frame;
        } completion:^(BOOL finished) {
            self.block = block;
            self.titles = titles;

            self.index = index;
            if (self.index < 0 || self.index >= self.titles.count) {
                self.index = 0;
            }
            self.secondIndex = secondIndex;
            if (![titles[0] isKindOfClass:[NSString class]]) {
                NSArray *ary = [self.titles[self.index] objectForKey:@"right"];
                if (self.secondIndex < 0 || self.secondIndex >= ary.count) {
                    self.secondIndex = 0;
                }
            }

            NSInteger count = self.titles.count;
            while (count * kCellH > self.frame.size.height) {
                count--;
            }
            CGFloat sH = count * kCellH;
            self.baseView.frame = CGRectMake(0, -sH, self.frame.size.width, sH);
            self.tableView.frame = CGRectMake(0, 0, self.frame.size.width, sH);
            [self.tableView reloadData];
            self.leftTableView.frame = CGRectMake(0, 0, self.frame.size.width / 3, sH);
            [self.leftTableView reloadData];
            self.rightTableView.frame = CGRectMake(self.frame.size.width / 3, 0, self.frame.size.width / 3 * 2, sH);
            [self.rightTableView reloadData];
            self.lineView.frame = CGRectMake(self.frame.size.width / 3, 0, 0.5f, sH);

            self.lineView.hidden = [titles[0] isKindOfClass:[NSString class]] ? YES : NO;
            self.leftTableView.hidden = self.lineView.hidden;
            self.rightTableView.hidden = self.lineView.hidden;
            self.tableView.hidden = !self.lineView.hidden;
            [self showView];
        }];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (_titles.count > 0) {
        if (tableView == _tableView) {
            return [_titles[0] isKindOfClass:[NSString class]] ? _titles.count : 0;
        } else if (tableView == _leftTableView) {
            return [_titles[0] isKindOfClass:[NSString class]] ? 0 : _titles.count;
        } else if (tableView == _rightTableView) {
            if ([_titles[0] isKindOfClass:[NSString class]]) {
                return 0;
            } else if (_index >= 0 && _index < _titles.count) {
                NSArray *ary = [_titles[_index] objectForKey:@"right"];
                return ary.count;
            }
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (tableView == _tableView) {
        WMDropDown2Cell *dropCell = [tableView dequeueReusableCellWithIdentifier:@"WMDropDown2Cell"];
        dropCell.textLabel.text = _titles[indexPath.row];
        dropCell.imageView.hidden = (_index == indexPath.row ? FALSE : TRUE);
        dropCell.tag = indexPath.row + 1000;
        cell = dropCell;
    } else if (tableView == _leftTableView) {
        WMDropDownLeftCell *leftCell = [tableView dequeueReusableCellWithIdentifier:@"WMDropDownLeftCell"];
        leftCell.textLabel.text = [_titles[indexPath.row] objectForKey:@"left"];
        leftCell.textLabel.textColor = (_index == indexPath.row ? kGreenColor : kTextColor);
        leftCell.tag = indexPath.row + 1000;
        cell = leftCell;
    } else if (tableView == _rightTableView) {
        WMDropDownRightCell *rightCell = [tableView dequeueReusableCellWithIdentifier:@"WMDropDownRightCell"];
        if (_index >= 0 && _index < _titles.count) {
            NSArray *ary = [_titles[_index] objectForKey:@"right"];
            rightCell.textLabel.text = ary[indexPath.row];
        }
        //rightCell.textLabel.textColor = (_secondIndex == indexPath.row ? kTextColor : kGreenColor);
        rightCell.tag = indexPath.row + 1000;
        cell = rightCell;
    }

    return cell;
}

#pragma mark - UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == _tableView) {
        return [WMDropDown2Cell cellHeight];
    } else if (tableView == _leftTableView) {
        return [WMDropDownLeftCell cellHeight];
    } else if (tableView == _rightTableView) {
        return [WMDropDownRightCell cellHeight];
    }
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];

    if (tableView == _tableView) {
        NSArray *cells = [tableView visibleCells];
        for (WMDropDown2Cell *cell in cells) {
            cell.imageView.hidden = ((cell.tag == (indexPath.row + 1000)) ? FALSE : TRUE);
        }
        if (_index != indexPath.row) {
            _index = indexPath.row;
            if (self.block) {
                self.block(_index, 0, _titles[indexPath.row]);
            }
        }
        [self hideView];
    } else if (tableView == _leftTableView) {
        NSArray *cells = [tableView visibleCells];
        for (WMDropDownLeftCell *cell in cells) {
            cell.textLabel.textColor = ((cell.tag == (indexPath.row + 1000)) ? kGreenColor : kTextColor);
        }
        if (_index != indexPath.row) {
            _index = indexPath.row;
            _secondIndex = 0;
            [_rightTableView reloadData];
        }
        if (_index == 0) {// 第0个默认为全部
            if (self.block) {
                self.block(_index, 0, [_titles[_index] objectForKey:@"left"]);
            }
            [self hideView];
        }
    } else if (tableView == _rightTableView) {
        _secondIndex = indexPath.row;
        if (self.block) {
            if (_secondIndex == 0) {// 第0个默认为全部
                self.block(_index, _secondIndex, [_titles[_index] objectForKey:@"left"]);
            } else {
                self.block(_index, _secondIndex, [_titles[_index] objectForKey:@"right"][_secondIndex]);
            }
        }
        [self hideView];
    }
}

#pragma mark -
- (void)showView
{
    CGRect frame = _baseView.frame;
    frame.origin.y = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.frame = frame;
    } completion:^(BOOL finished) {}];
}

- (void)hideView
{
    CGRect frame = _baseView.frame;
    frame.origin.y = -frame.size.height;
    [UIView animateWithDuration:0.3 animations:^{
        self.baseView.frame = frame;
    } completion:^(BOOL finished) {
        if (self.block) {
            self.block(-1, -1, nil);
        }
        [UIView animateWithDuration:0.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

@end
