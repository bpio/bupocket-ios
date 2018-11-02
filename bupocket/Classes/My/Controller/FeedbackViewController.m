//
//  FeedbackViewController.m
//  bupocket
//
//  Created by bupocket on 2018/10/19.
//  Copyright © 2018年 bupocket. All rights reserved.
//

#import "FeedbackViewController.h"
#import "PlaceholderTextView.h"

@interface FeedbackViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) PlaceholderTextView * feedbackText;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"Feedback");
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    NSArray * array = @[Localized(@"QuestionsOrSuggestions"), Localized(@"YourContact")];
    for (NSInteger i = 0; i < array.count; i++) {
        UIView * titleView = [self setViewWithTitle:array[i]];
        [self.view addSubview:titleView];
        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view.mas_top).offset(NavBarH + ScreenScale(15) + (ScreenScale(170) * i));
            make.left.right.equalTo(self.view);
            make.height.mas_equalTo(MAIN_HEIGHT);
        }];
    }
    [self.view addSubview:self.feedbackText];
    [self.feedbackText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(NavBarH + ScreenScale(15) + MAIN_HEIGHT);
        make.left.equalTo(self.view.mas_left).offset(Margin_12);
        make.right.equalTo(self.view.mas_right).offset(-Margin_12);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    UIView * lineView = [[UIView alloc] init];
    lineView.backgroundColor = COLOR(@"E3E3E3");
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.feedbackText.mas_bottom);
        make.left.equalTo(self.view.mas_left).offset(ScreenScale(22));
        make.right.equalTo(self.view.mas_right).offset(-ScreenScale(22));
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(16);
    textField.placeholder = Localized(@"PleaseEnterContact");
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.delegate = self;
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(lineView.mas_bottom).offset(ScreenScale(55));
        make.left.equalTo(self.view.mas_left).offset(Margin_30);
        make.right.equalTo(self.view.mas_right).offset(-Margin_30);
        make.height.mas_equalTo(Margin_40);
    }];
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = COLOR(@"E3E3E3");
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.right.equalTo(lineView);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    UIButton * submit = [UIButton createButtonWithTitle:Localized(@"Submit") TextFont:18 TextColor:[UIColor whiteColor] Target:self Selector:@selector(submitAction)];
    submit.layer.masksToBounds = YES;
    submit.clipsToBounds = YES;
    submit.layer.cornerRadius = ScreenScale(4);
    submit.backgroundColor = MAIN_COLOR;
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_30 - SafeAreaBottomH);
        make.left.right.equalTo(self.feedbackText);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
}
- (void)submitAction
{
    
}
- (PlaceholderTextView *)feedbackText
{
    if (!_feedbackText) {
        _feedbackText = [[PlaceholderTextView alloc] init];
        _feedbackText.font = FONT(15);
        _feedbackText.textColor = COLOR_6;
        _feedbackText.placeholderColor = COLOR(@"B2B2B2");
        _feedbackText.placeholder = Localized(@"PleaseEnterQOrS");
        _feedbackText.delegate = self;
        CGFloat xMargin = ScreenScale(8), yMargin = ScreenScale(8);
        // 使用textContainerInset设置top、left、right
        _feedbackText.textContainerInset = UIEdgeInsetsMake(yMargin, xMargin, 0, xMargin);
        //当光标在最后一行时，始终显示低边距，需使用contentInset设置bottom.
        _feedbackText.contentInset = UIEdgeInsetsMake(0, 0, yMargin, 0);
        //防止在拼音打字时抖动
        _feedbackText.layoutManager.allowsNonContiguousLayout = NO;
//        _feedbackText.layer.masksToBounds = YES;
//        _feedbackText.layer.cornerRadius = ScreenScale(5);
    }
    return _feedbackText;
}
- (UIView *)setViewWithTitle:(NSString *)title
{
    UIView * viewBg = [[UIView alloc] init];
    UILabel * header = [[UILabel alloc] init];
    header.font = FONT(16);
    header.textColor = COLOR_9;
    [viewBg addSubview:header];
    NSMutableAttributedString * attr = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"| %@", title]];
    //        NSMutableDictionary * dic = [NSMutableDictionary dictionary];
    //        dic[NSFontAttributeName] = FONT(15);
    //        dic[NSForegroundColorAttributeName] = TITLE_COLOR;
    //        [attr addAttributes:dic range:NSMakeRange(3, str.length - 3)];
    [attr addAttribute:NSForegroundColorAttributeName value:MAIN_COLOR range:NSMakeRange(0, 1)];
    [attr addAttribute:NSFontAttributeName value:FONT_Bold(18) range:NSMakeRange(0, 1)];
    header.attributedText = attr;
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(viewBg);
        make.left.equalTo(viewBg.mas_left).offset(ScreenScale(22));
        make.right.equalTo(viewBg.mas_right).offset(-ScreenScale(22));
    }];
    return viewBg;
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
