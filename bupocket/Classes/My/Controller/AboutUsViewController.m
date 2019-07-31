//
//  AboutUsViewController.m
//  bupocket
//
//  Created by bupocket on 2019/6/20.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "AboutUsViewController.h"
#import "ListTableViewCell.h"
#import "VersionModel.h"
#import "VersionLogViewController.h"
#import "VersionUpdateAlertView.h"
#import "CustomEnvironmentViewController.h"

@interface AboutUsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;
@property (nonatomic, strong) UISwitch * switchControl;
@property (nonatomic, strong) VersionModel * versionModel;
// Repeat click interval
@property (nonatomic, assign) NSTimeInterval acceptEventInterval;
// Last click timestamp
@property (nonatomic, assign) NSTimeInterval acceptEventTime;

@property (nonatomic, assign) NSInteger touchCounter;

// Repeat click interval
@property (nonatomic, assign) NSTimeInterval acceptEventIntervalCustom;
// Last click timestamp
@property (nonatomic, assign) NSTimeInterval acceptEventTimeCustom;

@property (nonatomic, assign) NSInteger touchCounterCustom;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"AboutUs");
    self.touchCounter = 0;
    self.touchCounterCustom = 0;
//    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:If_Show_Switch_Network];
//    [defaults removeObjectForKey:If_Show_Custom_Network];
    [self setupView];
    [self setData];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.switchControl.enabled = ![defaults boolForKey:If_Custom_Network];
    [self getVersionData];
}
- (void)setData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Show_Switch_Network] && [defaults boolForKey:If_Show_Custom_Network]) {
        self.listArray = @[@[Localized(@"VersionLog"), Localized(@"VersionUpdate")], @[Localized(@"SwitchedNetwork")], @[Localized(@"CustomEnvironment")]];
    } else if ([defaults boolForKey:If_Show_Switch_Network]) {
        self.listArray = @[@[Localized(@"VersionLog"), Localized(@"VersionUpdate")], @[Localized(@"SwitchedNetwork")]];
    } else if ([defaults boolForKey:If_Show_Custom_Network]) {
        self.listArray = @[@[Localized(@"VersionLog"), Localized(@"VersionUpdate")],  @[Localized(@"CustomEnvironment")]];
    } else {
        self.listArray = @[@[Localized(@"VersionLog"), Localized(@"VersionUpdate")]];
    }
    [self.tableView reloadData];
}
- (void)getVersionData
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    self.versionModel  = [VersionModel mj_objectWithKeyValues:[defaults objectForKey:Version_Info]];
    [self.tableView reloadData];
//    [[HTTPManager shareManager] getVersionDataWithSuccess:^(id responseObject) {
//        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
//        if (code == Success_Code) {
//            self.versionModel  = [VersionModel mj_objectWithKeyValues:[responseObject objectForKey:@"data"]];
//            [self.tableView reloadData];
//        } else {
////            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
//        }
//    } failure:^(NSError *error) {
//
//    }];
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
    UIButton * icon = [UIButton createButtonWithNormalImage:@"about_us_logo" SelectedImage:@"about_us_logo" Target:self Selector:@selector(SwitchingNetwork)];
    [headerView addSubview:icon];
    CGSize iconSize = CGSizeMake(ScreenScale(70), ScreenScale(70));
    [icon setViewSize:iconSize borderWidth:0 borderColor:nil borderRadius:Margin_15];
    [icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(headerView.mas_top).offset(Margin_50);
        make.centerX.equalTo(headerView);
        make.size.mas_equalTo(iconSize);
    }];
    UIButton * currentVersion = [UIButton createButtonWithTitle:[NSString stringWithFormat:Localized(@"Current version: V%@"), App_Version] TextFont:FONT_15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
    [headerView addSubview:currentVersion];
    [currentVersion mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(icon.mas_bottom).offset(Margin_15);
        make.centerX.equalTo(headerView);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_30);
    }];
    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200));
    self.tableView.tableHeaderView = headerView;

    
