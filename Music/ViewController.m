//
//  ViewController.m
//  Music
//
//  Created by 李银 on 15/12/9.
//  Copyright © 2015年 liyin. All rights reserved.
//

#import "ViewController.h"
#import "LrcManager.h"

@interface ViewController (){
    NSTimer *_timer;
    NSMutableArray *_musicsArray;
    int _index;
    LrcManager *lrc;
    BOOL isLoop;
}

@property (nonatomic, strong) AVAudioPlayer *player;
@property (weak, nonatomic) IBOutlet UILabel *musicNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *playerImageView;
@property (weak, nonatomic) IBOutlet UILabel *lrcLabel;
@property (weak, nonatomic) IBOutlet UILabel *curentTimeLabel;
@property (weak, nonatomic) IBOutlet UIButton *playOrPauseButton;
@property (weak, nonatomic) IBOutlet UISlider *musicProgressSlider;
@property (weak, nonatomic) IBOutlet UISlider *voiceSlider;
@property (weak, nonatomic) IBOutlet UITableView *musicListTabelView;
@property (weak, nonatomic) IBOutlet UIButton *loopButton;
@property (weak, nonatomic) IBOutlet UILabel *totalTimeLabel;
- (IBAction)musicProgressChangeS:(id)sender;
- (IBAction)lastMusicClick:(id)sender;
- (IBAction)playOrPauseClick:(id)sender;
- (IBAction)nextMusicClick:(id)sender;
- (IBAction)displayVoiceClick:(id)sender;
- (IBAction)displayMusicListClick:(id)sender;
- (IBAction)voiceChange:(id)sender;
- (IBAction)loopClick:(id)sender;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    [self initDataAndViewAndSoOn];
}

- (void)initDataAndViewAndSoOn{
    Musics *music1 = [[Musics alloc] initMusicsWithName:@"林俊杰 - 当你" andType:@"m4a"];
    Musics *music2 = [[Musics alloc] initMusicsWithName:@"林俊杰 - 生生" andType:@"m4a"];
    Musics *music3 = [[Musics alloc] initMusicsWithName:@"林俊杰 - 可惜没如果" andType:@"m4a"];
    Musics *music4 = [[Musics alloc] initMusicsWithName:@"李荣浩 - 老街" andType:@"mp3"];
    _musicsArray = [NSMutableArray arrayWithObjects:music1, music2, music3, music4, nil];
    [self loadMudicWithName:music1.name andType:music1.mType];
    
    
    _index = 0;
    isLoop = YES;
    _voiceSlider.transform = CGAffineTransformMakeRotation(- M_PI_2);
    _voiceSlider.hidden = YES;
    _musicListTabelView.hidden = YES;
    _musicListTabelView.alpha = 0.8;
    _lrcLabel.text = @"Hello Music";
    
    [self displayTotalTime];
    
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self                                selector:@selector(showMusicProgress) userInfo:nil repeats:YES];
    }
    
}

- (void)displayTotalTime{
    if ((int)_player.duration%60 < 10) {
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)_player.duration/60,(int)_player.duration%60];
    }else{
        _totalTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)_player.duration/60,(int)_player.duration%60];
    }
}

- (void)loadMudicWithName:(NSString *)names andType:(NSString *)types{
    NSString *path = [[NSBundle mainBundle] pathForResource:names ofType:types];
    NSURL *audioUrl = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:audioUrl error:nil];
    _musicNameLabel.text = names;
    _playerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",names]];
    _player.delegate = self;
    [_player prepareToPlay];
}

- (void)showMusicProgress{
    _musicProgressSlider.value = _player.currentTime/_player.duration;
    if ((int)_player.currentTime%60 < 10) {
        _curentTimeLabel.text = [NSString stringWithFormat:@"%d:0%d",(int)_player.currentTime/60,(int)_player.currentTime%60];
    }else{
        _curentTimeLabel.text = [NSString stringWithFormat:@"%d:%d",(int)_player.currentTime/60,(int)_player.currentTime%60];
    }
    [self displayLrc];
    if (_player.playing) {
       [self pugongying];
    }
}

