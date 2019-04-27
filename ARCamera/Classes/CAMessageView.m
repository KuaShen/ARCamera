//
//  CAMessageView.m
//  ARCamera_Example
//
//  Created by mac on 2019/4/27.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import "CAMessageView.h"

@interface CAMessageView()

@property (strong, nonatomic) UIView *noteView;
@property (strong, nonatomic) UILabel *noteLable;

@property (strong, nonatomic) NSTimer *timer;

@end

@implementation CAMessageView

static CAMessageView* instance = nil;
+ (CAMessageView*)sharedInstance
{
    static dispatch_once_t oneToken;
    
    dispatch_once(&oneToken, ^{
        
        instance = [[CAMessageView alloc]init];
        
    });
    
    return instance;
}

- (id)init
{
    self = [super init];
    if (self)
    {
        NSInteger w = 220;
        NSInteger h = 50;
        NSInteger x = ([UIScreen mainScreen].bounds.size.width-w)/2;
        NSInteger y = ([UIScreen mainScreen].bounds.size.height - h)/2;
        
        self.noteView = [[UIView alloc] initWithFrame:CGRectMake(x, y, w, h)];
        self.noteView.layer.cornerRadius = 5.0;
        self.noteView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.6];
        
        self.noteLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, w, h)];
        self.noteLable.text = @"消息提示";
        self.noteLable.numberOfLines=2;
        self.noteLable.textColor = [UIColor whiteColor];
        self.noteLable.textAlignment = NSTextAlignmentCenter;
        self.noteLable.backgroundColor = [UIColor clearColor];
        [self.noteView addSubview:self.noteLable];
    }
    return self;
}

-(void)setFont:(UIFont*)font
{
    self.noteLable.font=font;
}

- (void)showNoteView:(NSString*)noteText subView:(UIView*)subView
{
    if (self.timer != nil && [self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
    
    if (noteText != nil && [noteText length] > 0)
        self.noteLable.text = noteText;
    
    [subView addSubview:self.noteView];
    [subView layoutIfNeeded];
    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.5 target:self selector:@selector(timerFired:) userInfo:nil repeats:NO];
}

- (void)timerFired:(NSTimer*)timer
{
    [self.timer invalidate];
    //[self setFont:[BIDDeviceFont font_15]];
    [self setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    self.timer = nil;
    [self.noteView removeFromSuperview];
}

@end
