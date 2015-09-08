//
//  SegmentControl.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kLineColor [UIColor colorWithRed:0/255.0 green:206/255.0 blue:13/255.0 alpha:1.0]
#define kHLineColor [UIColor colorWithRed:221/255.0 green:221/255.0 blue:221/255.0 alpha:1.0]
#define kIconDefault [UIImage imageNamed:@"home_avatar"]
#define kIconWidth (40)
#define kIconHeight (40)
#define kItemWidth (60)

typedef void(^WMIconSegmentControlBlock)(NSInteger index);

@class WMIconSegmentControl;
@protocol WMIconSegmentControlDelegate <NSObject>
- (void)segmentControl:(WMIconSegmentControl *)control selectedIndex:(NSInteger)index;
@end

@protocol WMWebImageDelegate <NSObject>
- (void)setWebImage:(UIImageView *)imgView imgUrl:(NSString *)imgUrl;
@end

@interface WMIconSegmentControl : UIView

@property (nonatomic) NSInteger currentIndex;
@property (nonatomic, weak) id <WMIconSegmentControlDelegate> delegate;
@property (nonatomic, weak) id <WMWebImageDelegate> imgDelegate;

- (void)setItemsWithIconArray:(NSArray *)titleItem selectedBlock:(WMIconSegmentControlBlock)selectedHandle;
- (void)setItemsWithIconArray:(NSArray *)titleItem;

- (void)selectIndex:(NSInteger)index;

- (void)moveIndexWithProgress:(float)progress;

@end
