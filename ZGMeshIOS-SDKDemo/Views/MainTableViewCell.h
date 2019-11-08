//
//  MainTableViewCell.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/8.
//  Copyright © 2019 文. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MeshGroup;
NS_ASSUME_NONNULL_BEGIN

@protocol MainTableViewCellDelegate <NSObject>

-(void)powerSwithChanged:(BOOL)on deviceType:(int)deviceType meshAddress:(int)meshAddress;

@end

@interface MainTableViewCell : UITableViewCell
{
    IBOutlet UILabel *_nameLabel;
    
}
@property (strong) MeshGroup *meshGroup;

-(void)setGroupCell:(MeshGroup*)group;

@property (assign) id<MainTableViewCellDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
