//
//  MyViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/15.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "MyViewController.h"
#import "ListTableViewCell.h"
#import "SubtitleListViewCell.h"

#import "MyIdentityViewController.h"
#import "AddressBookViewController.h"
#import "WalletListViewController.h"

#import "MonetaryUnitViewController.h"
#import "MultilingualViewController.h"
#import "NodeSettingsViewController.h"
#import "TermsOfUseViewController.h"
#import "FeedbackViewController.h"
#import "AboutUsViewController.h"

#import "ChangePasswordViewController.h"
#import <WXApi.h>
#import "WXApiManager.h"

@interface MyViewController ()<UITableViewDelegate, UITableViewDataSource, WXApiManagerDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) UIButton * networkPrompt;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIImageView * IDIcon;
@property (nonatomic, strong) UIButton * bindingBtn;

@end

@implementation MyViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    [self getWechatBindWithURL:Binding_Wechat_Status wxCode:@""];
    /*
     // 活动开启提示绑定微信
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    BOOL isBind = [defaults boolForKey:If_Wechat_Binded];
    if (!isBind) {
        [Encapsulation showAlertControllerWithTitle:Localized(@"WechatBindPrompt") message:nil confirmHandler:^{
            [self bindingWechat];
        }];
    }
     */
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView.mj_header beginRefreshing];
    self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[Localized(@"MoneyOfAccount"), Localized(@"DisplayLanguage"), Localized(@"NodeSettings"), Localized(@"BindingWechat")], @[Localized(@"UserProtocol"), Localized(@"Feedback"), Localized(@"AboutUs")]]];
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults boolForKey:If_Custom_Network] == YES) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"CustomEnvironment") Target:nil Selector:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
        self.listArray = [NSMutableArray arrayWithArray:@[@[@""], @[Localized(@"MoneyOfAccount"), Localized(@"DisplayLanguage"), Localized(@"BindingWechat")], @[Localized(@"UserProtocol"), Localized(@"Feedback"), Localized(@"AboutUs")]]];
    } else if ([defaults boolForKey:If_Switch_TestNetwork]) {
        self.networkPrompt = [UIButton createNavButtonWithTitle:Localized(@"TestNetworkPrompt") Target:nil Selector:nil];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:self.networkPrompt];
    } else {
        self.navigationItem.leftBarButtonItem = nil;
    }
    [self.tableView reloadData];
    
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.tableView.mj_header endRefreshing];
}
// Wechat Bind
- (void)getWechatBindWithURL:(NSString *)URL wxCode:(NSString *)wxCode
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
//    [defaults removeObjectForKey:If_Wechat_Binded];
//    if ([URL isEqualToString:Binding_Wechat_Status] && [defaults objectForKey:Wechat_Image]) return;
    [[HTTPManager shareManager] getBindingWechatDataWithURL:URL wxCode:wxCode success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            NSString * imageUrl;
            if ([URL isEqualToString:Binding_Wechat_Status]) {
                // 已绑定 头像返回
                BOOL isBind = [dataDic[@"isBindWx"] integerValue];
                DLog(@"是否绑定：%d", isBind);
                [defaults setBool:isBind forKey:If_Wechat_Binded];
                self.bindingBtn.selected = isBind;
                imageUrl = dataDic[@"wxInfo"][@"headImgUrl"];
            } else if ([URL isEqualToString:Binding_Wechat]) {
                self.bindingBtn.selected = YES;
                [defaults setBool:YES forKey:If_Wechat_Binded];
                imageUrl = dataDic[@"wxHeadImgUrl"];
                [MBProgressHUD showTipMessageInWindow:Localized(@"WechatBoundSuccess")];
            }
            if (self.bindingBtn.selected == YES) {
                NSData * imageData = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
                UIImage * image = [UIImage imageWithData:imageData];
                self.IDIcon.image = image;
//                [defaults setObject:imageData forKey:Wechat_Image];
            }
            [defaults synchronize];
        } else {
            [MBProgressHUD showTipMessageInWindow:[ErrorTypeTool getDescriptionWithErrorCode:code]];
        }
