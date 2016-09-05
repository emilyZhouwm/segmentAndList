//
//  WMMenuHead.m
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMMenuHead.h"
#import "WMPickupList.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width
#define kHeadH 44
#define kHeadFont [UIFont systemFontOfSize:15]
#define kTextColor [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1.0]
#define kBackColor [UIColor colorWithRed:233/255.0 green:233/255.0 blue:233/255.0 alpha:1.0]
#define kLineColor [UIColor colorWithRed:178/255.0 green:178/255.0 blue:178/255.0 alpha:1.0]
#define kCancelColor [UIColor colorWithRed:0/255.0 green:198/255.0 blue:12/255.0 alpha:1.0]

@implementation WMMenuHead

+ (CGFloat)headHeight
{
    return kHeadH;
}

+ (UIView *)addHeadTo:(WMPickupList *)control withTitle:(NSString *)title
{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kHeadH)];
    if (headView) {
        headView.backgroundColor = kBackColor;

        UIView *topLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 0.6)];
        topLineView.backgroundColor = kLineColor;
        [headView addSubview:topLineView];
        UIView *bottomLineView = [[UIView alloc] initWithFrame:CGRectMake(0, kHeadH - 0.6, kScreen_Width, 0.6)];
        bottomLineView.backgroundColor = kLineColor;
        [headView addSubview:bottomLineView];

        UILabel *headLbl = [[UILabel alloc] initWithFrame:headView.bounds];
        headLbl.text = title;
        headLbl.font = kHeadFont;
        headLbl.textColor = kTextColor;
        headLbl.textAlignment = NSTextAlignmentCenter;
        [headView addSubview:headLbl];

        UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 60, kHeadH)];
        [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancelBtn setTitleColor:kCancelColor forState:UIControlStateNormal];
        [cancelBtn.titleLabel setFont:kHeadFont];
        [cancelBtn addTarget:control action:@selector(hideView) forControlEvents:UIControlEventTouchUpInside];
        [headView addSubview:cancelBtn];
    }
    return headView;
}

@end
