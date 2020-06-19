//
//  WMNavTabBar.m
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMNavTabBar.h"

#define kBarSpeace 10
#define kBarLine 3
#define kBarSampSpeace 5

// 焦点不在时的颜色
#define kGreyColor [UIColor colorWithRed:165/255.0 green:165/255.0 blue:165/255.0 alpha:1.0]

#ifndef kColor
#define kColor(r, g, b) [UIColor colorWithRed: (r)/255.0 green: (g)/255.0 blue: (b)/255.0 alpha: 1.0]
#endif

@interface WMNavTabBar () <UIScrollViewDelegate>
{
    UIView *_line;
    NSMutableArray *_itemsBtn;
    NSMutableArray *_itemsWidth;

    UIImageView *_shadeLeft;
    UIImageView *_shadeRight;

    CGFloat _barSpeace;
}

@property (strong, nonatomic) UIScrollView *tabBarScrollView;
@property (strong, nonatomic) UIScrollView *scrollView;
@property (nonatomic, copy) WMNavTabBarBlock block;

@property (nonatomic, assign) CGFloat barFont;
@property (nonatomic, assign) CGFloat barFontScale;
@property (nonatomic, assign) CGFloat BarLineH;
@property (nonatomic, strong) UIColor *LineColor;

@end

@implementation WMNavTabBar

- (instancetype)init
{
    if (self = [super init]) {
        [self commonInit];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    _barFont = kBarFont;
    _barFontScale = kBarFontScale;
    _BarLineH = kBarLine;
    _LineColor = kLineColor;
}

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
            CGFloat buttonW = self.frame.size.width / _itemsBtn.count;
            for (UIButton *btn in _itemsBtn) {
                btn.frame = CGRectMake(buttonX, 0, buttonW, self.frame.size.height);
                buttonX += buttonW;
            }
            UIButton *button = _itemsBtn[_currentItemIndex];
            CGFloat width = [_itemsWidth[_currentItemIndex] floatValue] - _barSpeace * 2;
            _line.frame = CGRectMake(button.center.x - width * 0.5, _tabBarScrollView.frame.size.height - _BarLineH, width, _BarLineH);
        } else {
            UIButton *button = _itemsBtn[_currentItemIndex];
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
            [_tabBarScrollView setContentOffset:CGPointMake(offsetX, 0.0f) animated:NO];
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
        _line.backgroundColor = _LineColor;
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
- (void)setItemTitles:(NSArray *)itemTitles
        andScrollView:(UIScrollView *)scrollView
        selectedBlock:(WMNavTabBarBlock)block
{
    if (itemTitles.count <= 0) {
        return;
    }
    [self initUI];

    _block = block;
    _scrollView = scrollView;
    _scrollView.delegate = self;

    for (UIButton *btn in _itemsBtn) {
        [btn removeFromSuperview];
    }
    _itemsBtn = [@[] mutableCopy];
    _itemsWidth = [@[] mutableCopy];

    CGFloat buttonX = 0.0f;
    CGFloat buttonW = self.frame.size.width / _itemsBtn.count;
    _barSpeace = _isSamp ? 0 : kBarSpeace;
    CGFloat barSampSpeace = _isSamp ? kBarSampSpeace * 2 : 0;
    for (NSString *title in itemTitles) {
        CGSize size = [title sizeWithAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:_barFont]}];
        NSNumber *width = [NSNumber numberWithFloat:size.width + _barSpeace * 2 + barSampSpeace];
        [_itemsWidth addObject:width];

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(buttonX, 0, _isSamp ? buttonW : [width floatValue], self.frame.size.height);
        [button setTitle:title forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont boldSystemFontOfSize:_barFont]];
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
    _currentItemIndex = -1;
    self.currentItemIndex = 0;
}

- (void)setCurrentItemIndex:(NSInteger)currentItemIndex
{
    if (currentItemIndex > _itemsBtn.count - 1 || currentItemIndex < 0) return;
    if (currentItemIndex != _currentItemIndex) {
        if (_delegate) {
            [_delegate itemDidSelected:self withIndex:currentItemIndex isRepeat:FALSE];
        } else if (_block) {
            _block(currentItemIndex, FALSE);
        }
    }
    _currentItemIndex = currentItemIndex;

    NSInteger i = 0;
    for (UIButton *btn in _itemsBtn) {
        [btn setTitleColor:kGreyColor forState:UIControlStateNormal];
        if (_isFont && i != _currentItemIndex) {
            btn.transform = CGAffineTransformMakeScale(_barFontScale, _barFontScale);
        }
        i++;
    }
    UIButton *button = _itemsBtn[_currentItemIndex];
    [button setTitleColor:kCurrentColor forState:UIControlStateNormal];
    if (_isFont) {
        button.transform = CGAffineTransformIdentity;
    }
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
    _line.frame = CGRectMake(button.center.x - width * 0.5, _tabBarScrollView.frame.size.height - _BarLineH, width, _BarLineH);
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
        if (!_isStop) {
            [self setLinePosition:_tabBarScrollView.frame.size.width * scrollView.contentOffset.x / _scrollView.frame.size.width];
        }
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
        if (scrollView.contentOffset.x == 0
            || scrollView.contentOffset.x+scrollView.frame.size.width == scrollView.contentSize.width) {
            self.currentItemIndex = scrollView.contentOffset.x / scrollView.frame.size.width;
        }
    }
}

