//
//  NGViewHighlightControl.m
//  ConfigTest
//
//  Created by li bo on 11/21/17.
//  Copyright © 2017 li bo. All rights reserved.
//

#import "NGViewHighlightControl.h"

@implementation NGViewHighlightControl

/*
    禁用子控件的 userInterface 交互，当点击view试图时，使父试图与其子视图均为 Highlight 状态
*/
- (void)setHighlighted:(BOOL)highlighted
{
    [super setHighlighted:highlighted];

    for (id subview in self.subviews)
    {
        if ([subview respondsToSelector:@selector(setHighlighted:)])
        {
            [subview setHighlighted:highlighted];
        }
    }
}

@end
