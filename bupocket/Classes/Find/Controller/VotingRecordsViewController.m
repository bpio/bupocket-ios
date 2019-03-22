//
//  VotingRecordsViewController.m
//  bupocket
//
//  Created by huoss on 2019/3/22.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "VotingRecordsViewController.h"
#import "NodePlanViewCell.h"
#import "VotingRecordsViewCell.h"

@interface VotingRecordsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@end

static NSString * const NodeCellID = @"NodeCellID";
static NSString * const NodeRecordsCellID = @"NodeRecordsCellID";
static NSString * const VotingRecordsCellID = @"VotingRecordsCellID";

@implementation VotingRecordsViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"VotingRecords");
    [self.listArray addObjectsFromArray:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 && !self.str) {
        return Margin_5;
    } else if (self.str && section == 1) {
        return MAIN_HEIGHT;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.str && section == 1) {
        UIButton * title = [UIButton createButtonWithTitle:Localized(@"VotingRecords") TextFont:13 TextNormalColor:COLOR_9 TextSelectedColor:COLOR_9 Target:nil Selector:nil];
        title.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_10, 0, 0);
        title.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        return title;
    } else {
        return nil;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return SafeAreaBottomH + NavBarH;
    } else {
        return CGFLOAT_MIN;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.str && indexPath.section == 0) {
        return ScreenScale(85);
    } else {
        return ScreenScale(105);
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.str && indexPath.section == 0) {
        NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodeCellID];
        //    cell.searchAssetsModel = self.listArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.moreOperations.hidden = YES;
        return cell;
    } else {
        NSString * cellID = VotingRecordsCellID;
        if (self.str) {
            cellID = NodeRecordsCellID;
        }
        VotingRecordsViewCell * cell = [VotingRecordsViewCell cellWithTableView:tableView identifier:cellID];
        //    cell.searchAssetsModel = self.listArray[indexPath.row];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        return cell;
    }
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
