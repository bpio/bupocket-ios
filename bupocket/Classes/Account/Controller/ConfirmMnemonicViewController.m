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
/** 所有的标签 */
@property (nonatomic, strong) NSMutableArray * tagArray;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray * tagButtons;
/** 随机数组 */
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
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
}
- (void)setupView
{
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, DEVICE_WIDTH, DEVICE_HEIGHT)];
    self.scrollView.contentInset = UIEdgeInsetsMake(0, 0, SafeAreaBottomH + NavBarH + Margin_10, 0);
    //    self.scrollView.scrollsToTop = NO;
    //    self.scrollView.delegate = self;
    self.scrollView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self.view addSubview:self.scrollView];
    //    self.noDataBtn = [Encapsulation showNoDataWithSuperView:self.view frame:self.view.frame];
    //    self.noNetWork = [Encapsulation showNoNetWorkWithSuperView:self.view frame:self.view.frame target:self action:@selector(getDataWithtxt_text:pageindex:)];
    UILabel * confirmPrompt = [[UILabel alloc] init];
    confirmPrompt.font = TITLE_FONT;
    confirmPrompt.textColor = COLOR_9;
    confirmPrompt.text = Localized(@"ConfirmMnemonicPrompt");
    [self.scrollView addSubview:confirmPrompt];
    [confirmPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(Margin_10);
        make.left.mas_equalTo(Margin_30);
        make.width.mas_equalTo(DEVICE_WIDTH - Margin_60);
    }];
    
    self.mnemonicBg = [[UIView alloc] init];
    self.mnemonicBg.backgroundColor = VIEWBG_COLOR;
    self.mnemonicBg.layer.cornerRadius = TAG_FILLET;
    [self.scrollView addSubview:self.mnemonicBg];
    [self.mnemonicBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPrompt.mas_bottom).offset(Margin_40);
        make.left.width.equalTo(confirmPrompt);
        make.height.mas_equalTo(ScreenScale(145));
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - Margin_60, LINE_WIDTH);
    [lineView drawDashLine];
    [self.scrollView addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(confirmPrompt);
        make.top.equalTo(self.mnemonicBg.mas_bottom).offset(Margin_15);
    }];
    self.randomArray = [self.mnemonicArray sortedArrayUsingComparator:^NSComparisonResult(NSString *str1, NSString *str2) {
        int seed = arc4random_uniform(2);
        if (seed) {
            return [str1 compare:str2];
        } else {
            return [str2 compare:str1];
        }
    }];
    CGFloat tagW = (DEVICE_WIDTH - ScreenScale(90)) / 4;
    CGFloat tagH = Margin_40;
    CGFloat tagBgH = Margin_20 + (tagH + Margin_10) * (self.randomArray.count / 4) +  MAIN_HEIGHT;
    for (NSInteger i = 0; i < self.randomArray.count; i ++) {
        UIButton * tagBtn = [UIButton createButtonWithTitle:self.randomArray[i] TextFont:14 TextNormalColor:MAIN_COLOR TextSelectedColor:[UIColor whiteColor] NormalImage:nil SelectedImage:nil Target:self Selector:@selector(tagAction:)];
        tagBtn.backgroundColor = VIEWBG_COLOR;
        tagBtn.layer.cornerRadius = TAG_FILLET;
        tagBtn.tag = i;
        [self.scrollView addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(confirmPrompt.mas_left).offset((tagW + Margin_10) * (i % 4));
            make.top.equalTo(lineView.mas_bottom).offset(Margin_20 + (tagH + Margin_10) * (i / 4));
            make.size.mas_equalTo(CGSizeMake(tagW, tagH));
        }];
    }
    UIButton * finish = [UIButton createButtonWithTitle:Localized(@"Finished") isEnabled:NO Target:self Selector:@selector(finishedAction)];
    [self.scrollView addSubview:finish];
    [finish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(tagBgH);
        make.left.width.equalTo(confirmPrompt);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.finish = finish;
    [self.view layoutIfNeeded];
    self.scrollView.contentSize = CGSizeMake(DEVICE_WIDTH, CGRectGetMaxY(finish.frame) + Margin_50);
}
- (void)tagAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = MAIN_COLOR;
        [self.tagArray addObject:button.titleLabel.text];
        UIButton * tagButton = [UIButton createButtonWithTitle:button.titleLabel.text TextFont:15 TextColor:COLOR_6 Target:nil Selector:nil];
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
            CGFloat rightWidth = DEVICE_WIDTH - ScreenScale(70) - leftWidth;
            if (rightWidth >= tagButton.width) {
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else {
                tagButton.x = Margin_10;
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + Margin_10;
            }
        }
    }
}
- (void)finishedAction
{
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:ifBackup];
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
