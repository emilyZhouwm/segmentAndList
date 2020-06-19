//
//  WMCustomMenuCell.m
//  segmentAndListDemo
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMCustomMenuCell.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kTextSpace 15
#define kTextFont [UIFont systemFontOfSize:16]
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kIconImage [UIImage imageNamed:@"tag_list_s"]
#define kCellH 44
#define kTableH 266
#define kIconW 18
#define kIconH 18
#define kIconSpace 15
#define kLineColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]
#define kIconLeftW 25
#define kIconLeftH 25

@implementation DownMenuTitle
+ (DownMenuTitle *)title:(NSString *)title image:(NSString *)image
{
    DownMenuTitle *menuObj = [[DownMenuTitle alloc] init];
    menuObj.titleValue = title;
    menuObj.imageName = image;
    return menuObj;
}
@end

@interface WMCustomMenuCell ()
{
    UIImageView *_leftIcon;
    UIView *_bottomLineView;
}
@end

@implementation WMCustomMenuCell
+ (CGFloat)tableHeight
{
    return kTableH;
}

+ (CGFloat)cellHeight
{
    return kCellH;
}

- (void)setInfo:(DownMenuTitle *)info
{
    if (!_bottomLineView) {
        [self initUI];
    }
    
    self.textLabel.text = info.titleValue;
    [_leftIcon setImage:[UIImage imageNamed:info.imageName]];
}

- (void)setIsSelect:(BOOL)selected
{
    self.imageView.hidden = (selected ? FALSE : TRUE);
}

- (void)initUI
{
    self.textLabel.textColor = kTextColor;
    self.textLabel.font = kTextFont;
    
    self.imageView.image = kIconImage;
    
    _leftIcon = [[UIImageView alloc] initWithFrame:CGRectMake(kIconSpace, (kCellH - kIconLeftH) * 0.5, kIconLeftW, kIconLeftH)];
    [self addSubview:_leftIcon];
    
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(kIconSpace + kIconLeftW + kIconSpace, kCellH - 0.6, kScreen_Width, 0.6)];
    _bottomLineView.backgroundColor = kLineColor;
    [self addSubview:_bottomLineView];
}


- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(kScreen_Width - kIconW - kIconSpace, (kCellH - kIconH) * 0.5, kIconW, kIconH);
    self.textLabel.frame = CGRectMake(kTextSpace + CGRectGetMaxX(_leftIcon.frame), 0, CGRectGetMinX(self.imageView.frame) - kTextSpace - CGRectGetMaxX(_leftIcon.frame), kCellH);
}

@end
