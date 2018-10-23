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

static NSString * const TransferResultsCellID = @"TransferResultsCellID";

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    self.listArray = @[@[Localized(@"reciprocalAccount"), Localized(@"amountOfTransfer"), Localized(@"TransactionCost"), Localized(@"Remarks"), Localized(@"TransferTime")], @[@"buQs9npaCq9mNFZG18qu88ZcmXYqd6bqpTU3", @"100 BU", @"0.01 BU", @"转账", @"2018-09-08 14:22"]];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, NavBarH, DEVICE_WIDTH, DEVICE_HEIGHT - NavBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    CustomButton * transferResults = [[CustomButton alloc] init];
    transferResults.layoutMode = VerticalNormal;
    [transferResults setTitle:Localized(@"TransferSuccess") forState:UIControlStateNormal];
    // TransferFailure
    [transferResults setTitleColor:COLOR(@"666666") forState:UIControlStateNormal];
    transferResults.titleLabel.font = FONT(16);
    [transferResults setImage:[UIImage imageNamed:@"TransferSuccess"] forState:UIControlStateNormal];
    transferResults.bounds = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(120));
    transferResults.backgroundColor = [UIColor whiteColor];
    self.tableView.tableHeaderView = transferResults;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return ScreenScale(10);
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        return ScreenScale(70);
    } else {
        return ScreenScale(40);
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
    DetailListViewCell * cell = [DetailListViewCell cellWithTableView:tableView];
    cell.title.text = self.listArray[0][indexPath.row];
    cell.infoTitle.text = self.listArray[1][indexPath.row];
    return cell;
    /*
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:TransferResultsCellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:TransferResultsCellID];;
    }
    cell.textLabel.text = self.listArray[0][indexPath.row];
    cell.textLabel.font = FONT(15);
    cell.textLabel.textColor = COLOR(@"999999");
    cell.detailTextLabel.font = FONT(15);
    cell.detailTextLabel.textColor = COLOR(@"666666");
    cell.detailTextLabel.textAlignment = NSTextAlignmentRight;
    cell.detailTextLabel.preferredMaxLayoutWidth = ScreenScale(205);
    
    cell.detailTextLabel.text = self.listArray[1][indexPath.row];
    return cell;
     */
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
