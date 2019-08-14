//
//  RedEnvelopesViewController.m
//  bupocket
//
//  Created by bupocket on 2019/8/2.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "RedEnvelopesViewController.h"
#import "RedEnvelopesInfo.h"
#import "CFCycleScrollView.h"
#import "ActivityResultModel.h"
#import "ActivityAwardsModel.h"
#import "UINavigationController+Extension.h"

@interface RedEnvelopesViewController()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) CFCycleScrollView * cycleScrollView;
@property (nonatomic, strong) NSArray * luckyArray;
@property (nonatomic, strong) ActivityResultModel * activityResultModel;

@property (nonatomic, strong) UIButton * luckyTitle;
//@property (nonatomic, strong) UIView * line1;
@property (nonatomic, strong) UIButton * activitiesTitle;
@property (nonatomic, strong) UIView * activitiesContentBg;
@property (nonatomic, strong) UILabel * activitiesContent;
@property (nonatomic, assign) NSInteger showCount;
@property (nonatomic, strong) dispatch_source_t timer;

@property (nonatomic, strong) UIView * noNetWork;

@end

@implementation RedEnvelopesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loopGetData];
    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view target:self action:@selector(reloadData)];
}
- (void)getActivityDataIsShowLoading:(BOOL)isShowLoading
{
    if (isShowLoading) {
        [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    }
    [[HTTPManager shareManager] getActivityDataWithURL:Activity_Detail bonusCode:self.activityID success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self.activityResultModel = [ActivityResultModel mj_objectWithKeyValues:dataDic];
            self.luckyArray = [ActivityAwardsModel mj_objectArrayWithKeyValuesArray:self.activityResultModel.latelyData[@"data"]];
            self.navTitleColor = self.navTintColor = TITLE_COLOR;
            self.navigationItem.title = self.activityResultModel.pageTitle;
            if (self.scrollView == nil) {
                [self setupView];
            }
            if (self.showCount != MIN(5, self.luckyArray.count)) {
                [self.cycleScrollView removeAllSubviews];
                [self.scrollView addSubview:self.cycleScrollView];
                [self updateLayout];
            } else {
                self.cycleScrollView.dataSourceArray = self.luckyArray;
            }
        } else if (code == 100022) {
            // 已领取红包
        }
        self.noNetWork.hidden = YES;
    } failure:^(NSError *error) {
        self.noNetWork.hidden = NO;
    }];
}
- (void)loopGetData
{
    __block NSInteger count = 0;
    //创建队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建定时器
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置定时器时间
    dispatch_time_t start = dispatch_time(DISPATCH_TIME_NOW, 0);
    uint64_t interval = (uint64_t)((1.0 * 60) * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        //重复执行的事件
        count++;
        DLog(@"-----%ld-----", count);
        [self getActivityDataIsShowLoading:(count == 1)];
    });
    //启动定时器
    dispatch_resume(self.timer);
}
- (void)reloadData
{
    self.noNetWork.hidden = YES;
    [self getActivityDataIsShowLoading:YES];
}
- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //停止定时器
    dispatch_source_cancel(self.timer);
    self.timer = nil;
}
//- (void)dealloc
//{
//    //停止定时器
//    dispatch_source_cancel(self.timer);
//    self.timer = nil;
//}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] init];
    self.view.backgroundColor = VIEWBG_COLOR;
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    RedEnvelopesInfo * infoView = [[RedEnvelopesInfo alloc] initWithRedEnvelopesType:RedEnvelopesTypeNormal confrimBolck:nil cancelBlock:nil];
    infoView.activityInfoModel = [ActivityInfoModel mj_objectWithKeyValues:self.activityResultModel.bonusInfo];
    [infoView showInWindowWithMode:CustomAnimationModeView inView:self.scrollView bgAlpha:0 needEffectView:NO];

//    UIView * line0 = [self setupLineView];
//    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(infoView.mas_bottom);
////        make.left.mas_equalTo(0);
//    }];
    self.luckyTitle = [self setupHeaderWithTitle:self.activityResultModel.latelyData[@"label"]];
