//
//  ReceiveViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/21.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "ReceiveViewController.h"
#import "UINavigationController+Extension.h"
#import "HMScannerController.h"

@interface ReceiveViewController ()

@property (nonatomic, strong) UILabel * navTitle;
@property (nonatomic, strong) UIImageView * imageViewBg;
@property (nonatomic, strong) UIView * addressBg;
@property (nonatomic, strong) UIImageView * walletIcon;
@property (nonatomic, strong) UILabel * walletName;
@property (nonatomic, strong) CustomButton * walletAddress;
@property (nonatomic, strong) UIImageView * QRCodeImage;
@property (nonatomic, strong) UILabel * addressTitle;
@property (nonatomic, strong) CustomButton * icon;

@end

@implementation ReceiveViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.edgesForExtendedLayout = UIRectEdgeAll;
    self.automaticallyAdjustsScrollViewInsets = NO;
//    self.navigationItem.title = Localized(@"Receive");
    self.navAlpha = 0;
    self.navBackgroundColor = [UIColor whiteColor];
    self.navTitleColor = self.navTintColor = [UIColor whiteColor];
    [self setupNav];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)setupNav
{
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_goback_w" SelectedImage:@"nav_goback_w" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    
    UIButton * share = [UIButton createButtonWithNormalImage:@"nav_share" SelectedImage:@"nav_share" Target:self Selector:@selector(shareAction)];
    share.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    share.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:share];
}
- (void)cancelAction
{
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)shareAction
{
    UIImage * walletImage = [Encapsulation mergedImageWithMainImage:self.imageViewBg];
    NSArray * activityItems = @[walletImage];
    UIActivityViewController *activity = [[UIActivityViewController alloc] initWithActivityItems:activityItems applicationActivities:nil];
    // excludedActivityTypes 用于指定不需要提供的服务
    if (@available(iOS 11.0, *)) {
        activity.excludedActivityTypes = @[UIActivityTypePostToFacebook,
                                           UIActivityTypePostToTwitter,
                                           UIActivityTypePostToWeibo,
                                           UIActivityTypeMessage,
                                           UIActivityTypeMail,
                                           UIActivityTypePrint,
                                           UIActivityTypeCopyToPasteboard,
                                           UIActivityTypeAssignToContact,
                                           UIActivityTypeSaveToCameraRoll,
                                           UIActivityTypeAddToReadingList,
                                           UIActivityTypePostToVimeo,
                                           UIActivityTypePostToTencentWeibo,
                                           UIActivityTypeAirDrop,
                                           UIActivityTypeOpenInIBooks,
                                           UIActivityTypeMarkupAsPDF];
    } else {
        // Fallback on earlier versions
    }
    UIPopoverPresentationController *popover = activity.popoverPresentationController;
    if (popover) {
        popover.sourceView = self.view;
        popover.permittedArrowDirections = UIPopoverArrowDirectionUp;
    }
    [self presentViewController:activity animated:YES completion:nil];
    activity.completionWithItemsHandler = ^(UIActivityType  _Nullable activityType, BOOL completed, NSArray * _Nullable returnedItems, NSError * _Nullable activityError) {
        if (completed) {
            NSLog(@"系统分享成功");
        } else {
            NSLog(@"系统分享失败");
        }
    };
}
- (void)setupView
{
    self.imageViewBg = [[UIImageView alloc] init];
    self.imageViewBg.image = [UIImage imageNamed:@"receive_bg"];
    self.imageViewBg.contentMode = UIViewContentModeScaleAspectFill;
    self.imageViewBg.userInteractionEnabled = YES;
    [self.view addSubview:self.imageViewBg];
    [self.imageViewBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    [self.imageViewBg addSubview:self.addressBg];
    
    self.navTitle = [[UILabel alloc] init];
    self.navTitle.font = FONT_Bold(21);
    self.navTitle.textColor = [UIColor whiteColor];
    self.navTitle.text = Localized(@"Receive");
    [self.imageViewBg addSubview:self.navTitle];
    [self.navTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.imageViewBg.mas_top).offset(StatusBarHeight);
        make.height.mas_equalTo(ScreenScale(NavBarH - StatusBarHeight));
        make.centerX.equalTo(self.imageViewBg);
    }];
    
    CGSize addressBgSize = CGSizeMake(DEVICE_WIDTH - Margin_60, ScreenScale(390));
    [self.addressBg setViewSize:addressBgSize borderRadius:BG_CORNER corners:UIRectCornerAllCorners];
    [self.addressBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.imageViewBg);
        make.size.mas_equalTo(addressBgSize);
    }];
    
    [self.imageViewBg addSubview:self.walletIcon];
    CGSize imageViewBgSize = CGSizeMake(ScreenScale(70), ScreenScale(70));
    [self.walletIcon setViewSize:imageViewBgSize borderRadius:ScreenScale(35) corners:UIRectCornerAllCorners];
    [self.walletIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.addressBg.mas_top);
        make.centerX.equalTo(self.imageViewBg);
        make.size.mas_equalTo(imageViewBgSize);
    }];
    
    [self.addressBg addSubview:self.walletName];
    [self.walletName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletIcon.mas_bottom).offset(Margin_15);
        make.centerX.equalTo(self.addressBg);
        make.width.mas_lessThanOrEqualTo(addressBgSize.width - Margin_60);
    }];
    [self.addressBg addSubview:self.walletAddress];
    CGFloat walletAddressW = addressBgSize.width - Margin_20;
    
    UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, walletAddressW, LINE_WIDTH)];
