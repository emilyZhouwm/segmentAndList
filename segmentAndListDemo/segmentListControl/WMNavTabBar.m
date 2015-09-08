//
//  WMNavTabBar.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//  此系列都没有做高度适应，都假设定高

#import "WMNavTabBar.h"


#define kBarFont 14
#define kBarSpeace 10
#define kBarLine 2

#define kGreyColor [UIColor colorWithRed:120/255.0 green:120/255.0 blue:120/255.0 alpha:1.0]
#define kColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface WMNavTabBar () <UIScrollViewDelegate>
{
    UIView          *_line;
    NSMutableArray  *_itemsBtn;
    NSMutableArray  *_itemsWidth;
    
    UIImageView     *_shadeLeft;
    UIImageView     *_shadeRight;
    
    CGFloat         _barSpeace;
}
@property (strong, nonatomic) UIScrollView *tabBarScrollView;
@property (strong, nonatomic) UIScrollView *scrollView;

@end

@implementation WMNavTabBar
- (void)layoutSubviews
{
    [super layoutSubviews];
    if (_tabBarScrollView) {
        _tabBarScrollView.contentInset = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0);
        _tabBarScrollView.frame = self.bounds;
        
        _shadeLeft.frame = CGRectMake(0, 0, kShadeW, self.frame.size.height);
        _shadeRight.frame = CGRectMake(self.frame.size.width - kShadeW, 0, kShadeW, self.frame.size.height);
        
        if (_isSamp) {
            CGFloat buttonX = 0.0f;
            CGFloat buttonW = kScreen_Width / _itemsBtn.count;
            for (UIButton *btn in _itemsBtn) {
                btn.frame = CGRectMake(buttonX, 0, buttonW, self.frame.size.height);
                buttonX += buttonW;
            }
            UIButton *button = _itemsBtn[_currentItemIndex];
            CGFloat width = [_itemsWidth[_currentItemIndex] floatValue] - _barSpeace * 2;
            _line.frame = CGRectMake(button.center.x - width * 0.5, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
        }
    }
}

- (void)initUI
{
    if (!_tabBarScrollView) {
        _tabBarScrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
        _tabBarScrollView.delegate = self;
        _tabBarScrollView.showsHorizontalScrollIndicator = NO;
        [self addSubview:_tabBarScrollView];
        
        _line = [[UIView alloc] initWithFrame:CGRectZero];
        _line.backgroundColor = kLineColor;
        [_tabBarScrollView addSubview:_line];
        
        _shadeLeft = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kShadeW, self.frame.size.height)];
        [_shadeLeft setImage:kShadeLeft];
        [self addSubview:_shadeLeft];
        _shadeRight = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - kShadeW, 0, kShadeW, self.frame.size.height)];
        [_shadeRight setImage:kShadeRight];
        [self addSubview:_shadeRight];
    }
}

