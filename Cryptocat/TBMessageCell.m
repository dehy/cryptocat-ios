//
//  TBMessageCell.m
//  ChatView
//
//  Created by Thomas Balthazar on 07/11/13.
//  Copyright (c) 2013 Thomas Balthazar. All rights reserved.
//

#import "TBMessageCell.h"
#import "TBMessageCellView.h"
#import "TBWarningView.h"

#define kPaddingTop     0.0
#define kPaddingBottom  10.0
#define kPaddingLeft    11.0
#define kPaddingRight   12.5

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@interface TBMessageCell () <TBMessageCellViewDelegate>

@property (nonatomic, strong) TBMessageCellView *messageView;
@property (nonatomic, strong) TBWarningView *warningView;

@end

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
@implementation TBMessageCell

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Lifecycle

////////////////////////////////////////////////////////////////////////////////////////////////////
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
  if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    _messageView = [[TBMessageCellView alloc] init];
    _messageView.delegate = self;
    [self.contentView addSubview:_messageView];
    
    _warningView = nil;
  }
  return self;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)layoutSubviews {
  [super layoutSubviews];
  
  // message view
  CGRect messageViewFrame = self.contentView.frame;
  messageViewFrame.origin.x+=kPaddingLeft;
  messageViewFrame.origin.y+=kPaddingTop;
  messageViewFrame.size.width-=(kPaddingLeft+kPaddingRight);
  messageViewFrame.size.height-=(kPaddingTop+kPaddingBottom);

  // warning view
  if (self.warningMessage!=nil) {
    CGRect warningViewFrame = messageViewFrame;
    CGSize size = [TBWarningView sizeForText:self.warningMessage];
    warningViewFrame.size.height = size.height;
    self.warningView.frame = warningViewFrame;

    messageViewFrame.size.height-=size.height;
    messageViewFrame.origin.y+=size.height;
    [self.warningView setNeedsDisplay];
  }
  
  self.messageView.frame = messageViewFrame;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark Public Methods

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setSenderName:(NSString *)senderName {
  self.messageView.senderName = senderName;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)senderName {
  return self.messageView.senderName;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setMessage:(NSString *)message {
  self.messageView.message = message;
  [self setNeedsLayout];
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)message {
  return self.messageView.message;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setWarningMessage:(NSString *)warningMessage {
  if (warningMessage==nil) {
    [self.warningView removeFromSuperview];
    self.warningView = nil;
  }
  else if (self.warningView==nil) {
    self.warningView = [[TBWarningView alloc] init];
    [self.contentView addSubview:self.warningView];
    self.warningView.message = warningMessage;
    [self setNeedsLayout];
  }
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (NSString *)warningMessage {
  return self.warningView==nil ? nil : self.warningView.message;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setMeSpeaking:(BOOL)meSpeaking {
  self.messageView.meSpeaking = meSpeaking;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isMeSpeaking {
  return self.messageView.isMeSpeaking;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setIsErrorMessage:(BOOL)isErrorMessage {
  self.messageView.isErrorMessage = isErrorMessage;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)isErrorMessage {
  return self.messageView.isErrorMessage;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
+ (CGFloat)heightForCellWithSenderName:(NSString *)senderName
                                  text:(NSString *)text
                           warningText:(NSString *)warningText {
  // add the sender name and some spaces for the sender label padding
  NSString *paddingString = @"     :     ";
  NSString *fullText = [senderName stringByAppendingFormat:@"%@%@", paddingString, text];
  
  CGFloat height = [TBMessageCellView sizeForText:fullText].height + kPaddingTop + kPaddingBottom;

  if (warningText!=nil) {
    height+=[TBWarningView sizeForText:warningText].height;
  }
  
  return height;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
- (void)setBackgroundColor:(UIColor *)backgroundColor {
  [super setBackgroundColor:backgroundColor];
  self.messageView.backgroundColor = backgroundColor;
  self.warningView.backgroundColor = backgroundColor;
}

////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark -
#pragma mark TBMessageCellViewDelegate

////////////////////////////////////////////////////////////////////////////////////////////////////
- (BOOL)messageCellView:(TBMessageCellView *)cellView
  shouldInteractWithURL:(NSURL *)URL
                inRange:(NSRange)characterRange {
  if ([self.delegate respondsToSelector:@selector(messageCell:shouldInteractWithURL:inRange:)]) {
    return [self.delegate messageCell:self shouldInteractWithURL:URL inRange:characterRange];
  }
  return NO;
}

@end
