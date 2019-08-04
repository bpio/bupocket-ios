//
//  RedEnvelopesViewController.m
//  bupocket
//
//  Created by huoss on 2019/8/2.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "RedEnvelopesViewController.h"
#import "RedEnvelopesInfo.h"
#import "CFCycleScrollView.h"
#import "ActivityResultModel.h"
#import "ActivityAwardsModel.h"

@interface RedEnvelopesViewController()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) CFCycleScrollView * cycleScrollView;
@property (nonatomic, strong) NSArray * luckyArray;
@property (nonatomic, strong) ActivityResultModel * activityResultModel;

@property (nonatomic, strong) UILabel * luckyTitle;
@property (nonatomic, strong) UIView * line1;
@property (nonatomic, strong) UILabel * activitiesTitle;
@property (nonatomic, strong) UILabel * activitiesContent;
@property (nonatomic, assign) NSInteger showCount;
@property (nonatomic, strong) dispatch_source_t timer;

@end

@implementation RedEnvelopesViewController

//- (void)viewDidLoad
//{
//    [super viewDidLoad];
//    [self setupView];
//}
//- (void)setupView
//{
//    _cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(Margin_15, 0, View_Width_Main, ScreenScale(200)) imageNamesGroup:nil];
//    _cycleScrollView.onlyDisplayText = YES;
//    _cycleScrollView.autoScrollTimeInterval = 2.5;
//    _cycleScrollView.scrollDirection = UICollectionViewScrollDirectionVertical;
//    /** 轮播文字label字体颜色 */
//    _cycleScrollView.titleLabelTextColor = TITLE_COLOR;
//
//    /** 轮播文字label字体大小 */
//    _cycleScrollView.titleLabelTextFont = FONT(14);
//
//    /** 轮播文字label背景颜色 */
//    _cycleScrollView.titleLabelBackgroundColor = RandomColor;
//    _cycleScrollView.titleLabelHeight = ScreenScale(200);
//
//    /** 轮播文字label高度 */
//    //        _cycleScrollView.titleLabelHeight = 70;
//    [self.view addSubview:_cycleScrollView];
//
//    self.noticeArray = @[@"1分钟前 buQsUE***JCNmM1领取了 7777.77 BU",
//                         @"10分钟前 buQsUE***JCNmM1领取了 520 BU",
//                         @"19分钟前 buQsUE***JCNmM1领取了 520 BU",
//                         @"1小时前 buQsUE***JCNmM1领取了 1314 BU",
//                         @"2小时前 buQsUE***JCNmM1领取了 999.99 BU"];
//    _cycleScrollView.titlesGroup = self.noticeArray;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"领取成功";
    /*
    self.title = @"DEMO入口";
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    UILabel *titleL = [[UILabel alloc] initWithFrame:CGRectMake(0, 100, self.view.cf_width, 50)];
    titleL.numberOfLines = 0;
    titleL.textAlignment = NSTextAlignmentCenter;
    titleL.textColor = CFRandomColor;
    titleL.text = @"交流QQ 545486205\n个人github网址:https://github.com/CoderPeak";
    [self.view addSubview:titleL];
    
    
    
    UIButton *btn00 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn00 setTitle:@"点此进入--> 竖直-一行循环轮播 >>>" forState:UIControlStateNormal];
    [btn00 addTarget:self action:@selector(toVC00) forControlEvents:UIControlEventTouchUpInside];
    btn00.frame = CGRectMake(0, 180, self.view.cf_width, 50);
    [btn00 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn00.backgroundColor = CFRandomColor;
    [self.view addSubview:btn00];
    UIButton *btn01 = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [btn01 setTitle:@"点此进入--> 水平-一行循环轮播 >>>" forState:UIControlStateNormal];
    [btn01 addTarget:self action:@selector(toVC01) forControlEvents:UIControlEventTouchUpInside];
    btn01.frame = CGRectMake(0, 230, self.view.cf_width, 50);
    [btn01 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn01.backgroundColor = CFRandomColor;
    [self.view addSubview:btn01];
    
    
    UIButton *btn10 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn10 setTitle:@"点此进入--> 竖直-二行循环轮播 >>>" forState:UIControlStateNormal];
    [btn10 addTarget:self action:@selector(toVC10) forControlEvents:UIControlEventTouchUpInside];
    btn10.frame = CGRectMake(0, 300, self.view.cf_width, 50);
    [btn10 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn10.titleLabel.numberOfLines = 0;
    btn10.backgroundColor = CFRandomColor;
    [self.view addSubview:btn10];
    
    UIButton *btn11 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn11 setTitle:@"点此进入--> 水平-二行循环轮播 >>>" forState:UIControlStateNormal];
    [btn11 addTarget:self action:@selector(toVC11) forControlEvents:UIControlEventTouchUpInside];
    btn11.frame = CGRectMake(0, 350, self.view.cf_width, 50);
    [btn11 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn11.titleLabel.numberOfLines = 0;
    btn11.backgroundColor = CFRandomColor;
    [self.view addSubview:btn11];
    
    
    UIButton *btn20 = [UIButton buttonWithType:UIButtonTypeCustom];
    btn20.titleLabel.numberOfLines = 0;
    [btn20 setTitle:@"点此进入--> 竖直-三行循环轮播 >>>" forState:UIControlStateNormal];
    [btn20 addTarget:self action:@selector(toVC20) forControlEvents:UIControlEventTouchUpInside];
    btn20.frame = CGRectMake(0, 420, self.view.cf_width, 50);
    [btn20 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    btn20.backgroundColor = CFRandomColor;
    [self.view addSubview:btn20];
    
    
    */
    [self loopGetData];
}
- (void)getActivityData
{
    [MBProgressHUD showActivityMessageInWindow:Localized(@"Loading")];
    [[HTTPManager shareManager] getActivityDataWithURL:Activity_Detail bonusCode:self.activityID success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
        if (code == Success_Code) {
            NSDictionary * dataDic = [responseObject objectForKey:@"data"];
            self.activityResultModel = [ActivityResultModel mj_objectWithKeyValues:dataDic];
            self.luckyArray = [ActivityAwardsModel mj_objectArrayWithKeyValuesArray:self.activityResultModel.latelyData[@"data"]];
            [self setupView];
        } else if (code == 100022) {
            // 已领取红包
            
        }
    } failure:^(NSError *error) {
        
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
    uint64_t interval = (uint64_t)((5.0 * 60) * NSEC_PER_SEC);
    dispatch_source_set_timer(self.timer, start, interval, 0);
    //设置回调
    dispatch_source_set_event_handler(self.timer, ^{
        //重复执行的事件
        count++;
        NSLog(@"-----%ld-----", count);
        [[HTTPManager shareManager] getActivityDataWithURL:Activity_Detail bonusCode:self.activityID success:^(id responseObject) {
            NSInteger code = [[responseObject objectForKey:@"errCode"] integerValue];
            if (code == Success_Code) {
                NSDictionary * dataDic = [responseObject objectForKey:@"data"];
                self.activityResultModel = [ActivityResultModel mj_objectWithKeyValues:dataDic];
                self.luckyArray = [ActivityAwardsModel mj_objectArrayWithKeyValuesArray:self.activityResultModel.latelyData[@"data"]];
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
        } failure:^(NSError *error) {
            NSLog(@"%@",error);
        }];
    });
    //启动定时器
    dispatch_resume(self.timer);
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
    [self.view addSubview:self.scrollView];
    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    RedEnvelopesInfo * infoView = [[RedEnvelopesInfo alloc] initWithRedEnvelopesType:RedEnvelopesTypeNormal confrimBolck:nil cancelBlock:nil];
    infoView.activityInfoModel = [ActivityInfoModel mj_objectWithKeyValues:self.activityResultModel.bonusInfo];
    [infoView showInWindowWithMode:CustomAnimationModeView inView:self.scrollView bgAlpha:0 needEffectView:NO];

    UIView * line0 = [self setupLineView];
    [line0 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(infoView.mas_bottom);
//        make.left.mas_equalTo(0);
    }];
    self.luckyTitle = [self setupHeaderWithTitle:self.activityResultModel.latelyData[@"label"]];
    [self.scrollView addSubview:self.luckyTitle];
    [self.luckyTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line0.mas_bottom).offset(Margin_20);
        make.centerX.mas_equalTo(0);
    }];
    
    [self.scrollView addSubview:self.cycleScrollView];
    
    self.line1 = [self setupLineView];
    self.activitiesTitle = [self setupHeaderWithTitle:self.activityResultModel.activityRules[@"label"]];
    [self.scrollView addSubview:self.activitiesTitle];
    
    [self.scrollView addSubview:self.activitiesContent];
    [self updateLayout];
    // @"1. 活动时间：2019年8月7日 00:00 - 24:00 ；\n2. 每个设备ID仅限领取一次七夕节日红包，红包领取成功后存放入当前使用钱包，可在当前使用钱包的资产余额中和最新交易记录中进行查询；\n3. 红包最大额度为7777.77 BU，领取成功后可点击「保存图片并分享」按钮，邀请好友一起领取七夕节日红包，先到先得；\n4. 本活动解释权归小布口袋所有。"
}
- (UILabel *)activitiesContent
{
    if (!_activitiesContent) {
        _activitiesContent = [[UILabel alloc] init];
        _activitiesContent.numberOfLines = 0;
        _activitiesContent.attributedText = [Encapsulation attrWithString:self.activityResultModel.activityRules[@"data"] font:FONT_TITLE color:COLOR_6 lineSpacing:LINE_SPACING];
    }
    return _activitiesContent;
}
- (void)updateLayout
{
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luckyTitle.mas_bottom).offset(Margin_25);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.luckyTitle.mas_bottom).offset(Margin_25 + ScreenScale(60) * _showCount);
    }];
    [self.activitiesTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.line1.mas_bottom).offset(Margin_20);
        make.centerX.mas_equalTo(0);
    }];
    [self.activitiesContent mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.activitiesTitle.mas_bottom).offset(Margin_25);
        make.left.mas_equalTo(Margin_Main);
        make.width.mas_equalTo(View_Width_Main);
    }];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(self.activitiesContent.frame) + ContentInset_Bottom);
}
- (CFCycleScrollView *)cycleScrollView
{
    if (!_cycleScrollView) {
        _showCount = MIN(5, _luckyArray.count);
        CGFloat cycleScrollViewH = ScreenScale(60) * _showCount;
        _cycleScrollView = [CFCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, cycleScrollViewH) dataSourceArray:self.luckyArray showItemCount: _showCount];
        _cycleScrollView.timeInterval = 2.0;
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
- (UILabel *)setupHeaderWithTitle:(NSString *)title
{
    UILabel * label = [[UILabel alloc] init];
    label.textColor = Valentine_COLOR;
    label.font = FONT_Bold(18);
    label.text = title;
    label.textAlignment = NSTextAlignmentCenter;
//    label.size = CGSizeMake(DEVICE_WIDTH, ScreenScale(65));
    return label;
}

@end