//    [self.scrollView addSubview:self.luckyTitle];
    [self.luckyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.mas_bottom).offset(Margin_10);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.cycleScrollView];
    
//    self.line1 = [self setupLineView];
    self.activitiesTitle = [self setupHeaderWithTitle:self.activityResultModel.activityRules[@"label"]];
//    [self.scrollView addSubview:self.activitiesTitle];
    [self.scrollView addSubview:self.activitiesContentBg];
    [self.scrollView addSubview:self.activitiesContent];
    [self updateLayout];
    
//    self.noNetWork.hidden = NO;
    // @"1. 活动时间：2019年8月7日 00:00 - 24:00 ；\n2. 每个设备ID仅限领取一次七夕节日红包，红包领取成功后存放入当前使用钱包，可在当前使用钱包的资产余额中和最新交易记录中进行查询；\n3. 红包最大额度为7777.77 BU，领取成功后可点击「保存图片并分享」按钮，邀请好友一起领取七夕节日红包，先到先得；\n4. 本活动解释权归小布口袋所有。"
}
- (UIView *)activitiesContentBg
{
    if (!_activitiesContentBg) {
        _activitiesContentBg = [[UIView alloc] init];
        _activitiesContentBg.backgroundColor = [UIColor whiteColor];
    }
    return _activitiesContentBg;
}
- (UILabel *)activitiesContent
{
    if (!_activitiesContent) {
        _activitiesContent = [[UILabel alloc] init];
        _activitiesContent.numberOfLines = 0;
        NSString * activities = self.activityResultModel.activityRules[@"data"];
        if (NotNULLString(activities)) {
            _activitiesContent.attributedText = [Encapsulation attrWithString:activities font:FONT_TITLE color:COLOR_6 lineSpacing:LINE_SPACING];
        }
    }
    return _activitiesContent;
}
- (void)updateLayout
{
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.luckyTitle.mas_bottom).offset(Margin_25);
        make.top.equalTo(self.luckyTitle.mas_bottom);
    }];
    
//    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.luckyTitle.mas_bottom).offset(Margin_25 + ScreenScale(60) * self->_showCount);
//    }];
    [self.activitiesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luckyTitle.mas_bottom).offset(Margin_10 + ScreenScale(60) * self->_showCount);
//        make.top.equalTo(self.cycleScrollView.mas_bottom).offset(Margin_10);
        make.centerX.mas_equalTo(0);
    }];
    [self.activitiesContentBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activitiesTitle.mas_bottom);
        make.left.mas_equalTo(0);
        make.width.mas_equalTo(DEVICE_WIDTH);
    }];
    [self.activitiesContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activitiesTitle.mas_bottom);
        make.left.mas_equalTo(Margin_Main);
        make.width.mas_equalTo(View_Width_Main);
        make.bottom.equalTo(self.activitiesContentBg.mas_bottom).offset(-Margin_10);
    }];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.activitiesContentBg.frame) + SafeAreaBottomH + Margin_10);
}
- (CFCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _showCount = MIN(5, _luckyArray.count);
        CGFloat cycleScrollViewH = ScreenScale(60) * _showCount;
        _cycleScrollView = [CFCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, cycleScrollViewH) dataSourceArray:self.luckyArray showItemCount: _showCount];
        _cycleScrollView.timeInterval = 1.5;
    }
    return _cycleScrollView;
}
- (UIView *)setupLineView
{
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = VIEWBG_COLOR;
    lineView.size = CGSizeMake(DEVICE_WIDTH, Margin_10);
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake(DEVICE_WIDTH, Margin_10));
    }];
    return lineView;
}
- (UIButton *)setupHeaderWithTitle:(NSString *)title
{
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = FONT_Bold(18);
    [button setTitleColor:Valentine_COLOR forState:UIControlStateNormal];
    button.contentEdgeInsets = UIEdgeInsetsMake(0, Margin_Main, 0, Margin_Main);
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    button.backgroundColor = [UIColor whiteColor];
    CGSize size = CGSizeMake(DEVICE_WIDTH, ScreenScale(65));
    [self.scrollView addSubview:button];
    [button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(size);
    }];
    return button;
}

@end
