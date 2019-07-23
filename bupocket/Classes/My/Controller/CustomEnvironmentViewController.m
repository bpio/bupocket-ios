//
//  CustomEnvironmentViewController.m
//  bupocket
//
//  Created by huoss on 2019/6/26.
//  Copyright © 2019 bupocket. All rights reserved.
//

#import "CustomEnvironmentViewController.h"
#import "TextFieldViewCell.h"

@interface CustomEnvironmentViewController ()<UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIButton * rightBtn;
@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * listArray;
@property (nonatomic, strong) UIView * footerView;

@property (nonatomic, strong) UIButton * next;
@property (nonatomic, strong) UILabel * notes;

@property (nonatomic, strong) UITextField * walletText;
@property (nonatomic, strong) UITextField * nodeText;

@property (nonatomic, strong) NSString * walletService;
@property (nonatomic, strong) NSString * nodeService;

@end

@implementation CustomEnvironmentViewController

- (NSMutableArray *)listArray
{
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    }
    return _listArray;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = Localized(@"CustomEnvironment");
    [self setupNav];
    self.listArray = [NSMutableArray arrayWithObjects:@[Localized(@"WalletService"), Localized(@"WalletServicePlaceholder")], @[Localized(@"NodeService"), Localized(@"NodeServicePlaceholder")], nil];
    [self setupView];
}
- (void)setupNav
{
    self.rightBtn = [UIButton createButtonWithTitle:Localized(@"Save") TextFont:FONT_NAV_TITLE TextNormalColor:MAIN_COLOR TextSelectedColor:MAIN_COLOR Target:self Selector:@selector(rightAcrion:)];
    self.rightBtn.frame = CGRectMake(0, 0, ScreenScale(60), ScreenScale(44));
    self.rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.rightBtn setTitle:Localized(@"Edit") forState:UIControlStateSelected];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
    self.rightBtn.selected = NotNULLString(CurrentServerCustom);
}
- (void)rightAcrion:(UIButton *)button
{
    if (self.rightBtn.selected == NO) {
        if (!NotNULLString(self.walletService) || !NotNULLString(self.nodeService)) {
            return;
        }
        [self getData];
    } else {
        [self setCustomData];
    }
}

