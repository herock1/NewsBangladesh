//
//  NewsBriefTableViewCell.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/17/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import "NewsBriefTableViewCell.h"

@implementation NewsBriefTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self.contentView layoutIfNeeded];
    
    self.headingLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.headingLabel.frame);
    self.breifLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.breifLabel.frame);
}

@end
