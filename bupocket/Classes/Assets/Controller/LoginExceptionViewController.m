//
//  LoginExceptionViewController.m
//  bupocket
//
//  Created by bupocket on 2019/3/25.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "LoginExceptionViewController.h"

@interface LoginExceptionViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation LoginExceptionViewController

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
    
    CustomButton * exceptionPrompt = [[CustomButton alloc] init];
    exceptionPrompt.layoutMode = VerticalNormal;
    exceptionPrompt.titleLabel.font = FONT(16);
    [exceptionPrompt setTitle:Localized(@"LoginException") forState:UIControlStateNormal];
    [exceptionPrompt setTitleColor:TITLE_COLOR forState:UIControlStateNormal];
    exceptionPrompt.titleLabel.numberOfLines = 0;
    exceptionPrompt.titleLabel.textAlignment = NSTextAlignmentCenter;
    [exceptionPrompt setImage:[UIImage imageNamed:@"assetsTimeout"] forState:UIControlStateNormal];
    exceptionPrompt.userInteractionEnabled = NO;
    [self.scrollView addSubview:exceptionPrompt];
    [exceptionPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_20);
        make.centerX.mas_equalTo(0);
        make.height.mas_equalTo(ScreenScale(120) + [Encapsulation rectWithText:Localized(@"LoginException") font:exceptionPrompt.titleLabel.font textWidth:DEVICE_WIDTH - Margin_40].size.height);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UILabel * prompt = [[UILabel alloc] init];
    prompt.font = FONT(13);
    prompt.textColor = COLOR_9;
    prompt.textAlignment = NSTextAlignmentCenter;
    prompt.numberOfLines = 0;
    prompt.text = Localized(@"LoginExceptionPrompt");
    [self.scrollView addSubview:prompt];
    [prompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.width.equalTo(exceptionPrompt);
        make.top.equalTo(exceptionPrompt.mas_bottom);
    }];
    
    
    CGSize btnSize = CGSizeMake(DEVICE_WIDTH - Margin_40, MAIN_HEIGHT);
    UIButton * confirmBtn = [UIButton createButtonWithTitle:Localized(@"Confirm") isEnabled:YES Target:self Selector:@selector(confirmAction)];
    [self.scrollView addSubview:confirmBtn];
    [confirmBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(prompt.mas_bottom).offset(Margin_50);
        make.centerX.mas_equalTo(0);
        make.size.mas_equalTo(btnSize);
    }];
}

- (void)confirmAction
{
    //    NSString * json = [self setResultDataWithCode:0 message:@"register success"];
    //    [self.socket emit:Register_Success with:[NSArray arrayWithObjects:json, nil]];
    //    [self.socket on:Register_Success callback:^(NSArray* data, SocketAckEmitter* ack) {
    //        [self.socket disconnect];
    //    }];
    [self.navigationController popToRootViewControllerAnimated:NO];
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
