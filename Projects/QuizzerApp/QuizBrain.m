//
//  QuizBrain.m
//  QuizzerApp
//

#import "QuizBrain.h"

@implementation QuizBrain

+ (id)sharedBrain
{
    static QuizBrain *sharedQuizBrain = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQuizBrain = [[self alloc] init];
    });
    
    return sharedQuizBrain;
}

- (id) init
{
    if (self = [super init])
    {
        //initialization code here
        quesCount = 0;
        
        numWrong = 0;
        numRight = 0;
        
        //set default settings for flipside
        quizLevel = 0;  //default guess options (set to 0 for 3, 1 for 6 and 2 for 9)
        quizType = YES; //default quiz type (YES for student mode, NO for teacher mode)
        quizDiff = YES; //default quiz difficulty (YES for easy, NO for HARD)
        
        //correct answer array
        answers = @[@"Buck", @"Bobcat", @"Cougar", @"Coyote", @"Howler Monkey", @"Hyena", @"Jackrabbit", @"Moose", @"Raccoon", @"Red Fox"];
        
        //scientific equivalent array
        sciAnswers = @[@"Odocoileus", @"Lynx-rufus", @"Felis-concol", @"Canis-latrans", @"Alouatta", @"Crocuta", @"Oryctolagus", @"Alces", @"Procyon", @"Vulpes"];
        
        //filler answers array
        labels = @[@"Mouse", @"Giraffe", @"Donkey", @"Jackal", @"Warthog", @"Lion", @"Dingo", @"Shark", @"Mammoth", @"Deer", @"Kangaroo", @"Gorilla", @"Hippo", @"Eagle", @"Parrott"];
        
        arrayRandomNumber=[[NSMutableArray alloc] init];
        [arrayRandomNumber addObject:[NSString stringWithFormat:@"%d",0]];
        
        arrayRandomArray=[[NSMutableArray alloc]init];
    }
    
    return self;
}

//This method generates the random number used to display random (non-repeating) images
- (int) generateRandomNumber:(int)reset //use zero to reset the array
{
    if (reset == 0)
    {
        arrayRandomNumber.removeAllObjects;
        [arrayRandomNumber addObject:[NSString stringWithFormat:@"%d",0]];
        
        return 0;
    }
    while (arrayRandomNumber.count < answers.count)
    {
        randomNum1 = arc4random() % answers.count;
        if (![arrayRandomNumber containsObject:[NSString stringWithFormat:@"%d",randomNum1]])
        {
            //the generated number is stored in the array only if it is not already there
            //the number is only returned if it was not previously in this array (prevents repeating)
            [arrayRandomNumber addObject:[NSString stringWithFormat:@"%d",randomNum1]];
            break;
        }
    }
    return randomNum1;
}

//This method generates the random number used to insert the filler answers (incorrect) into their segments
- (int) generateRandomArrayIndex:(int)reset //use zero to reset the array
{
    if (reset == 0)
    {
        arrayRandomArray.removeAllObjects;
        
        return 0;
    }
    for (int i=0; i<labels.count; i++) //using the length of the array allows addition of more filler answers
    {
        randomNum2 = arc4random() %labels.count;
        if (![arrayRandomArray containsObject:[NSString stringWithFormat:@"%d",randomNum2]])
        {
            //the generated number is stored in the array only if it is not already there
            //the number is only returned if it was not previously in this array (prevents repeating)
            [arrayRandomArray addObject:[NSString stringWithFormat:@"%d",randomNum2]];
            break;
        }
    }
    return randomNum2;
}

- (BOOL)correctAnswer:(NSString *)selection :(int)index
{
    if([selection isEqual:[answers objectAtIndex:(index)]])
        return YES;
    else
        return NO;
}

- (NSString *)currentAnswer:(int)index
{
    return [answers objectAtIndex:(index)];
}

- (NSString *)currentSciAnswer:(int)index;
{
    return [sciAnswers objectAtIndex:(index)];
}

- (NSString *)getLabel:(int)value
{
    return [labels objectAtIndex:(value)];
}

- (void)setQuesCount:(int)quesNum //send down zero to reset quesCount
{
    if (quesNum == 0)
        quesCount = 0;
    else
        quesCount += quesNum;
}

- (int)getQuesCount
{
    return quesCount;
}

//This method sets the settings from flipside for storage and use from other classes & views
- (void)setSettings:(BOOL)quizVal :(BOOL)diffVal :(int)choiceVal
{
    quizType = quizVal;
    quizDiff = diffVal;
    quizLevel = choiceVal;
}

- (BOOL)getQuizMode
{
    return quizType;
}

- (BOOL)getQuizDiff
{
    return quizDiff;
}

- (int)getQuizLevel
{
    return quizLevel;
}

- (void)setRight :(int)value //send down zero to reset
{
    if(value == 0)
        numRight = 0;
    else
        numRight += value;
}

- (int)getRight
{
    return numRight;
}

- (void)setWrong :(int)value //send down zero to reset
{
    if(value == 0)
        numWrong = 0;
    else
        numWrong += value;
}

- (int)getWrong
{
    return numWrong;
}

- (void)setWrongOnce :(BOOL)value
{
    wrongOnce = value;
}

- (BOOL)getWrongOnce
{
    return wrongOnce;
}

@end
