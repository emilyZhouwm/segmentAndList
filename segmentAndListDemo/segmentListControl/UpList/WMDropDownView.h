//
//  WMDropDownList.h
//
//  Created by zwm on 15-5-26.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^WMDropDownViewBlock)(id title, NSInteger index);

@interface WMDropDownView : UIView

+ (void)setCellClass:(Class)cellClass;

- (id)initWithFrame:(CGRect)frame
             titles:(NSArray *)titles
       defaultIndex:(NSInteger)index
      selectedBlock:(WMDropDownViewBlock)block;

- (void)changeWithTitles:(NSArray *)titles
            defaultIndex:(NSInteger)index
           selectedBlock:(WMDropDownViewBlock)block;

- (void)showView;
- (void)hideView;

@end
