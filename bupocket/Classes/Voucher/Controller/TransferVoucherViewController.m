//
//  TransferVoucherViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/15.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "TransferVoucherViewController.h"
#import "TextFieldViewCell.h"
#import "BottomConfirmAlertView.h"
#import "AddressBookViewController.h"
#import "HMScannerController.h"
#import "ResultViewController.h"
#import "VoucherViewCell.h"
#import "VoucherViewController.h"
#import "RequestTimeoutViewController.h"
#import "ResultViewController.h"

@interface TransferVoucherViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

@property (nonatomic, strong) CustomButton * chooseVoucher;
@property (nonatomic, strong) UIButton * next;

@property (nonatomic, strong) UITextField * receiveAddress;
@property (nonatomic, strong) UITextField * value;
@property (nonatomic, strong) UITextField * remarks;
@property (nonatomic, strong) UITextField * transactionCosts;

//@property (nonatomic, strong) UILabel * availableBalance;
//@property (nonatomic, strong) NSString * availableAmount;

//@property (nonatomic, strong) NSMutableArray * transferInfoArray;
//@property (nonatomic, assign) BOOL isCorrectText;
//@property (nonatomic, assign) BOOL isSufficientBalance;

@property (nonatomic, strong) NSString * valueStr;
@property (nonatomic, strong) NSString * remarksStr;
@property (nonatomic, strong) NSString * transactionCostsStr;

@property (nonatomic, strong) ConfirmTransactionModel * confirmModel;
//@property (nonatomic, strong) DposModel * dposModel;
@property (nonatomic, strong) NSString * number;

@end

static NSString * const VoucherCellID = @"VoucherCellID";
static NSString * const ChooseVoucherCellID = @"ChooseVoucherCellID";

@implementation TransferVoucherViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"DonateVouchers");
    self.listArray = [NSMutableArray arrayWithObjects:@[[NSString stringWithFormat:@"%@ *", Localized(@"DonateVoucher")]], @[[NSString stringWithFormat:@"%@ *", Localized(@"ReceivingAccount")], Localized(@"ReceiveAddressPlaceholder")], @[Localized(@"TransferQuantity*"), Localized(@"AmountOfTransfer")], @[Localized(@"Remarks"), Localized(@"RemarksPlaceholder")], @[Localized(@"EstimatedMaximum"), Localized(@"TransactionCostPlaceholder")], nil];
    self.number = @"0";
    [self setupView];
    if (@available(iOS 11.0, *)) {
        self.tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
    } else {
        // Fallback on earlier versions
    }
    if (self.voucherModel) {
        [self getAvailableVoucherNumber];
    }
}
- (void)getAvailableVoucherNumber
{
    __weak typeof(self) weakSelf = self;
    DposModel * dposModel = [[DposModel alloc] init];
    dposModel.dest_address = self.voucherModel.contractAddress;
    dposModel.tx_fee = TransactionCost_MIN;
    dposModel.input = SKUTokenQuery(self.voucherModel.voucherId, CurrentWalletAddress);
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        int64_t number = [[HTTPManager shareManager] getVoutherBalanceWithDposModel: dposModel];
        self.number = [NSString stringWithFormat:@"%lld", number];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            [self judgeHasText];
            [weakSelf.tableView reloadData];
        }];
    }];
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    [self setupHeaderView];
    [self setupFooterView];
}
- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(0);
        make.bottom.left.right.mas_equalTo(0);
    }];
}
- (void)scrollViewDidChangeAdjustedContentInset:(UIScrollView *)scrollView
{
    DLog(@"%@", scrollView);
}
- (void)setupHeaderView
{
    UIButton * titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [titleBtn setAttributedTitle:[Encapsulation attrTitle:[[self.listArray firstObject] firstObject] ifRequired:YES] forState:UIControlStateNormal];
    titleBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    titleBtn.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_15, 0, Margin_15);
    titleBtn.frame = CGRectMake(0, 0, DEVICE_WIDTH, MAIN_HEIGHT);
    self.tableView.tableHeaderView = titleBtn;
}
- (void)setupFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(200) + SafeAreaBottomH)];
    self.next = [UIButton createButtonWithTitle:Localized(@"Next") isEnabled:NO Target:self Selector:@selector(nextAction:)];
    [footerView addSubview:self.next];
    
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(ScreenScale(50));
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.tableView.tableFooterView = footerView;
}

