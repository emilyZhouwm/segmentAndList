//
//  WMMaskSegmentControl.m
//
//  Created by zwm on 16/8/30.
//  Copyright © 2016年 zwm. All rights reserved.
//

#import "WMMaskSegmentControl.h"

@interface WMMaskSegmentControlItem : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *lineView;

- (void)resetTitle:(NSString *)title;

@end

@implementation WMMaskSegmentControlItem

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        _titleLabel = ({
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(self.bounds) - 2 * kMaskGroundSpace, CGRectGetHeight(self.bounds) - 2 * kMaskGroundSpaceH)];
            label.font = [UIFont systemFontOfSize:kMaskTextFont];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title;
            label.textColor = kMaskTextColor;
            label.backgroundColor = [UIColor clearColor];
            label;
        });

        [self addSubview:_titleLabel];

        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, kMaskLineSpace, kMaskLineW, CGRectGetHeight(self.bounds) - kMaskLineSpace * 2)];
        _lineView.backgroundColor = kMaskLineColor;
        [self addSubview:_lineView];
    }
    return self;
}

- (void)resetTitle:(NSString *)title
{
    _titleLabel.text = title;
}

- (void)resetUI:(CGRect)rect
{
    self.frame = rect;

    _titleLabel.frame = CGRectMake(kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(self.bounds) - 2 * kMaskGroundSpace, CGRectGetHeight(self.bounds) - 2 * kMaskGroundSpaceH);

    _lineView.frame = CGRectMake(0, kMaskLineSpace, kMaskLineW, CGRectGetHeight(self.bounds) - kMaskLineSpace * 2);
}

@end

@interface WMMaskSegmentControl () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic, strong) UIView *groundView;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic, strong) NSMutableArray *itemViews;
@property (nonatomic, strong) NSMutableArray *itemViews2;

@property (nonatomic, copy) WMMaskSegmentControlBlock block;

@property (nonatomic, assign) BOOL isNot;

@end

@implementation WMMaskSegmentControl

- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_contentView) {
        _contentView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _contentView.frame = self.bounds;

        _bottomLineView.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - kMaskBottomLineH, CGRectGetWidth(self.bounds), kMaskBottomLineH);
        _upLineView.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), kMaskUpLineH);

        CGFloat height = CGRectGetHeight(self.bounds);
        CGFloat width = 0;
        if (_segmentType == WMMaskSegmentAll) {
            width = self.frame.size.width / _itemFrames.count;
        } else if (_segmentType == WMMaskSegmentWidth) {
            width = kMaskDefultWidth;
        }
        CGFloat x = 0;

        for (int i = 0; i < _itemFrames.count; i++) {
            WMMaskSegmentControlItem *item = _itemViews[i];

            if (_segmentType == WMMaskSegmentSize) {
                NSString *title = item.titleLabel.text;
                CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMaskTextFont]}];
                width = size.width + kMaskDefultSpace * 2;
            }
            x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
            CGRect rect = CGRectMake(x, 0, width, height);
            [_itemFrames replaceObjectAtIndex:i withObject:[NSValue valueWithCGRect:rect]];

            WMMaskSegmentControlItem *item2 = _itemViews2[i];
            [item resetUI:rect];
            [item2 resetUI:rect];
            if (i == _currentIndex) {
                CGRect tempRect = CGRectMake(x + kMaskGroundSpace, kMaskGroundSpaceH, width - 2 * kMaskGroundSpace, height - 2 * kMaskGroundSpaceH);
                _groundView.layer.mask.frame = tempRect;
            }
        }

        [_contentView setContentSize:CGSizeMake(x + width, height)];
        _groundView.frame = CGRectMake(0, 0, x + width, height);
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

        _upLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), kMaskUpLineH)];
        _upLineView.backgroundColor = kMaskLineColor;
        [self addSubview:_upLineView];

        _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight(self.bounds) - kMaskBottomLineH, CGRectGetWidth(self.bounds), kMaskBottomLineH)];
        _bottomLineView.backgroundColor = kMaskLineColor;
        [self addSubview:_bottomLineView];

        _groundView = [[UIView alloc] initWithFrame:CGRectZero];
        _groundView.backgroundColor = kMaskGroundColor;
        CALayer *maskLayer = [CALayer layer];
        maskLayer.frame = CGRectZero;
        maskLayer.cornerRadius = kMaskGroundRadius;
        maskLayer.backgroundColor = kMaskGroundColor.CGColor;
        _groundView.layer.mask = maskLayer;
        [_contentView addSubview:_groundView];
    }
}

