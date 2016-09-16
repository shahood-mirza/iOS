//
//  Results.h
//  QuizzerApp
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>

@interface Results : UIViewController
{
    AVAudioPlayer *audioPlayer;
    
    IBOutlet UILabel *right;
    IBOutlet UILabel *wrong;
}

@property (nonatomic, retain) AVAudioPlayer *audioPlayer;
@property(readonly, getter=isPlaying) BOOL playing;

- (IBAction)buttonTapped:(UIButton *)sender;

@end
