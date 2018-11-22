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
@property (nonatomic, strong) UISearchController * searchController;
@property (nonatomic, strong) NSMutableArray *results;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;

@end

@implementation AddAssetsViewController

static NSString * const SearchID = @"SearchID";

- (NSMutableArray *)results {
    if (!_results) {
        _results = [NSMutableArray array];
    }
    return _results;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"AddAssets");
    if (@available(iOS 11.0, *)) {
        self.navigationItem.hidesSearchBarWhenScrolling = YES;
    } else {
        // Fallback on earlier versions
    }
    [self setupView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_n" SelectedImage:@"nav_goback_n" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    [self setupRefresh];
    // Do any additional setup after loading the view.
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
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
    self.tableView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = -(ContentSizeBottom);
}
- (void)loadNewData
{
    [self getDataWithPageindex: PageIndex_Default];
}
- (void)loadMoreData
{
    [self getDataWithPageindex:self.pageindex];
}
- (void)getDataWithPageindex:(NSInteger)pageindex
{
    [[HTTPManager shareManager] getSearchAssetsDataWithAssetCode:_searchController.searchBar.text pageIndex:1 success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * listArray = [SearchAssetsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
            if (pageindex == PageIndex_Default) {
                [self.results removeAllObjects];
                self.pageindex = PageIndex_Default;
            }
            self.pageindex = self.pageindex + 1;
            [self.results addObjectsFromArray:listArray];
            if (listArray.count < PageSize_Max) {
                [self.tableView.mj_footer endRefreshingWithNoMoreData];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
            [self.tableView reloadData];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
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
- (UISearchController *)searchController
{
    if (!_searchController) {
        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        _searchController.searchResultsUpdater = self;
        _searchController.delegate = self;
        _searchController.searchBar.delegate = self;
        _searchController.dimsBackgroundDuringPresentation = NO;
        _searchController.hidesNavigationBarDuringPresentation = NO;
        _searchController.searchBar.placeholder = Localized(@"InputAssetName");
        _searchController.searchBar.tintColor = MAIN_COLOR;
        _searchController.searchBar.barTintColor = [UIColor whiteColor];
        UIImageView *barImageView = [[[_searchController.searchBar.subviews firstObject] subviews] firstObject];
        barImageView.layer.borderColor = LINE_COLOR.CGColor;
        barImageView.layer.borderWidth = LINE_WIDTH;
        UITextField * textField = [_searchController.searchBar valueForKey:@"_searchField"];
        textField.textColor = TITLE_COLOR;
        textField.font = FONT(16);
    }
    return _searchController;
}

- (void)setupView
{
    self.definesPresentationContext = NO;
    [self setExtendedLayoutIncludesOpaqueBars:YES];
    CGFloat searchBarH = self.searchController.searchBar.height;
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, searchBarH, DEVICE_WIDTH, DEVICE_HEIGHT - searchBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.searchController.searchBar];
    [self.view addSubview:self.tableView];
}
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
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.searchController.active) {
        return self.results.count ;
    }
    return 0;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom;
}
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
}

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
    // Prevent UISearchBar from moving up after returning.
    self.edgesForExtendedLayout = UIRectEdgeNone;
    searchController.searchBar.showsCancelButton = YES;
    UIButton * cancelButton = [self.searchController.searchBar valueForKey:@"cancelButton"];
    if (cancelButton) {
        [cancelButton setTitle:Localized(@"Cancel") forState:UIControlStateNormal];
        [cancelButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
    }
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
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar
{
    [self.results removeAllObjects];
    [self.tableView reloadData];
}
/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
