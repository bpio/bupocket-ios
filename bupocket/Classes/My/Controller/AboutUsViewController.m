//
//  AboutUsViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/20.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ListTableViewCell.h"
#import "VersionModel.h"
#import "VersionLogViewController.h"
#import "VersionUpdateAlertView.h"

@interface AboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UISwitch * switchControl;
@property (nonatomic, strong) VersionModel * versionModel;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"AboutUs");
    [self setupView];
    
    self.listArray = @[@[Localized(@"VersionLog"), Localized(@"VersionUpdate")], @[Localized(@"SwitchedNetwork")], @[Localized(@"CustomEnvironment")]];
    [self getVersionData];
    // Do any additional setup after loading the view.
}
- (void)getVersionData
{
    [[HTTPManager shareManager] getVersionDataWithSuccess:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            self.versionModel  = [VersionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
            [self.tableView reloadData];
        } else {
//            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
    } failure:^(NSError *error) {
        
    }];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorInset = UIEdgeInsetsZero;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
}
- (void)setupHeaderView
{
    UIView * headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor whiteColor];
    CustomButton * currentVersion = [[CustomButton alloc] init];
    currentVersion.layoutMode = VerticalNormal;
    [currentVersion setTitleColor:COLOR_6 forState:UIControlStateNormal];
    currentVersion.titleLabel.font = FONT_15;
    [currentVersion setTitle:[NSString stringWithFormat:Localized(@"Current version: %@"), App_Version] forState:UIControlStateNormal];
    [currentVersion setImage:[UIImage imageNamed:@"about_us_logo"] forState:UIControlStateNormal];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200));
    self.tableView.tableHeaderView = headerView;
    [headerView addSubview:currentVersion];
    [currentVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView);
        make.left.equalTo(headerView.mas_left).offset(Margin_15);
        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(ScreenScale(130));
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return Margin_50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == self.listArray.count - 1) {
        return ContentSizeBottom;
    }
    return CGFLOAT_MIN;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.listArray.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.listArray[section] count];
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeWalletDetail];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.detail.hidden = NO;
        [cell.detail setImage:[UIImage imageNamed:@""] forState:UIControlStateNormal];
        BOOL result = [App_Version compare:self.versionModel.verNumber] == NSOrderedAscending;
        NSString * isNewVersion = !result ? @"" : @"• ";
        NSAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@V%@", isNewVersion, self.versionModel.verNumber] preFont:FONT(15) preColor:WARNING_COLOR index:isNewVersion.length sufFont:FONT(15) sufColor:COLOR_6 lineSpacing:0];
        [cell.detail setAttributedTitle:attr forState:UIControlStateNormal];
    } else if (indexPath.section == 1 && indexPath.row == 0) {
        cell.detail.hidden = YES;
        [cell.contentView addSubview:self.switchControl];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin_20);
        }];
    } else {
        cell.detail.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, Margin_50);
    if (indexPath.row == 0) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        cell.lineView.hidden = NO;
    } else if (indexPath.row == [self.listArray[indexPath.section] count] - 1) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        cell.lineView.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VersionLogViewController * VC = [[VersionLogViewController alloc] init];
            [self.navigationController pushViewController:VC animated:NO];
        } else if (indexPath.row == 1) {
             BOOL result = [App_Version compare:self.versionModel.verNumber] == NSOrderedAscending;
             if (result) {
             NSString * updateContent = nil;
             if ([CurrentAppLanguage hasPrefix:ZhHans]) {
             updateContent = self.versionModel.verContents;
             } else {
             updateContent = self.versionModel.englishVerContents;
             }
             NSAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:Localized(@"NewVersionContent%@"), updateContent] preFont:FONT_15 preColor:TITLE_COLOR index:8 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_10];
             [Encapsulation showAlertControllerWithTitle:[NSString stringWithFormat: Localized(@"NewVersionTitle%@"), self.versionModel.verNumber]  messageAttr:attr cancelHandler:^(UIAlertAction *action) {
             
             } confirmHandler:^(UIAlertAction *action) {
             [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionModel.downloadLink]];
             
             }];
             }
            //                VersionUpdateAlertView * alertView = [[VersionUpdateAlertView alloc] initWithUpdateVersionNumber:self.versionModel.verNumber versionSize:self.versionModel.appSize content:updateContent verType:self.versionModel.verType confrimBolck:^{
            //                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionModel.downloadLink]];
            //                } cancelBlock:^{
            //
            //                }];
            //                [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        }
    } else if (indexPath.section == 2) {
        
    }
}
- (UISwitch *)switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
        [_switchControl setOn:[[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork] animated:YES];
    }
    return _switchControl;
}
- (void)switchChange:(UISwitch *)sender
{
    NSString * message = Localized(@"OpenedTestNetwork");
    if (sender.on == NO) {
        message = Localized(@"ClosedTestNetwork");
    }
    [Encapsulation showAlertControllerWithMessage:message handler:^(UIAlertAction *action) {
        [[HTTPManager shareManager] SwitchedNetworkWithIsTest:sender.on];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
    }];
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
