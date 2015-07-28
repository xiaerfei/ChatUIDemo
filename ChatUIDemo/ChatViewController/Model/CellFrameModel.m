//
//  CellFrameModel.m
//  QQ聊天布局
//
//  Created by TianGe-ios on 14-8-19.
//  Copyright (c) 2014年 TianGe-ios. All rights reserved.
//

// 版权属于原作者
// http://code4app.com (cn) http://code4app.net (en)
// 发布代码于最专业的源码分享网站: Code4App.com

#import "CellFrameModel.h"
#import "MessageModel.h"
#import "NSString+Extension.h"

#define timeH     30
#define timeW     200
#define padding   10
#define iconW     40
#define iconH     40
#define textW     150
#define companyH  20
#define companyW  100



@implementation CellFrameModel

- (void)setMessage:(MessageModel *)message
{
    _message = message;
    if (message.type == MessageModelTypeThough) {
        _cellHeght = 40;
        return;
    }
    CGRect frame = [UIScreen mainScreen].bounds;
    
    //1.时间的Frame
    if (message.showTime) {
        CGSize textSize = [message.time sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:CGSizeMake(MAXFLOAT, timeH)];
        _timeFrame = CGRectMake(frame.size.width/2 - textSize.width/2, 0, textSize.width, timeH);
    }
    // 公司名称
    CGFloat companyFrameX = message.type?(padding + iconW) : (frame.size.width - (padding + iconW) - companyW);
    if (message.type == MessageModelTypeOther) {
        companyFrameX = frame.size.width - (padding + iconW) - companyW;
    } else if (message.type == MessageModelTypeMe) {
        companyFrameX = padding + iconW;
    }
    CGFloat companyFrameY = CGRectGetMaxY(_timeFrame);
    _companyFrame = CGRectMake(companyFrameX, companyFrameY, companyW, companyH);
    
    //2.头像的Frame
    CGFloat iconFrameX = message.type ? padding : (frame.size.width - padding - iconW);
    CGFloat iconFrameY = CGRectGetMaxY(_companyFrame);
    CGFloat iconFrameW = iconW;
    CGFloat iconFrameH = iconH;
    _iconFrame = CGRectMake(iconFrameX, iconFrameY, iconFrameW, iconFrameH);
    
    //3.内容的Frame
    CGFloat textWidth = [UIScreen mainScreen].bounds.size.width - 2*(2 * padding + iconFrameW+8);
    CGSize textMaxSize = CGSizeMake(textWidth, MAXFLOAT);
    CGSize textSize = [message.text sizeWithFont:[UIFont systemFontOfSize:14.0] maxSize:textMaxSize];
    CGSize textRealSize = CGSizeMake(textSize.width + textPadding * 2, textSize.height + textPadding * 2);
    CGFloat textFrameY = iconFrameY;
    CGFloat textFrameX = message.type ? (2 * padding + iconFrameW) : (frame.size.width - (padding * 2 + iconFrameW + textRealSize.width));
    _textFrame = (CGRect){textFrameX, textFrameY, textRealSize};
    
    //4.cell的高度
    _cellHeght = MAX(CGRectGetMaxY(_iconFrame), CGRectGetMaxY(_textFrame)) + padding;
}

@end
