//
//  ThreeViewController.m
//  segmentAndListDemo
//
//  Created by zwm on 15/5/27.
//  Copyright (c) 2015年 zwm. All rights reserved.
//

#import "ThreeViewController.h"
#import "WMNavTabBar.h"

#define kScreen_Width [UIScreen mainScreen].bounds.size.width

@interface ThreeViewController () <WMNavTabBarDelegate>
@property (weak, nonatomic) IBOutlet WMNavTabBar *navTabBar;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView1;
@property (weak, nonatomic) IBOutlet WMNavTabBar *navTabBarSamp;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView2;

@end

@implementation ThreeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _navTabBar.navDelegate = self;
    [_navTabBar setItemTitles:@[@"精选", @"优惠", @"海淘", @"精选", @"优惠", @"海淘", @"精选", @"优惠", @"海淘"] andScrollView:_scrollView1];
    
    NSArray *ary = @[[UIColor greenColor], [UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor redColor], [UIColor greenColor], [UIColor blueColor], [UIColor redColor]];
    for (int i=0; i<9; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scrollView1.frame.size.height)];
        v.backgroundColor = ary[i];
        [_scrollView1 addSubview:v];
    }
    _scrollView1.contentSize = CGSizeMake(kScreen_Width * 9, 0);
    
    _navTabBarSamp.isSamp = TRUE;// !!!
    _navTabBarSamp.navDelegate = self;
    [_navTabBarSamp setItemTitles:@[@"精选", @"优惠", @"海淘"] andScrollView:_scrollView2];
    
    for (int i=0; i<3; i++) {
        UIView *v = [[UIView alloc] initWithFrame:CGRectMake(kScreen_Width * i, 0, kScreen_Width, _scrollView2.frame.size.height)];
        v.backgroundColor = ary[i];
        [_scrollView2 addSubview:v];
    }
    _scrollView2.contentSize = CGSizeMake(kScreen_Width * 3, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - WMNavTabBarDelegate
- (void)itemDidSelected:(WMNavTabBar *)tabBar withIndex:(NSInteger)index isRepeat:(BOOL)isRepeat
{
    if (tabBar == _navTabBarSamp) {
    } else if (tabBar == _navTabBar) {
    }
    if (isRepeat) {
        [self scrollHead:index];
    } else {
        [self loadData:index];
    }
}

- (void)scrollHead:(NSInteger)index
{
    
}

- (void)loadData:(NSInteger)index
{
    
}

@end
