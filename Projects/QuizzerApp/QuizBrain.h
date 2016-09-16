//
//  QuizBrain.h
//  QuizzerApp
//

#import <Foundation/Foundation.h>

@interface QuizBrain : NSObject
{
    int quesCount;
    int randomNum1;
    int randomNum2;
    
    int numRight;
    int numWrong;
    int score;
    BOOL wrongOnce; //checks if a wrong answer was given on the current question
    
    NSArray *answers;
    NSArray *sciAnswers;
    NSArray *labels;
    
    BOOL quizType; //flipside student or teacher mode
    BOOL quizDiff; //flipside easy/hard mode
    int quizLevel; //flipside number of options
    
    NSMutableArray *arrayRandomNumber;
    NSMutableArray *arrayRandomArray;
}

+ (id) sharedBrain;

- (BOOL)correctAnswer:(NSString *)selection :(int)index;
- (NSString *)currentAnswer:(int)index;
- (NSString *)currentSciAnswer:(int)index;
- (NSString *)getLabel:(int)value;

- (void)setQuesCount:(int)quesNum;
- (int)getQuesCount;

- (void)setSettings:(BOOL)quizVal :(BOOL)diffVal :(int)choiceVal;
- (BOOL)getQuizMode;
- (BOOL)getQuizDiff;
- (int)getQuizLevel;

- (int)generateRandomNumber:(int)reset;
- (int)generateRandomArrayIndex: (int)reset;

- (void)setRight :(int)value;
- (int)getRight;
- (void)setWrong :(int)value;
- (int)getWrong;
- (void)setWrongOnce :(BOOL)value;
- (BOOL)getWrongOnce;

@end
