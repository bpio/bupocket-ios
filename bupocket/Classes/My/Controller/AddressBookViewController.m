//
//  AddressBookViewController.m
//  bupocket
//
//  Created by bubi on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookListViewCell.h"
#import "AddressBookModel.h"
#import "ContactViewController.h"
#import "MyViewController.h"
#import "TransferAccountsViewController.h"
#import "AddressBookCache.h"

@interface AddressBookViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * noData;
//@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;

@end

static NSString * const AddressBookCellID = @"AddressBookCellID";

@implementation AddressBookViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self setupRefresh];    
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
//    self.tableView.mj_footer.ignoredScrollViewContentInsetBottom = -(ContentSizeBottom);
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
    NSArray * listArray = [AddressBookCache cachedAddressBookData];
    if (listArray.count > 0) {
        self.listArray = [NSMutableArray array];
        [self.listArray addObjectsFromArray:listArray];
        [self.tableView reloadData];
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)];
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.noNetWork.hidden = YES;
    }
    [[HTTPManager shareManager] getAddressBookListWithIdentityAddress:[[AccountTool shareTool] account].identityAddress pageIndex:pageindex success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * listArray = [AddressBookModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"addressBookList"]];
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
        
        [AddressBookCache deleteAddressBookCached];
        [AddressBookCache saveAddressBookWithArray:responseObject[@"data"] [@"addressBookList"]];
    } failure:^(NSError *error) {
        [self.tableView.mj_header endRefreshing];
        [self.tableView.mj_footer endRefreshing];
        self.noNetWork.hidden = NO;
    }];
}
- (void)setupNav
{
    self.navigationItem.title = Localized(@"AddressBook");
    UIButton * add = [UIButton createButtonWithNormalImage:@"addAddressBook" SelectedImage:@"addAddressBook" Target:self Selector:@selector(addAction)];
    add.bounds = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    add.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:add];
}
- (void)addAction
{
    ContactViewController * VC = [[ContactViewController alloc] init];
    VC.navigationItem.title = Localized(@"NewContacts");
    [self.navigationController pushViewController:VC animated:NO];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH - SafeAreaBottomH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
//        _noData.backgroundColor = [UIColor blueColor];
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookModel * addressBookModel = self.listArray[indexPath.row];
    return addressBookModel.cellHeight;
//    return ScreenScale(130);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.listArray.count > 0) {
        return Margin_5;
    }
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    return nil;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    return ContentSizeBottom;
    return CGFLOAT_MIN;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddressBookListViewCell * cell = [AddressBookListViewCell cellWithTableView:tableView identifier:AddressBookCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.addressBookModel = self.listArray[indexPath.row];
//    if (_index == indexPath.row) {
//        cell.detailImage.hidden = NO;
//    } else {
//        cell.detailImage.hidden = YES;
//    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    AddressBookModel * addressBookModel = self.listArray[indexPath.row];
    NSArray * VCsArray = [self.navigationController viewControllers];
    if ([VCsArray[VCsArray.count - 2] isKindOfClass:[TransferAccountsViewController class]]) {
        [self.navigationController popViewControllerAnimated:NO];
        if (self.walletAddress != nil) {
            self.walletAddress(addressBookModel.linkmanAddress);
        }
    } else if ([VCsArray[VCsArray.count - 2] isKindOfClass:[MyViewController class]]) {
        ContactViewController * VC = [[ContactViewController alloc] init];
        VC.navigationItem.title = Localized(@"EditContact");
        VC.addressBookModel = self.listArray[indexPath.row];
        [self.navigationController pushViewController:VC animated:NO];
    }
//    NSIndexPath * lastIndex = [NSIndexPath indexPathForRow:_index inSection:indexPath.section];
//    AddressBookListViewCell * lastcell = [tableView cellForRowAtIndexPath:lastIndex];
//    lastcell.detailImage.hidden = YES;
//    AddressBookListViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell.detailImage.hidden = NO;
//    _index = indexPath.row;
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
