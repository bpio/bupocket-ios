//
//  LoginConfirmViewController.m
//  bupocket
//
//  Created by huoss on 2019/3/25.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "LoginConfirmViewController.h"
#import "LoginExceptionViewController.h"
//@import SocketIO;

@interface LoginConfirmViewController ()
@property (nonatomic, strong) UIScrollView * scrollView;

//@property (nonatomic, strong) SocketManager * manager;
//@property (nonatomic, strong) SocketIOClient * socket;

@end

//static NSString * const Register_Join = @"token.register.join";
//static NSString * const Register_ScanSuccess = @"token.register.scanSuccess";
//static NSString * const Register_Processing = @"token.register.processing";
//static NSString * const Register_Success = @"token.register.success";
//static NSString * const Register_Failure = @"token.register.failure";
//static NSString * const Register_Timeout = @"token.register.timeout";
//static NSString * const Register_Cancel = @"token.register.Cancel";
//static NSString * const Register_Leave = @"leaveRoomForApp";

@implementation LoginConfirmViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
//    [self connectSocket];
    UIButton * backButton = [UIButton createButtonWithNormalImage:@"nav_close" SelectedImage:@"nav_close" Target:self Selector:@selector(cancelAction)];
    backButton.frame = CGRectMake(0, 0, ScreenScale(44), Margin_30);
    backButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backButton];
    // Do any additional setup after loading the view.
}
/*
- (void)connectSocket
{
    NSURL* url = [[NSURL alloc] initWithString:[HTTPManager shareManager].pushMessageSocketUrl];
    self.manager = [[SocketManager alloc] initWithSocketURL:url config:@{@"log": @YES, @"compress": @YES}];
    self.socket = self.manager.defaultSocket;
    __weak typeof(self) weakself = self;
    [self.socket on:@"connect" callback:^(NSArray* data, SocketAckEmitter* ack) {
        [weakself.socket emit:Register_Join with:[NSArray arrayWithObjects:weakself.uuid, nil]];
    }];
    [self.socket on:Register_Join callback:^(NSArray* data, SocketAckEmitter* ack) {
        [weakself.socket emit:Register_ScanSuccess with:@[]];
    }];
    [self.socket on:Register_ScanSuccess callback:^(NSArray* data, SocketAckEmitter* ack) {
        
    }];
    [self.socket connect];
}*/
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    CustomButton * confirmationPrompt = [[CustomButton alloc] init];
    confirmationPrompt.layoutMode = VerticalNormal;
    confirmationPrompt.titleLabel.font = FONT_Bold(18);
    [confirmationPrompt setTitle:Localized(@"LoginSystem") forState:UIControlStateNormal];
    [confirmationPrompt setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    [confirmationPrompt setImage:[UIImage imageNamed:@"login_system_logo"] forState:UIControlStateNormal];
    confirmationPrompt.titleLabel.numberOfLines = 0;
    confirmationPrompt.titleLabel.textAlignment = NSTextAlignmentCenter;
    confirmationPrompt.userInteractionEnabled = NO;
    [self.scrollView addSubview:confirmationPrompt];
    [confirmationPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScreenScale(160));
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self.scrollView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(confirmationPrompt);
        make.top.equalTo(confirmationPrompt.mas_bottom);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    UILabel * confirmLoginPrompt = [[UILabel alloc] init];
    confirmLoginPrompt.numberOfLines = 0;
    [self.scrollView addSubview:confirmLoginPrompt];
    [confirmLoginPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(confirmationPrompt);
        make.top.equalTo(line.mas_bottom).offset(Margin_25);
    }];
    confirmLoginPrompt.attributedText = [Encapsulation attrWithString:[NSString stringWithFormat:@"%@\n%@", Localized(@"ConfirmLoginPrompt"), Localized(@"LoginPromptInfo")] preFont:FONT(15) preColor:COLOR_6 index:Localized(@"ConfirmLoginPrompt").length sufFont:FONT(13) sufColor:COLOR_9 lineSpacing:8.5];
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - ScreenScale(80), MAIN_HEIGHT);
    UIButton * confirmBtn = [UIButton createButtonWithTitle:Localized(@"ConfirmLogin") isEnabled:YES Target:self Selector:@selector(confirmAction)];
    [self.scrollView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmLoginPrompt.mas_bottom).offset(Margin_40);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
    UIButton * cancelBtn = [UIButton createButtonWithTitle:Localized(@"Cancel")isEnabled:YES Target:self Selector:@selector(cancelAction)];
    cancelBtn.backgroundColor = COLOR(@"EDEDED");
    [self.scrollView addSubview:cancelBtn];
    [cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmBtn.mas_bottom).offset(Margin_30);
        make.size.centerX.equalTo(confirmBtn);
    }];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(cancelBtn.frame) + ContentSizeBottom + ScreenScale(50));
}

- (void)confirmAction
{
//    NSString * json = [self setResultDataWithCode:0 message:@"register success"];
//    [self.socket emit:Register_Success with:[NSArray arrayWithObjects:json, nil]];
//    [self.socket on:Register_Success callback:^(NSArray* data, SocketAckEmitter* ack) {
//        [self.socket disconnect];
//    }];
    LoginExceptionViewController * VC = [[LoginExceptionViewController alloc] init];
    [self.navigationController pushViewController:VC animated:NO];
}




- (void)cancelAction
{
//    [self.socket emit:Register_Cancel with:@[Localized(@"Cancel")]];
//    [self.socket on:Register_Cancel callback:^(NSArray* data, SocketAckEmitter* ack) {
//        [self.socket emit:Register_Leave with:[NSArray arrayWithObjects:self.uuid, nil]];
//    }];
//    [self.socket on:Register_Leave callback:^(NSArray* data, SocketAckEmitter* ack) {
//        [self.socket disconnect];
//    }];
    [self.navigationController popViewControllerAnimated:NO];
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
