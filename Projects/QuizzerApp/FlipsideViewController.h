//
//  FlipsideViewController.h
//  QuizzerApp
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController
{
    int choiceVal;  //flipside vars (settings)
    BOOL diffVal;
    BOOL quizVal;
    
    IBOutlet UISegmentedControl *quizMode;
    IBOutlet UISegmentedControl *quizLevel;
    IBOutlet UISegmentedControl *quizDiff;
}

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end
