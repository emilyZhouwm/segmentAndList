//
//  WMCustomMenuCell.h
//  segmentAndListDemo
//
//  Created by zwm on 15/6/3.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "WMMenuCell.h"

@interface DownMenuTitle : NSObject
@property (nonatomic, strong) NSString *titleValue, *imageName;
+ (DownMenuTitle *)title:(NSString *)title image:(NSString *)image;
@end

@interface WMCustomMenuCell : WMMenuCell

+ (CGFloat)cellHeight;
- (void)setInfo:(id)info;
- (void)setIsSelect:(BOOL)selected;

@end
