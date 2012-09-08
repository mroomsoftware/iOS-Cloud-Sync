//
//  PhotosCell.m
//  cloudComputing
//
//  Created by Minh Tuan on 9/6/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PhotosCell.h"

@implementation PhotosCell
@synthesize imv1;
@synthesize imv2;
@synthesize imv3;
@synthesize imv4;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc {
    [imv1 release];
    [imv2 release];
    [imv3 release];
    [imv4 release];
    [super dealloc];
}
@end
