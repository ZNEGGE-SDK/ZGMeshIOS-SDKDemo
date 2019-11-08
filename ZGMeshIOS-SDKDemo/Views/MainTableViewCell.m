//
//  MainTableViewCell.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/8.
//  Copyright © 2019 文. All rights reserved.
//

#import "MainTableViewCell.h"
#import "MeshGroup.h"

@implementation MainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setGroupCell:(MeshGroup *)group
{
    _nameLabel.text = group.displayName;
    self.meshGroup = group;
}
- (IBAction)swithChanged:(UISwitch *)sender {
    
    [self.delegate powerSwithChanged:sender.on deviceType:self.meshGroup.groupType meshAddress:self.meshGroup.meshAddress];
}

@end
