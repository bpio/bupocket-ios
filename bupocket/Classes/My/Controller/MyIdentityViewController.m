//
//  MyIdentityViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyIdentityViewController.h"
#import "IdentityViewController.h"
//#import "BackupMnemonicsViewController.h"
#import "BackUpWalletViewController.h"
#import "ClearCacheTool.h"
#import "YBPopupMenu.h"
#import "ListTableViewCell.h"

@interface MyIdentityViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@property (nonatomic, strong) YBPopupMenu *popupMenu;
@property (nonatomic, strong) CustomButton * identityIDTitle;

@end

@implementation MyIdentityViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"MyIdentity");
    self.listArray = @[@[Localized(@"IdentityNameTitle"), [[AccountTool shareTool] account].identityName], @[Localized(@"IdentityIDTitle"), [NSString stringEllipsisWithStr:[[AccountTool shareTool] account].identityAddress subIndex:SubIndex_Address]]];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self.view addSubview:self.tableView];
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
    return ContentSizeBottom + ScreenScale(200);
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200))];
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_30, MAIN_HEIGHT);
    
    UIButton * backupIdentity = [UIButton createButtonWithTitle:Localized(@"BackupIdentity") isEnabled:YES Target:self Selector:@selector(backupIdentityAction)];
    [footerView addSubview:backupIdentity];
    [backupIdentity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
        make.centerX.equalTo(footerView);
        make.size.mas_equalTo(btnSize);
    }];
    
    UIButton * exitID = [UIButton createButtonWithTitle:Localized(@"ExitCurrentIdentity") isEnabled:YES Target:self Selector:@selector(exitIDAction)];
    [exitID setTitleColor:WARNING_COLOR forState:UIControlStateNormal];
    exitID.backgroundColor = [UIColor whiteColor];
    [footerView addSubview:exitID];
    [exitID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backupIdentity.mas_bottom).offset(Margin_20);
        make.centerX.equalTo(footerView);
        make.size.mas_equalTo(btnSize);
    }];
    return footerView;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = self.listArray[indexPath.row][0];
    cell.detailTitle.text = self.listArray[indexPath.row][1];
    cell.detail.hidden = YES;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, Margin_50);
    cell.lineView.hidden = (indexPath.row == self.listArray.count - 1 );
    if (self.listArray.count - 1 == 0) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
    } else if (indexPath.row == 0) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
    } else if (indexPath.row == self.listArray.count - 1) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        cell.listImage.image = [UIImage imageNamed:@"explain_info"];
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    ListTableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 1) {
        [self identityIDInfo:cell.listImage];
    }
}
/*
- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"MyIdentity");
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)setupView
{
    self.view.backgroundColor = COLOR(@"F2F2F2");
    UIView * myIdentityBg = [[UIView alloc] initWithFrame:CGRectMake(Margin_15, Margin_10, DEVICE_WIDTH - Margin_30, ScreenScale(90))];
    myIdentityBg.backgroundColor = [UIColor whiteColor];
    [myIdentityBg setViewSize:myIdentityBg.size borderWidth:0 borderColor:nil borderRadius:BG_CORNER];
    [self.view addSubview:myIdentityBg];
    
    UILabel * IDNameTitle = [[UILabel alloc] init];
    IDNameTitle.font = FONT(15);
    IDNameTitle.textColor = COLOR_9;
    IDNameTitle.text = Localized(@"IdentityNameTitle");
    [myIdentityBg addSubview:IDNameTitle];
    UILabel * IDName = [[UILabel alloc] init];
    IDName.font = FONT(15);
    IDName.textColor = COLOR_6;
    IDName.text = [[AccountTool shareTool] account].identityName;
    [myIdentityBg addSubview:IDName];
    [IDNameTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [IDNameTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(myIdentityBg.mas_top).offset(Margin_15);
        make.left.equalTo(myIdentityBg.mas_left).offset(Margin_10);
        make.right.mas_lessThanOrEqualTo(IDName.mas_left).offset(-Margin_10);
    }];
    
    [IDName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNameTitle);
        make.right.equalTo(myIdentityBg.mas_right).offset(-Margin_10);
        make.left.mas_greaterThanOrEqualTo(IDNameTitle.mas_right).offset(Margin_10);
    }];
    
    self.identityIDTitle = [[CustomButton alloc] init];
    self.identityIDTitle.layoutMode = HorizontalInverted;
    self.identityIDTitle.titleLabel.font = IDNameTitle.font;
    [self.identityIDTitle setTitleColor:IDNameTitle.textColor forState:UIControlStateNormal];
    [self.identityIDTitle setTitle:Localized(@"IdentityIDTitle") forState:UIControlStateNormal];
    [self.identityIDTitle setImage:[UIImage imageNamed:@"explain_info"] forState:UIControlStateNormal];
    [self.identityIDTitle addTarget:self action:@selector(identityIDInfo:) forControlEvents:UIControlEventTouchUpInside];
    [myIdentityBg addSubview:self.identityIDTitle];
    
    UILabel * IdentityID = [[UILabel alloc] init];
    IdentityID.font = IDName.font;
    IdentityID.textColor = IDName.textColor;
    IdentityID.text = [NSString stringEllipsisWithStr:[[AccountTool shareTool] account].identityAddress subIndex:SubIndex_Address];
    IdentityID.numberOfLines = 0;
    IdentityID.textAlignment = NSTextAlignmentRight;
    [myIdentityBg addSubview:IdentityID];
    
    [self.identityIDTitle setContentCompressionResistancePriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
    [self.identityIDTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(IDNameTitle.mas_bottom).offset(Margin_25);
        make.left.equalTo(IDNameTitle);
        make.right.mas_lessThanOrEqualTo(IdentityID.mas_left).offset(-Margin_10);
    }];
    [IdentityID mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.identityIDTitle);
        make.right.equalTo(IDName);
        make.left.mas_greaterThanOrEqualTo(self.identityIDTitle.mas_right).offset(Margin_10);
    }];
    
 
}

 */