- (void)setupView
{
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    self.tableView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    [self setupFooterView];
}
- (void)setupFooterView
{
    self.footerView = [[UIView alloc] init];
    self.next = [UIButton createButtonWithTitle:Localized(@"Enable") TextFont:FONT_BUTTON TextNormalColor:[UIColor whiteColor] TextSelectedColor:WARNING_COLOR Target:self Selector:@selector(nextAction:)];
    self.next.backgroundColor = MAIN_COLOR;
    [self.next setTitle:Localized(@"Prohibit") forState:UIControlStateSelected];
    self.next.layer.masksToBounds = YES;
    self.next.clipsToBounds = YES;
    self.next.layer.cornerRadius = MAIN_CORNER;
    [self.footerView addSubview:self.next];
    [self.next mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.footerView.mas_top).offset(MAIN_HEIGHT);
        make.left.equalTo(self.footerView.mas_left).offset(Margin_Main);
        make.right.equalTo(self.footerView.mas_right).offset(-Margin_Main);
        make.height.mas_equalTo(MAIN_HEIGHT);
    }];
    
    self.notes = [[UILabel alloc] init];
    self.notes.numberOfLines = 0;
    [self.footerView addSubview:self.notes];
    [self.notes mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.next.mas_bottom).offset(MAIN_HEIGHT);
        make.left.right.equalTo(self.next);
    }];
    BOOL isCustom = [[NSUserDefaults standardUserDefaults] boolForKey:If_Custom_Network];
    self.next.selected = isCustom;
    [self setNotesWithIsCustom:isCustom];
    self.footerView.hidden = !NotNULLString(CurrentServerCustom);
}
- (void)setNotesWithIsCustom:(BOOL)isCustom
{
    NSString * notesStr;
    if (isCustom) {
        notesStr = [NSString stringWithFormat:@"%@\n%@", Localized(@"Notes"), Localized(@"ProhibitNotes")];
        self.next.backgroundColor = [UIColor whiteColor];
    } else {
        notesStr = [NSString stringWithFormat:@"%@\n%@", Localized(@"Notes"), Localized(@"EnableNotes")];
        self.next.backgroundColor = MAIN_COLOR;
    }
    self.notes.attributedText = [Encapsulation attrWithString:notesStr preFont:FONT_15 preColor:COLOR_6 index:[Localized(@"Notes") length] sufFont:FONT_TITLE sufColor:COLOR_9 lineSpacing:Margin_10];
    CGFloat notesH = [Encapsulation getSizeSpaceLabelWithStr:notesStr font:FONT_15 width:DEVICE_WIDTH - Margin_30 height:CGFLOAT_MAX lineSpacing:Margin_10].height;
    self.footerView.frame = CGRectMake(0, 0, DEVICE_WIDTH, ScreenScale(105) + notesH);
    self.tableView.tableFooterView = self.footerView;
    self.navigationItem.rightBarButtonItem = (isCustom) ? nil : [[UIBarButtonItem alloc]initWithCustomView:self.rightBtn];
}
- (void)nextAction:(UIButton *)button
{
    button.selected = !button.selected;
    [self setNotesWithIsCustom:button.selected];
    [[HTTPManager shareManager] SwitchedNetworkWithIsCustom:button.selected];
    [UIApplication sharedApplication].keyWindow.rootViewController = [[TabBarViewController alloc] init];
}
- (void)getData
{
    [[HTTPManager shareManager] getNodeDataWithURL:[NSString stringWithFormat:@"%@%@", self.walletService, Server_Check] success:^(id responseObject) {
        NSInteger code = [responseObject[@"meta"][@"code"] integerValue];
        if (code == Success_Code) {
            [self checkNode];
        } else {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidServerURL") handler:nil];
        }
    } failure:^(NSError *error) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidServerURL") handler:nil];
    }];
}
- (void)checkNode
{
    [[HTTPManager shareManager] getNodeDataWithURL:[NSString stringWithFormat:@"%@%@", self.nodeService, Node_Check] success:^(id responseObject) {
        NSInteger code = [[responseObject objectForKey:@"error_code"] integerValue];
        if (code == Success_Code) {
            [self setCustomData];
            //            [[NSUserDefaults standardUserDefaults] setObject:self.listArray forKey:self.nodeURLArrayKey];
            [self.tableView reloadData];
        } else {
            [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidNodeURL") handler:nil];
        }
    } failure:^(NSError *error) {
        [Encapsulation showAlertControllerWithErrorMessage:Localized(@"InvalidNodeURL") handler:nil];
    }];
}
- (void)setCustomData
{
    self.walletText.userInteractionEnabled = self.nodeText.userInteractionEnabled = self.footerView.hidden = self.rightBtn.selected;
    self.rightBtn.selected = !self.rightBtn.selected;
    if (self.rightBtn.selected == YES) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:self.walletService forKey:Server_Custom];
        [defaults setObject:self.nodeService forKey:Current_Node_URL_Custom];
        [defaults synchronize];
        //                [self.listArray addObject:URL];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return ScreenScale(90);
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return CGFLOAT_MIN;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return SafeAreaBottomH;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.listArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    TextFieldViewCell * cell = [TextFieldViewCell cellWithTableView:tableView cellType: TextFieldCellDefault];
    cell.title.text = [self.listArray[indexPath.row] firstObject];
    cell.textField.placeholder = [self.listArray[indexPath.row] lastObject];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    switch (indexPath.row) {
        case 0:
            self.walletText = cell.textField;
            break;
        case 1:
            self.nodeText = cell.textField;
            break;
        default:
            break;
    }
    if (NotNULLString(CurrentServerCustom)) {
        NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
        self.walletService = CurrentServerCustom;
        self.walletText.text = self.walletService;
        self.nodeService = [defaults objectForKey:Current_Node_URL_Custom];
        self.nodeText.text = self.nodeService;
        self.walletText.userInteractionEnabled = NO;
        self.nodeText.userInteractionEnabled = NO;
    }
    cell.textChange = ^(UITextField * _Nonnull textField) {
        [self judgeHasText];
    };
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)judgeHasText
{
    [self updateText];
    if (self.walletService.length > 0 && self.nodeService.length > 0) {
        self.rightBtn.enabled = YES;
    } else {
        self.rightBtn.enabled = NO;
    }
}
- (void)updateText
{
    self.walletService = TrimmingCharacters(self.walletText.text);
    self.nodeService = TrimmingCharacters(self.nodeText.text);
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