//    CustomButton * currentVersion = [[CustomButton alloc] init];
//    currentVersion.layoutMode = VerticalNormal;
//    [currentVersion setTitleColor:COLOR_6 forState:UIControlStateNormal];
//    currentVersion.titleLabel.font = FONT_15;
//    [currentVersion setTitle:[NSString stringWithFormat:Localized(@"Current version: %@"), App_Version] forState:UIControlStateNormal];
//    [currentVersion setImage:[UIImage imageNamed:@"about_us_logo"] forState:UIControlStateNormal];
//    [currentVersion addTarget:self action:@selector(SwitchingNetwork) forControlEvents:UIControlEventTouchUpInside];
//    headerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200));
//    self.tableView.tableHeaderView = headerView;
//    [headerView addSubview:currentVersion];
//    [currentVersion mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.centerY.equalTo(headerView);
//        make.left.equalTo(headerView.mas_left).offset(Margin_15);
//        make.right.equalTo(headerView.mas_right).offset(-Margin_15);
//        make.height.mas_equalTo(ScreenScale(130));
//    }];
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
        [cell.detail setImage:nil forState:UIControlStateNormal];
        if (NotNULLString(self.versionModel.verNumber)) {
            BOOL result = [App_Version compare:self.versionModel.verNumber] == NSOrderedAscending;
            NSString * isNewVersion = !result ? @"" : @"• ";
            NSAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@V%@", isNewVersion, self.versionModel.verNumber] preFont:FONT_TITLE preColor:WARNING_COLOR index:isNewVersion.length sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:0];
            [cell.detail setAttributedTitle:attr forState:UIControlStateNormal];
        }
    } else if ([cell.title.text isEqualToString:Localized(@"SwitchedNetwork")]) {
        cell.detail.hidden = YES;
        [cell.contentView addSubview:self.switchControl];
        [_switchControl setOn:[[NSUserDefaults standardUserDefaults] boolForKey:If_Switch_TestNetwork] animated:YES];
        [_switchControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(cell.contentView);
            make.right.equalTo(cell.contentView.mas_right).offset(-Margin_Main);
        }];
    } else {
        cell.detail.hidden = NO;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.lineView.hidden = indexPath.row == [self.listArray[indexPath.section] count] - 1;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            VersionLogViewController * VC = [[VersionLogViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            BOOL result = [App_Version compare:self.versionModel.verNumber] == NSOrderedAscending;
            if (result) {
                NSString * updateContent = nil;
                if ([CurrentAppLanguage hasPrefix:ZhHans]) {
                    updateContent = self.versionModel.verContents;
                } else {
                    updateContent = self.versionModel.englishVerContents;
                }
                /*
                NSAttributedString * attr = [Encapsulation attrWithString:[NSString stringWithFormat:Localized(@"NewVersionContent%@"), updateContent] preFont:FONT_15 preColor:TITLE_COLOR index:8 sufFont:FONT_TITLE sufColor:COLOR_6 lineSpacing:Margin_10];
                [Encapsulation showAlertControllerWithTitle:[NSString stringWithFormat: Localized(@"NewVersionTitle%@"), self.versionModel.verNumber]  messageAttr:attr cancelHandler:^(UIAlertAction *action) {
                    
                } confirmHandler:^(UIAlertAction *action) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionModel.downloadLink]];
                    
                }];
                 */
                VersionUpdateAlertView * alertView = [[VersionUpdateAlertView alloc] initWithUpdateVersionNumber:self.versionModel.verNumber versionSize:self.versionModel.appSize content:updateContent verType:self.versionModel.verType confrimBolck:^{
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:self.versionModel.downloadLink]];
                } cancelBlock:^{
                    
                }];
                [alertView showInWindowWithMode:CustomAnimationModeDisabled inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
            }
        }
    } else if ([cell.title.text isEqualToString:Localized(@"SwitchedNetwork")]) {
        [self showCustomEnvironment];
    } else if ([cell.title.text isEqualToString:Localized(@"CustomEnvironment")]) {
        CustomEnvironmentViewController * VC = [[CustomEnvironmentViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (UISwitch *)switchControl
{
    if (!_switchControl) {
        _switchControl = [[UISwitch alloc] init];
        [_switchControl addTarget:self action:@selector(switchChange:) forControlEvents:UIControlEventValueChanged];
    }
    return _switchControl;
}
- (void)switchChange:(UISwitch *)sender
{
    NSString * message = Localized(@"OpenedTestNetwork");
    if (sender.on == NO) {
        message = Localized(@"ClosedTestNetwork");
    }
    [Encapsulation showAlertControllerWithMessage:message handler:^ {
        [[HTTPManager shareManager] SwitchedNetworkWithIsTest:sender.on];
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
    }];
}

- (void)SwitchingNetwork {
    if ([[NSUserDefaults standardUserDefaults] boolForKey:If_Show_Switch_Network]) return;
    if (self.acceptEventInterval <= 0) {
        self.acceptEventInterval = 2;
    }
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.acceptEventTime >= self.acceptEventInterval);
    if (self.acceptEventInterval > 0) {
        self.acceptEventTime = NSDate.date.timeIntervalSince1970;
    }
    if (!needSendAction) {
        self.touchCounter += 1;
    } else {
        self.touchCounter = 0;
    }
    if (self.touchCounter == 4) {
        self.touchCounter = 0;
        NSString * title = Localized(@"SwitchToTestNetwork");
        [Encapsulation showAlertControllerWithTitle:title message:nil confirmHandler:^{
            [[HTTPManager shareManager] SwitchedNetworkWithIsTest:YES];
            [self setData];
        }];
        /*
        NSString * message = Localized(@"SwitchToTestNetwork");
        UIAlertController * alertController = [UIAlertController alertControllerWithTitle:message message:nil preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction * cancelAction = [UIAlertAction actionWithTitle:Localized(@"NO") style:UIAlertActionStyleDefault handler:nil];
        [alertController addAction:cancelAction];
        UIAlertAction * okAction = [UIAlertAction actionWithTitle:Localized(@"YES") style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [[HTTPManager shareManager] SwitchedNetworkWithIsTest:YES];
            [self setData];
        }];
        [alertController addAction:okAction];
        [self presentViewController:alertController animated:YES completion:nil];
         */
    }
}
- (void)showCustomEnvironment
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if (![defaults boolForKey:If_Show_Switch_Network]) return;
    if ([defaults boolForKey:If_Show_Custom_Network]) return;
    
    if (self.acceptEventIntervalCustom <= 0) {
        self.acceptEventIntervalCustom = 2;
    }
    BOOL needSendAction = (NSDate.date.timeIntervalSince1970 - self.acceptEventTimeCustom >= self.acceptEventIntervalCustom);
    if (self.acceptEventIntervalCustom > 0) {
        self.acceptEventTimeCustom = NSDate.date.timeIntervalSince1970;
    }
    if (!needSendAction) {
        self.touchCounterCustom += 1;
    } else {
        self.touchCounterCustom = 0;
    }
    if (self.touchCounterCustom == 4) {
        self.touchCounterCustom = 0;
        [[HTTPManager shareManager] ShowCustomNetwork];
        [self setData];
    }
}
- (BOOL)gestureRecognizer:(UIGestureRecognizer*)gestureRecognizer shouldReceiveTouch:(UITouch*)touch {
    if([NSStringFromClass([touch.view class])isEqual:@"UITableViewCellContentView"]){
        return YES;
    }
    return NO;
}
- (NSTimeInterval)acceptEventInterval
{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventInterval") doubleValue];
}
- (void)setAcceptEventInterval:(NSTimeInterval)acceptEventInterval
{
    objc_setAssociatedObject(self, "UIControl_acceptEventInterval", @(acceptEventInterval), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (NSTimeInterval)acceptEventTime
{
    return [objc_getAssociatedObject(self, "UIControl_acceptEventTime") doubleValue];
}
- (void)setAcceptEventTime:(NSTimeInterval)acceptEventTime
{
    objc_setAssociatedObject(self, "UIControl_acceptEventTime", @(acceptEventTime), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
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
