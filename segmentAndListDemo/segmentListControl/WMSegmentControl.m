//
//  SegmentControl.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//  此系列都没有做高度适应，都假设定高

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

@end

@interface WMSegmentControl () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *contentView;
@property (nonatomic, strong) UIView *groundView;
@property (nonatomic, strong) UIView *upLineView;
@property (nonatomic, strong) UIView *bottomLineView;
@property (nonatomic, strong) NSMutableArray *itemFrames;
@property (nonatomic, strong) NSMutableArray *itemViews;

@property (nonatomic, copy) WMSegmentControlBlock block;

@property (nonatomic, assign) float groundH;
@property (nonatomic, assign) float groundY;

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

- (void)setItemsWithTitleArray:(NSArray *)titleArray selectedBlock:(WMSegmentControlBlock)selectedHandle
{
    self.block = selectedHandle;
    [self setItemsWithTitleArray:titleArray];
}

- (void)setItemsWithTitleArray:(NSArray *)titleArray
{
    [self initUI];
    if (_itemViews.count > 0) {
        for (WMSegmentControlItem *item in _itemViews) {
            [item removeFromSuperview];
        }
    }
    
    _itemFrames = @[].mutableCopy;
    _itemViews = @[].mutableCopy;
    float y = 0;
    float height = CGRectGetHeight(self.bounds);
    
    float screenW = [UIScreen mainScreen].bounds.size.width;

    for (int i = 0; i < titleArray.count; i++) {
        float x = i > 0 ? CGRectGetMaxX([_itemFrames[i-1] CGRectValue]) : 0;
        float width = screenW / titleArray.count;
        CGRect rect = CGRectMake(x, y, width, height);
        [_itemFrames addObject:[NSValue valueWithCGRect:rect]];
        
        NSString *title = titleArray[i];
        WMSegmentControlItem *item = [[WMSegmentControlItem alloc] initWithFrame:rect title:title];
        if (i == 0) {
            [item setSelected:YES];
            CGRect tempRect = CGRectMake(CGRectGetMinX(rect) + kGroundSpace, _groundY, CGRectGetWidth(rect) - 2 * kGroundSpace, _groundH);
            _groundView.frame = tempRect;
        }
        [_itemViews addObject:item];
        [_contentView addSubview:item];
        [_contentView insertSubview:item.lineView belowSubview:_groundView];
        item.lineView.hidden = i > 0 ? FALSE : TRUE;
    }
    
    [_contentView setContentSize:CGSizeMake(CGRectGetMaxX([[_itemFrames lastObject] CGRectValue]), CGRectGetHeight(self.bounds))];
    _currentIndex = -1;
    [self selectIndex:0];
}

- (void)setCurrentIndex:(NSInteger)currentIndex
{
    currentIndex = MAX(0, MIN(currentIndex, _itemViews.count));
    
    if (currentIndex != _currentIndex) {
        WMSegmentControlItem *preItem = [_itemViews objectAtIndex:_currentIndex];
        WMSegmentControlItem *curItem = [_itemViews objectAtIndex:currentIndex];
        [preItem setSelected:NO];
        [curItem setSelected:YES];
        _currentIndex = currentIndex;
    }
}

- (void)selectIndex:(NSInteger)index
{
    if (index != _currentIndex) {
        WMSegmentControlItem *curItem = [_itemViews objectAtIndex:index];
        CGRect rect = [_itemFrames[index] CGRectValue];
        CGRect tempRect = CGRectMake(CGRectGetMinX(rect) + kGroundSpace, _groundY, CGRectGetWidth(rect) - 2 * kGroundSpace, _groundH);

        [UIView animateWithDuration:kAnimationTime animations:^{
            _groundView.frame = tempRect;
        } completion:^(BOOL finished) {
            [_itemViews enumerateObjectsUsingBlock:^(WMSegmentControlItem *item, NSUInteger idx, BOOL *stop) {
                [item setSelected:NO];
            }];
            [curItem setSelected:YES];
            _currentIndex = index;
        }];
    }
}

- (void)setTitle:(NSString *)title withIndex:(NSInteger)index
{
    WMSegmentControlItem *curItem = [_itemViews objectAtIndex:index];
    [curItem resetTitle:title];
}

- (void)moveIndexWithProgress:(float)progress
{
    progress = MAX(0, MIN(progress, _itemViews.count));
    
    float delta = progress - _currentIndex;
    
    CGRect origionRect = [_itemFrames[_currentIndex] CGRectValue];;
    
    CGRect origionLineRect = CGRectMake(CGRectGetMinX(origionRect) + kGroundSpace, _groundY, CGRectGetWidth(origionRect) - 2 * kGroundSpace, _groundH);
    
    CGRect rect;
    
    if (delta > 0) {
        // 如果delta大于1的话，不能简单的用相邻item间距的乘法来计算距离
        if (delta > 1) {
            self.currentIndex += floorf(delta);
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
    } else if (delta < 0){
        
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
            self.currentIndex -= 1;
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
    if (self.delegate && [self.delegate conformsToProtocol:@protocol(WMSegmentControlDelegate)] && [self.delegate respondsToSelector:@selector(segmentControl:selectedIndex:)]) {
        
        [self.delegate segmentControl:self selectedIndex:index];
        
    } else if (self.block) {
        
        self.block(index);
    }
}

@end

