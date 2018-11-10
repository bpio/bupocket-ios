//
//  AddAssetsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/25.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "AddAssetsViewController.h"
#import "AddAssetsViewCell.h"
#import "SearchAssetsModel.h"

@interface AddAssetsViewController ()<UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
//@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UISearchController * searchController;
// 搜索结果数组
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;
//@property (nonatomic, strong) UIButton * emptyBtn;

@end

@implementation AddAssetsViewController

static NSString * const SearchID = @"SearchID";

//- (NSMutableArray *)listArray
//{
//    if (!_listArray) {
//        _listArray = [NSMutableArray array];
//    }
//    return _listArray;
//}
- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (@available(iOS 11.0, *)) {
        [self.navigationController.navigationBar setPrefersLargeTitles:NO];
    } else {
        // Fallback on earlier versions
    }
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"AddAssets");
//    self.extendedLayoutIncludesOpaqueBars = YES;
    //    self.navigationItem.titleView = self.searchBar;
    if (@available(iOS 11.0, *)) {
        self.navigationItem.hidesSearchBarWhenScrolling = YES;
    } else {
        // Fallback on earlier versions
    }
    [self setupView];
    self.pageindex = 1;
     self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(loadNewData)];
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)cancelAction
{
    self.searchController.active = NO;
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
//    self.tableView.mj_header.ignoredScrollViewContentInsetTop = _headerViewH;
//    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.hidden = YES;
}
- (void)loadNewData
{
    [self getDataWithPageindex:1];
}
- (void)loadMoreData
{
    [self getDataWithPageindex:self.pageindex];
}
- (void)getDataWithPageindex:(NSInteger)pageindex
{
    [[HTTPManager shareManager] getSearchAssetsDataWithAssetCode:_searchController.searchBar.text pageIndex:1 success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"msg"];
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == 0) {
            // 请求成功数据处理
            NSArray * listArray = [SearchAssetsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
            if (pageindex == 1) {
                // 清除所有旧数据
                [self.results removeAllObjects];
                self.pageindex = 1;
            }
            self.pageindex = self.pageindex + 1;
            [self.results addObjectsFromArray:listArray];
            if (listArray.count < 10) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:message];
        }
        [self.tableView.mj_header endRefreshing];
        (self.results.count > 0) ? (self.tableView.tableFooterView = [UIView new]) : (self.tableView.tableFooterView = self.noData);
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.noNetWork.hidden = NO;
    }];
}
/*
- (void)getDataWithKey:(NSString *)key
{
    [self saveHistoryTagsWithKeyword:key];
    [[HTTPManager shareManager] getDataWithURL:Interface_SearchShop type:1 paramName:@"txt_key" paramValue:key txt_code:nil pageindex:0 success:^(id responseObject) {
        NSString * message = [responseObject objectForKey:@"txt_message"];
        NSInteger status =[[responseObject objectForKey:@"txt_code"] integerValue];
        if (status == 0) {
            ListViewController * VC = [[ListViewController alloc] init];
            VC.listArray = [BaseModel mj_objectArrayWithKeyValuesArray:[responseObject objectForKey:@"txt_data"]];
            VC.navigationItem.title = @"搜索店铺";
            [self.navigationController pushViewController:VC animated:YES];
            //            self.baseModel = [BaseModel mj_objectWithKeyValues:[responseObject objectForKey:@"txt_data"]];
            //            [self.tableView reloadData];
        } else if (status == 2) {
            [MBProgressHUD showTipMessageInWindow:message];
            [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[LoginViewController alloc] init]];
        } else if (status == 4) {
            // 无数据
            [MBProgressHUD showTipMessageInWindow:message];
        }
    } failure:^(NSError *error) {
        
    }];
}
 */
- (UISearchController *)searchController
{
    if (!_searchController) {
        //        [self.datas addObjectsFromArray:[DataCacheTool DataArray]];
        // 创建UISearchController, 这里使用当前控制器来展示结果
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        // 设置结果更新代理
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
//        [_searchController.searchBar sizeToFit];
        // 因为在当前控制器展示结果, 所以不需要这个透明视图
        _searchController.dimsBackgroundDuringPresentation = NO;
        //点击搜索的时候,是否隐藏导航栏
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.placeholder = Localized(@"InputAssetName");
        //包着搜索框外层的颜色 显示searBar的光标
        _searchController.searchBar.tintColor = MAIN_COLOR;
        //改变searchController背景颜色
        _searchController.searchBar.barTintColor = [UIColor whiteColor];
//        [_searchController.searchBar setValue:Localized(@"Cancel") forKey:@"_cancelButtonText"];
        //去掉searchController.searchBar的上下边框（黑线）
        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor = LINE_COLOR.CGColor;
        barImageView.layer.borderWidth = LINE_WIDTH;
//        _searchController.obscuresBackgroundDuringPresentation = NO;
        UITextField * textField = [_searchController.searchBar valueForKey:@"_searchField"];
        textField.textColor = TITLE_COLOR;
        textField.font = FONT(16);
    }
    return _searchController;
}

