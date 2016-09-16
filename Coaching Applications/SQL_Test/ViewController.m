//
//  ViewController.m
//  SQL_Test
//
//  Created by Shahood Mirza
//

#import "ViewController.h"
#import <sqlite3.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    @try {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"test.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured: %s", sqlite3_errmsg(db));
            
        }
        
        
        const char *sql = "SELECT * FROM  test";
        //sqlite3_stmt *sqlStatement;
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
        }else{
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW) {
                //Author * author = [[Author alloc] init];
                //author.name = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)];
                //author.title = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,2)];
                //author.genre = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement, 3)];
                //[theauthors addObject:author];
                NSLog([NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]);
                NSLog([NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,1)]);
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
    }
    @finally {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        
        //return theauthors;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
