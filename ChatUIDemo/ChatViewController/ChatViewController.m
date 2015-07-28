//
//  ChatViewController.m
//  ChatUIDemo
//
//  Created by xiaerfei on 15/7/28.
//  Copyright (c) 2015年 RongYu100. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageModel.h"
#import "CellFrameModel.h"
#import "MessageCell.h"
#import "NSString+Extension.h"
#import "UIViewExt.h"

#define kToolBarH 50
#define kTextFieldH 30

#define kTextViewH 30

@interface ChatViewController ()<UITableViewDataSource, UITableViewDelegate, UITextViewDelegate>
{
    NSMutableArray *_cellFrameDatas;
    CGFloat _firstTop;
    CGFloat _lastHeight;
}

@property (weak, nonatomic) IBOutlet UIView *headInfo;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UITextView *textView;


- (IBAction)touchEndEidt:(id)sender;

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillChange:) name:UIKeyboardWillChangeFrameNotification object:nil];
    //UITextFieldTextDidBeginEditingNotification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldTextChange:) name:UITextViewTextDidChangeNotification object:nil];

    self.tableView.allowsSelection = NO;
    NSLog(@"%@",self.textView.subviews);
    _firstTop = self.bottomView.top;
    [self.textView sizeToFit];
    [self loadData];
    
    self.view.backgroundColor = [UIColor colorWithRed:235.0/255 green:235.0/255 blue:235.0/255 alpha:1.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/**
 *  记载数据
 */
- (void)loadData
{
    _cellFrameDatas =[NSMutableArray array];
    NSURL *dataUrl = [[NSBundle mainBundle] URLForResource:@"messages.plist" withExtension:nil];
    NSArray *dataArray = [NSArray arrayWithContentsOfURL:dataUrl];
    for (NSDictionary *dict in dataArray) {
        MessageModel *message = [MessageModel messageModelWithDict:dict];
        CellFrameModel *lastFrame = [_cellFrameDatas lastObject];
        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
        message.showTime = ![message.time isEqualToString:lastFrame.message.time];
        message.companyName = @"【网络公司】张三";
        cellFrame.message = message;
        [_cellFrameDatas addObject:cellFrame];
    }
}
#pragma mark - tableView的数据源和代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _cellFrameDatas.count;
}

- (MessageCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    MessageCell *cell = nil;
    if (cellFrame.message.type == MessageModelTypeThough) {
        cell = [self tableView:tableView reuseIdentifier:kMessageCellThough];
    } else {
        cell = [self tableView:tableView reuseIdentifier:kMessageCellChat];
    }
    
    cell.cellFrame = cellFrame;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CellFrameModel *cellFrame = _cellFrameDatas[indexPath.row];
    return cellFrame.cellHeght;
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        //1.获得时间
        NSDate *senddate = [NSDate date];
        NSDateFormatter *dateformatter = [[NSDateFormatter alloc] init];
        [dateformatter setDateFormat:@"yyyy/MM/dd HH:mm"];
        NSString *locationString = [dateformatter stringFromDate:senddate];
        
        //2.创建一个MessageModel类
        MessageModel *message = [[MessageModel alloc] init];
        message.text = textView.text;
        message.time = locationString;
        message.type = MessageModelTypeThough;
        message.companyName = @"李四【网络公司】";
        //3.创建一个CellFrameModel类
        CellFrameModel *cellFrame = [[CellFrameModel alloc] init];
        CellFrameModel *lastCellFrame = [_cellFrameDatas lastObject];
        message.showTime = ![lastCellFrame.message.time isEqualToString:message.time];
        cellFrame.message = message;
        
        //4.添加进去，并且刷新数据
        [_cellFrameDatas addObject:cellFrame];
        [self.tableView reloadData];
        
        //5.自动滚到最后一行
        NSIndexPath *lastPath = [NSIndexPath indexPathForRow:_cellFrameDatas.count - 1 inSection:0];
        [self.tableView scrollToRowAtIndexPath:lastPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        
        textView.text = @"";
        self.bottomView.top = _firstTop;
        self.bottomView.height = kToolBarH;
        self.textView.height = kTextViewH;

    }
    return YES;
}


#pragma mark - events response
- (void)textFieldTextChange:(NSNotification *)note
{
    NSString *content = self.textView.text;
    if (content.length != 0) {
        CGRect textFrame = [[self.textView layoutManager] usedRectForTextContainer:[self.textView textContainer]];
        if (textFrame.size.height/kTextViewH > 1) {
            if (textFrame.size.height < kTextViewH) {
                self.textView.height = kTextViewH;
                NSLog(@"<-------------------------->");
            } else {
                if (textFrame.size.height != _lastHeight) {
                    
                    NSLog(@"textHeight = %f",textFrame.size.height);
                    CGFloat h = textFrame.size.height + 20;
                    self.bottomView.height = h;
                    self.bottomView.top = self.view.height - h;
                    
//                    self.textView.height = textFrame.size.height;
//                    self.textView.contentSize = CGSizeMake(0, textSize.height);
                    NSLog(@"%@",NSStringFromCGRect(self.textView.frame));
                    _lastHeight = textFrame.size.height;
                }
            }
        }
    } else {
        self.bottomView.height = kToolBarH;
        self.textView.height = kTextViewH;
    }

}
/**
 *  键盘发生改变执行
 */
- (void)keyboardWillChange:(NSNotification *)note
{
    NSLog(@"%@", note.userInfo);
    NSDictionary *userInfo = note.userInfo;
    CGFloat duration = [userInfo[@"UIKeyboardAnimationDurationUserInfoKey"] doubleValue];
    
    CGRect keyFrame = [userInfo[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    CGFloat moveY = keyFrame.origin.y - self.view.frame.size.height;
    
    [UIView animateWithDuration:duration animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, moveY);
    }];
}
- (void)endEdit
{
    [self.view endEditing:YES];
}
- (IBAction)touchEndEidt:(id)sender {
    [self.view endEditing:YES];
}
#pragma mark - private methods
- (MessageCell *)tableView:(UITableView *)tableView reuseIdentifier:(NSString *)cellIdentifier
{
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil) {
        cell = [[MessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
    }
    return cell;
}

#pragma mark - dealloc
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:nil];
}


@end
