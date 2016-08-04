//
//  NewsDetailBodyTableViewCell.m
//  NewsBangladesh
//
//  Created by Ishtiak Ahmed(Nidaan Systems Ltd) on 3/16/15.
//  Copyright (c) 2015 DGDev. All rights reserved.
//

#import "NewsDetailBodyTableViewCell.h"

@implementation NewsDetailBodyTableViewCell

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
    
    self.newsDetailLabel.preferredMaxLayoutWidth = CGRectGetWidth(self.newsDetailLabel.frame);
}

@end
