//
//  GiftGivingViewController.m
//  bupocket
//
//  Created by huoss on 2019/7/4.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "GiftGivingViewController.h"
#import "TextFieldViewCell.h"
#import "BottomConfirmAlertView.h"
#import "AddressBookViewController.h"
#import "HMScannerController.h"
#import "ResultViewController.h"

@interface GiftGivingViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;

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

@property (nonatomic, strong) NSString * receiveAddressStr;
@property (nonatomic, strong) NSString * valueStr;
@property (nonatomic, strong) NSString * remarksStr;
@property (nonatomic, strong) NSString * transactionCostsStr;

@end

@implementation GiftGivingViewController

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
    self.navigationItem.title = Localized(@"GiftGiving");
    self.listArray = [NSMutableArray arrayWithObjects:@[[NSString stringWithFormat:@"%@ *", Localized(@"ReceivingAccount")], Localized(@"ReceiveAddressPlaceholder")], @[Localized(@"TransferQuantity*"), Localized(@"AmountOfDonation")], @[Localized(@"Remarks"), Localized(@"RemarksPlaceholder")], @[Localized(@"EstimatedMaximum"), Localized(@"TransactionCostPlaceholder")], nil];
    [self setupView];
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self setupFooterView];
}
- (void)setupFooterView
{
    UIView * footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(170) + SafeAreaBottomH)];
    self.next = [UIButton createButtonWithTitle:Localized(@"Next") isEnabled:NO Target:self Selector:@selector(nextAction:)];
    [footerView addSubview:self.next];
    
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(footerView.mas_top).offset(ScreenScale(90));
        make.left.equalTo(footerView.mas_left).offset(Margin_15);
        make.right.equalTo(footerView.mas_right).offset(-Margin_15);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.tableView.tableFooterView = footerView;
}

- (void)nextAction:(UIButton *)button
{
    BottomConfirmAlertView * confirmAlertView = [[BottomConfirmAlertView alloc] initWithIsShowValue:NO confrimBolck:^(NSString * _Nonnull transactionCost) {
        ResultViewController * VC = [[ResultViewController alloc] init];
//        VC.state = YES;
//        VC.resultModel = resultModel;
//        VC.confirmTransactionModel = self.confirmTransactionModel;
        [self.navigationController pushViewController:VC animated:NO];
        /*
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(Dispatch_After_Time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSDecimalNumber * amount = [NSDecimalNumber decimalNumberWithString:self.valueStr];
            NSDecimalNumber * minTransactionCost = [NSDecimalNumber decimalNumberWithString:transactionCost];
            NSDecimalNumber * totleAmount = [amount decimalNumberByAdding:minTransactionCost];
            NSDecimalNumber * amountNumber = [[HTTPManager shareManager] getDataWithBalanceJudgmentWithCost:[totleAmount stringValue] ifShowLoading:NO];
            NSString * totleAmountStr = [amountNumber stringValue];
            if (!NotNULLString(totleAmountStr) || [amountNumber isEqualToNumber:NSDecimalNumber.notANumber]) {
            } else if ([totleAmountStr hasPrefix:@"-"]) {
                [MBProgressHUD showTipMessageInWindow:Localized(@"NotSufficientFunds")];
            } else {
//                if (![[HTTPManager shareManager] getTransactionWithDposModel: self.dposModel]) return;
                [self showPWAlertView];
            }
        });
         */
    } cancelBlock:^{
        
    }];
    confirmAlertView.title.text = Localized(@"ConfirmationOfGifts");
//    confirmAlertView.dposModel = self.dposModel;
    [confirmAlertView showInWindowWithMode:CustomAnimationModeShare inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
}
- (void)showPWAlertView
{
    PasswordAlertView * PWAlertView = [[PasswordAlertView alloc] initWithPrompt:Localized(@"TransactionWalletPWPrompt") confrimBolck:^(NSString * _Nonnull password, NSArray * _Nonnull words) {
        if (NotNULLString(password)) {
            
        }
    } cancelBlock:^{
        
    }];
    [PWAlertView showInWindowWithMode:CustomAnimationModeAlert inView:nil bgAlpha:AlertBgAlpha needEffectView:NO];
    [PWAlertView.PWTextField becomeFirstResponder];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(85);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SafeAreaBottomH;
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
    TextFieldCellType cellType = (indexPath.row <= 1) ? TextFieldCellAddress : TextFieldCellDefault;
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: cellType];
    cell.title.attributedText = [Encapsulation attrTitle:[self.listArray[indexPath.row] firstObject] ifRequired:YES];
    cell.textField.placeholder = [self.listArray[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (indexPath.row == 0) {
        self.receiveAddress = cell.textField;
        cell.scanClick = ^{
            
        };
        cell.addressListClick = ^{
            [self chooseAddress];
        };
    } else if (indexPath.row == 1) {
        self.value = cell.textField;
        cell.scan.hidden = YES;
        [cell.rightBtn setImage:nil forState:UIControlStateNormal];
        NSString * number = @"100";
        NSString * transferable = [NSString stringWithFormat:Localized(@"Transferable %@"), number];
        NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:transferable];
        [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:[transferable rangeOfString:number]];
        [cell.rightBtn setAttributedTitle:attr forState:UIControlStateNormal];
    } else if (indexPath.row == 2) {
        self.remarks = cell.textField;
    } else if (indexPath.row == 3) {
        self.transactionCosts = cell.textField;
        cell.textField.text = TransactionCost_MIN;
        [cell.textField sendActionsForControlEvents:UIControlEventEditingChanged];
    }
    cell.textChange = ^(UITextField * _Nonnull textField) {
        [self judgeHasText];
    };
    return cell;
}
- (void)chooseAddress
{
    AddressBookViewController * VC = [[AddressBookViewController alloc] init];
    VC.walletAddress = ^(NSString * stringValue) {
        self.receiveAddress.text = stringValue;
        [self.receiveAddress sendActionsForControlEvents:UIControlEventEditingChanged];
//        [self IsActivatedWithAddress:stringValue];
    };
    [self.navigationController pushViewController:VC animated:NO];
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
            weakself.receiveAddress.text = stringValue;
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
}

- (void)judgeHasText
{
    [self updateText];
    if (self.receiveAddressStr.length > 0 && self.valueStr.length > 0 &&  self.transactionCostsStr.length > 0) {
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