- (void)setItemsWithTitleArray:(NSArray<NSString *> *)titleArray
                 andScrollView:(UIScrollView *)scrollView
                 selectedBlock:(WMMaskSegmentControlBlock)block
{
    if (titleArray.count <= 0) {
        return;
    }
    [self initUI];

    _block = block;
    _scrollView = scrollView;
    _scrollView.delegate = self;

    if (_itemViews.count > 0) {
        for (WMMaskSegmentControlItem *item in _itemViews) {
            [item removeFromSuperview];
        }
        for (WMMaskSegmentControlItem *item in _itemViews2) {
            [item removeFromSuperview];
        }
    }
    _itemFrames = @[].mutableCopy;
    _itemViews = @[].mutableCopy;
    _itemViews2 = @[].mutableCopy;

    CGFloat height = CGRectGetHeight(self.bounds);
    CGFloat width = 0;
    if (_segmentType == WMMaskSegmentAll) {
        width = self.frame.size.width / titleArray.count;
    } else if (_segmentType == WMMaskSegmentWidth) {
        width = kMaskDefultWidth;
    }
    CGFloat x = 0;

    for (int i = 0; i < titleArray.count; i++) {
        NSString *title = titleArray[i];

        if (_segmentType == WMMaskSegmentSize) {
            CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kMaskTextFont]}];
            width = size.width + kMaskDefultSpace * 2;
        }

        x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
        CGRect rect = CGRectMake(x, 0, width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];

        WMMaskSegmentControlItem *item = [[WMMaskSegmentControlItem alloc] initWithFrame:rect title:title];
        WMMaskSegmentControlItem *item2 = [[WMMaskSegmentControlItem alloc] initWithFrame:rect title:title];
        item2.titleLabel.textColor = kMaskTextSColor;
        if (i == 0) {
            CGRect tempRect = CGRectMake(x + kMaskGroundSpace, kMaskGroundSpaceH, width - 2 * kMaskGroundSpace, height - 2 * kMaskGroundSpaceH);
            _groundView.layer.mask.frame = tempRect;
        }
        [_itemViews addObject:item];
        [_itemViews2 addObject:item2];
        [_contentView addSubview:item];
        [_groundView addSubview:item2];
        item.lineView.hidden = i > 0 ? FALSE : TRUE;
        item2.lineView.hidden = i > 0 ? FALSE : TRUE;
    }

    [_contentView setContentSize:CGSizeMake(x + width, height)];
    _groundView.frame = CGRectMake(0, 0, x + width, height);
    [_contentView bringSubviewToFront:_groundView];

    _currentIndex = -1;
    [self selectIndex:0 check:YES];
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    if (index >= 0 && index < _itemViews.count) {
        WMMaskSegmentControlItem *curItem = [_itemViews objectAtIndex:index];
        [curItem resetTitle:title];
    }
}

- (void)selectIndex:(NSInteger)index check:(BOOL)isCheck
{
    if (index != _currentIndex) {
        if (_delegate) {
            [_delegate segmentControl:self selectedIndex:index isRepeat:FALSE];
        } else if (_block) {
            _block(index, FALSE);
        }
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect tempRect = CGRectMake(CGRectGetMinX(rect) + kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(rect) - 2 * kMaskGroundSpace, CGRectGetHeight(rect)- 2 * kMaskGroundSpaceH);

        if (!CGRectEqualToRect(_groundView.layer.mask.frame, tempRect)) {
            _groundView.layer.mask.frame = tempRect;
        }
        _currentIndex = index;
    } else if (isCheck) {
        if (_delegate) {
            [_delegate segmentControl:self selectedIndex:index isRepeat:TRUE];
        } else if (_block) {
            _block(index, TRUE);
        }
    }
    [self setScrollOffset:index];
}

- (void)moveIndexWithProgress:(CGFloat)progress
{
    progress = MAX(0, MIN(progress, _itemViews.count));

    CGFloat delta = progress - _currentIndex;

    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;

    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(origionRect) - 2 * kMaskGroundSpace, CGRectGetHeight(origionRect)- 2 * kMaskGroundSpaceH);

    CGRect rect;

    if (delta > 0) {
        // 如果delta大于1的话，不能简单的用相邻item间距的乘法来计算距离
        if (delta > 1) {
            _currentIndex += floorf(delta);
            delta -= floorf(delta);
            origionRect = [_itemFrames[_currentIndex] CGRectValue];;
            origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(origionRect) - 2 * kMaskGroundSpace, CGRectGetHeight(origionRect)- 2 * kMaskGroundSpaceH);
        }

        if (_currentIndex == _itemFrames.count - 1) {
            return;
        }

        rect = [_itemFrames[_currentIndex + 1] CGRectValue];

        CGRect lineRect = CGRectMake(CGRectGetMinX(rect) + kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(rect) - 2 * kMaskGroundSpace, CGRectGetHeight(rect)- 2 * kMaskGroundSpaceH);

        CGRect moveRect = CGRectZero;

        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) + delta * (CGRectGetWidth(lineRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(lineRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) + delta * (CGRectGetMidX(lineRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));

        dispatch_async(dispatch_get_main_queue(), ^{
            self.groundView.layer.mask.frame = moveRect;
        });
    } else if (delta < 0) {
        if (_currentIndex == 0) {
            return;
        }
        rect = [_itemFrames[_currentIndex - 1] CGRectValue];
        CGRect tempRect = CGRectMake(CGRectGetMinX(rect) + kMaskGroundSpace, kMaskGroundSpaceH, CGRectGetWidth(rect) - 2 * kMaskGroundSpace, CGRectGetHeight(rect)- 2 * kMaskGroundSpaceH);
        CGRect moveRect = CGRectZero;
        moveRect.size = CGSizeMake(CGRectGetWidth(origionLineRect) - delta * (CGRectGetWidth(tempRect) - CGRectGetWidth(origionLineRect)), CGRectGetHeight(tempRect));
        moveRect.origin = CGPointMake(CGRectGetMidX(origionLineRect) - delta * (CGRectGetMidX(tempRect) - CGRectGetMidX(origionLineRect)) - CGRectGetMidX(moveRect), CGRectGetMidY(origionLineRect) - CGRectGetMidY(moveRect));

        dispatch_async(dispatch_get_main_queue(), ^{
            self.groundView.layer.mask.frame = moveRect;
        });

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
    if (_contentView.contentSize.width <= self.frame.size.width) {
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

    [UIView animateWithDuration:kMaskAnimationTime animations:^{
        [self.contentView setContentOffset:CGPointMake(offset, 0) animated:NO];
    }];
}

@end
