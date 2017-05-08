//
//  WMSegmentControl.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMSegmentControl.h"

@interface WMSegmentControlItem : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)setSelected:(BOOL)selected;
- (void)resetTitle:(NSString *)title;

@end

@implementation WMSegmentControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kGroundSpace, 0, CGRectGetWidth(self.bounds) - 2 * kGroundSpace, CGRectGetHeight(self.bounds))];
            label.font = [UIFont systemFontOfSize:kTextFont];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title;
            label.textColor = kTextColor;
            label.backgroundColor = [UIColor clearColor];
            label;
        });

        [self addSubview:_titleLabel];

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(frame.origin.x, kLineSpace, kLineW, CGRectGetHeight(self.bounds) - kLineSpace * 2)];
        _lineView.backgroundColor = kLineColor;
        //[self addSubview:_lineView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected
{
    [_titleLabel setTextColor:(selected ? kTextSColor : kTextColor)];
}

- (void)resetTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)resetUI:(CGRect)rect
{
    self.frame = rect;

    _titleLabel.frame = CGRectMake(kGroundSpace, 0, CGRectGetWidth(self.bounds) - 2 * kGroundSpace, CGRectGetHeight(self.bounds));

    _lineView.frame = CGRectMake(self.frame.origin.x, kLineSpace, kLineW, CGRectGetHeight(self.bounds) - kLineSpace * 2);
}

@end

@interface WMSegmentControl () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *groundView;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic, strong) NSMutableArray *itemViews;

@property (nonatomic, assign) CGFloat groundH;
@property (nonatomic, assign) CGFloat groundY;

@property (nonatomic, copy) WMSegmentControlBlock block;

@property (nonatomic, assign) BOOL isNot;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation WMSegmentControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_contentView) {
        _contentView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _contentView.frame = self.bounds;

        _bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kBottomLineH, CGRectGetWidth(self.bounds), kBottomLineH);
        _upLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kUpLineH);

        _groundY = 0;
        _groundH = kGroundHeight;
        if (_groundH > 0.0f) {
            _groundY = CGRectGetHeight(self.bounds) - _groundH - kBottomLineH;
        } else {
            _groundH = self.bounds.size.height;
        }

        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat width = 0;
        if (_segmentType == WMSegmentAll) {
            width = self.frame.size.width / _itemFrames.count;
        } else if (_segmentType == WMSegmentWidth) {
            width = kSegmentDefultWidth;
        }
        CGFloat x = 0;

        for (int i = 0; i < _itemFrames.count; i++) {
            WMSegmentControlItem *item = _itemViews[i];

            if (_segmentType == WMSegmentSize) {
                NSString *title = item.titleLabel.text;
                CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTextFont]}];
                width = size.width + kSegmentDefultSpace * 2;
            }

            x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            CGRect rect = CGRectMake(x, 0, width, height);
            [_itemFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:rect]];

            [item resetUI:rect];

            if (i == _currentIndex) {
                CGRect tempRect = CGRectMake(x + kGroundSpace, _groundY, width - 2 * kGroundSpace, _groundH);
                _groundView.frame = tempRect;
            }
        }

        [_contentView setContentSize:CGSizeMake(x + width, height)];
        [self setScrollOffset:_currentIndex];
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

        _upLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kUpLineH)];
        _upLineView.backgroundColor = kLineColor;
        [self addSubview:_upLineView];

        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kBottomLineH, CGRectGetWidth(self.bounds), kBottomLineH)];
        _bottomLineView.backgroundColor = kLineColor;
        [self addSubview:_bottomLineView];

        _groundView = [[UIView alloc] initWithFrame:CGRectZero];
        _groundView.backgroundColor = kGroundColor;
        [_contentView addSubview:_groundView];
        //_groundView.layer.zPosition = -1;

        _groundY = 0;
        _groundH = kGroundHeight;
        if (_groundH > 0.0f) {
            _groundY = CGRectGetHeight(self.bounds) - _groundH - kBottomLineH;
        } else {
            _groundH = CGRectGetHeight(self.bounds);
        }
    }
}

- (void)setItemsWithTitleArray:(NSArray<NSString *> *)titleArray
                 andScrollView:(UIScrollView *)scrollView
                 selectedBlock:(WMSegmentControlBlock)block
{
    if (titleArray.count <= 0) {
        return;
    }
    [self initUI];

    _block = block;
    _scrollView = scrollView;
    _scrollView.delegate = self;

    if (_itemViews.count > 0) {
        for (WMSegmentControlItem *item in _itemViews) {
            [item removeFromSuperview];
        }
    }
    _itemFrames = @[].mutableCopy;
    _itemViews = @[].mutableCopy;

    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = 0;
    if (_segmentType == WMSegmentAll) {
        width = self.frame.size.width / titleArray.count;
    } else if (_segmentType == WMSegmentWidth) {
        width = kSegmentDefultWidth;
    }
    CGFloat x = 0;

    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];

        if (_segmentType == WMSegmentSize) {
            CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kTextFont]}];
            width = size.width + kSegmentDefultSpace * 2;
        }

        x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
        CGRect rect = CGRectMake(x, 0, width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];

        WMSegmentControlItem *item = [[WMSegmentControlItem alloc] initWithFrame:rect title:title];
        if (i == 0) {
            [item setSelected:YES];
            CGRect tempRect = CGRectMake(x + kGroundSpace, _groundY, width - 2 * kGroundSpace, _groundH);
            _groundView.frame = tempRect;
        }
        [_itemViews addObject:item];
        [_contentView addSubview:item];
        [_contentView insertSubview:item.lineView belowSubview:_groundView];
        item.lineView.hidden = i > 0 ? FALSE : TRUE;
    }

    [_contentView setContentSize:CGSizeMake(x + width, height)];

    _currentIndex = -1;
    [self selectIndex:0 check:YES];
}

