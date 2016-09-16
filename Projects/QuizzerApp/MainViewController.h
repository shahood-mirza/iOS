//
//  MainViewController.h
//  QuizzerApp
//

#import "FlipsideViewController.h"
#import "QuizBrain.h"
#import <AVFoundation/AVFoundation.h>

@interface MainViewController : UIViewController <FlipsideViewControllerDelegate>
{
    int randomNum;
    int randSeg;
    int randIndex;

    int soundWrong; // used to randomize sound for wrong answers
    
    int quizLevel; //these two variables will hold setting values for one instance
    BOOL quizDiff;
    
    AVAudioPlayer *audioPlayer;
    
    IBOutlet UILabel *display;
    IBOutlet UILabel *quesNum;
    
    IBOutlet UIProgressView *progBar;
    
    IBOutlet UISegmentedControl *segOne;
    IBOutlet UISegmentedControl *segTwo;
    IBOutlet UISegmentedControl *segThree;
    
    IBOutlet UIImageView *imageView;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property (readonly, getter=isPlaying) BOOL playing;

- (IBAction)startMode:(UIButton *)sender;
- (IBAction)playSound:(UIButton *)sender;
- (IBAction)goHome:(UIButton *)sender;
- (IBAction)goToNextQuestion:(id)sender;
- (IBAction)tutorialNextPrev:(id)sender;

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex;
- (void)playRightWrong:(BOOL)corrAns;

@end
