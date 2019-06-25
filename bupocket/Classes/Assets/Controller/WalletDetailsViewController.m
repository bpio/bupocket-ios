//
//  WalletDetailsViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/18.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "WalletDetailsViewController.h"
#import "WalletManagementViewController.h"
#import "ListTableViewCell.h"
#import "ModifyAlertView.h"
#import "ModifyIconAlertView.h"

@interface WalletDetailsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSArray * listArray;

@end

@implementation WalletDetailsViewController

- (NSMutableArray *)walletArray
{
    if (!_walletArray) {
        _walletArray = [NSMutableArray array];
    }
    return _walletArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"WalletDetails");
    [self setupView];
    self.listArray = @[Localized(@"ChangeWalletIcon"), Localized(@"ModifyWalletName")];
    // Do any additional setup after loading the view.
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (self.returnValueBlock) {
        self.returnValueBlock(self.walletIcon, self.walletModel.walletName);
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
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(55);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return Margin_10;
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
    ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeWalletDetail];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.title.text = self.listArray[indexPath.row];
    if (indexPath.row == 0) {
        cell.listImage.image = self.walletIcon;
    } else if (indexPath.row == 1) {
        cell.detailTitle.text = self.walletModel.walletName;
    }
//    cell.detailImage.image = [UIImage imageNamed:@"list_arrow"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGSize cellSize = CGSizeMake(DEVICE_WIDTH - Margin_20, ScreenScale(55));
    if (indexPath.row == 0) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerTopLeft | UIRectCornerTopRight];
        cell.lineView.hidden = NO;
    } else if (indexPath.row == self.listArray.count - 1) {
        [cell.listBg setViewSize:cellSize borderRadius:BG_CORNER corners:UIRectCornerBottomLeft | UIRectCornerBottomRight];
        cell.lineView.hidden = YES;
    }
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        ModifyIconAlertView * alertView = [[ModifyIconAlertView alloc] initWithTitle:@"选择头像" confrimBolck:^(NSString * _Nonnull text) {
            
        } cancelBlock:^{
            
        }];
        [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    } else if (indexPath.row == self.listArray.count - 1) {
        [self modifyWalletNameWithIndexPath:indexPath];
    }
}
- (void)modifyWalletNameWithIndexPath:(NSIndexPath *)indexPath
{
    ListTableViewCell * cell = [self.tableView cellForRowAtIndexPath:indexPath];
    ModifyAlertView * alertView = [[ModifyAlertView alloc] initWithTitle:Localized(@"ModifyWalletName") placeholder:Localized(@"EnterWalletName") modifyType:ModifyTypeWalletName confrimBolck:^(NSString * _Nonnull text) {
        if ([RegexPatternTool validateUserName:text]) {
            cell.detailTitle.text = text;
            if ([self.walletModel.walletAddress isEqualToString:[[[AccountTool shareTool] account] walletAddress]]) {
                self.walletModel.walletName = text;
                AccountModel * account = [[AccountModel alloc] init];
                account = [[AccountTool shareTool] account];
                account.walletName = text;
                [[AccountTool shareTool] save:account];
                NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
                [defaults setObject:text forKey:Current_WalletName];
                [defaults synchronize];
            } else {
                self.walletModel.walletName = text;
                [self.walletArray replaceObjectAtIndex:self.index withObject:self.walletModel];
                [[WalletTool shareTool] save:self.walletArray];
//                for (NSInteger i = 0; i < self.walletArray.count; i++) {
//                    WalletModel * walletModel = self.walletArray[i];
//                    if ([walletModel.walletAddress isEqualToString:self.walletModel.walletAddress]) {
//                        self.walletModel.walletName = text;
//                        [self.walletArray replaceObjectAtIndex:i withObject:self.walletModel];
//                        [[WalletTool shareTool] save:self.walletArray];
//                    }
//                }
//                NSInteger index = [[[WalletTool shareTool] walletArray] indexOfObject:self.walletModel];
            }
        } else {
            [MBProgressHUD showTipMessageInWindow:Localized(@"WalletNameFormatIncorrect")];
        }
    } cancelBlock:^{
        
    }];
    [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
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