- (void)selectIndex:(NSInteger)index check:(BOOL)isCheck
{
    if (index != _currentIndex) {
        if (_delegate) {
            [_delegate segmentControl:self selectedIndex:index isRepeat:FALSE];
        } else if (_block) {
            _block(index, FALSE);
        }
        WMSegmentControlItem *curItem = [_itemViews objectAtIndex:index];
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect tempRect = CGRectMake(CGRectGetMinX(rect) + kGroundSpace, _groundY, CGRectGetWidth(rect) - 2 * kGroundSpace, _groundH);

        if (CGRectEqualToRect(_groundView.frame, tempRect)) {
            [_itemViews enumerateObjectsUsingBlock:^(WMSegmentControlItem *item, NSUInteger idx, BOOL *stop) {
                [item setSelected:NO];
            }];
            [curItem setSelected:YES];
            _currentIndex = index;
        } else {
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.groundView.frame = tempRect;
            } completion:^(BOOL finished) {
                [self.itemViews enumerateObjectsUsingBlock:^(WMSegmentControlItem *item, NSUInteger idx, BOOL *stop) {
                    [item setSelected:NO];
                }];
                [curItem setSelected:YES];
                self.currentIndex = index;
            }];
        }
    } else if (isCheck) {
        if (_delegate) {
            [_delegate segmentControl:self selectedIndex:index isRepeat:TRUE];
        } else if (_block) {
            _block(index, TRUE);
        }
    }
    [self setScrollOffset:index];
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    WMSegmentControlItem *curItem = [_itemViews objectAtIndex:index];
    [curItem resetTitle:title];
}

- (void)moveIndexWithProgress:(float)progress
{
    progress = MAX(0, MIN(progress, _itemViews.count));

    CGFloat delta = progress - _currentIndex;

    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;

    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kGroundSpace, _groundY, CGRectGetWidth(origionRect) - 2 * kGroundSpace, _groundH);

    CGRect rect;

    if (delta > 0) {
        // 如果delta大于1的话，不能简单的用相邻item间距的乘法来计算距离
        if (delta > 1) {
            _currentIndex += floorf(delta);
            delta -= floorf(delta);
            origionRect = [_itemFrames[_currentIndex] CGRectValue];;
            origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kGroundSpace, _groundY, CGRectGetWidth(origionRect) - 2 * kGroundSpace, _groundH);
        }

        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }

        rect = [_itemFrames[_currentIndex + 1] CGRectValue];

        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + kGroundSpace, _groundY, CGRectGetWidth(rect) - 2 * kGroundSpace, _groundH);

        CGRect moveRect = CGRectZero;

        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) + delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _groundView.frame = moveRect;
    } else if (delta < 0) {
        if (_currentIndex == 0) {
            return;
        }
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        CGRect tempRect = CGRectMake(CGRectGetMinX(rect) + kGroundSpace, _groundY, CGRectGetWidth(rect) - 2 * kGroundSpace, _groundH);
        CGRect moveRect = CGRectZero;
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(tempRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(tempRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) - delta * (CGRectGetMidX(tempRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _groundView.frame = moveRect;
        if (delta < -1) {
            _currentIndex -= 1;
        }
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        if (!_isNot && !_isStop) {
            CGFloat index = scrollView.contentOffset.x / scrollView.frame.size.width;
            [self moveIndexWithProgress:index];
        }
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        NSInteger index = scrollView.contentOffset.x / scrollView.frame.size.width;
        [self selectIndex:index check:NO];
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        _isNot = FALSE;
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
            [weakSelf selectIndex:idx check:YES];

            [weakSelf transformAction:idx];

            *stop = YES;
        }
    }];
}

- (void)transformAction:(NSInteger)index
{
    _isNot = TRUE;
    [_scrollView setContentOffset:CGPointMake(_scrollView.frame.size.width * index, 0) animated:YES];
}

- (void)setScrollOffset:(NSInteger)index
{
    if (_contentView.contentSize.width <= [UIScreen mainScreen].bounds.size.width) {
        return;
    }

    CGRect rect = [_itemFrames[index] CGRectValue];

    CGFloat midX = CGRectGetMidX(rect);

    CGFloat offset = 0;

    CGFloat contentWidth = _contentView.contentSize.width;

    CGFloat halfWidth = CGRectGetWidth(self.bounds) / 2.0;

    if (midX < halfWidth) {
        offset = 0;
    } else if (midX > contentWidth - halfWidth) {
        offset = contentWidth - 2 * halfWidth;
    } else {
        offset = midX - halfWidth;
    }

    [UIView animateWithDuration:kAnimationTime animations:^{
        [self.contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

@end

