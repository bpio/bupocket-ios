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

@interface AddAssetsViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;
@property (nonatomic, strong) NSString * searchText;

@end

@implementation AddAssetsViewController

static NSString * const SearchID = @"SearchID";

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"AddAssets");
    [self setupView];
    [self setupRefresh];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    // Do any additional setup after loading the view.
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self.tableView.mj_header beginRefreshing];
}
- (void)setupRefresh
{
    self.tableView.mj_header = [CustomRefreshHeader headerWithRefreshingTarget:self refreshingAction:@selector(loadNewData)];
    self.tableView.mj_header.automaticallyChangeAlpha = YES;
    self.tableView.mj_footer = [CustomRefreshFooter footerWithRefreshingTarget:self refreshingAction:@selector(loadMoreData)];
    [self.tableView.mj_header beginRefreshing];
    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = -(ContentSizeBottom);
}
- (void)loadNewData
{
    if (self.searchText.length > 0) {
        [self getDataWithPageindex: PageIndex_Default];
    } else {
        [self.tableView.mj_header endRefreshing];
    }
}
- (void)loadMoreData
{
    if (self.searchText.length > 0) {
        [self getDataWithPageindex:self.pageindex];
    } else {
        [self.tableView.mj_footer endRefreshing];
    }
}
- (void)getDataWithPageindex:(NSInteger)pageindex
{
    [[HTTPManager shareManager] getSearchAssetsDataWithAssetCode:_searchText pageIndex:pageindex success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * listArray = [SearchAssetsModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"tokenList"]];
            if (pageindex == PageIndex_Default) {
                [self.listArray removeAllObjects];
                self.pageindex = PageIndex_Default;
            }
            self.pageindex = self.pageindex + 1;
            [self.listArray addObjectsFromArray:listArray];
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
        (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
        self.tableView.mj_footer.hidden = (self.listArray.count == 0);
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.noNetWork.hidden = NO;
    }];
}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [_searchTextField becomeFirstResponder];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [_searchTextField resignFirstResponder];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor whiteColor];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
}

- (void)setupHeaderView
{
    UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT)];
    headerView.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = headerView;
    _searchTextField = [[UITextField alloc] init];
    _searchTextField.placeholder = Localized(@"InputAssetName");
    _searchTextField.font = FONT(16);
    _searchTextField.textColor = TITLE_COLOR;
    _searchTextField.delegate = self;
    _searchTextField.tintColor = MAIN_COLOR;
    _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
    _searchTextField.returnKeyType = UIReturnKeySearch;
    [_searchTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [headerView addSubview:_searchTextField];
    
    UIButton * searchBtn = [UIButton createButtonWithNormalImage:@"search" SelectedImage:@"search" Target:self Selector:@selector(searchAction)];
    [headerView addSubview:searchBtn];
    [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(headerView);
        make.right.equalTo(headerView.mas_right).offset(-Margin_20);
        make.width.mas_equalTo(ScreenScale(22));
    }];
    
    [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(headerView.mas_left).offset(Margin_20);
        make.top.bottom.equalTo(headerView);
        make.right.equalTo(searchBtn.mas_left).offset(-Margin_10);
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = LINE_COLOR;
    [headerView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchTextField);
        make.right.equalTo(searchBtn);
        make.height.mas_equalTo(LINE_WIDTH);
        make.bottom.equalTo(headerView);
    }];
}

- (UIView *)noData
{
    if (!_noData) {
        CGFloat contentSizeH = ContentSizeBottom;
        CGFloat noDataH = DEVICE_HEIGHT - MAIN_HEIGHT - 3 * contentSizeH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoSearchResults") imageName:@"noSearchResults" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
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
    return self.listArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (void)searchAction
{
    [self.searchTextField resignFirstResponder];
    if (self.searchText.length > 0) {
        if (!self.tableView.mj_header) {
            [self setupRefresh];
        } else {
            [self.tableView.mj_header beginRefreshing];
        }
    }
}
- (void)textChange:(UITextField *)textField
{
    self.searchText = TrimmingCharacters(self.searchTextField.text);
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(130);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SearchAssetsModel * searchAssetsModel = self.listArray[indexPath.row];
    return searchAssetsModel.cellHeight;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddAssetsViewCell * cell = [AddAssetsViewCell cellWithTableView:tableView];
    cell.searchAssetsModel = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
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
