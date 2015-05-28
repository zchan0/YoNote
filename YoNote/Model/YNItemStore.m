//
//  YNItemStore.m
//  YoNote
//
//  Created by Zchan on 15/5/23.
//  Copyright (c) 2015年 Zchan. All rights reserved.
//

#import "YNItemStore.h"
#import "YNImageStore.h"

@interface YNItemStore ()

@property (nonatomic) NSMutableArray *privateItems;
@property (nonatomic) NSMutableArray *privateCollections;
@property (nonatomic) NSMutableArray *privateTags;
@property (nonatomic, strong) NSManagedObjectContext *context;
@property (nonatomic, strong) NSManagedObjectModel *model;

@end

@implementation YNItemStore

#pragma mark - Init

+ (instancetype)sharedStore
{
    //  声明为静态变量
    //  静态变量和全局变量一样，并不是在栈中，所以该方法返回时，程序并不会释放该变量
    static YNItemStore *sharedStore = nil;
    
    //  判断是否需要创建一个sharedStore对象
    if (!sharedStore) {
        sharedStore = [[self alloc] initPrivate];
    }
    
    return sharedStore;
}


- (instancetype)init
{
    @throw [NSException exceptionWithName:@"Singleton" reason:@"Use + [[YNItemStore alloc] sharedStore]" userInfo:nil];
    return nil;
}

- (instancetype)initPrivate
{
    self = [super init];
    if (self) {
        //  从YoNote.xcdatamoeld中读取实体信息来创建模型对象
        _model = [NSManagedObjectModel mergedModelFromBundles:nil];
        
        //  创建psc
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:_model];
        
        //  指定持久化文件的存储路径
        NSString *path = self.itemArchivePath;
        NSURL *storeURL = [NSURL fileURLWithPath:path];
        NSError *error;
        
        //  指定存储格式为SQLite
        if (![psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
            @throw [NSException exceptionWithName:@"OpenFailure"
                                           reason:[error localizedDescription]
                                         userInfo:nil];
        }
        
        // 创建NSManagedObjectContext
        _context = [[NSManagedObjectContext alloc]init];
        _context.persistentStoreCoordinator = psc;
        
        // 如果已经有数据存在，取出
        [self loadAllItems];
        
    }
    
    return  self;
}

#pragma mark - Item

- (NSArray *)allItems
{
    return [self.privateItems copy];
}

- (BOOL)saveChanges
{
    NSError *error;
    BOOL successful = [self.context save:&error];
    if (!successful) {
        NSLog(@"Error saving: %@", [error localizedDescription]);
    }
    return successful;
}

- (YNItem *)createItem
{
    YNItem *item = [NSEntityDescription insertNewObjectForEntityForName:@"YNItem" inManagedObjectContext:self.context];
    [self.privateItems addObject:item];
    
    return item;
}

- (void)removeItem:(YNItem *)item
{
    [self.context deleteObject:item];
    [self.privateItems removeObjectIdenticalTo:item];
}

- (void)loadAllItems
{
    if (!self.privateItems) {
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        NSEntityDescription *entity = [NSEntityDescription entityForName:@"YNItem" inManagedObjectContext:self.context];
        request.entity = entity;
        
        NSError *error;
        NSArray *result = [self.context executeFetchRequest:request error:&error];
        
        if (!result) {
            [NSException raise:@"Fetch failed" format:@"Reason: %@", [error localizedDescription]];
        }
        
        self.privateItems = [[NSMutableArray alloc] initWithArray:result];
        
    }
}

#pragma mark - Collection

- (NSArray *)allCollections {
    return [self.privateCollections copy];
}

- (YNCollection *)getCollectionByName:(NSString *)collectionName {
    
    NSFetchRequest *request = [NSFetchRequest fetchRequestWithEntityName:@"YNCollection"];
    
    request.predicate = [NSPredicate predicateWithFormat:@"%K=%@",@"collectionName", collectionName];
    
    NSError *error;
    YNCollection *collection;
    
    NSArray *results = [self.context executeFetchRequest:request error:&error];
    if (error) {
        NSLog(@"Error：%@！",error.localizedDescription);
    } else {
        collection = [results firstObject];
    }
    return collection;
    
}

- (void)createCollection:(NSString *)collectionName {
    YNCollection *collection = [NSEntityDescription insertNewObjectForEntityForName:@"YNCollection" inManagedObjectContext:self.context];
    
    [collection setValue:collectionName forKey:@"collectionName"];
    
    [self.privateCollections addObject:collection];
}

- (void)addCollectionForItem:(NSString *)collectionName forItem:(YNItem *)item {
    YNCollection *collection = [self getCollectionByName:collectionName];
    [collection addItemsObject:item];
    
}



#pragma mark - Tags

- (NSArray *)allTags {
    return [self.privateTags copy];
}

- (void)createTag:(NSString *)tagName {
    YNTag *tag = [NSEntityDescription insertNewObjectForEntityForName:@"YNTag" inManagedObjectContext:self.context];
    tag.tag = tagName;
    [self.privateTags addObject:tag];

}

- (void)addTagsForItem:(NSArray *)tags forItem:(YNItem *)item {
    item.tags = [NSSet setWithArray:tags];
}

#pragma mark - Private Methods

- (NSString *)itemArchivePath
{
    // NSSearchPathForDirectoriesInDomains能返回Sandbox中某种(第一个参数指定的）目录的全路径
    // 后面两个参数在iOS中都这样, 在OS中会不一样
    NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentDirectory = [documentDirectories firstObject];
    
    return [documentDirectory stringByAppendingPathComponent:@"store.data"];
}



@end
