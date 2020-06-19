//
//  WMMenuCell.m
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMMenuCell.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kTextSpace 0
#define kTextFont [UIFont systemFontOfSize:14]
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kIconImage [UIImage imageNamed:@"tag_list_s"]
#define kCellH 34
#define kTableH 266
#define kIconW 18
#define kIconH 18
#define kIconSpace 15
#define kLineColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]

@interface WMMenuCell ()
{
    UIView *_bottomLineView;
}
@end

@implementation WMMenuCell
+ (CGFloat)tableHeight
{
    return kTableH;
}

+ (CGFloat)cellHeight
{
    return kCellH;
}

- (void)setInfo:(id)info
{
    if (!_bottomLineView) {
        [self initUI];
    }
    self.textLabel.text = info;
}

- (void)setIsSelect:(BOOL)selected
{
    self.imageView.hidden = (selected ? FALSE : TRUE);
}

- (void)initUI
{
    self.textLabel.textColor = kTextColor;
    self.textLabel.font = kTextFont;
    self.textLabel.textAlignment = NSTextAlignmentCenter;
   
    self.imageView.image = kIconImage;
    
    _bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kCellH - 0.6, kScreen_Width, 0.6)];
    _bottomLineView.backgroundColor = kLineColor;
    [self addSubview:_bottomLineView];
    self.backgroundColor = [UIColor clearColor];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake(kScreen_Width - kIconW - kIconSpace, (kCellH - kIconH) * 0.5, kIconW, kIconH);
    self.textLabel.frame = CGRectMake(kTextSpace, 0, kScreen_Width - kTextSpace, kCellH);
}

@end
