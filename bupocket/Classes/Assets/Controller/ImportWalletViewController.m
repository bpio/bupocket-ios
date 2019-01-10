//
//  ImportWalletViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/9.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ImportWalletViewController.h"
#import "ImportWalletModeViewController.h"

@interface ImportWalletViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UIButton * selectedButton;
@property (nonatomic, strong) UIView * line;
@property (nonatomic, strong) NSMutableArray * btnArray;
@property (nonatomic, copy) NSArray * typeArray;
@property (nonatomic, strong) UIScrollView * contentScrollView;
@property (nonatomic, strong) UIViewController * currentVC;

@end

@implementation ImportWalletViewController

- (NSMutableArray *)btnArray
{
    if (!_btnArray) {
        _btnArray = [NSMutableArray array];
    }
    return _btnArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ImportWallet");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    self.typeArray = @[Localized(@"Mnemonics"), Localized(@"Keystore"), Localized(@"PrivateKey")];
    CGFloat width = DEVICE_WIDTH / self.typeArray.count;
    for (int i = 0; i < self.typeArray.count; i++) {
        UIButton * navBtn = [UIButton createButtonWithTitle:self.typeArray[i] TextFont:16 TextNormalColor:COLOR_6 TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(navAction:)];
        navBtn.tag = i;
        [self.view addSubview:navBtn];
        [navBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.left.equalTo(self.view.mas_left).offset(width * i);
            make.size.mas_equalTo(CGSizeMake(width, MAIN_HEIGHT));
        }];
        [self.btnArray addObject:navBtn];
        if (i == 0) {
            navBtn.selected = YES;
            self.selectedButton = navBtn;
        }
    }
    [self.selectedButton layoutIfNeeded];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = VIEWBG_COLOR;
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.bottom.equalTo(self.selectedButton);
        make.height.mas_equalTo(ScreenScale(1.5));
    }];
    self.line = [[UIView alloc] init];
    self.line.backgroundColor = MAIN_COLOR;
    [self.view addSubview:self.line];
//    CGFloat lineW = [Encapsulation rectWithText:self.typeArray[0] font:FONT(16) textHeight:ScreenScale(16)].size.width;
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.bottom.equalTo(self.selectedButton);
        make.height.mas_equalTo(ScreenScale(3));
        make.width.mas_equalTo(self.selectedButton.titleLabel.width);
    }];
    
    
    _contentScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, MAIN_HEIGHT, DEVICE_WIDTH, DEVICE_HEIGHT - (NavBarH + MAIN_HEIGHT))];
    _contentScrollView.pagingEnabled = YES;
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.showsVerticalScrollIndicator = YES;
    _contentScrollView.showsHorizontalScrollIndicator = YES;
    [self.view addSubview:_contentScrollView];
    self.contentScrollView.contentSize = CGSizeMake(DEVICE_WIDTH * self.typeArray.count, 0);
    [self setupChildVcWithTitleArray:self.typeArray];
}
- (void)navAction:(UIButton *)button
{
    CGPoint offset = self.contentScrollView.contentOffset;
    offset.x = button.tag * self.contentScrollView.frame.size.width;
    [self.contentScrollView setContentOffset:offset animated:YES];
}
- (void)setupChildVcWithTitleArray:(NSArray *)titleArray
{
    for (UIViewController * VC in self.childViewControllers) {
        [VC removeFromParentViewController];
    }
    for (int i = 0; i < titleArray.count; i++) {
        ImportWalletModeViewController * VC = [[ImportWalletModeViewController alloc] init];
        VC.title = titleArray[i];
        VC.view.frame = CGRectMake(DEVICE_WIDTH * i, 0, _contentScrollView.frame.size.width, _contentScrollView.frame.size.height);
        [self.contentScrollView addSubview:VC.view];
        [self addChildViewController:VC];
    }
    self.contentScrollView.contentSize = CGSizeMake(self.childViewControllers.count * DEVICE_WIDTH, 0);
    [self scrollViewDidEndScrollingAnimation:self.contentScrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    CGFloat offsetX = scrollView.contentOffset.x;
    NSInteger index = offsetX / DEVICE_WIDTH;
    self.selectedButton.selected = NO;
    for (UIButton * button in self.btnArray) {
        if (button.tag == index) {
            button.selected = YES;
            self.selectedButton = button;
            [self.line mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.centerX.bottom.equalTo(self.selectedButton);
                make.height.mas_equalTo(2);
                make.width.mas_equalTo(self.selectedButton.titleLabel.width);
            }];
        }
    }
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self scrollViewDidEndScrollingAnimation:scrollView];
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
