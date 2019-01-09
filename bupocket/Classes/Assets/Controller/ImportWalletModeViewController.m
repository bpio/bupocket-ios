//
//  ImportWalletModeViewController.m
//  bupocket
//
//  Created by huoss on 2019/1/9.
//  Copyright © 2019年 bupocket. All rights reserved.
//

#import "ImportWalletModeViewController.h"
#import "PlaceholderTextView.h"

@interface ImportWalletModeViewController ()<UITextViewDelegate, UITextFieldDelegate>

@property (nonatomic, strong) PlaceholderTextView * importText;
@property (nonatomic, strong) UITextField * contactField;
@property (nonatomic, strong) UIButton * submit;

@end

@implementation ImportWalletModeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setupView];
    // Do any additional setup after loading the view.
}
- (void)setupView
{
    UILabel * importPrompt = [[UILabel alloc] init];
    importPrompt.textColor = COLOR_9;
    importPrompt.font = TITLE_FONT;
    importPrompt.numberOfLines = 0;
    [self.view addSubview:importPrompt];
    [importPrompt mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(Margin_15);
        make.left.equalTo(self.view.mas_left).offset(Margin_15);
        make.right.equalTo(self.view.mas_right).offset(-Margin_15);
    }];
    
    self.importText = [[PlaceholderTextView alloc] init];
    self.importText.delegate = self;
    self.importText.backgroundColor = VIEWBG_COLOR;
    self.importText.layer.masksToBounds = YES;
    self.importText.layer.cornerRadius = BG_CORNER;
    [self.view addSubview:self.importText];
    [self.importText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(importPrompt.mas_bottom).offset(Margin_15);
        make.left.right.equalTo(importPrompt);
        make.height.mas_equalTo(ScreenScale(120));
    }];
    if ([self.title isEqualToString:Localized(@"Mnemonics")]) {
        importPrompt.text = Localized(@"ImportMnemonicsPrompt");
        self.importText.placeholder = Localized(@"PleaseEnterMnemonics");
    }
//    NSArray * array = @[Localized(@"QuestionsOrSuggestions"), Localized(@"YourContact")];
//    for (NSInteger i = 0; i < array.count; i++) {
//        UIView * titleView = [self setViewWithTitle:array[i]];
//        [self.view addSubview:titleView];
//        [titleView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.equalTo(self.view.mas_top).offset(Margin_15 + (ScreenScale(170) * i));
//            make.left.right.equalTo(self.view);
//            make.height.mas_equalTo(MAIN_HEIGHT);
//        }];
//    }
    
    UITextField * textField = [[UITextField alloc] init];
    textField.textColor = TITLE_COLOR;
    textField.font = FONT(16);
    textField.placeholder = Localized(@"PleaseEnterContact");
    textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    //    textField.keyboardType = UIKeyboardTypePhonePad;
    textField.delegate = self;
    [textField addTarget:self action:@selector(textChange:) forControlEvents:UIControlEventEditingChanged];
    [self.view addSubview:textField];
    [textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.importText.mas_bottom).offset(ScreenScale(55));
        make.left.right.equalTo(importPrompt);
        make.height.mas_equalTo(Margin_40);
    }];
    self.contactField = textField;
    UIView * line = [[UIView alloc] init];
    line.backgroundColor = LINE_COLOR;
    [self.view addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textField.mas_bottom);
        make.left.right.equalTo(importPrompt);
        make.height.mas_equalTo(LINE_WIDTH);
    }];
    UIButton * submit = [UIButton createButtonWithTitle:Localized(@"Submission") isEnabled:NO Target:self Selector:@selector(submitAction)];
    [self.view addSubview:submit];
    [submit mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.view.mas_bottom).offset(-Margin_30 - SafeAreaBottomH);
        make.left.right.equalTo(importPrompt);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    self.submit = submit;
}

- (void)submitAction
{
}
- (void)textViewDidChange:(UITextView *)textView
{
    [self judgeHasText];
    NSString * content = textView.text;
    if (content.length > SuggestionsContent_MAX) {
        NSString * contentText = [content substringToIndex:SuggestionsContent_MAX];
        [textView setText:contentText];
    }
}
- (void)textChange:(UITextField *)textField
{
    [self judgeHasText];
}
- (void)judgeHasText
{
//    self.feedback = [self.feedbackText.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    self.feedback = [self.feedback stringByReplacingOccurrencesOfString:@"\n" withString:@""];
//    self.contact = [self.contactField.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
//    if (self.feedback.length > 0 && self.contact.length > 0) {
//        self.submit.enabled = YES;
//        self.submit.backgroundColor = MAIN_COLOR;
//    } else {
//        self.submit.enabled = NO;
//        self.submit.backgroundColor = DISABLED_COLOR;
//    }
}
- (UIView *)setViewWithTitle:(NSString *)title
{
    UIView * viewBg = [[UIView alloc] init];
    UILabel * header = [[UILabel alloc] init];
    [viewBg addSubview:header];
    header.attributedText = [Encapsulation attrTitle:title ifRequired:NO];
    [header mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.bottom.equalTo(viewBg);
        make.left.equalTo(viewBg.mas_left).offset(Margin_20);
        make.right.equalTo(viewBg.mas_right).offset(-Margin_20);
    }];
    return viewBg;
}
/*
 - (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
 {
 NSString * str = [textField.text stringByReplacingCharactersInRange:range withString:string];
 if (string.length == 0) {
 return YES;
 }
 if (textField == _contactField) {
 if (str.length > MAX_LENGTH) {
 textField.text = [str substringToIndex:MAX_LENGTH];
 return NO;
 } else {
 return YES;
 }
 }
 return YES;
 }
 */
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
