//
//  TransferAccountsViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/22.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "TransferAccountsViewController.h"
#import "PurseCipherAlertView.h"
#import "TransferDetailsAlertView.h"
#import "TransferResultsViewController.h"
#import "RequestTimeoutViewController.h"
#import "HMScannerController.h"

@interface TransferAccountsViewController ()

@property (nonatomic, strong) UITextField * amountOfTransfer;
@property (nonatomic, strong) UITextField * mostOnce;
@property (nonatomic, strong) UITextField * remarks;
@property (nonatomic, strong) UITextField * transactionCosts;
@property (nonatomic, strong) UIButton * next;

@property (nonatomic, strong) NSMutableArray * transferInfoArray;

@end

@implementation TransferAccountsViewController

- (NSMutableArray *)transferInfoArray
{
    if (!_transferInfoArray) {
        _transferInfoArray = [NSMutableArray array];
    }
    return _transferInfoArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(keyBoardHidden)];
    [self.view addGestureRecognizer:tap];
    NSArray * array = @[@[Localized(@"ReciprocalAccount"), Localized(@"AmountOfTransfer"), Localized(@"Remarks"), Localized(@"EstimatedMaximum")], @[Localized(@"PhoneOrAddress"), Localized(@"MostOnce"), Localized(@"RemarksPlaceholder"), Localized(@"TransactionCostPlaceholder")]];
//    NSArray * array = @[@[@"对方账户（BU地址） *", @"转账数量（BU） *", @"备注 ", @"预估最多支付费用（BU) *"], @[@"请输入手机号/接收方地址", @"单笔不可超过10000 BU", @"请输入备注", @"请输交易费用"]];
    for (NSInteger i = 0; i < 4; i++) {
        UIView * TAView = [self setViewWithTitle:[array firstObject][i] placeholder:[array lastObject][i] index:i];
        [self.view addSubview:TAView];
        [TAView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(NavBarH + ScreenScale(15) + (ScreenScale(95) * i));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(ScreenScale(95));
        }];
    }
    
    self.next = [UIButton createButtonWithTitle:Localized(@"Next") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(nextAction)];
    self.next.layer.masksToBounds = YES;
    self.next.clipsToBounds = YES;
    self.next.layer.cornerRadius = ScreenScale(4);
    [self.view addSubview:self.next];
    self.next.enabled = NO;
    self.next.backgroundColor = COLOR(@"9AD9FF");
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_30 - SafeAreaBottomH);
        make.left.equalTo(self.view.mas_left).offset(Margin_12);
        make.right.equalTo(self.view.mas_right).offset(-Margin_12);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (void)keyBoardHidden
{
    [self.view endEditing:YES];
}
- (void)nextAction
{
    CGFloat cost = [self.transactionCosts.text floatValue];
    if (cost < TransactionCost_MIN) {
        [MBProgressHUD wb_showWarning:@"最多支付交易费用不可少于0.01 BU"];
        return;
    } else if (cost > TransactionCost_MAX) {
        [MBProgressHUD wb_showWarning:@"最多支付交易费用不可超过10 BU"];
        return;
    }
    self.transferInfoArray = [NSMutableArray arrayWithObjects:self.amountOfTransfer.text, [NSString stringAppendingBUWithStr:self.mostOnce.text], [NSString stringAppendingBUWithStr:self.transactionCosts.text], nil];
    if ([_remarks hasText]) {
        [self.transferInfoArray addObject:_remarks.text];
    }
    TransferDetailsAlertView * transferDetailsAlertView = [[TransferDetailsAlertView alloc] initWithTransferInfoArray:self.transferInfoArray confrimBolck:^{
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            PurseCipherAlertView * alertView = [[PurseCipherAlertView alloc] initWithConfrimBolck:^(NSString * _Nonnull password) {
                HSSLog(@"确认转账");
                [self getDataWithPassword:password];
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:0.2 needEffectView:NO];
        });
    } cancelBlock:^{
        
    }];
    [transferDetailsAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:0.2 needEffectView:NO];
}

