//
//  WMTabControl.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMTabControl.h"

@interface WMTabControlItem : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *titleIconView;
@property (nonatomic, strong) UIView *lineView;

- (void)setSelected:(BOOL)selected;
- (void)resetTitle:(NSString *)title;

@end

@implementation WMTabControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _titleLabel.font = [UIFont systemFontOfSize:kTextFont];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.text = title;
        _titleLabel.textColor = kTextColor;
        _titleLabel.backgroundColor = [UIColor clearColor];
        [_titleLabel sizeToFit];
        if (_titleLabel.frame.size.width > CGRectGetWidth(self.bounds) - kIconSpace - 10) {
            CGRect frame = _titleLabel.frame;
            frame.size.width = CGRectGetWidth(self.bounds) - kIconSpace - 10;
            _titleLabel.frame = frame;
        }
        _titleLabel.center = CGPointMake((CGRectGetWidth(self.bounds) - kIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);
        [self addSubview:_titleLabel];

        CGFloat x = CGRectGetMaxX(_titleLabel.frame) + kIconSpace;
        _titleIconView = [[UIImageView alloc] initWithFrame:CGRectMake(x, (CGRectGetHeight(self.bounds) - kIconH) * 0.5, kIconW, kIconH)];
        [_titleIconView setImage:kIconNomal];
        [self addSubview:_titleIconView];

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kVerticalLineSpace,
                                                             0.5, CGRectGetHeight(self.bounds) - kVerticalLineSpace * 2)];
        _lineView.backgroundColor = kHLineColor;
        [self addSubview:_lineView];
    }
    return self;
}

- (void)resetUI:(CGRect)frame
{
    self.frame = frame;

    _titleLabel.frame = self.bounds;
    [_titleLabel sizeToFit];
    if (_titleLabel.frame.size.width > CGRectGetWidth(self.bounds) - kIconSpace - 10) {
        CGRect frame = _titleLabel.frame;
        frame.size.width = CGRectGetWidth(self.bounds) - kIconSpace - 10;
        _titleLabel.frame = frame;
    }
    _titleLabel.center = CGPointMake((CGRectGetWidth(self.bounds) - kIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);

    CGFloat x = CGRectGetMaxX(_titleLabel.frame) + kIconSpace;
    _titleIconView.frame = CGRectMake(x, (CGRectGetHeight(self.bounds) - kIconH) * 0.5, kIconW, kIconH);

    _lineView.frame = CGRectMake(0, kVerticalLineSpace, 0.5, CGRectGetHeight(self.bounds) - kVerticalLineSpace * 2);
}

- (void)setSelected:(BOOL)selected
{
    [_titleLabel setTextColor:(selected ? kLineColor : kTextColor)];
    [_titleIconView setImage:(selected ? kIconSelect : kIconNomal)];
}

- (void)resetTitle:(NSString *)title
{
    _titleLabel.text = title;
    [_titleLabel sizeToFit];
    if (_titleLabel.frame.size.width > CGRectGetWidth(self.bounds) - kIconSpace - 10) {
        CGRect frame = _titleLabel.frame;
        frame.size.width = CGRectGetWidth(self.bounds) - kIconSpace - 10;
        _titleLabel.frame = frame;
    }
    _titleLabel.center = CGPointMake((CGRectGetWidth(self.bounds) - kIconSpace - 10) * 0.5, CGRectGetHeight(self.bounds) * 0.5);

    CGRect frame = _titleIconView.frame;
    frame.origin.x = CGRectGetMaxX(_titleLabel.frame) + kIconSpace;
    _titleIconView.frame = frame;
}

@end

@interface WMTabControl () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, copy) WMTabControlBlock block;

@end

@implementation WMTabControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_contentView) {
        _contentView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _contentView.frame = self.bounds;
        _bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kHorizontalLineH, CGRectGetWidth(self.bounds), kHorizontalLineH);

        CGFloat x = 0;
        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat width = self.frame.size.width / _itemFrames.count;

        for (int i = 0; i < _itemFrames.count; i++) {
            x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            CGRect rect = CGRectMake(x, 0, width, height);
            [_itemFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:rect]];
            if (i == _currentIndex) {
                _lineView.frame = CGRectMake(x + kHspace, height - kLineHeight - kHorizontalLineH, width - 2 * kHspace, kLineHeight);
            }
            WMTabControlItem *item = _itemViews[i];
            [item resetUI:rect];
        }

        [_contentView setContentSize:CGSizeMake(x + width, height)];
    }
}

