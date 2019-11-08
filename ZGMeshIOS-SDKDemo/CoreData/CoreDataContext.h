//
//  CoreDataContext.h
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

NS_ASSUME_NONNULL_BEGIN

@interface CoreDataContext : NSObject
{
    
    NSManagedObjectContext *managedObjectContext_;
    NSManagedObjectModel *managedObjectModel_;
    NSPersistentStoreCoordinator *persistentStoreCoordinator_;
}
-(NSManagedObjectContext *)managedObjectContext;
- (NSManagedObjectContext *)managedObjectContextWithAppGroupIdentifier:(NSString*)appGroupIdentifier
                                                             modelName:(NSString*)modelName;

-(NSManagedObjectContext*)createManagedObjectContext;
-(NSManagedObjectContext*)createManagedObjectContextWithAppGroupIdentifier:(NSString*)appGroupIdentifier
                                                                 modelName:(NSString*)modelName;

@end

NS_ASSUME_NONNULL_END
