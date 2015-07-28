//
//  MessageCell.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "MessageCell.h"
#import "CellFrameModel.h"
#import "MessageModel.h"
#import "UIImage+ResizeImage.h"
#import "UIViewExt.h"
#import "NSString+Extension.h"


NSString * const kMessageCellChat   = @"kMessageCellChat";
NSString * const kMessageCellThough = @"kMessageCellThough";



@interface MessageCell()

@property (nonatomic,strong) UILabel *chatName;
@property (nonatomic,strong) UILabel *timeLabel;
@property (nonatomic,strong) UIImageView *iconView;
@property (nonatomic,strong) UIButton *textView;
@property (nonatomic,strong) UIView *timeLineLeft;
@property (nonatomic,strong) UIView *timeLineRight;

@property (nonatomic,strong) UIView *creditThough;

@end

@implementation MessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = nil;
        self.backgroundColor = [UIColor clearColor];
        if ([reuseIdentifier isEqualToString:kMessageCellThough]) {
            [self.contentView addSubview:self.creditThough];
            
        } else {
            [self.contentView addSubview:self.timeLabel];
            [self.contentView addSubview:self.timeLineLeft];
            [self.contentView addSubview:self.timeLineRight];
            
            [self.contentView addSubview:self.chatName];
            
            [self.contentView addSubview:self.iconView];
            
            _textView = [UIButton buttonWithType:UIButtonTypeCustom];
            _textView.titleLabel.numberOfLines = 0;
            _textView.titleLabel.font = [UIFont systemFontOfSize:13];
            _textView.contentEdgeInsets = UIEdgeInsetsMake(textPadding, textPadding, textPadding, textPadding);
            [self.contentView addSubview:_textView];
        }
    }
    return self;
}

- (void)setCellFrame:(CellFrameModel *)cellFrame
{
    _cellFrame = cellFrame;
    
    MessageModel *message = cellFrame.message;
    if (message.type == MessageModelTypeThough) {

    } else {
        self.timeLabel.frame = cellFrame.timeFrame;
        NSLog(@"%@",NSStringFromCGRect(cellFrame.timeFrame));
        self.timeLabel.text = message.time;
        if (message.showTime) {
            self.timeLineLeft.hidden  = NO;
            self.timeLineLeft.width  = 20;
            self.timeLineLeft.height = 1;
            self.timeLineLeft.right   = self.timeLabel.left-5;
            self.timeLineLeft.top     = self.timeLabel.center.y;
            
            self.timeLineRight.hidden = NO;
            self.timeLineRight.width  = 20;
            self.timeLineRight.height = 1;
            self.timeLineRight.left   = self.timeLabel.right+5;
            self.timeLineRight.top    = self.timeLabel.center.y;
        } else {
            self.timeLineLeft.height  = 0;
            self.timeLineRight.height = 0;
        }
        
        
        self.chatName.frame = cellFrame.companyFrame;
        self.chatName.text  = message.companyName;
        self.chatName.textAlignment = message.type ? NSTextAlignmentRight : NSTextAlignmentLeft;
        
        self.iconView.frame = cellFrame.iconFrame;
        NSString *iconStr = message.type ? @"other" : @"me";
        self.iconView.image = [UIImage imageNamed:iconStr];
        
        _textView.frame = cellFrame.textFrame;
        NSString *textBg = message.type ? @"chat_recive_nor" : @"chat_send_nor";
        UIColor *textColor = message.type ? [UIColor blackColor] : [UIColor whiteColor];
        [_textView setTitleColor:textColor forState:UIControlStateNormal];
        [_textView setBackgroundImage:[UIImage resizeImage:textBg] forState:UIControlStateNormal];
        [_textView setTitle:message.text forState:UIControlStateNormal];
    }
    
}

#pragma mark - getters
- (UILabel *)chatName
{
    if (_chatName == nil) {
        _chatName = [[UILabel alloc] init];
        _chatName.textAlignment = NSTextAlignmentCenter;
        _chatName.textColor = [UIColor grayColor];
        _chatName.font = [UIFont systemFontOfSize:12];
    }
    return _chatName;
}
- (UILabel *)timeLabel
{
    if (_timeLabel == nil) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.textColor = [UIColor grayColor];
        _timeLabel.font = [UIFont systemFontOfSize:14];
//        _timeLabel.backgroundColor = [UIColor cyanColor];
    }
    return _timeLabel;
}

- (UIImageView *)iconView
{
    if (_iconView == nil) {
        _iconView = [[UIImageView alloc] init];
        _iconView.layer.masksToBounds = YES;
        _iconView.layer.cornerRadius  = 20;
    }
    return _iconView;
}

- (UIView *)timeLineLeft
{
    if (_timeLineLeft == nil) {
        _timeLineLeft = [[UIView alloc] init];

        _timeLineLeft.backgroundColor = [UIColor lightGrayColor];
//        _timeLineLeft.hidden = YES;
    }
    return _timeLineLeft;
}

- (UIView *)timeLineRight
{
    if (_timeLineRight == nil) {
        _timeLineRight = [[UIView alloc] init];
        _timeLineRight.backgroundColor = [UIColor lightGrayColor];

//        _timeLineRight.hidden = YES;
    }
    return _timeLineRight;
}

- (UIView *)creditThough
{
    if (_creditThough == nil) {
        CGSize size = [UIScreen mainScreen].bounds.size;
        _creditThough = [[UIView alloc] initWithFrame:CGRectMake(0, 0, size.width, 40)];
        NSString *tips = @"恭喜！信贷申请已通过融誉审核！";
        CGSize textSize = [tips sizeWithFont:[UIFont systemFontOfSize:12.0] maxSize:CGSizeMake(MAXFLOAT, 40)];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(size.width/2 - textSize.width/2, 10, textSize.width, 20)];
        label.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:79.0f/255.0f blue:53.0f/255.0f alpha:1];
        label.textColor = [UIColor whiteColor];
        label.text = tips;
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        [_creditThough addSubview:label];
        
        UIView *lineLeft = [[UIView alloc] initWithFrame:CGRectMake(0, label.center.y, label.left - 10, 1)];
        lineLeft.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:79.0f/255.0f blue:53.0f/255.0f alpha:1];
        [_creditThough addSubview:lineLeft];
        
        UIView *lineRight = [[UIView alloc] initWithFrame:CGRectMake(label.right + 10, label.center.y,lineLeft.width, 1)];
        lineRight.backgroundColor = [UIColor colorWithRed:246.0f/255.0f green:79.0f/255.0f blue:53.0f/255.0f alpha:1];
        [_creditThough addSubview:lineRight];
    }
    return _creditThough;
}



@end