// 转账数据解析
- (void)getDataWithPassword:(NSString *)password
{
    [HTTPManager setTransferDataWithPassword:password destAddress:_amountOfTransfer.text BUAmount:_mostOnce.text feeLimit:_transactionCosts.text notes:_remarks.text success:^(TransactionResultModel *resultModel) {
        [self.transferInfoArray addObject:[DateTool getDateStringWithTimeStr:[NSString stringWithFormat:@"%lld", resultModel.transactionTime]]];
        // 交易成功、失败
        TransferResultsViewController * VC = [[TransferResultsViewController alloc] init];
        if (resultModel.errorCode == 0) { // 成功
            VC.state = YES;
        } else {
            // 直接失败
            VC.state = NO;
            [MBProgressHUD wb_showError:resultModel.errorDesc];
        }
        VC.transferInfoArray = self.transferInfoArray;
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        // 请求超时
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        [self.navigationController pushViewController:VC animated:YES];
    }];
}

- (UIView *)setViewWithTitle:(NSString *)title placeholder:(NSString *)placeholder index:(NSInteger)index
{
    UIView * viewBg = [[UIView alloc] init];
    UILabel * header = [[UILabel alloc] init];
    header.font = FONT(16);
    header.textColor = COLOR_9;
    [viewBg addSubview:header];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@", title]];
    //        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //        dic[NSFontAttributeName] = FONT(15);
    //        dic[NSForegroundColorAttributeName] = TITLE_COLOR;
    //        [attr addAttributes:dic range:NSMakeRange(3, str.length - 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 1)];
    [attr addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(attr.length - 1, 1)];
    [attr addAttribute:NSFontAttributeName value:FONT_Bold(18) range:NSMakeRange(0, 1)];
    header.attributedText = attr;
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(viewBg.mas_top).offset(Margin_30);
        make.left.equalTo(viewBg.mas_left).offset(Margin_15);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_15);
        //        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(15);
    textField.placeholder = placeholder;
//    textField.secureTextEntry = YES;
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    [viewBg addSubview:textField];
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(header.mas_bottom).offset(ScreenScale(5));
        make.left.equalTo(viewBg.mas_left).offset(Margin_15);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(Margin_40);
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR(@"E3E3E3");
    [viewBg addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.right.equalTo(header);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    if (index == 0) {
        self.amountOfTransfer = textField;
        UIButton * scan = [UIButton createButtonWithNormalImage:@"TransferAccounts_scan" SelectedImage:@"TransferAccounts_scan" Target:self Selector:@selector(scanAction)];
        scan.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        scan.bounds = CGRectMake(0, 0, Margin_30, Margin_40);
        textField.rightViewMode = UITextFieldViewModeAlways;
        textField.rightView = scan;
        
    } else if (index == 1) {
        UILabel * availableBalance = [[UILabel alloc] init];
//        availableBalance.textColor = MAIN_COLOR;
//        availableBalance.font = FONT(12);
        availableBalance.numberOfLines = 0;
        [header addSubview:availableBalance];
//        NSMutableAttributedString * balanceAttr = [[NSMutableAttributedString alloc] initWithString:@"可用余额\n1000 BU"];
//        [balanceAttr addAttribute:NSForegroundColorAttributeName value:COLOR_6 range:NSMakeRange(0, 4)];
//        availableBalance.attributedText = balanceAttr;
        availableBalance.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@ BU", Localized(@"AvailableBalance"), self.listModel.amount] preFont:FONT(12) preColor:COLOR_6 index:4 sufFont:FONT(12) sufColor:MAIN_COLOR lineSpacing:10];
        availableBalance.textAlignment = NSTextAlignmentRight;
        [availableBalance mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.top.equalTo(header);
        }];
        self.mostOnce = textField;
    } else if (index == 2) {
        self.remarks = textField;
    } else if (index == 3) {
        self.transactionCosts = textField;
    }
    return viewBg;
}

- (void)textChange:(UITextField *)textField
{
    if (_amountOfTransfer.text.length > 0 && _mostOnce.text.length > 0 && _transactionCosts.text.length > 0) {
        self.next.enabled = YES;
        self.next.backgroundColor = MAIN_COLOR;
    } else {
        self.next.enabled = NO;
        self.next.backgroundColor = COLOR(@"9AD9FF");
    }
}
- (void)scanAction
{
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        self.amountOfTransfer.text = stringValue;
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
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
