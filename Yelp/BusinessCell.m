//
//  BusinessCell.m
//  Yelp
//
//  Created by Sarp Centel on 2/14/15.
//  Copyright (c) 2015 codepath. All rights reserved.
//

#import "BusinessCell.h"
#import "UIImageView+AFNetworking.h"

@interface BusinessCell ()

@property (weak, nonatomic) IBOutlet UIImageView *thumbImageView;
@property (weak, nonatomic) IBOutlet UIImageView *ratingImageView;
@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;
@property (weak, nonatomic) IBOutlet UILabel *categoryLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *ratingLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation BusinessCell

- (void)awakeFromNib {
    // Initialization code
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
    
    self.thumbImageView.layer.cornerRadius = 3;
    self.thumbImageView.clipsToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setBusiness:(Business *)business {
    _business = business;
    
    [self.thumbImageView setImageWithURL:[NSURL URLWithString:self.business.imageUrl]];
    self.nameLabel.text = self.business.name;
    [self.ratingImageView setImageWithURL:[NSURL URLWithString:self.business.ratingImageUrl]];
    self.ratingLabel.text = [NSString stringWithFormat:@"%ld Reviews", self.business.numReviews];
    self.distanceLabel.text = [NSString stringWithFormat:@"%.2f mi", self.business.distance];
    self.addressLabel.text = self.business.address;
    self.categoryLabel.text = self.business.categories;
}

- (void) layoutSubviews {
    [super layoutSubviews];
    
    self.nameLabel.preferredMaxLayoutWidth = self.nameLabel.frame.size.width;
}

@end
