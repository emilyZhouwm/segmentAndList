//
//  WMPickerControl.h
//
//  Created by zwm on 15/6/2.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^WMPickerControlBlock)(id title, NSInteger index);

@interface WMPickerControl : UIView

+ (void)setCellClass:(Class )cellClass;

+ (void)showWithTitle:(NSString *)title
           WithTitles:(NSArray *)titles
         defaultIndex:(NSInteger)index
        selectedBlock:(WMPickerControlBlock)selectedHandle;

- (void)hideView;

@end
