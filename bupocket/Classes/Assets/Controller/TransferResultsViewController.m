//
//  TransferResultsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferResultsViewController.h"
#import "DetailListViewCell.h"

@interface TransferResultsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation TransferResultsViewController

static NSString * const TransferResultsCellID = @"DetailListCellID";


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.listArray = @[@[Localized(@"reciprocalAccount"), Localized(@"amountOfTransfer"), Localized(@"TransactionCost"), Localized(@"Remarks"), Localized(@"TransferTime")], self.transferInfoArray];
    [self popToRootVC];
    // Do any additional setup after loading the view.
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
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    CustomButton * transferResults = [[CustomButton alloc] init];
    transferResults.layoutMode = VerticalNormal;
    [transferResults setTitleColor:COLOR_6 forState:UIControlStateNormal];
    transferResults.titleLabel.font = FONT(16);
    if (self.state == YES) {
        [transferResults setTitle:Localized(@"TransferSuccess") forState:UIControlStateNormal];
        [transferResults setImage:[UIImage imageNamed:@"TransferSuccess"] forState:UIControlStateNormal];
    } else {
        [transferResults setTitle:Localized(@"TransferFailure") forState:UIControlStateNormal];
        [transferResults setImage:[UIImage imageNamed:@"TransferFailure"] forState:UIControlStateNormal];
    }
    transferResults.bounds = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(120));
    transferResults.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = transferResults;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SafeAreaBottomH + NavBarH + Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return ScreenScale(70);
    } else {
        return MAIN_HEIGHT;
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self.listArray firstObject] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView identifier:TransferResultsCellID];
    cell.title.text = self.listArray[0][indexPath.row];
    if (indexPath.row == [self.listArray[0] count] - 2) {
        cell.infoTitle.text = ([self.listArray[0] count] != [self.listArray[1] count]) ? @"" : self.listArray[1][indexPath.row];
    } else if (indexPath.row == [self.listArray[0] count] - 1) {
        cell.infoTitle.text = [self.listArray[1] lastObject];
    } else {
        cell.infoTitle.text = self.listArray[1][indexPath.row];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
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
