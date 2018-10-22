//
//  ConfirmMnemonicViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "ConfirmMnemonicViewController.h"
#import "TabBarViewController.h"

@interface ConfirmMnemonicViewController ()

@property (nonatomic, strong) UIView * mnemonicBg;
/** 所有的标签 */
@property (nonatomic, strong) NSMutableArray * tagArray;
/** 所有的标签按钮 */
@property (nonatomic, strong) NSMutableArray * tagButtons;

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
    self.navigationItem.title = Localized(@"BackupMnemonics");
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:[UIButton createButtonWithTitle:@"跳过" TextFont:16 TextColor:COLOR(@"5745C3") Target:self Selector:@selector(skipAction)]];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)skipAction
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
}
- (void)setupView
{
    // 请按顺序点击助记词，以确认您正确备份。
    UILabel * confirmPrompt = [[UILabel alloc] init];
    confirmPrompt.font = FONT(14);
    confirmPrompt.textColor = COLOR(@"999999");
    confirmPrompt.text = Localized(@"ConfirmMnemonic");
    [self.view addSubview:confirmPrompt];
    [confirmPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavBarH + ScreenScale(15));
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(30));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(30));
    }];
    
    self.mnemonicBg = [[UIView alloc] init];
    self.mnemonicBg.backgroundColor = COLOR(@"F5F5F5");
    self.mnemonicBg.layer.cornerRadius = ScreenScale(2);
    [self.view addSubview:self.mnemonicBg];
    [self.mnemonicBg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(confirmPrompt.mas_bottom).offset(40);
        make.left.right.equalTo(confirmPrompt);
        make.height.mas_equalTo(ScreenScale(145));
    }];
    
    UIView * lineView = [[UIView alloc] init];
    lineView.bounds = CGRectMake(0, 0, DEVICE_WIDTH - ScreenScale(60), ScreenScale(1.5));
    [lineView drawDashLine:lineView lineLength:ScreenScale(3) lineSpacing:ScreenScale(1) lineColor:COLOR(@"E3E3E3")];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(confirmPrompt);
        make.top.equalTo(self.mnemonicBg.mas_bottom).offset(ScreenScale(13));
//        make.height.mas_equalTo(ScreenScale(1.5));
    }];
    
    NSArray * array = @[@"bestball", @"merge", @"river", @"tag", @"mnemoni", @"bestball", @"merge", @"river", @"tag", @"mnemoni"];
    CGFloat tagW = (DEVICE_WIDTH - ScreenScale(90)) / 4;
    CGFloat tagH = ScreenScale(40);
    for (NSInteger i = 0; i < array.count; i ++) {
        UIButton * tagBtn = [UIButton createButtonWithTitle:array[i] TextFont:15 TextNormalColor:MAIN_COLOR TextSelectedColor:[UIColor whiteColor] NormalImage:nil SelectedImage:nil Target:self Selector:@selector(tagAction:)];
        tagBtn.backgroundColor = COLOR(@"F5F5F5");
        tagBtn.layer.cornerRadius = ScreenScale(2);
        tagBtn.tag = i;
        [self.view addSubview:tagBtn];
        [tagBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(confirmPrompt.mas_left).offset((tagW + ScreenScale(10)) * (i % 4));
            make.top.equalTo(lineView.mas_bottom).offset(ScreenScale(20) + (tagH + ScreenScale(10)) * (i / 4));
            make.size.mas_equalTo(CGSizeMake(tagW, tagH));
        }];
    }
    //    [self setupTagsViewWithArray:array];
    //    [self.view addSubview:self.tagView];
    //    [self.tagView mas_makeConstraints:^(MASConstraintMaker *make) {
    //        make.top.equalTo(savePrompt.mas_bottom).offset(ScreenScale(15));
    //        make.left.right.equalTo(promptBg);
    //    }];
    //    self.tagView.backgroundColor = [UIColor redColor];
    
    UIButton * finish = [UIButton createButtonWithTitle:Localized(@"Finished") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(finishedAction)];
    finish.layer.masksToBounds = YES;
    finish.clipsToBounds = YES;
    finish.layer.cornerRadius = ScreenScale(4);
    finish.backgroundColor = MAIN_COLOR;
    [self.view addSubview:finish];
    [finish mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-ScreenScale(55) - SafeAreaBottomH);
        make.left.right.equalTo(self.mnemonicBg);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