- (void)displayLrc{
    lrc = [[LrcManager alloc] initWithLrcFile:[_musicsArray[_index] name]];
    //NSLog(@"%f",_player.currentTime);
    //02:04.00
    int minu = (int)_player.currentTime/60;
    int second = (int)(_player.currentTime - minu*60);
    int msecond =(int)(_player.currentTime - (minu*60+second))*100;
    _lrcLabel.text = [lrc lrcForTime:[NSString stringWithFormat:@"0%d:%d.%d", minu, second, msecond]];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag{
    if (isLoop) {
        if (_index == _musicsArray.count - 1) {
            _index = 0;
        }else{
            _index ++;
        }
        [self loadMudicWithName:[[_musicsArray objectAtIndex:_index] name] andType:[[_musicsArray objectAtIndex:_index] mType]];
        [_player play];
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [_musicsArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [[_musicsArray objectAtIndex:indexPath.row] name];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *aa = [[_musicsArray objectAtIndex:indexPath.row] name];
    NSString *bb = [[_musicsArray objectAtIndex:indexPath.row] mType];
    NSString *path = [[NSBundle mainBundle] pathForResource:aa ofType:bb];
    NSURL *url = [NSURL fileURLWithPath:path];
    _player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:nil];
    [_player play];
    _musicNameLabel.text = aa;
    _playerImageView.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@.jpg",aa]];
    [self displayTotalTime];
    _index = (int)indexPath.row;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    _musicListTabelView.hidden = YES;
}

-(void)pugongying
{
    int startX= random()%320;
    int endX= random()%320;
    int width= random()%25;
    CGFloat time= (random()%100)/10+5;
    CGFloat alp= (random()%9)/10.0+0.1;
    UIImage* image= [UIImage imageNamed:@"pugongying.png"];
    UIImageView* imageView = [[UIImageView alloc] initWithImage:image];
    imageView.frame= CGRectMake(startX,-1*width,width,width);
    imageView.alpha=alp;
    
    [self.view addSubview:imageView];
    
    [UIView beginAnimations:nil context:(__bridge void *)(imageView)];
    [UIView setAnimationDuration:time];
    
    if(endX>50&&endX<270)
    {
        imageView.frame= CGRectMake(endX, 270-width/2, width, width);
        
    }
    else if((endX>10&&endX<50)||(endX>270&&endX<310))
        imageView.frame= CGRectMake(endX, 400-width/2, width, width);
    else
        imageView.frame= CGRectMake(endX, 480, width, width);
    [UIView setAnimationDidStopSelector:@selector(onAnimationComplete:finished:context:)];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    
}

-(void)onAnimationComplete:(NSString*)animationID finished:(NSNumber*)finished context:(void*)context
{
    UIImageView* snowView=(__bridge UIImageView *)(context);
    [snowView removeFromSuperview];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark FouctionCode(功能性代码)

- (IBAction)musicProgressChangeS:(id)sender {
    _player.currentTime = _musicProgressSlider.value*_player.duration;
    
}

- (IBAction)lastMusicClick:(id)sender {
    BOOL isP;
    if (_player.playing) {
        [_player stop];
        isP = YES;
    }else{
        isP = NO;
    }
    if (_index == 0) {
        _index = (int)[_musicsArray count] - 1;
    }else {
        _index --;
    }
    [self loadMudicWithName:[[_musicsArray objectAtIndex:_index] name] andType:[[_musicsArray objectAtIndex:_index] mType]];
    if (isP) {
        [_player play];
    }
    [self displayTotalTime];
}

- (IBAction)playOrPauseClick:(id)sender {
    if (_player.playing == NO) {
        [_player play];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"pause.png"] forState:UIControlStateNormal];
        if (_timer == nil) {
            _timer = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(showMusicProgress) userInfo:nil repeats:YES];
        }
    }else{
        [_player pause];
        [_playOrPauseButton setImage:[UIImage imageNamed:@"play.png"] forState:UIControlStateNormal];
        [_timer invalidate];
        _timer = nil;
    }
    [self displayTotalTime];
}

- (IBAction)nextMusicClick:(id)sender {
    BOOL isP;
    if (_player.playing) {
        [_player stop];
        isP = YES;
    }else{
        isP = NO;
    }
    if (_index == [_musicsArray count] - 1) {
        _index = 0;
    }else {
        _index ++;
    }
    [self loadMudicWithName:[[_musicsArray objectAtIndex:_index] name] andType:[[_musicsArray objectAtIndex:_index] mType]];
    if (isP) {
        [_player play];
    }
    [self displayTotalTime];
}

- (IBAction)displayVoiceClick:(id)sender {
    if (_voiceSlider.hidden) {
        _voiceSlider.hidden = NO;
    }else{
        _voiceSlider.hidden = YES;
    }
}

- (IBAction)displayMusicListClick:(id)sender {
    if (_musicListTabelView.hidden) {
        _musicListTabelView.hidden = NO;
    }else{
        _musicListTabelView.hidden = YES;
    }
}

- (IBAction)voiceChange:(id)sender {
    _player.volume = _voiceSlider.value;
}

- (IBAction)loopClick:(id)sender {
    if (isLoop) {
        isLoop = NO;
        _loopButton.backgroundColor = [UIColor grayColor];
    }else{
        isLoop = YES;
        _loopButton.backgroundColor = [UIColor clearColor];
    }
}
@end
