//
//  MonopolyBrain.m
//  Monopoly
//

#import "MonopolyBrain.h"

@implementation MonopolyBrain

- (id) init
{
    self = [super init];
    if (self) {
        //initialization code here
    }
    
    return self;
}

-(int)rentPayment:(int) position :(NSString *) owner :(int) diceroll; //calculate rent based on monopoly type
{
    payment = [[self runSQL:([NSString stringWithFormat:@"SELECT Rent FROM  Properties WHERE Position=%d", position])] intValue];
    
    //utility rent is determined by diceroll
    if(position == 29 || position == 13)
    {
        if([self isMonopoly:position:owner]) //if the player has a utility monopoly rent is dice roll times 10
            payment = diceroll*10;
        else  //if the player only has one utility rent is diceroll times 4
            payment = diceroll*4;
    }
    //railroad rent is determined by number of railroads owned
    else if(position == 6 || position == 16 || position == 26 || position == 36)
    {
        [self isMonopoly:position:owner];
        payment = 25 * monCount;
    }
    //regular monopoly rent is just doubled
    else if([self isMonopoly:position:owner])
    {
        payment *= 2;
    }
    
    return payment;
}

-(NSString *)runSQL:(NSString *) statement //returns only one result so query must be prepared correctly
{
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
        
        const char *sql = [statement UTF8String];
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
        }
        else
        {
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                result = [NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)];
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
    }
    @finally
    {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
        
        return result;
    }
}

-(BOOL)isMonopoly:(int) position :(NSString *) owner; //checks if the owner of the property has the monopoly
{
    monopoly = YES; //initially assumes monopoly, if the properties are not a monopoly it will change
    monCount = 0;
    
    colour = [self runSQL:([NSString stringWithFormat:@"SELECT Colour FROM  OwnableProperties WHERE Position=%d", position])];
    
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
        
        const char *sql = [([NSString stringWithFormat:@"SELECT owner FROM  OwnableProperties WHERE colour='%@'", colour]) UTF8String];
        
        if(sqlite3_prepare(db, sql, -1, &sqlStatement, NULL) != SQLITE_OK)
        {
            NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
        }
        else
        {
            
            while (sqlite3_step(sqlStatement)==SQLITE_ROW)
            {
                if (![[NSString stringWithUTF8String:(char *) sqlite3_column_text(sqlStatement,0)] isEqual:owner])
                {
                    monopoly = NO;  //if there is no monopoly set to NO
                    monCount--; //decrease monCount (this is used to check number of owned railroads)
                }
                monCount++;  //increase monCount (used to check number of owned railroads)
            }
        }
    }
    @catch (NSException *exception)
    {
        NSLog(@"Problem with prepare statement:  %s", sqlite3_errmsg(db));
    }
    @finally
    {
        sqlite3_finalize(sqlStatement);
        sqlite3_close(db);
    }
    
    return monopoly;
}

@end
