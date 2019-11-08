//
//  CoreDataContext.m
//  ZGMeshIOS-SDKDemo
//
//  Created by 文 on 2019/11/1.
//  Copyright © 2019 文. All rights reserved.
//

#import "CoreDataContext.h"

@implementation CoreDataContext

- (NSManagedObjectContext *)managedObjectContext
{
    return [self managedObjectContextWithAppGroupIdentifier:nil modelName:nil];
}

#pragma mark Core Data stack
/**
 Returns the managed object context for the application.
 If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
 */
- (NSManagedObjectContext *)managedObjectContextWithAppGroupIdentifier:(NSString*)appGroupIdentifier
                                                             modelName:(NSString*)modelName
{
    if (managedObjectContext_ != nil) {
        return managedObjectContext_;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinatorWithAppGroupIdentifier:appGroupIdentifier
                                                                                             modelName:modelName];
    if (coordinator != nil) {
        managedObjectContext_ = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSMainQueueConcurrencyType];    //context在主线程上
        [managedObjectContext_ setPersistentStoreCoordinator:coordinator];
    }
    return managedObjectContext_;
}




- (void)mergeChanges:(NSNotification *)notification
{
    NSManagedObjectContext *mainContext = [self managedObjectContext];
    
    // Merge changes into the main context on the main thread
    [mainContext performSelectorOnMainThread:@selector(mergeChangesFromContextDidSaveNotification:)
                                  withObject:notification
                               waitUntilDone:YES];
//    NSLog(@"mainContext mergeChangesFromContextDidSaveNotification");
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [mainContext performBlock:^{
//            [mainContext mergeChangesFromContextDidSaveNotification:notification];    //必须要在主线程合并
//        }];
//    });
    [mainContext performBlock:^{    //performBlock 代表使用mainContext创建时的线程,即主线程执行
        [mainContext mergeChangesFromContextDidSaveNotification:notification];    //必须要在主线程合并
    }];

}

-(NSManagedObjectContext*)createManagedObjectContext
{
    //modelName 为nil 代表全部的模型进行合并
    //appGroupIdentifier 为nil代表 App  或者  Extension的沙盒区域, 指定的话代表共享数据的AppGroups
    return [self createManagedObjectContextWithAppGroupIdentifier:nil modelName:nil];
}

/** 用于子线程创建新的Context
 */
-(NSManagedObjectContext*)createManagedObjectContextWithAppGroupIdentifier:(NSString*)appGroupIdentifier
                                                                 modelName:(NSString*)modelName
{
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinatorWithAppGroupIdentifier:appGroupIdentifier
                                                                                             modelName:modelName
                                                 ];
    NSManagedObjectContext *ctx = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];    //context在私有线程上的
    [ctx setPersistentStoreCoordinator:coordinator];
    
    NSNotificationCenter *nc = [NSNotificationCenter defaultCenter];
    [nc addObserver:self
           selector:@selector(mergeChanges:)
               name:NSManagedObjectContextDidSaveNotification
             object:ctx];
    
    return ctx;
}

/**
 Managed Object Model 是描述应用程序的数据模型，这个模型包含实体（Entity），特性（Property），读取请求（Fetch Request）等。
 其實就是.xcdatamodeld當對應的對象
 If the model doesn't already exist, it is created from the application's model.
 */
- (NSManagedObjectModel *)managedObjectModelWithModelName:(NSString*)modelName {
    
    if (managedObjectModel_ != nil) {
        return managedObjectModel_;
    }
    
    if (modelName==nil) {
        //直接加載Bundle裏面所有的momd，創建整合模型；比較簡單，不用考慮模型文件名稱；一般都用這個。
        managedObjectModel_ = [NSManagedObjectModel mergedModelFromBundles:nil];
        return managedObjectModel_;
    }
    else
    {
        //指定数据模型名称方式加载
        //加載單個模型，如果有不同的模型要想給不同的NSPersistentStoreCoordinator,就需要這個方法了；
//        NSString *modelPath = [[NSBundle mainBundle] pathForResource:modelName ofType:@"momd"];
//        //NSLog(@"%@",modelPath);
//        NSURL *modelURL = [NSURL fileURLWithPath:modelPath];
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:modelName withExtension:@"momd"];
        managedObjectModel_ = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        return managedObjectModel_;
    }
}


/**
 Persistent Store Coordinator 相当于数据文件管理器，处理底层的对数据文件的读取与写入。一般我们无需与它打交道。
 If the coordinator doesn't already exist, it is created and the application's store added to it.
 */
- (NSPersistentStoreCoordinator *)persistentStoreCoordinatorWithAppGroupIdentifier:(NSString*)appGroupIdentifier
                                                                         modelName:(NSString*)modelName
{
    
    if (persistentStoreCoordinator_ != nil) {
        return persistentStoreCoordinator_;
    }
    
    NSURL *storeURL = nil;
    if (appGroupIdentifier!=nil)
    {
        NSString *dbName = [NSString stringWithFormat:@"DataBasic_%@.sqlite",modelName];
        storeURL = [[self applicationDirectoryForSecurityApplicationGroupIdentifier:appGroupIdentifier] URLByAppendingPathComponent:dbName];
    }
    else
    {
        storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"DataBasic.sqlite"];
    }
    
    // handle db upgrade
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:
                             [NSNumber numberWithBool:YES], NSMigratePersistentStoresAutomaticallyOption,
                             [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
    
    NSError *error = nil;
    persistentStoreCoordinator_ = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModelWithModelName:modelName]];
    if (![persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:options error:&error]) {
        
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //abort();
        
        //以下為錯誤處理：可能資料庫版本問題 (无法合并数据库的情况下，选择删除数据)
        [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil];
        [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithBool:YES],NSMigratePersistentStoresAutomaticallyOption, [NSNumber numberWithBool:YES], NSInferMappingModelAutomaticallyOption, nil];
        
        //重新創建
        [persistentStoreCoordinator_ addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error];
    }
    
    return persistentStoreCoordinator_;
}


#pragma mark Application's Documents directory
/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDirectoryForSecurityApplicationGroupIdentifier:(NSString*)appGroupIdentifier
{
    return [[NSFileManager defaultManager] containerURLForSecurityApplicationGroupIdentifier:appGroupIdentifier];
}

- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