- (void)initUI
{
    if (!_contentView) {
        [self layoutIfNeeded];
        _contentView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _contentView.backgroundColor = [UIColor clearColor];
        _contentView.delegate = self;
        _contentView.showsHorizontalScrollIndicator = NO;
        _contentView.scrollsToTop = NO;
        [self addSubview:_contentView];

        UITapGestureRecognizer *tapGes = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doTap:)];
        [_contentView addGestureRecognizer:tapGes];
        [tapGes requireGestureRecognizerToFail:_contentView.panGestureRecognizer];
        _lineView = [[UIView alloc] initWithFrame:CGRectZero];
        _lineView.backgroundColor = kLineColor;
        [_contentView addSubview:_lineView];

        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kHorizontalLineH, CGRectGetWidth(self.bounds), kHorizontalLineH)];
        _bottomLineView.backgroundColor = kHLineColor;
        [self addSubview:_bottomLineView];
    }
}

- (void)setItemsWithTitleArray:(NSArray *)titleArray selectedBlock:(WMTabControlBlock)selectedHandle
{
    if (titleArray.count <= 0) {
        return;
    }
    [self initUI];

    _block = selectedHandle;

    if (_itemViews.count > 0) {
        for (WMTabControlItem *item in _itemViews) {
            [item removeFromSuperview];
        }
    }
    _itemFrames = @[].mutableCopy;
    _itemViews = @[].mutableCopy;

    CGFloat x = 0;
    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = self.frame.size.width / titleArray.count;

    for (int i = 0; i < titleArray.count; i++) {
        x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
        CGRect rect = CGRectMake(x, 0, width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];

        NSString *title = titleArray[i];
        if ([title isKindOfClass:[NSDictionary class]] || [title isKindOfClass:[NSMutableDictionary class]]) {
            title = [titleArray[i] objectForKey:@"left"];
        }
        WMTabControlItem *item = [[WMTabControlItem alloc] initWithFrame:rect title:title];
        [_itemViews addObject:item];
        [_contentView addSubview:item];
        item.lineView.hidden = i > 0 ? FALSE : TRUE;
    }

    [_contentView setContentSize:CGSizeMake(x + width, CGRectGetHeight(self.bounds))];
    [self selectIndex:-1];
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    WMTabControlItem *curItem = [_itemViews objectAtIndex:index];
    [curItem resetTitle:title];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    currentIndex = MAX(0, MIN(currentIndex, _itemViews.count));

    if (currentIndex != _currentIndex) {
        WMTabControlItem *preItem = [_itemViews objectAtIndex:_currentIndex];
        WMTabControlItem *curItem = [_itemViews objectAtIndex:currentIndex];
        [preItem setSelected:NO];
        [curItem setSelected:YES];
        _currentIndex = currentIndex;
    }
}

- (void)selectIndex:(NSInteger)index
{
    if (index < 0) {
        _currentIndex = -1;
        _lineView.hidden = TRUE;
        for (WMTabControlItem *curItem in _itemViews) {
            [curItem setSelected:NO];
        }
    } else {
        _lineView.hidden = FALSE;

        if (index != _currentIndex) {
            WMTabControlItem *curItem = [_itemViews objectAtIndex:index];
            CGRect rect = [_itemFrames[index] CGRectValue];
            CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + kHspace, CGRectGetHeight(rect) - kLineHeight - kHorizontalLineH, CGRectGetWidth(rect) - 2 * kHspace, kLineHeight);
            if (_currentIndex < 0) {
                _lineView.frame = lineRect;
                [curItem setSelected:YES];
                _currentIndex = index;
            } else {
                [UIView animateWithDuration:kAnimationTime animations:^{
                    self.lineView.frame = lineRect;
                } completion:^(BOOL finished) {
                    [self.itemViews enumerateObjectsUsingBlock:^(WMTabControlItem *item, NSUInteger idx, BOOL *stop) {
                        [item setSelected:NO];
                    }];
                    [curItem setSelected:YES];
                    self.currentIndex = index;
                }];
            }
        }
    }
}

#pragma mark - private
- (void)doTap:(UITapGestureRecognizer *)sender
{
    CGPoint point = [sender locationInView:sender.view];

    __weak typeof(self) weakSelf = self;

    [_itemFrames enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        CGRect rect = [obj CGRectValue];

        if (CGRectContainsPoint(rect, point)) {
            [weakSelf selectIndex:idx];

            [weakSelf transformAction:idx];

            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index
{
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(WMTabControlDelegate)] && [self.delegate respondsToSelector:@selector(control:selectedIndex:)]) {
        [self.delegate control:self selectedIndex:index];
    } else if (self.block) {
        self.block(index);
    }
}

@end