- (void)backupIdentityAction
{
    BackUpWalletViewController * VC = [[BackUpWalletViewController alloc] init];
    VC.mnemonicType = MnemonicBackup;
    [self.navigationController pushViewController:VC animated:NO];
    /*
    PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"IdentityCipherPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        if (words.count > 0) {
            BackupMnemonicsViewController * VC = [[BackupMnemonicsViewController alloc] init];
            VC.mnemonicArray = words;
            [self.navigationController pushViewController:VC animated:NO];
        }
        //        [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:VC];
    } cancelBlock:^{
        
    }];
    alertView.passwordType = PWTypeBackUpID;
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [alertView.PWTextField becomeFirstResponder];
     */
}
- (void)exitIDAction
{
    [Encapsulation showAlertControllerWithTitle:Localized(@"ExitCurrentID") message:Localized(@"ExitCurrentIdentityPrompt") cancelHandler:^(UIAlertAction *action) {
        
    } confirmHandler:^(UIAlertAction *action) {
        PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"IdentityCipherWarning") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
            [self exitIDData];
        } cancelBlock:^{
            
        }];
        alertView.passwordType = PWTypeExitID;
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
        [alertView.PWTextField becomeFirstResponder];
    }];
}
- (void)exitIDData
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [ClearCacheTool cleanCache:^{
            [ClearCacheTool cleanUserDefaults];
            [[AccountTool shareTool] clearCache];
            [[WalletTool shareTool] clearCache];
            //            [[LanguageManager shareInstance] setDefaultLocale];
            [[HTTPManager shareManager] initNetWork];
            // Minimum Asset Limitation
            [[HTTPManager shareManager] getBlockLatestFees];
            [[NSOperationQueue mainQueue] addOperationWithBlock:^{
                [MBProgressHUD hideHUD];
                [UIApplication sharedApplication].keyWindow.rootViewController = [[NavigationViewController alloc] initWithRootViewController:[[IdentityViewController alloc] init]];
            }];
        }];
    }];
}
- (void)identityIDInfo:(UIView *)view
{
    NSString * title = Localized(@"IdentityIDInfo");
    CGFloat titleHeight = [Encapsulation rectWithText:title font:FONT_TITLE textWidth:DEVICE_WIDTH - ScreenScale(120)].size.height;
    _popupMenu = [YBPopupMenu showRelyOnView:view titles:@[title] icons:nil menuWidth:DEVICE_WIDTH - ScreenScale(100) otherSettings:^(YBPopupMenu * popupMenu) {
        popupMenu.priorityDirection = YBPopupMenuPriorityDirectionTop;
        popupMenu.itemHeight = titleHeight + Margin_30;
        popupMenu.dismissOnTouchOutside = YES;
        popupMenu.dismissOnSelected = NO;
        popupMenu.fontSize = FONT_TITLE;
        popupMenu.textColor = [UIColor whiteColor];
        popupMenu.backColor = COLOR_POPUPMENU;
        popupMenu.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        popupMenu.tableView.scrollEnabled = NO;
        popupMenu.tableView.allowsSelection = NO;
        popupMenu.height = titleHeight + Margin_40;
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
