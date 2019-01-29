//
//  AddressBookViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/29.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "AddressBookViewController.h"
#import "AddressBookListViewCell.h"
#import "AddressBookModel.h"
#import "ContactViewController.h"
#import "MyViewController.h"
#import "TransferAccountsViewController.h"

@interface AddressBookViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UIView * noData;
//@property (nonatomic, assign) NSInteger index;

@end

static NSString * const AddressBookCellID = @"AddressBookCellID";

@implementation AddressBookViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupNav];
    [self setupView];
    AddressBookModel * addressBookModel = [[AddressBookModel alloc] init];
    addressBookModel.nickName = @"火币充值地址火币充值地址火币充值地址火币充值地址火币充值地址火币充值地址";
    addressBookModel.linkmanAddress = @"buQhSMWwbuQhSMWwbuQhSMWwbuQhSMWwbuQhSMWwbuQhSMWwbuQhSMWw4Bo73c8C";
    addressBookModel.remark = @"gatez交易所充值账户地址";
    self.listArray = @[addressBookModel];
    (self.listArray.count > 0) ? (self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, CGFLOAT_MIN)]) : (self.tableView.tableFooterView = self.noData);
    // Do any additional setup after loading the view.
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
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:self.noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        noDataBtn.hidden = NO;
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(130);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && self.listArray.count > 0) {
        return Margin_5;
    }
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
//    return ContentSizeBottom;
    return CGFLOAT_MIN;
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
