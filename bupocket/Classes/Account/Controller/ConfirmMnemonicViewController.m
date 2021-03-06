//
//  ConfirmMnemonicViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ConfirmMnemonicViewController.h"

@interface ConfirmMnemonicViewController ()

@property (nonatomic, strong) UIScrollView * scrollView;
@property (nonatomic, strong) UIView * mnemonicBg;
@property (nonatomic, strong) NSMutableArray * tagArray;
@property (nonatomic, strong) NSMutableArray * tagButtons;
@property (nonatomic, strong) NSArray * randomArray;
@property (nonatomic, strong) UIButton * finish;

@end

@implementation ConfirmMnemonicViewController

- (NSMutableArray *)tagArray
{
    if (!_tagArray) {
        _tagArray = [NSMutableArray array];
    }
    return _tagArray;
}

- (NSMutableArray *)tagButtons
{
    if (!_tagButtons) {
        _tagButtons = [NSMutableArray array];
    }
    return _tagButtons;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"ConfirmMnemonic");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton createNavButtonWithTitle:Localized(@"Skip") Target:self Selector:@selector(skipAction)]];
    [self setupView];
    // Do any additional setup after loading the view.
}

- (void)skipAction
{
    NSArray * VCArray = self.navigationController.viewControllers;
    NSInteger index = 4;
    if (self.mnemonicType == MnemonicCreateWallet) {
        index = 5;
    }
    if (self.mnemonicType == MnemonicCreateID) {
        [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
    } else if (VCArray.count >= index) {
        [self.navigationController popToViewController:VCArray[VCArray.count - index] animated:NO];
    }
    
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
//    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    UILabel * confirmPrompt = [UILabel createTitleLabel];
    confirmPrompt.text = Localized(@"ConfirmMnemonicPrompt");
    [self.scrollView addSubview:confirmPrompt];
    [confirmPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_Main);
        make.left.mas_equalTo(Margin_Main);
        make.width.mas_equalTo(View_Width_Main);
    }];
    
    self.mnemonicBg = [[UIView alloc] init];
    self.mnemonicBg.clipsToBounds = YES;
    self.mnemonicBg.layer.masksToBounds = YES;
    self.mnemonicBg.layer.cornerRadius = MAIN_CORNER;
    self.mnemonicBg.backgroundColor = VIEWBG_COLOR;
    [self.scrollView addSubview:self.mnemonicBg];
    [self.mnemonicBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPrompt.mas_bottom).offset(Margin_Main);
        make.left.width.equalTo(confirmPrompt);
        make.height.mas_equalTo(ScreenScale(115));
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.bounds = CGRectMake(0, 0, View_Width_Main, LINE_WIDTH);
    [lineView drawDashLine];
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.mnemonicBg);
        make.top.equalTo(self.mnemonicBg.mas_bottom).offset(Margin_Main);
    }];
    self.randomArray = [self.mnemonicArray sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    CGFloat tagW = (View_Width_Main - Margin_30) / 4;
    CGFloat tagH = Margin_40;
//    CGFloat tagBgH = Margin_30 + (tagH + Margin_Main) * (self.randomArray.count / 4);
    for (NSInteger i = 0; i < self.randomArray.count; i ++) {
        UIButton * tagBtn = [UIButton createButtonWithTitle:self.randomArray[i] TextFont:FONT_15 TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(tagAction:)];
        [tagBtn setTitleColor:WHITE_BG_COLOR forState:UIControlStateSelected];
        tagBtn.backgroundColor = VIEWBG_COLOR;
        tagBtn.layer.cornerRadius = TAG_CORNER;
        tagBtn.tag = i;
        [self.scrollView addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(confirmPrompt.mas_left).offset((tagW + Margin_10) * (i % 4));
            make.top.equalTo(lineView.mas_bottom).offset(Margin_Main + (tagH + Margin_Main) * (i / 4));
            make.size.mas_equalTo(CGSizeMake(tagW, tagH));
        }];
    }
    self.finish = [UIButton createFooterViewWithTitle:Localized(@"Finished") isEnabled:NO Target:self Selector:@selector(finishedAction)];
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(0, CGRectGetMaxY(lineView.frame) + ScreenScale(135) + (tagH + Margin_10) * (self.mnemonicArray.count / 4) + ContentInset_Bottom);
}
- (void)tagAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = TAGBG_COLOR;
        [self.tagArray addObject:button.titleLabel.text];
        UIButton * tagButton = [UIButton createButtonWithTitle:button.titleLabel.text TextFont:FONT_15 TextNormalColor:COLOR_6 TextSelectedColor:COLOR_6 Target:nil Selector:nil];
        [tagButton sizeToFit];
        tagButton.tag = button.tag;
        [self.mnemonicBg addSubview:tagButton];
        [self.tagButtons addObject:tagButton];
    } else {
        button.backgroundColor = VIEWBG_COLOR;
        [self.tagButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * tagButton = (UIButton *)obj;
            if (tagButton.tag == button.tag) {
                [self.tagButtons removeObject:tagButton];
                [tagButton removeFromSuperview];
                [self.tagArray removeObject:button.titleLabel.text];
            }
        }];
    }
    [self updateTagButtonFrame];
    if ([self.tagArray isEqualToArray:self.mnemonicArray])  {
        self.finish.backgroundColor = MAIN_COLOR;
        self.finish.enabled = YES;
    } else {
        self.finish.backgroundColor = DISABLED_COLOR;
        self.finish.enabled = NO;
    }
}
- (void)updateTagButtonFrame
{
    for (int i = 0; i < self.tagButtons.count; i++) {
        UIButton * tagButton = self.tagButtons[i];
        if (i == 0) {
            tagButton.x = Margin_10;
            tagButton.y = 0;
        } else {
            UIButton *lastTagButton = self.tagButtons[i - 1];
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + Margin_10;
            CGFloat rightWidth = DEVICE_WIDTH - ScreenScale(50) - leftWidth;
            if (rightWidth >= tagButton.width) {
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else {
                tagButton.x = Margin_10;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame);
            }
        }
    }
}
- (void)finishedAction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:If_Backup];
    [defaults synchronize];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
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