//    line.backgroundColor = LINE_COLOR;
    [line drawDashLine];
    [self.addressBg addSubview:line];
    
    [self.addressBg addSubview:self.addressTitle];
    [self.addressTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addressBg.mas_bottom).offset(-Margin_20);
        make.left.equalTo(self.addressBg.mas_left).offset(Margin_15);
        make.right.equalTo(self.addressBg.mas_right).offset(-Margin_15);
    }];
    
    [self.addressBg addSubview:self.QRCodeImage];
    [self.QRCodeImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.addressTitle.mas_top).offset(-Margin_20);
        make.centerX.equalTo(self.walletIcon);
        make.size.mas_equalTo(CGSizeMake(ScreenScale(180), ScreenScale(180)));
    }];
    
    [self.imageViewBg addSubview:self.icon];
    [self.icon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.imageViewBg);
        make.bottom.equalTo(self.imageViewBg.mas_bottom).offset(- SafeAreaBottomH - Margin_30);
        make.height.mas_equalTo(ScreenScale(80));
    }];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.QRCodeImage.mas_top).offset(-Margin_20);
        make.centerX.equalTo(self.addressBg);
        make.size.mas_equalTo(CGSizeMake(walletAddressW, LINE_WIDTH));
    }];
    
    [self.walletAddress mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.walletName.mas_bottom);
        make.bottom.equalTo(line.mas_top);
        make.centerX.equalTo(self.walletIcon);
        make.width.mas_lessThanOrEqualTo(walletAddressW);
//        make.height.mas_equalTo(Margin_40);
    }];
}
- (UIView *)addressBg
{
    if (!_addressBg) {
        _addressBg = [[UIView alloc] init];
        _addressBg.backgroundColor = [UIColor whiteColor];
    }
    return _addressBg;
}
- (UIImageView *)walletIcon
{
    if (!_walletIcon) {
        _walletIcon = [[UIImageView alloc] init];
        NSString * imageName = CurrentWalletIconName ? CurrentWalletIconName : Current_Wallet_IconName;
        _walletIcon.image = [UIImage imageNamed:imageName];
        _walletIcon.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _walletIcon;
}
- (UILabel *)walletName
{
    if (!_walletName) {
        _walletName = [[UILabel alloc] init];
        _walletName.textColor = TITLE_COLOR;
        _walletName.font = FONT_Bold(16);
        _walletName.numberOfLines = 0;
        NSString * name = (CurrentWalletName) ? CurrentWalletName : Current_WalletName;
        _walletName.attributedText = [Encapsulation attrWithString:name font:FONT_Bold(16) color:TITLE_COLOR lineSpacing:LINE_SPACING];
//        _walletName.text = CurrentWalletName ? CurrentWalletName : Current_WalletName;;
        _walletName.textAlignment = NSTextAlignmentCenter;
    }
    return _walletName;
}
- (CustomButton *)walletAddress
{
    if (!_walletAddress) {
        _walletAddress = [[CustomButton alloc] init];
        _walletAddress.layoutMode = HorizontalInverted;
        [_walletAddress setTitleColor:COLOR_6 forState:UIControlStateNormal];
        _walletAddress.titleLabel.font = FONT(12);
        [_walletAddress setTitle:CurrentWalletAddress forState:UIControlStateNormal];
        [_walletAddress setImage:[UIImage imageNamed:@"copy_wallet_address"] forState:UIControlStateNormal];
        [_walletAddress addTarget:self action:@selector(copyAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _walletAddress;
}
- (void)copyAction
{
    [[UIPasteboard generalPasteboard] setString:CurrentWalletAddress];
    [MBProgressHUD showTipMessageInWindow:Localized(@"Replicating")];
}
- (UIImageView *)QRCodeImage
{
    if (!_QRCodeImage) {
        _QRCodeImage = [[UIImageView alloc] init];
        _QRCodeImage.image = [UIImage imageNamed:@"placeholderBg"];
        NSString * qrCodeStr = (self.receiveType == ReceiveTypeDefault) ? CurrentWalletAddress : [NSString stringWithFormat:@"%@%@", Voucher_Prefix, CurrentWalletAddress];
        [HMScannerController cardImageWithCardName:qrCodeStr avatar:nil scale:0.2 completion:^(UIImage *image) {
            self->_QRCodeImage.image = image;
        }];
    }
    return _QRCodeImage;
}
- (UILabel *)addressTitle
{
    if (!_addressTitle) {
        _addressTitle = [[UILabel alloc] init];
        _addressTitle.font = FONT_15;
        _addressTitle.textColor = COLOR(@"B2B2B2");
        _addressTitle.text = Localized(@"ReceiveAddress");
        _addressTitle.textAlignment = NSTextAlignmentCenter;
    }
    return _addressTitle;
}
- (CustomButton *)icon
{
    if (!_icon) {
        _icon = [[CustomButton alloc] init];
        _icon.layoutMode = VerticalNormal;
        [_icon setImage:[UIImage imageNamed:@"logo_receive"] forState:UIControlStateNormal];
        [_icon setTitle:Localized(@"BUPocket") forState:UIControlStateNormal];
        _icon.titleLabel.font = FONT(12);
        [_icon setTitleColor:[[UIColor whiteColor] colorWithAlphaComponent:0.25] forState:UIControlStateNormal];
    }
    return _icon;
}

//- (void)scrollViewDidScroll:(UIScrollView *)scrollView
//{
//    CGFloat y = scrollView.contentOffset.y;
//    self.navAlpha = y / 80;
//    if (y > 80) {
//
//    } else {
//    }
//}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
