//
//  NodePlanViewController.m
//  bupocket
//
//  Created by huoss on 2019/3/21.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "NodePlanViewController.h"
#import "NodePlanViewCell.h"
#import "YBPopupMenu.h"
#import "VotingRecordsViewController.h"
#import "CancellationOfVotingAlertView.h"

@interface NodePlanViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, YBPopupMenuDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UITextField * searchTextField;
@property (nonatomic, strong) YBPopupMenu *popupMenu;
@property (nonatomic, strong) YBPopupMenu * operationsMenu;
@property (nonatomic, assign) NSInteger index;

@end

static NSString * const NodePlanCellID = @"NodePlanCellID";

@implementation NodePlanViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"NodePlan");
    [self.listArray addObjectsFromArray:@[@"", @"", @"", @"", @"", @"", @"", @"", @""]];
    [self setupNav];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupNav
{
    UIButton * votingRecords = [UIButton createButtonWithNormalImage:@"nav_records_n" SelectedImage:@"nav_votingRecords_n" Target:self Selector:@selector(votingRecordsAction)];
    votingRecords.frame = CGRectMake(0, 0, ScreenScale(44), ScreenScale(44));
    votingRecords.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:votingRecords];
}
- (void)votingRecordsAction
{
    VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
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
    if (section == 0) {
        return ScreenScale(50);
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT)];
        UIButton * interdependentNode = [UIButton createButtonWithTitle:[NSString stringWithFormat:@"  %@", Localized(@"InterdependentNode")] TextFont:14 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 NormalImage:@"interdependent_node_n" SelectedImage:@"interdependent_node_s" Target:self Selector:@selector(interdependentNodeAction:)];
        interdependentNode.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [headerView addSubview:interdependentNode];
        CGFloat interdependentNodeW = [Encapsulation rectWithText:Localized(@"InterdependentNode") font:FONT(13) textHeight:MAIN_HEIGHT].size.width + Margin_30;
        [interdependentNode mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(headerView.mas_left).offset(Margin_10);
            make.top.bottom.equalTo(headerView);
            make.width.mas_equalTo(interdependentNodeW);
        }];
        UIButton * infoBtn = [UIButton createButtonWithNormalImage:@"interdependent_node_explain" SelectedImage:@"interdependent_node_explain" Target:self Selector:@selector(infoAction:)];
        [headerView addSubview:infoBtn];
        infoBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        [infoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(interdependentNode.mas_right).offset(Margin_5);
            make.top.bottom.equalTo(headerView);
            make.width.mas_equalTo(Margin_30);
        }];
        
        _searchTextField = [[UITextField alloc] init];
        _searchTextField.placeholder = Localized(@"InputAssetName");
        _searchTextField.font = FONT(11);
        _searchTextField.textColor = TITLE_COLOR;
        _searchTextField.delegate = self;
        _searchTextField.tintColor = MAIN_COLOR;
        _searchTextField.clearButtonMode = UITextFieldViewModeWhileEditing;
        _searchTextField.returnKeyType = UIReturnKeySearch;
        [_searchTextField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
        _searchTextField.placeholder = Localized(@"Search");
        _searchTextField.layer.masksToBounds = YES;
        _searchTextField.layer.cornerRadius = TAG_CORNER;
        _searchTextField.layer.borderWidth = 0.5;
        _searchTextField.layer.borderColor = COLOR(@"D2D2D2").CGColor;
        [headerView addSubview:_searchTextField];
        [_searchTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(headerView.mas_right).offset(-Margin_10);
            make.centerY.equalTo(interdependentNode);
            make.size.mas_equalTo(CGSizeMake(ScreenScale(73), Margin_20));
        }];
        
        UIButton * searchBtn = [UIButton createButtonWithNormalImage:@"node_search" SelectedImage:@"node_search" Target:self Selector:@selector(searchAction)];
        _searchTextField.leftViewMode = UITextFieldViewModeAlways;
        _searchTextField.leftView = searchBtn;
        searchBtn.size = CGSizeMake(Margin_20, Margin_20);
//        [searchBtn mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.top.bottom.equalTo(self->_searchTextField);
//            make.width.mas_equalTo(Margin_20);
//        }];
        
        return headerView;
    } else {
        return nil;
    }
}
- (void)interdependentNodeAction:(UIButton *)button
{
    button.selected = !button.selected;
}
- (void)infoAction:(UIButton *)button
{
    NSString * title = Localized(@"IdentityIDInfo");
    CGFloat titleHeight = [Encapsulation rectWithText:title font:TITLE_FONT textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:button.imageView titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(100) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = TITLE_FONT;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR(@"56526D");
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = NO;
        popupMenu.height = titleHeight + Margin_40;
    }];
}
- (void)searchAction
{
    [self.searchTextField resignFirstResponder];
//    if (self.searchText.length > 0) {
//        if (!self.tableView.mj_header) {
//            [self setupRefresh];
//        } else {
//            [self.tableView.mj_header beginRefreshing];
//        }
//    }
}
- (void)textChange:(UITextField *)textField
{
//    self.searchText = [self.searchTextField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self searchAction];
    return YES;
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
    return ScreenScale(85);
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NodePlanViewCell * cell = [NodePlanViewCell cellWithTableView:tableView identifier:NodePlanCellID];
//    cell.searchAssetsModel = self.listArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.operationClick = ^(UIButton * _Nonnull btn) {
        btn.tag = indexPath.section;
        [self setupOperation: btn];
    };
    return cell;
}
- (void)setupOperation:(UIButton *)button
{
    //    CGFloat titleHeight = [Encapsulation rectWithText:title font:TITLE_FONT textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    self.index = button.tag;
    NSArray * titles = @[Localized(@"CancellationOfVotes"), Localized(@"VotingRecords")];
    NSString * title;
    for (NSString * str in titles) {
        if (title.length < str.length) {
            title = str;
        }
    }
    CGFloat menuW = [Encapsulation rectWithText:title font:TITLE_FONT textHeight:Margin_15].size.width + ScreenScale(65);
    _operationsMenu = [YBPopupMenu showRelyOnView:button titles:titles icons:@[@"cancellationOfVotes", @"votingRecords"] menuWidth:menuW otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = Margin_50;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = YES;
        popupMenu.fontSize = TITLE_FONT;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR(@"56526D");
//        popupMenu.tableView.scrollEnabled = NO;
//        popupMenu.tableView.allowsSelection = NO;
        popupMenu.delegate = self;
        popupMenu.showMaskView = NO;
    }];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
- (void)ybPopupMenu:(YBPopupMenu *)ybPopupMenu didSelectedAtIndex:(NSInteger)index
{
    if (index == 0) {
        CancellationOfVotingAlertView * alertView = [[CancellationOfVotingAlertView alloc] initWithText:@"撤销" confrimBolck:^(NSString * _Nonnull text) {
            
        } cancelBlock:^{
            
        }];
         [alertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    } else if (index == 1) {
        VotingRecordsViewController * VC = [[VotingRecordsViewController alloc] init];
        VC.str = [NSString stringWithFormat:@"第%zd个节点，%@ %zd", self.index, ybPopupMenu.titles[index], index];
        [self.navigationController pushViewController:VC animated:NO];
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