- (void)nextAction:(UIButton *)button
{
    [self DataJudgment];
}
- (void)DataJudgment
{
    __weak typeof (self) weakself = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        BOOL isCorrectAddress = [Keypair isAddressValid: weakself.receiveAddressStr];
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            if (!isCorrectAddress) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"BUAddressIsIncorrect")];
                return;
            }
            if ([weakself.receiveAddressStr isEqualToString:CurrentWalletAddress]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"CannotTransferVoucherToOneself")];
                return;
            }
            //            if ([self.number isEqualToString:@"0"]) {
            //                [MBProgressHUD hideHUD];
            //                [MBProgressHUD showTipMessageInWindow:Localized(@"NoVouchers")];
            //                return;
            //            }
            RegexPatternTool * regex = [[RegexPatternTool alloc] init];
            BOOL transferVolumeRegx = [regex validateIsPositiveInteger:self.valueStr];
            
            if (transferVolumeRegx == NO) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"VoucherSendingQuantityIsIncorrect")];
                return;
            }
            if ([self.number integerValue] - [self.valueStr integerValue] < 0) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"VoucherNotSufficientFunds")];
                return;
            }
            
            //            NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:self.dposModel.tx_fee];
            NSDecimalNumber * minLimitationNumber = [NSDecimalNumber decimalNumberWithString:[[NSUserDefaults standardUserDefaults] objectForKey:Minimum_Asset_Limitation]];
            NSDecimalNumber * cost = [NSDecimalNumber decimalNumberWithString:self.transactionCostsStr];
            NSDecimalNumber * totleAmount = [minLimitationNumber decimalNumberByAdding:cost];
            NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
            NSString * totleAmountStr = [amountNumber stringValue];
            if (!NotNULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
                [MBProgressHUD hideHUD];
                return;
            }
            if ([totleAmountStr hasPrefix:@"-"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
                return;
            }
            
            if (self.remarksStr.length > MAX_LENGTH) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"ExtraLongNotes")];
                return;
            }
            BOOL transactionCostsRegx = [regex validateIsPositiveFloatingPoint:self.transactionCostsStr] && [regex validateIsPositiveFloatingPoint:self.transactionCostsStr decimals:Decimals_BU];
            NSDecimalNumber * maxTransactionCost = [NSDecimalNumber decimalNumberWithString:TransactionCost_MAX];
            NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:TransactionCost_Voucher_MIN];
            if (transactionCostsRegx == NO || [self.transactionCostsStr isEqualToString:@"0"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:Localized(@"TransactionCostIsIncorrect")];
                return;
            }
            //            TransactionCost_Voucher_MIN "TransactionCostMin%@"
            
            NSString * minCost  = [[cost decimalNumberBySubtracting:minTransactionCost] stringValue];
            if ([minCost hasPrefix:@"-"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:Localized(@"TransactionCostMin%@"), minTransactionCost]];
                return;
            }
            
            NSString * maxCost  = [[maxTransactionCost decimalNumberBySubtracting:cost] stringValue];
            if ([maxCost hasPrefix:@"-"]) {
                [MBProgressHUD hideHUD];
                [MBProgressHUD showTipMessageInWindow:[NSString stringWithFormat:Localized(@"TransactionCostMax%@"), maxTransactionCost]];
                return;
            }
            [self showConfirmAlertView];
        }];
    }];
}
- (void)showConfirmAlertView
{
    BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO confrimBolck:^(NSString * _Nonnull transactionCost) {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            DposModel * dposModel = [[DposModel alloc] init];
            dposModel.dest_address = self.voucherModel.contractAddress;
            dposModel.tx_fee = self.transactionCostsStr;
            dposModel.input = self.confirmModel.script;
            dposModel.notes = self.remarksStr;
            dposModel.amount = @"0";
            dposModel.to_address = self.receiveAddressStr;
            if (![[HTTPManager shareManager] getTransactionWithDposModel: dposModel isDonateVoucher:YES]) return;
            [self showPWAlert];
        });
    } cancelBlock:^{
        
    }];
    confirmAlertView.title.text = Localized(@"ConfirmationOfGifts");
    self.confirmModel = [[ConfirmTransactionModel alloc] init];
    self.confirmModel.transactionDetail = Localized(@"TransferEncryptedDigitalVouchers");
    self.confirmModel.type = [NSString stringWithFormat:@"%zd", TransactionTypeVoucher];
    self.confirmModel.destAddress = self.receiveAddressStr;
    self.confirmModel.amount = self.valueStr;
    self.confirmModel.transactionCost = self.transactionCostsStr;
    self.confirmModel.qrRemark = self.remarksStr;
    self.confirmModel.script = SKUTokenTranche(self.voucherModel.voucherId, self.voucherModel.trancheId, self.confirmModel.destAddress, self.confirmModel.amount);
    confirmAlertView.confirmTransactionModel = self.confirmModel;
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)showPWAlert
{
    __weak typeof(self) weakSelf = self;
    NSOperationQueue * queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            PasswordAlertView * alertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransferWalletPWPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
                if (NotNULLString(password)) {
                    [weakSelf submitTransaction];
                }
            } cancelBlock:^{
                
            }];
            [alertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
            [alertView.PWTextField becomeFirstResponder];
            
        }];
    }];
}
- (void)submitTransaction
{
    [[HTTPManager shareManager] submitTransactionWithSuccess:^(TransactionResultModel *resultModel) {
        ResultViewController * VC = [[ResultViewController alloc] init];
        if (resultModel.errorCode == Success_Code) {
            VC.state = YES;
        } else {
            VC.state = NO;
        }
        VC.resultModel = resultModel;
        VC.confirmTransactionModel = self.confirmModel;
        [self.navigationController pushViewController:VC animated:YES];
    } failure:^(TransactionResultModel *resultModel) {
        RequestTimeoutViewController * VC = [[RequestTimeoutViewController alloc] init];
        VC.transactionHash = resultModel.transactionHash;
        [self.navigationController pushViewController:VC animated:YES];
    }];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0) {
        if (self.voucherModel) {
            return self.voucherModel.cellHeight;
        } else {
            [self.chooseVoucher sizeToFit];
            return self.chooseVoucher.height;
        }
    }
    return ScreenScale(85);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
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
    if (indexPath.row == 0) {
        if (self.voucherModel) {
            VoucherViewCell * cell = [VoucherViewCell cellWithTableView:tableView identifier:VoucherCellID];
            cell.voucherModel = self.voucherModel;
            cell.number.hidden = YES;
            cell.contentView.backgroundColor = [UIColor whiteColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        } else {
            UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:ChooseVoucherCellID];
            if (cell == nil) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ChooseVoucherCellID];
            }
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            [cell.contentView addSubview:self.chooseVoucher];
            [self.chooseVoucher mas_makeConstraints:^(MASConstraintMaker *make) {
                make.bottom.equalTo(cell.contentView.mas_bottom);
                make.left.equalTo(cell.contentView.mas_left).offset(Margin_15);
                make.right.equalTo(cell.contentView.mas_right).offset(-Margin_15);
                //            make.height.mas_equalTo(ScreenScale(130));
            }];
            return cell;
        }
    }
    TextFieldCellType cellType = (indexPath.row == 1 || indexPath.row == 2) ? TextFieldCellAddress : TextFieldCellDefault;
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: cellType];
    cell.title.attributedText = [Encapsulation attrTitle:[self.listArray[indexPath.row] firstObject] ifRequired:YES];
    cell.textField.placeholder = (indexPath.row == 0) ? @"" : [self.listArray[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 1) {
        self.receiveAddress = cell.textField;
        if (NotNULLString(self.receiveAddressStr)) {
            self.receiveAddress.text = self.receiveAddressStr;
        }
        cell.scanClick = ^{
            [self scanAction];
        };
        cell.addressListClick = ^{
            [self chooseAddress];
        };
    } else if (indexPath.row == 2) {
        self.value = cell.textField;
        cell.scan.hidden = YES;
        [cell.rightBtn setImage:nil forState:UIControlStateNormal];
        if (NotNULLString(self.number)) {
            NSString * transferable = [NSString stringWithFormat:Localized(@"Transferable %@"), self.number];
            NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:transferable];
            [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:[transferable rangeOfString:self.number]];
            [cell.rightBtn setAttributedTitle:attr forState:UIControlStateNormal];
        }
    } else if (indexPath.row == 3) {
        self.remarks = cell.textField;
    } else if (indexPath.row == 4) {
        self.transactionCosts = cell.textField;
        cell.textField.text = TransactionCost_Voucher_MIN;
        [cell.textField sendActionsForControlEvents:UIControlEventEditingChanged];
    }
    cell.textChange = ^(UITextField * _Nonnull textField) {
        [self judgeHasText];
    };
    return cell;
}
- (CustomButton *)chooseVoucher
{
    if (!_chooseVoucher) {
        _chooseVoucher = [[CustomButton alloc] init];
        [_chooseVoucher setTitleColor:COLOR_9 forState:UIControlStateNormal];
        _chooseVoucher.titleLabel.font = FONT_13;
        [_chooseVoucher setBackgroundImage:[UIImage imageNamed:@"choose_voucher_bg"] forState:UIControlStateNormal];
        [_chooseVoucher setImage:[UIImage imageNamed:@"choose_voucher"] forState:UIControlStateNormal];
        [_chooseVoucher setTitle:Localized(@"ChoiceVouchers") forState:UIControlStateNormal];
        [_chooseVoucher addTarget:self action:@selector(chooseVoucherAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseVoucher;
}
- (void)chooseVoucherAction
{
    VoucherViewController * VC = [[VoucherViewController alloc] init];
    VC.isChoiceVouchers = YES;
    VC.voucherId = self.voucherModel.voucherId;
    VC.voucher = ^(VoucherModel * voucherModel) {
        self.voucherModel = voucherModel;
        [self getAvailableVoucherNumber];
        [self.tableView reloadData];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)chooseAddress
{
    AddressBookViewController * VC = [[AddressBookViewController alloc] init];
    VC.walletAddress = ^(NSString * stringValue) {
        self.receiveAddress.text = stringValue;
        [self.receiveAddress sendActionsForControlEvents:UIControlEventEditingChanged];
        //        [self IsActivatedWithAddress:stringValue];
    };
    [self.navigationController pushViewController:VC animated:YES];
}
- (void)scanAction
{
    __block NSString * result = nil;
    __weak typeof (self) weakself = self;
    HMScannerController *scanner = [HMScannerController scannerWithCardName:nil avatar:nil completion:^(NSString *stringValue) {
        if (result) {
            return;
        }
        result = stringValue;
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            NSString * str = stringValue;
            if ([stringValue hasPrefix:Voucher_Prefix]) {
                str = [stringValue substringFromIndex:[Voucher_Prefix length]];
            }
            weakself.receiveAddress.text = str;
            [weakself.receiveAddress sendActionsForControlEvents:UIControlEventEditingChanged];
            //            [weakself IsActivatedWithAddress:stringValue];
        }];
    }];
    [scanner setTitleColor:[UIColor whiteColor] tintColor:MAIN_COLOR];
    [self showDetailViewController:scanner sender:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row == 0) {
        [self chooseVoucherAction];
    }
}

- (void)judgeHasText
{
    [self updateText];
    if (self.receiveAddressStr.length > 0 && self.valueStr.length > 0 &&  self.transactionCostsStr.length > 0 && self.voucherModel && [self.number integerValue] > 0) {
        self.next.enabled = YES;
        self.next.backgroundColor = MAIN_COLOR;
    } else {
        self.next.enabled = NO;
        self.next.backgroundColor = DISABLED_COLOR;
    }
}
- (void)updateText
{
    self.receiveAddressStr = TrimmingCharacters(self.receiveAddress.text);
    self.valueStr = TrimmingCharacters(self.value.text);
    self.remarksStr = TrimmingCharacters(self.remarks.text);
    self.transactionCostsStr = TrimmingCharacters(self.transactionCosts.text);
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
