//
//  Player.m
//  Monopoly
//

#import "Player.h"

@implementation Player

- (id) init
{
    self = [super init];
    if (self)
    {
        money = 1500; //initial starting cash for all players (default 1500)
        position = 1; //go is set to position 1 in the db, maybe change to 0 in db?
        
    }
    
    return self;
}

-(void)setInitialPosition:(int)setLocation
{
    position = setLocation;
}

-(void)setInitialMoney:(int)setAmount
{
    money = setAmount;
}

-(void)setPosition:(int)roll
{
    while(roll > 0)
    {
        if(position == 40)
        {
            position = 1; //go is set to position 1 in the db, maybe change to 0 in db?
            money += 200; //passing go gives $200
        }
        else
            position++;
        
        roll--;
    }
}

-(int)getPosition
{
    return position;
}

-(void)setMoney:(int)payment //should be used to subtract money as well (paying rent etc.)
{
    money += payment;
}

-(int)getMoney
{
    return money;
}

@end
