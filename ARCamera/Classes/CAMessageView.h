//
//  CAMessageView.h
//  ARCamera_Example
//
//  Created by mac on 2019/4/27.
//  Copyright © 2019 KuaShen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface CAMessageView : NSObject

+ (CAMessageView*)sharedInstance;

- (void)showNoteView:(NSString*)noteText subView:(UIView*)subView;

-(void)setFont:(UIFont*)font;


@end

NS_ASSUME_NONNULL_END