#pragma mark - Private Methods
- (void)setLinePosition:(CGFloat)position
{
    //for (UIButton *btn in _itemsBtn) {
    //[btn setTitleColor:kGreyColor forState:UIControlStateNormal];
    //}

    NSInteger index = position / self.frame.size.width;
    if (index < _currentItemIndex && index >= 0) {
        CGFloat tt = self.frame.size.width - (position - (index * self.frame.size.width));
        tt /= self.frame.size.width;

        UIColor *color = kColor(kRed * tt, kGreen * tt, kBlue * tt);
        UIButton *button = _itemsBtn[index];
        [button setTitleColor:color forState:UIControlStateNormal];
        UIColor *color1 = kColor(kRed * (1-tt), kGreen * (1-tt), kBlue * (1-tt));
        UIButton *button1 = _itemsBtn[index + 1];
        [button1 setTitleColor:color1 forState:UIControlStateNormal];

        if (_isFont) {
            CGFloat scale = _barFontScale + (1-_barFontScale) * tt;
            button.transform = CGAffineTransformMakeScale(scale, scale);
            CGFloat scale1 = _barFontScale + (1-_barFontScale) * (1-tt);
            button1.transform = CGAffineTransformMakeScale(scale1, scale1);
        }

        CGFloat dw = ([_itemsWidth[index] floatValue] + [_itemsWidth[index + 1] floatValue]) * 0.5;
        CGFloat dt = tt > 0.5 ? (1 - tt) : tt;
        dw *= dt;
        
        CGFloat width = ([_itemsWidth[index] floatValue] * tt + [_itemsWidth[index + 1] floatValue] * (1-tt)) - _barSpeace * 2 + dw;
   
        CGFloat x = button1.center.x - width * 0.5 - button.frame.size.width * tt;

        CGFloat w = [_itemsWidth[index] floatValue] - _barSpeace * 2;
        if (x < button.center.x - w * 0.5) {
            x = button.center.x - w * 0.5;
        }

        _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - _BarLineH, width, _BarLineH);
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

            if (_isFont) {
                CGFloat scale = _barFontScale + (1-_barFontScale) * tt;
                button.transform = CGAffineTransformMakeScale(scale, scale);
                CGFloat scale1 = _barFontScale + (1-_barFontScale) * (1-tt);
                button1.transform = CGAffineTransformMakeScale(scale1, scale1);
            }

            CGFloat dw = ([_itemsWidth[index] floatValue] + [_itemsWidth[index - 1] floatValue]) * 0.5;
            CGFloat dt = tt > 0.5 ? (1 - tt) : tt;
            dw *= dt;
            
            CGFloat width = ([_itemsWidth[index - 1] floatValue] * (1-tt) + [_itemsWidth[index] floatValue] * tt) - _barSpeace * 2 + dw;
            CGFloat x = button1.center.x - width * 0.5 + button1.frame.size.width * tt;

            CGFloat w = [_itemsWidth[index] floatValue] - _barSpeace * 2;
            if (x > button.center.x - w * 0.5) {
                x = button.center.x - w * 0.5;
            }

            _line.frame = CGRectMake(x, _tabBarScrollView.frame.size.height - _BarLineH, width, _BarLineH);
        }
    }
}

- (void)itemPressed:(UIButton *)button
{
    NSInteger index = [_itemsBtn indexOfObject:button];
    if (index == _currentItemIndex) {
        if (_delegate) {
            [_delegate itemDidSelected:self withIndex:index isRepeat:TRUE];
        } else if (_block) {
            _block(index, TRUE);
        }
    } else {
        if (_scrollView) {
            CGFloat offset = index * _scrollView.frame.size.width;
            [_scrollView setContentOffset:CGPointMake(offset, 0.0f) animated:YES];
        } else {
            if (_delegate) {
                [_delegate itemDidSelected:self withIndex:index isRepeat:FALSE];
            } else if (_block) {
                _block(index, FALSE);
            }
        }
    }
}

@end
