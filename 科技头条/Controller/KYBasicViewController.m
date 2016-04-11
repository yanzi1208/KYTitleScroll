//
//  KYBasicViewController.m
//  科技头条
//
//  Created by apple on 15/7/16.
//  Copyright (c) 2015年 KY. All rights reserved.
//

#import "KYBasicViewController.h"
#import "KYNavTitleModel.h"
#import "KYNewsTableView.h"
#import "KYNewsTableViewCell.h"
#import "KYNewsModel.h"
#import "KYTitleScrollView.h"


#define backLittleColor [UIColor colorWithRed:224/255.0 green:224/255.0 blue:224/255.0 alpha:1]
#define randomColor [UIColor colorWithRed:arc4random_uniform(256)/255.0 green:arc4random_uniform(256)/255.0 blue:arc4random_uniform(256)/255.0 alpha:1]

#define  screenWidth  [UIScreen mainScreen].bounds.size.width
#define  screenHight  [UIScreen mainScreen].bounds.size.height


static NSString * const newsID = @"newsCollection";


@interface KYBasicViewController ()< UIScrollViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDataSource, UITableViewDelegate>

/// scrollView 视图
@property (nonatomic, strong) UIScrollView *newsCollection;
@property (nonatomic, strong) NSArray *titleList;
@property (nonatomic, strong) KYNavTitleModel *titleModel;


@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

//@property (nonatomic, strong) UICollectionView *newsCollection;

/// tableView 视图
@property (nonatomic, strong) KYNewsTableView *newsTableView;
/// 新闻列表
@property (nonatomic, strong) NSArray *newsList;
/// 下拉刷新
@property (nonatomic, strong) UIRefreshControl *refreshControl;

@property (nonatomic, strong) NSMutableArray *tableViewArray;
/// 流水布局

@property (nonatomic, assign) NSIndexPath *indexpath;


@property (nonatomic, strong) NSString *urlStr;






@property (nonatomic, strong) NSArray *titleLists;



@end

@implementation KYBasicViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self loadTitleNavView];
    
    // 加载中间主视图
    [self loadCollectionView];
    
}




#pragma  mark - 加载视图
/// 加载导航栏
- (void)loadTitleNavView{
    
    // 添加状态栏背景
    UIImageView *stateBarBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, screenWidth, 56)];
    stateBarBg.image = [UIImage imageNamed:@"channel_middle_bg"];
    [self.view addSubview:stateBarBg];
    // 添加导航条背景
    KYTitleScrollView *titleScrollView = [[KYTitleScrollView alloc] initWithFrame:CGRectMake(0, 20, screenWidth, 44)];
    [self.view addSubview:titleScrollView];
    titleScrollView.contentSize =CGSizeMake(64*7, 0) ;
    titleScrollView.showsHorizontalScrollIndicator = NO;

}




- (void)loadCollectionView{
    // 创建流水布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.minimumInteritemSpacing = 0;
    flowLayout.minimumLineSpacing = 0;
    flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayout.itemSize = CGSizeMake(screenWidth, screenHight - 64);
    self.flowLayout = flowLayout;
    
    UICollectionView *newsCollection = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:flowLayout];
    
    newsCollection.showsHorizontalScrollIndicator = NO;
    newsCollection.showsVerticalScrollIndicator = NO;
    newsCollection.bounces = NO;
    newsCollection.scrollEnabled = YES;
    newsCollection.backgroundColor = [UIColor clearColor];
    newsCollection.dataSource = self;
    newsCollection.delegate = self;
    newsCollection.pagingEnabled = YES;
    self.newsCollection = newsCollection;
    
    newsCollection.frame = CGRectMake(0, 64, screenWidth, screenHight - 64);
    
    [self.view addSubview:newsCollection];
    // 注册
    [newsCollection registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:newsID];
    
    [self loadTableView];
}


/// 添加tableView
- (void)loadTableView{
    
    KYNewsTableView *newsTableView = [[KYNewsTableView alloc] init];
    
    newsTableView.delegate = self;
    newsTableView.dataSource = self;
    newsTableView.rowHeight = 100;
    
    self.newsTableView = newsTableView;
    newsTableView.frame = CGRectMake(8+screenWidth, 0, screenWidth-16, screenHight-64);
    
    newsTableView.backgroundColor = backLittleColor;
    
    [self.newsCollection addSubview:newsTableView];
    [self.tableViewArray addObject:newsTableView];
  
}

- (void)setUrlStr:(NSString *)urlStr{
    
    _urlStr = urlStr;
    [self refreshChanged];
}



// 刷新tableView数据
- (void)refreshChanged{
    
    if (self.urlStr) {
        
        
        [KYNewsModel newsListWithUrl:self.urlStr Completion:^(NSArray *array) {
            
            self.newsList = array;
        } error:^(NSString *string) {
            NSLog(@"%@",string);
        }];
        
    }
    [self.refreshControl endRefreshing];
}






#pragma mark - collectionView 数据源方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    return self.titleList.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:newsID forIndexPath:indexPath];
    
    KYNavTitleModel *titleModel = self.titleList[indexPath.item];

//    cell.urlStr = titleModel.topURL;
    [cell addSubview:self.newsTableView];
    
    return cell;
    
}





#pragma  mark - 设置数据

/// 新闻列表setter 方法
- (void)setNewsList:(NSArray *)newsList {
    
    _newsList = newsList;
    
    [self.newsTableView reloadData];
}





#pragma mark - tableView 数据源方法

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return self.newsList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 显示新闻的tableView
    KYNewsTableViewCell *cell = [KYNewsTableViewCell tableViewCellWithTableView:tableView];
    
    cell.newsModel = self.newsList[indexPath.section];
    return cell;
    
    
}


#pragma mark - tableView 代理方法
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = backLittleColor;
    return view;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    view.backgroundColor = backLittleColor;
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 5.0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 5.0;
}



- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    
    // 滚动屏幕的时候调用
    if (decelerate) {
        
    }
    
}





#pragma mark - 懒加载

- (NSArray *)titleList{
    
    if (_titleList == nil) {
        _titleList = [KYNavTitleModel navTitleWithPlist];
    }
    return _titleList;
}
@end
