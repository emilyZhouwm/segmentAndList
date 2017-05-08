//
//  WMIconSegmentControl.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMIconSegmentControl.h"

#define kControlHspace (0)
#define kLineHeight (2)
#define kAnimationTime (0.3)
#define kHorizontalLineH (1)

@interface WMIconSegControlItem : UIView

@property (nonatomic, strong) UIImageView *iconView;

- (void)setSelected:(BOOL)selected;

@end

@implementation WMIconSegControlItem

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.bounds) - kIconWidth) * 0.5,
                                                                  (CGRectGetHeight(self.bounds)- kIconHeight) * 0.5, kIconWidth, kIconHeight)];
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius = kIconWidth * 0.5;
        _iconView.layer.borderWidth = 0.5;
        _iconView.layer.borderColor = [UIColor whiteColor].CGColor;
        [self addSubview:_iconView];
    }
    return self;
}

- (void)resetUI:(CGRect)rect
{
    self.frame = rect;

    _iconView.frame = CGRectMake((CGRectGetWidth(self.bounds) - kIconWidth) * 0.5,
                                 (CGRectGetHeight(self.bounds)- kIconHeight) * 0.5, kIconWidth, kIconHeight);
}

- (void)setSelected:(BOOL)selected
{
    _iconView.layer.backgroundColor = selected ? nil : [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5].CGColor;
}

@end

@interface WMIconSegmentControl () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *lineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic, strong) NSMutableArray *itemViews;

@property (nonatomic, copy) WMIconSegmentControlBlock block;

@property (nonatomic, assign) BOOL isNot;
@property (nonatomic, assign) NSInteger currentIndex;
@end

@implementation WMIconSegmentControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_contentView) {
        _contentView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _contentView.frame = self.bounds;
        _bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kHorizontalLineH, CGRectGetWidth(self.bounds), kHorizontalLineH);

        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat x = 0;

        for (int i = 0; i < _itemFrames.count; i++) {
            x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            CGRect rect = CGRectMake(x, 0, kItemWidth, height);
            [_itemFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:rect]];

            WMIconSegControlItem *item = _itemViews[i];
            [item resetUI:rect];
            if (i == _currentIndex) {
                CGRect lineRect = CGRectMake(x + kControlHspace, height - kLineHeight - kHorizontalLineH, kItemWidth - 2 * kControlHspace, kLineHeight);
                _lineView.frame = lineRect;
            }
        }

        [_contentView setContentSize:CGSizeMake(x + kItemWidth, height)];
        [self setScrollOffset:_currentIndex];
    }
}

- (void)initUI
{
    if (!_contentView) {
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
        _lineView.backgroundColor = kIconLineColor;
        [_contentView addSubview:_lineView];

        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kHorizontalLineH, CGRectGetWidth(self.bounds), kHorizontalLineH)];
        _bottomLineView.backgroundColor = kHLineColor;
        [self addSubview:_bottomLineView];
    }
}

- (void)setItemsWithIconArray:(NSArray<NSString *> *)iconArray
                andScrollView:(UIScrollView *)scrollView
                selectedBlock:(WMIconSegmentControlBlock)block
{
    if (iconArray.count <= 0) {
        return;
    }
    [self initUI];

    _block = block;
    _scrollView = scrollView;
    _scrollView.delegate = self;

    if (_itemViews.count > 0) {
        for (WMIconSegControlItem *item in _itemViews) {
            [item removeFromSuperview];
        }
    }
    _itemFrames = @[].mutableCopy;
    _itemViews = @[].mutableCopy;

    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat x = 0;

    for (int i = 0; i < iconArray.count; i++) {
        x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
        CGRect rect = CGRectMake(x, 0, kItemWidth, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];

        NSString *iconPath = iconArray[i];
        WMIconSegControlItem *item = [[WMIconSegControlItem alloc] initWithFrame:rect];
        if (iconPath.length > 0) {
            if (_imgDelegate) {
                [_imgDelegate setWebImage:item.iconView imgUrl:iconPath];
            } else {
                [item.iconView setImage:[UIImage imageNamed:iconPath]];
            }
        } else {
            [item.iconView setImage:kIconDefault];
        }

        if (i == 0) {
            [item setSelected:YES];
            CGRect lineRect = CGRectMake(x + kControlHspace, height - kLineHeight - kHorizontalLineH, kItemWidth - 2 * kControlHspace, kLineHeight);
            _lineView.frame = lineRect;
        }
        [_itemViews addObject:item];
        [_contentView addSubview:item];
    }

    [_contentView setContentSize:CGSizeMake(x + kItemWidth, height)];
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
        WMIconSegControlItem *curItem = [_itemViews objectAtIndex:index];
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + kControlHspace, CGRectGetHeight(rect) - kLineHeight - kHorizontalLineH, CGRectGetWidth(rect) - 2 * kControlHspace, kLineHeight);

        if (CGRectEqualToRect(_lineView.frame, lineRect)) {
            [_itemViews enumerateObjectsUsingBlock:^(WMIconSegControlItem *item, NSUInteger idx, BOOL *stop) {
                [item setSelected:NO];
            }];
            [curItem setSelected:YES];
            self.currentIndex = index;
        } else {
            [UIView animateWithDuration:kAnimationTime animations:^{
                self.lineView.frame = lineRect;
            } completion:^(BOOL finished) {
                [self.itemViews enumerateObjectsUsingBlock:^(WMIconSegControlItem *item, NSUInteger idx, BOOL *stop) {
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

- (void)moveIndexWithProgress:(float)progress
{
    progress = MAX(0, MIN(progress, _itemViews.count));

    CGFloat delta = progress - _currentIndex;

    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;

    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kControlHspace, CGRectGetHeight(origionRect) - kLineHeight - kHorizontalLineH, CGRectGetWidth(origionRect) - 2 * kControlHspace, kLineHeight);

    CGRect rect;

    if (delta > 0) {
        // 如果delta大于1的话，不能简单的用相邻item间距的乘法来计算距离
        if (delta > 1) {
            _currentIndex += floorf(delta);
            delta -= floorf(delta);
            origionRect = [_itemFrames[_currentIndex] CGRectValue];;
            origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kControlHspace, CGRectGetHeight(origionRect) - kLineHeight - kHorizontalLineH, CGRectGetWidth(origionRect) - 2 * kControlHspace, kLineHeight);
        }

        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }

        rect = [_itemFrames[_currentIndex + 1] CGRectValue];

        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + kControlHspace, CGRectGetHeight(rect) - kLineHeight - kHorizontalLineH, CGRectGetWidth(rect) - 2 * kControlHspace, kLineHeight);

        CGRect moveRect = CGRectZero;

        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) + delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _lineView.frame = moveRect;
    } else if (delta < 0) {
        if (_currentIndex == 0) {
            return;
        }
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + kControlHspace, CGRectGetHeight(rect) - kLineHeight - kHorizontalLineH, CGRectGetWidth(rect) - 2 * kControlHspace, kLineHeight);
        CGRect moveRect = CGRectZero;
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) - delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));
        _lineView.frame = moveRect;
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