#pragma mark - Public Methods
- (void)setItemTitles:(NSArray *)itemTitles andScrollView:(UIScrollView *)scrollView
{
    if (itemTitles.count <= 0) return;
    [self initUI];
    
    _scrollView = scrollView;
    _scrollView.delegate = self;
 
    for (UIButton *btn in _itemsBtn) {
        [btn removeFromSuperview];
    }
    _itemsBtn = [@[] mutableCopy];
    _itemsWidth = [@[] mutableCopy];
    
    CGFloat buttonX = 0.0f;
    CGFloat buttonW = kScreen_Width / _itemsBtn.count;
    _barSpeace = _isSamp ? 0 : kBarSpeace;
    for (NSString *title in itemTitles) {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:kBarFont]}];
        NSNumber *width = [NSNumber numberWithFloat:size.width + _barSpeace * 2];
        [_itemsWidth addObject:width];
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(buttonX, 0, _isSamp ? buttonW : [width floatValue], self.frame.size.height);
        
        [button setTitle:title forState:UIControlStateNormal];
        
        [button.titleLabel setFont:[UIFont systemFontOfSize:kBarFont]];
        [button setTitleColor:kGreyColor forState:UIControlStateNormal];
        
        [button addTarget:self action:@selector(itemPressed:) forControlEvents:UIControlEventTouchUpInside];
        [_tabBarScrollView addSubview:button];
        [_itemsBtn addObject:button];
        
        buttonX += _isSamp ? buttonW : [width floatValue];
    }
    if (_isSamp) {
        _tabBarScrollView.contentSize = self.frame.size;
        _shadeRight.hidden = TRUE;
    } else {
        _tabBarScrollView.contentSize = CGSizeMake(buttonX, self.frame.size.height);
    }
    [_tabBarScrollView setContentOffset:CGPointMake(0.0f, 0.0f) animated:NO];
    
    _shadeLeft.hidden = TRUE;
    self.currentItemIndex = 0;
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    if (currentItemIndex > _itemsBtn.count - 1 || currentItemIndex < 0) return;
    _currentItemIndex = currentItemIndex;
   
    for (UIButton *btn in _itemsBtn) {
        [btn setTitleColor:kGreyColor forState:UIControlStateNormal];
    }
    UIButton *button = _itemsBtn[_currentItemIndex];
    [button setTitleColor:kLineColor forState:UIControlStateNormal];
   
    if (!_isSamp) {
        CGFloat offsetX = button.center.x - self.frame.size.width * 0.5f;
        if (offsetX < 0.0f) {
            offsetX = 0.0f;
        } else if (offsetX + self.frame.size.width > _tabBarScrollView.contentSize.width) {
            if (_tabBarScrollView.contentSize.width < self.frame.size.width) {
                offsetX = 0.0f;
            } else {
                offsetX = _tabBarScrollView.contentSize.width - self.frame.size.width;
            }
        }
        [_tabBarScrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:YES];
    }
    CGFloat width = [_itemsWidth[_currentItemIndex] floatValue] - _barSpeace * 2;
    _line.frame = CGRectMake(button.center.x - width * 0.5, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView == _tabBarScrollView) {
        if (!_isSamp) {
            _shadeLeft.hidden = scrollView.contentOffset.x == 0 ? YES : NO;
            _shadeRight.hidden = ((scrollView.contentOffset.x + self.frame.size.width) >= scrollView.contentSize.width) ? YES : NO;
        }
    } else if (scrollView == _scrollView) {
        [self setLinePosition:scrollView.contentOffset.x];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (scrollView == _scrollView) {
        self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (scrollView == _scrollView) {
        if (scrollView.contentOffset.x==0
            || scrollView.contentOffset.x+scrollView.frame.size.width==scrollView.contentSize.width) {
            self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        }
    }
}

#pragma mark - Private Methods
- (void)setLinePosition:(CGFloat)position
{
    for (UIButton *btn in _itemsBtn) {
        [btn setTitleColor:kGreyColor forState:UIControlStateNormal];
    }
    
    NSInteger index = position / self.frame.size.width;
    if (index < _currentItemIndex && index >= 0) {
        CGFloat tt = self.frame.size.width - (position - (index * self.frame.size.width));
        tt /= self.frame.size.width;
        
        UIColor *color = kColor(kRed * tt , kGreen * tt, kBlue * tt);
        
        UIButton *button = _itemsBtn[index];
        [button setTitleColor:color forState:UIControlStateNormal];
        
        UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));
        
        UIButton *button1 = _itemsBtn[index + 1];
        [button1 setTitleColor:color1 forState:UIControlStateNormal];
        
        CGFloat width = ([_itemsWidth[index] floatValue] * tt + [_itemsWidth[index + 1] floatValue] * (1-tt)) - _barSpeace * 2;
        CGFloat x = button1.center.x - width * 0.5 - button.frame.size.width * tt;
        
        CGFloat w = [_itemsWidth[index] floatValue] - _barSpeace * 2;
        if (x < button.center.x - w * 0.5) {
            x = button.center.x - w * 0.5;
        }
        
        _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
    } else {
        index = (position + self.frame.size.width - 1) / self.frame.size.width;
        if (index > _currentItemIndex && index < _itemsBtn.count) {
            CGFloat tt = (position + self.frame.size.width - 1) - (index * self.frame.size.width);
            tt /= self.frame.size.width;
            UIColor *color = kColor(kRed * tt, kGreen * tt, kBlue * tt);
            UIButton *button = _itemsBtn[index];
            [button setTitleColor:color forState:UIControlStateNormal];
            UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));
            UIButton *button1 = _itemsBtn[index - 1];
            [button1 setTitleColor:color1 forState:UIControlStateNormal];
            CGFloat width = ([_itemsWidth[index - 1] floatValue] * (1-tt) + [_itemsWidth[index] floatValue] * tt) - _barSpeace * 2;
            CGFloat x = button1.center.x - width * 0.5 + button1.frame.size.width * tt;
            
            CGFloat w = [_itemsWidth[index] floatValue] - _barSpeace * 2;
            if (x > button.center.x - w * 0.5) {
                x = button.center.x - w * 0.5;
            }
            
            _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - kBarLine, width, kBarLine);
        }
    }
}

- (void)itemPressed:(UIButton *)button
{
    BOOL isRepeat = FALSE;
    NSInteger index = [_itemsBtn indexOfObject:button];
    if (_scrollView) {
        CGFloat offset = index * _scrollView.frame.size.width;
        if (_scrollView.contentOffset.x == offset) {
            isRepeat = TRUE;
        } else {
            [_scrollView setContentOffset:CGPointMake(offset, 0.0f) animated:YES];
        }
    }
    [_navDelegate itemDidSelected:self withIndex:index isRepeat:isRepeat];
}

@end