/**
 * 标签按钮的点击
 */
- (void)tagAction:(UIButton *)button
{
    button.selected = !button.selected;
    if (button.selected) {
        button.backgroundColor = MAIN_COLOR;
        [self.tagArray addObject:button.titleLabel.text];
        // 添加一个"标签按钮"
        UIButton *tagButton = [UIButton createButtonWithTitle:button.titleLabel.text TextFont:15 TextColor:COLOR(@"666666") Target:nil Selector:nil];
        [tagButton sizeToFit];
        tagButton.tag = button.tag;
        //        [tagButton addTarget:self action:@selector(tagButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [self.mnemonicBg addSubview:tagButton];
        [self.tagButtons addObject:tagButton];
    } else {
        button.backgroundColor = COLOR(@"F5F5F5");
        [self.tagButtons enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton * tagButton = (UIButton *)obj;
//            if ([tagButton.titleLabel.text isEqualToString:button.titleLabel.text]) {
            if (tagButton.tag == button.tag) {
                [self.tagButtons removeObject:tagButton];
                [tagButton removeFromSuperview];
                [self.tagArray removeObject:button.titleLabel.text];
            }
        }];
    }
    // 重新更新所有标签按钮的frame
    [self updateTagButtonFrame];
}
#pragma mark - 子控件的frame处理
- (void)updateTagButtonFrame
{
    // 更新标签按钮的frame
    for (int i = 0; i < self.tagButtons.count; i++) {
        UIButton * tagButton = self.tagButtons[i];
        if (i == 0) { // 最前面的标签按钮
            tagButton.x = ScreenScale(10);
            tagButton.y = 0;
        } else { // 其他标签按钮
            UIButton *lastTagButton = self.tagButtons[i - 1];
            // 计算当前行左边的宽度
            CGFloat leftWidth = CGRectGetMaxX(lastTagButton.frame) + ScreenScale(10);
            // 计算当前行右边的宽度
            CGFloat rightWidth = DEVICE_WIDTH - ScreenScale(70) - leftWidth;
            if (rightWidth >= tagButton.width) { // 按钮显示在当前行
                tagButton.y = lastTagButton.y;
                tagButton.x = leftWidth;
            } else { // 按钮显示在下一行
                tagButton.x = ScreenScale(10);
                tagButton.y = CGRectGetMaxY(lastTagButton.frame) + ScreenScale(10);
            }
        }
        
    }
}
- (void)finishedAction
{
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
}

/*
 - (UIView *)setupTagsViewWithArray:(NSArray *)array
 {
 _tagView = [[UIView alloc] init];
 CGFloat tagViewW = (DEVICE_WIDTH - ScreenScale(60));
 CGFloat currentX = 0;
 CGFloat currentY = 0;
 CGFloat countRow = 0;
 CGFloat countCol = 0;
 for (int i = 0; i < array.count; i ++) {
 UILabel *label = [[UILabel alloc] init];
 label.userInteractionEnabled = YES;
 label.font = FONT(15);
 label.textColor = COLOR(@"999999");
 label.backgroundColor = COLOR(@"F5F5F5");
 label.text = array[i];
 label.layer.cornerRadius = ScreenScale(2);
 label.clipsToBounds = YES;
 label.textAlignment = NSTextAlignmentCenter;
 [label sizeToFit];
 label.width += ScreenScale(20);
 //        label.height += 14;
 label.height = ScreenScale(40);
 if (label.width > tagViewW - ScreenScale(20)) label.width = tagViewW - ScreenScale(20);
 if (currentX + label.width + ScreenScale(10) * countRow > tagViewW - ScreenScale(20)) {
 label.left = 0;
 label.top = (currentY += label.height) + ScreenScale(10) * ++countCol;
 currentX = label.width;
 countRow = 1;
 } else {
 label.left = (currentX += label.width) - label.width + ScreenScale(10) * countRow;
 label.top = currentY + ScreenScale(10) * countCol;
 countRow ++;
 }
 [_tagView addSubview:label];
 //        [label addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidCLick:)]];
 }
 _tagView.frame = CGRectMake(0, 0, tagViewW, CGRectGetMaxY(_tagView.subviews.lastObject.frame));
 return _tagView;
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
