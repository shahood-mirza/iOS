//
//  PropertyViewController.m
//  Monopoly
//

#import "PropertyViewController.h"

@interface PropertyViewController ()

@end

@implementation PropertyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [_properties count];
}

//insert array into tableview
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"SimpleTableItem";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:simpleTableIdentifier];
    }
    
    cell.textLabel.text = [_properties objectAtIndex:indexPath.row];
    return cell;
}

//pull all of player 1's properties from the database
-(NSMutableArray *) propertiesList{
    _properties = [[NSMutableArray alloc] initWithCapacity:10];
    @try
    {
        NSFileManager *fileMgr = [NSFileManager defaultManager];
        NSString *dbPath = [[[NSBundle mainBundle] resourcePath ]stringByAppendingPathComponent:@"Monopoly.sqlite"];
        BOOL success = [fileMgr fileExistsAtPath:dbPath];
        
        if(!success)
        {
            NSLog(@"Cannot locate database file '%@'.", dbPath);
        }
        if(!(sqlite3_open([dbPath UTF8String], &db) == SQLITE_OK))
        {
            NSLog(@"An error has occured: %s", sqlite3_errmsg(db));
            
        }
        
        
        const char *sql = "SELECT name FROM properties INNER JOIN ownableproperties ON properties.position=ownableproperties.position AND ownableproperties.owner = 'P1'";
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
            
        }
        else
        {
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                [_properties addObject:[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)]];
            }
        }
        sqlite3_finalize(sqlStatement);
    }
    @catch (NSException *exception)
    {
        NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
    }
    @finally
    {
        
        sqlite3_close(db);
        
        return _properties;
    }
}

- (void)viewDidLoad
{
    [self propertiesList];
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