- (void)setupView
{
//    self.navigationItem.titleView = self.searchController.searchBar;
    //    设置definesPresentationContext为true，可以保证在UISearchController在激活状态下用户push到下一个view controller之后search bar不会仍留在界面上
    self.definesPresentationContext = NO;
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    CGFloat searchBarH = self.searchController.searchBar.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBarH, DEVICE_WIDTH, DEVICE_HEIGHT - searchBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.backgroundColor = VIEW_BG_COLOR;
    [self.view addSubview:self.searchController.searchBar];
    /*
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, -self.searchController.searchBar.height, DEVICE_WIDTH, self.searchController.searchBar.height)];
    headerView.frame = self.searchController.searchBar.bounds;
    [headerView addSubview:self.searchController.searchBar];
    [self.tableView addSubview:headerView];
    self.tableView.contentInset = UIEdgeInsetsMake(self.searchController.searchBar.height, 0, 0, 0);
//    self.tableView.tableHeaderView = headerView;
     */
    [self.view addSubview:self.tableView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    //    self.tableView.tableFooterView = self.emptyBtn;
}
/*
// 搜索结果tableView向上偏移20px
- (void)viewDidLayoutSubviews {
    if (@available(iOS 11.0, *)) {
        if(self.searchController.active) {
            [self.tableView setFrame:CGRectMake(0, 19, DEVICE_WIDTH, DEVICE_HEIGHT - 19)];
        } else {
            self.tableView.frame = self.view.bounds;
        }
    }
}*/
- (UIView *)noData
{
    if (!_noData) {
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(270))];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoSearchResults") imageName:@"noSearchResults" superView:self.noData frame:CGRectMake(0, Margin_50, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
/*
- (UIButton *)emptyBtn
{
    if (!_emptyBtn) {
        _emptyBtn = [UIButton createButtonWithTitle:@"清空搜索记录" TextFont:12 TextNormalColor:COLOR(121, 121, 121) TextSelectedColor:COLOR(121, 121, 121) NormalImage:@"searchDelete" SelectedImage:@"searchDelete" Target:self Selector:@selector(emptyAction:)];
        _emptyBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT);
    }
    return _emptyBtn;
}
*/
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 这里通过searchController的active属性来区分展示数据源是哪个
    if (self.searchController.active) {
        return self.results.count ;
    }
    return 0;
//    else {
//        return self.listArray.count;
//    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    return self.searchController.searchBar.height;
    return CGFLOAT_MIN;
}
//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
//{
//    return self.searchController.searchBar;
//}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SafeAreaBottomH + NavBarH + Margin_10;
}
/*
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return nil;
    } else {
        if (self.listArray.count > 0) {
            return self.emptyBtn;
        } else {
            return nil;
        }
    }
}*/
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(120);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAssetsViewCell * cell = [AddAssetsViewCell cellWithTableView:tableView];
    cell.searchAssetsModel = self.results[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    [self getDataWithKey:cell.textLabel.text];
    //    NSString * userID;
    //    if (self.searchController.active) {
    //        userID = [self.results objectAtIndex:indexPath.row];
    //        HSSLog(@"选择了搜索结果中的%@", [self.results objectAtIndex:indexPath.row]);
    //    } else {
    //        userID = [self.listArray objectAtIndex:indexPath.row];
    //        HSSLog(@"选择了列表中的%@", [self.listArray objectAtIndex:indexPath.row]);
    //    }
    //    [self.navigationController popViewControllerAnimated:YES];
}

//自动弹出键盘
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.searchController.active = true;
}
- (void)didPresentSearchController:(UISearchController *)searchController {
    [UIView animateWithDuration:0.1 animations:^{} completion:^(BOOL finished) {
        [self.searchController.searchBar becomeFirstResponder];
    }];
}
#pragma mark - UISearchResultsUpdating
- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    self.edgesForExtendedLayout = UIRectEdgeNone;//不加的话，UISearchBar返回后会上移
    [_searchController.searchBar setShowsCancelButton:YES animated:YES];
    [_searchController.searchBar setValue:@"Cancel" forKey:@"_cancelButtonText"];
    UIButton * cancelButton = [self.searchController.searchBar valueForKey:@"cancelButton"];
    if (cancelButton) {
        [cancelButton setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    }
    NSString *inputStr = _searchController.searchBar.text ;
//    if (self.results.count > 0) {
//        [self.results removeAllObjects];
//    }
    //    for (NSString *str in self.listArray) {
    //        if ([str.lowercaseString rangeOfString:inputStr.lowercaseString options:NSLiteralSearch].location != NSNotFound) {
    //            [self.results addObject:str];
    //        }
    //    }
    //    [self.tableView reloadData];
}
#pragma mark - UISearchBarDelegate
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {

}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {

}
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [searchBar resignFirstResponder];
    [self loadNewData];
    //    [self getDataWithKey:searchBar.text];
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
//    [searchBar resignFirstResponder];
    [self.results removeAllObjects];
    [self.tableView reloadData];
}
/*
- (void)emptyAction:(UIButton *)button
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:HistoryArray];
    [self.listArray removeAllObjects];
    [self.tableView reloadData];
}
- (void)saveHistoryTagsWithKeyword:(NSString *)keyword
{
    [self.searchController.searchBar resignFirstResponder];
    [self.listArray removeAllObjects];
    [self.listArray addObjectsFromArray:CurrentHistoryArray];
    if ([self.listArray containsObject:keyword]) {
        return;
    }
    [self.listArray addObject:keyword];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:self.listArray forKey:HistoryArray];
    [self.tableView reloadData];
    
}
*/
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
