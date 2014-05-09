//
//  GameOver.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/8/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"
@import AVFoundation;

@implementation GameOver
AVAudioPlayer *_backgroundAudioPlayer;


-(id)initWithSize:(CGSize)size lose: (NSInteger)game{
    [self startBackgroundMusic];
    if (self = [super initWithSize:size]) {
        
      //  [self runAction:[SKAction playSoundFileNamed:@"TempleFight.mp3" waitForCompletion:YES]];
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        NSString * message;
        message = @"Game Over";
        
        
        SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        label.text = message;
        label.fontSize = 40;
        label.fontColor = [SKColor blackColor];
        label.position = CGPointMake(self.size.width/2, self.size.height/2);
        [self addChild:label];
        
        
        //Add a Retry Button
        NSString * retrymessage;
        retrymessage = @"Replay Game";
        SKLabelNode *retryButton = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
        retryButton.text = retrymessage;
        retryButton.fontColor = [SKColor blackColor];
        retryButton.position = CGPointMake(self.size.width/2, 100);
        retryButton.name = @"retry";
        [retryButton setScale:.5];
        
        [self addChild:retryButton];
        
        
        
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInNode:self];
    SKNode *node = [self nodeAtPoint:location];
    
    if ([node.name isEqualToString:@"retry"]) {
        SKTransition *reveal = [SKTransition flipHorizontalWithDuration:0.5];
        
        MyScene * scene = [MyScene sceneWithSize:self.view.bounds.size];
        scene.scaleMode = SKSceneScaleModeAspectFill;
        [self.view presentScene:scene transition: reveal];
        
    }
    
}

- (void)startBackgroundMusic
{
    NSError *err;
    NSURL *file = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"TempleFight.mp3" ofType:nil]];
    _backgroundAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:file error:&err];
    if (err) {
        NSLog(@"error in audio play %@",[err userInfo]);
        return;
    }
    [_backgroundAudioPlayer prepareToPlay];
    
    // this will play the music infinitely
    _backgroundAudioPlayer.numberOfLoops = -1;
    [_backgroundAudioPlayer setVolume:.5];
    [_backgroundAudioPlayer play];
}



@end