//        [self.tableView.mj_header endRefreshing];
    } failure:^(NSError *error) {
//            [self.tableView.mj_header endRefreshing];
    }];
}
- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT - TabBarH) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGFLOAT_MIN;
    } else {
        return Margin_10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        return ScreenScale(100);
    } else if (section == self.listArray.count - 1) {
        return ContentSizeBottom;
    } else {
        return CGFLOAT_MIN;
    }
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    if (section == 0) {
        UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(100))];
        footerView.backgroundColor = NAV_BAR_BG_COLOR;
        NSArray * array = @[@[Localized(@"AddressBook"), ADDRESS_COLOR, @"addressBookBg_icon"], @[Localized(@"WalletManagement"), MAIN_COLOR, @"walletManageBg_icon"]];
        CGFloat btnW = (DEVICE_WIDTH - Margin_40) / 2;
        CGSize btnSize = CGSizeMake(btnW, ScreenScale(80));
        for (NSInteger i = 0; i < array.count; i ++) {
            UIButton * btn = [UIButton createButtonWithTitle:array[i][0] TextFont:FONT_Bold(18) TextNormalColor:WHITE_BG_COLOR TextSelectedColor:WHITE_BG_COLOR Target:self Selector:@selector(btnAction:)];
            btn.backgroundColor = array[i][1];
            btn.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_15, 0, Margin_15);
            btn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
            btn.tag = i;
            [footerView addSubview:btn];
            [btn setViewSize:btnSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
            [btn mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(footerView);
                make.left.equalTo(footerView.mas_left).offset(Margin_15 + (btnW + Margin_10) * i);
                make.size.mas_equalTo(btnSize);
            }];
            UIImageView * bgIcon = [[UIImageView alloc]  initWithImage:[UIImage imageNamed:array[i][2]]];
            [btn addSubview:bgIcon];
            [bgIcon mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.bottom.equalTo(btn);
            }];
        }
        return footerView;
    } else {
        return [[UIView alloc] init];
    }
}
- (void)btnAction:(UIButton *)button
{
    if (button.tag == 0) {
        AddressBookViewController * VC = [[AddressBookViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (button.tag == 1) {
        WalletListViewController * VC = [[WalletListViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return ScreenScale(110);
    } else {
        return ScreenScale(50);
    }
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
    if (indexPath.section == 0) {
        SubtitleListViewCell * cell = [SubtitleListViewCell cellWithTableView:tableView cellType:SubtitleCellNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.walletName.text = [[AccountTool shareTool] account].identityName;
        cell.walletAddress.text = [NSString stringEllipsisWithStr:[[AccountTool shareTool] account].identityAddress subIndex:SubIndex_Address];
        self.IDIcon = cell.walletImage;
        return cell;
    } else {
        ListTableViewCell * cell = [ListTableViewCell cellWithTableView:tableView cellType:CellTypeDetail];
        cell.title.text = self.listArray[indexPath.section][indexPath.row];
        NSString * imageName = [NSString stringWithFormat:@"my_list_%zd_%zd", indexPath.section, indexPath.row];
        if ([cell.title.text isEqualToString:Localized(@"BindingWechat")]) {
            imageName = @"my_list_1_3";
            [cell.detail setImage:nil forState:UIControlStateNormal];
            [cell.detail setTitle:Localized(@"ImmediateBinding") forState:UIControlStateNormal];
            [cell.detail setTitleColor:MAIN_COLOR forState:UIControlStateNormal];
            [cell.detail setTitle:Localized(@"Binded") forState:UIControlStateSelected];
            [cell.detail setTitleColor:COLOR_9 forState:UIControlStateSelected];
            self.bindingBtn = cell.detail;
            NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
            BOOL isBind = [defaults boolForKey:If_Wechat_Binded];
            self.bindingBtn.selected = isBind;
        }
        [cell.listImage setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (indexPath.section == 1) {
            if (indexPath.row == 0) {
                cell.detailTitle.text = [AssetCurrencyModel getAssetCurrencyTypeWithAssetCurrency:[[[NSUserDefaults standardUserDefaults] objectForKey:Current_Currency] integerValue]];
            } else if (indexPath.row == 1) {
                if ([CurrentAppLanguage isEqualToString:ZhHans]) {
                    cell.detailTitle.text = Localized(@"SimplifiedChinese");
                } else {
                    // if ([CurrentAppLanguage isEqualToString:EN])
                    cell.detailTitle.text = Localized(@"English");
                }
            }
        }
        cell.lineView.hidden = (indexPath.row == [self.listArray[indexPath.section] count] - 1);
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString * title = self.listArray[indexPath.section][indexPath.row];
    if (indexPath.section == 0) {
        MyIdentityViewController * VC = [[MyIdentityViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    } else if (indexPath.section == 1) {
        if (indexPath.row == 0) {
            MonetaryUnitViewController * VC = [[MonetaryUnitViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            MultilingualViewController * VC = [[MultilingualViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
        if ([title isEqualToString:Localized(@"NodeSettings")]) {
            NodeSettingsViewController * VC = [[NodeSettingsViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if ([title isEqualToString:Localized(@"BindingWechat")]) {
            [self bindingWechat];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.row == 0) {
            TermsOfUseViewController * VC = [[TermsOfUseViewController alloc] init];
            VC.userProtocolType = UserProtocolDefault;
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 1) {
            FeedbackViewController * VC = [[FeedbackViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        } else if (indexPath.row == 2) {
            AboutUsViewController * VC = [[AboutUsViewController alloc] init];
            [self.navigationController pushViewController:VC animated:YES];
        }
    }
}
- (void)bindingWechat
{
    if (self.bindingBtn.selected == YES) return;
    // 绑定微信
    SendAuthReq * req = [[SendAuthReq alloc] init];
    req.openID = Wechat_APP_ID;
    req.state = Wechat_Bind_State;
    req.scope = @"snsapi_userinfo";
    WXApiManager * manger = [WXApiManager sharedManager];
    manger.delegate = self;
    [WXApi sendAuthReq:req
        viewController:self
              delegate:manger];
}
- (void)wxSendAuthResponse:(SendAuthResp *)resp {
    if (resp.errCode == 0) {
        //获取授权成功
        DLog(@"授权code：%@", resp.code);
        [self getWechatBindWithURL:Binding_Wechat wxCode:resp.code];
//        [self getWeChatTokenThenGetUserInfoWithCode:resp.code];
    } else if (resp.errCode == -4) {
        //用户拒绝授权
    } else if (resp.errCode == -2) {
        //用户取消授权
    }
}
/*
// 获取用户微信token
- (void)getWeChatTokenThenGetUserInfoWithCode:(NSString *)code {
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",Wechat_APP_ID ,@"APPsecret",code];
    //
    [WLHttpTool post:url params:nil success:^(id responseObj) {
        //
        [self getWeChatUserInfoWithToken:responseObj[@"access_token"] andOpenID:responseObj[@"openid"]];
    } failure:^(NSError *error) {
        
    }];
}
// 获取微信用户信息
- (void)getWeChatUserInfoWithToken:(NSString *)token andOpenID:(NSString *)openid {
    //
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",token,openid];
    //
    [WLHttpTool post:url params:nil success:^(id responseObj) {
        NSLog(@"responseObj == %@",responseObj);
    } failure:^(NSError *error) {
        
    }];
}
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
