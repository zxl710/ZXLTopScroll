//
//  ViewController.m
//  高仿自选股
//
//  Created by macbook on 16/9/10.
//  Copyright © 2016年 曾晓利. All rights reserved.
//

#import "ZXLViewController.h"
#import "ZXLTableViewController.h"
#import "ZXLTitleView.h"
#import "ZXLConstant.h"


@interface ZXLViewController ()<UIScrollViewDelegate>


@property (nonatomic ,strong)ZXLTitleView *titleView;
@property (nonatomic ,strong)NSArray *titleList;
@property (nonatomic ,assign)NSInteger firstIndex;
@property (nonatomic ,strong)UIScrollView *mainScrollView;
@end

@implementation ZXLViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setUpTitleView];
    
    
    
    [self setUpSubViews];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.titleView observeScrollViewDidEndDecelerating:self.mainScrollView];
}


- (void)setUpTitleView
{
    self.navigationItem.titleView = self.titleView;
    UIButton *leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 50, 44);
    leftButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    
    
    [leftButton setTitle:@"编辑" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    

    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightButton.frame = CGRectMake(0, 0, 50, 44);
    rightButton.titleLabel.font = [UIFont systemFontOfSize:14.f];
    [rightButton setTitle:@"交易" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];
//    [[UIBarButtonItem alloc] initWithTitle:@"交易" style:UIBarButtonItemStylePlain target:self action:@selector(clickRightButton:)];
}
- (void)setUpSubViews
{
    [self.view addSubview:self.mainScrollView];
    
    [self seUpSubCtrls];
}

- (void)seUpSubCtrls
{
    ZXLTableViewController *vc1 = [[ZXLTableViewController alloc] init];
    [self addChildViewController:vc1];
    
    ZXLTableViewController *vc2 = [[ZXLTableViewController alloc] init];
    [self addChildViewController:vc2];
    
    ZXLTableViewController *vc3 = [[ZXLTableViewController alloc] init];
    [self addChildViewController:vc3];
    
    ZXLTableViewController *vc4 = [[ZXLTableViewController alloc] init];
    [self addChildViewController:vc4];
    
    ZXLTableViewController *vc5 = [[ZXLTableViewController alloc] init];
    [self addChildViewController:vc5];

    CGSize size = [UIScreen mainScreen].bounds.size;
    
    self.mainScrollView.contentSize = CGSizeMake(self.titleList.count * size.width, size.height);
    self.mainScrollView.bounces = NO;
}

- (ZXLTitleView *)titleView
{
    if (!_titleView) {
        _titleView  = [[ZXLTitleView alloc] initWithFrame:CGRectMake(0, 0, 80, 44) titleList:self.titleList firstIndex:self.firstIndex navigationItem:self.navigationItem];
    }
    return _titleView;
}

- (NSArray *)titleList
{
    if (!_titleList) {
        _titleList = @[@"基金产品",@"定期宝",@"指数宝",@"高端理财",@"组合宝"];
    }
    return _titleList;
}

- (NSInteger)firstIndex
{
    if (!_firstIndex) {
        _firstIndex = ZXLType_all;
    }
    return _firstIndex;
}

- (UIScrollView *)mainScrollView
{
    if (!_mainScrollView) {
        _mainScrollView = [[UIScrollView alloc] init];
        _mainScrollView.frame = self.view.bounds;
        _mainScrollView.delegate = self;
        _mainScrollView.showsHorizontalScrollIndicator = NO;
        _mainScrollView.pagingEnabled = YES;
        _mainScrollView.scrollsToTop = NO;
    }
    return _mainScrollView;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.titleView observeScrollDidScroll:scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self.titleView observeScrollViewDidEndDecelerating:scrollView];
}

@end
