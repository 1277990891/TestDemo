
//  Created by apple on 14-7-28.
//  Copyright (c) 2014年 heima. All rights reserved.
//

#import "HMRightMenuCenterViewRow.h"

@interface HMRightMenuCenterViewRow()
@property (weak, nonatomic) IBOutlet UIButton *titleView;
@property (weak, nonatomic) IBOutlet UIImageView *iconView;
@end

@implementation HMRightMenuCenterViewRow
+ (instancetype)centerViewRow
{
    return [[[NSBundle mainBundle] loadNibNamed:@"HMRightMenuCenterViewRow" owner:nil options:nil] lastObject];
}

- (void)setIcon:(NSString *)icon
{
    _icon = [icon copy];
    
    self.iconView.image = [UIImage imageNamed:icon];
}

- (void)setTitle:(NSString *)title
{
    _title = [title copy];
    
    [self.titleView setTitle:title forState:UIControlStateNormal];
}
@end
