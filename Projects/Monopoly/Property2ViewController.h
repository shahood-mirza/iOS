//
//  PropertyViewController.h
//  Monopoly
//

#import <UIKit/UIKit.h>
#import <sqlite3.h>

@interface Property2ViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
{
    sqlite3 * db;
    sqlite3_stmt *sqlStatement;
    
    NSArray *tableData;
    NSString *result;
}

@property(nonatomic, retain) NSMutableArray *properties;

@end
