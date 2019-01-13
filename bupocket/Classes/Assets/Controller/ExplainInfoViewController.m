//
//  ExplainInfoViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/11.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ExplainInfoViewController.h"

@interface ExplainInfoViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;

@end

@implementation ExplainInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    [self.view addSubview:self.scrollView];
    
    UILabel * titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = TITLE_COLOR;
    titleLabel.font = FONT(18);
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.numberOfLines = 0;
    titleLabel.text = self.titleText;
    [self.scrollView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(0);
        make.top.mas_equalTo(Margin_20);
        make.width.mas_lessThanOrEqualTo(DEVICE_WIDTH - Margin_40);
    }];
    
    UILabel * infoLabel = [[UILabel alloc] init];
    infoLabel.textColor = TITLE_COLOR;
    infoLabel.font = FONT(14);
    infoLabel.numberOfLines = 0;
    infoLabel.text = self.explainInfoText;
    [self.scrollView addSubview:infoLabel];
    [infoLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(Margin_20);
        make.left.mas_equalTo(Margin_20);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_40);
    }];
    
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(infoLabel.frame) + ContentSizeBottom + ScreenScale(100));
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
