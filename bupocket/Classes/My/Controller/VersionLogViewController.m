//
//  VersionLogViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/20.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "VersionLogViewController.h"
#import "VersionModel.h"

@interface VersionLogViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) NSMutableArray * cellHeightArray;
@property (nonatomic, strong) UIView * noData;
@property (nonatomic, assign) NSInteger pageindex;
@property (nonatomic, strong) UIView * noNetWork;

@end

static NSString * const VersionLogCellID = @"VersionLogCellID";

@implementation VersionLogViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}
- (NSMutableArray *)cellHeightArray
{
    if (!_cellHeightArray) {
        _cellHeightArray = [NSMutableArray array];
    }
    return _cellHeightArray;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"VersionLog");
    [self setupView];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
    [self setupRefresh];
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
    [self getDataWithPageindex: PageIndex_Default];
}
- (void)loadMoreData
{
    [self getDataWithPageindex:self.pageindex];
}
- (void)getDataWithPageindex:(NSInteger)pageindex
{
    [[HTTPManager shareManager] getVersionLogDataWithPageIndex:pageindex success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSArray * listArray = [VersionModel mj_objectArrayWithKeyValuesArray:responseObject[@"data"] [@"logList"]];
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
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
}
- (UIView *)noData
{
    if (!_noData) {
        CGFloat noDataH = DEVICE_HEIGHT - NavBarH - SafeAreaBottomH;
        _noData = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, noDataH)];
        UIButton * noDataBtn = [Encapsulation showNoDataWithTitle:Localized(@"NoRecord") imageName:@"noRecord" superView:_noData frame:CGRectMake(0, (noDataH - ScreenScale(160)) / 2, DEVICE_WIDTH, ScreenScale(160))];
        [_noData addSubview:noDataBtn];
    }
    return _noData;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    VersionModel * versionModel = self.listArray[indexPath.row];
    NSString * updateContent;
    if ([CurrentAppLanguage hasPrefix:ZhHans]) {
        updateContent = versionModel.verContents;
    } else {
        updateContent = versionModel.englishVerContents;
    }
    CGFloat cellHeight = [Encapsulation getSizeSpaceLabelWithStr:updateContent font:FONT_TITLE width:(DEVICE_WIDTH - Margin_30) height:CGFLOAT_MAX lineSpacing:Margin_10].height + ScreenScale(60);
    return cellHeight == 0 ? ScreenScale(120) : cellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return ContentSizeBottom;
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
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:VersionLogCellID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:VersionLogCellID];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    VersionModel * versionModel = self.listArray[indexPath.row];
    NSString * version = [NSString stringWithFormat:@"V%@ （%@）", versionModel.verNumber, [DateTool getDateStringWithTimeStr:versionModel.createTime]];
    cell.detailTextLabel.numberOfLines = 0;
    NSString * updateContent;
    if ([CurrentAppLanguage hasPrefix:ZhHans]) {
        updateContent = versionModel.verContents;
    } else {
        updateContent = versionModel.englishVerContents;
    }
    if (NotNULLString(version)) {
        cell.textLabel.attributedText = [Encapsulation attrWithString:version preFont:FONT(17) preColor:TITLE_COLOR index:0 sufFont:FONT(17) sufColor:TITLE_COLOR lineSpacing:Margin_10];
    }
    if (NotNULLString(updateContent)) {
        //    CGSize maximumSize = CGSizeMake(DEVICE_WIDTH - ScreenScale(80), CGFLOAT_MAX);
        //    CGSize expectSize = [prompt.titleLabel sizeThatFits:maximumSize];
        //    prompt.size = expectSize;
        cell.detailTextLabel.attributedText = [Encapsulation attrWithString:updateContent preFont:FONT_TITLE preColor:COLOR_6 index:0 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_10];
    }
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
