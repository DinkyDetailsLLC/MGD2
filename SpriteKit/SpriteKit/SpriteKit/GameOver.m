//
//  GameOver.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/8/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "GameOver.h"
#import "MyScene.h"
#import "MainScene.h"
@import AVFoundation;

@implementation GameOver
AVAudioPlayer *_backgroundAudioPlayer;


-(id)initWithSize:(CGSize)size lose: (NSInteger)score{
    [self startBackgroundMusic];
    if (self = [super initWithSize:size]) {
        
        //  [self runAction:[SKAction playSoundFileNamed:@"TempleFight.mp3" waitForCompletion:YES]];
        
        self.backgroundColor = [SKColor colorWithRed:1.0 green:1.0 blue:1.0 alpha:1.0];
        
        
        // Game Over Label
        SSBitmapFont *bitmapFont = [self bitmapFontForFile:@"ScorePanelFont"];
        gameOverLabel = [bitmapFont nodeFromString:@"GAME OVER!"];
        gameOverLabel.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                                  CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+200) :
                                  CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100));
        [self addChild:gameOverLabel];
        
        // Show score
        scoreLabel = [bitmapFont nodeFromString:[NSString stringWithFormat:@"Score: %d", score]];
        scoreLabel.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                               CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+80) :
                               CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+40));
        
        ;
        [self addChild:scoreLabel];
        
        
        //Add a Retry Button
        
        menu = [SKSpriteNode spriteNodeWithImageNamed:@"menu"];
        menu.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                         CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-100) :
                         CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)-40));
        
        menu.zPosition = 0.3;
        [self addChild:menu];
        
        retry = [SKSpriteNode spriteNodeWithImageNamed:@"retry"];
        retry.position = ((UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) ?
                          CGPointMake(CGRectGetMidX(self.frame), menu.position.y - (retry.size.height+40)) :
                          CGPointMake(CGRectGetMidX(self.frame), menu.position.y - (retry.size.height+20)));
        retry.zPosition = 0.3;
        [self addChild:retry];
        
    }
    return self;
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint positionInScene = [touch locationInNode:self];
    
    if (CGRectContainsPoint(retry.frame, positionInScene)) {
        
#ifdef DEBUG
        NSLog(@"retry Button Tapped");
#endif
        
        // Set an action to the button
        [retry runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1]]]completion:^{
            
            SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
            MyScene *gameScene = [[MyScene alloc] initWithSize:self.size];
            [self.scene.view presentScene:gameScene transition:reveal];
            
        }];
    } else if (CGRectContainsPoint(menu.frame, positionInScene)) {
        
#ifdef DEBUG
        NSLog(@"menu Button Tapped");
#endif
        
        // Set an action to the button
        [menu runAction:[SKAction sequence:@[[SKAction moveByX:0 y:-2 duration:0.1f], [SKAction moveByX:0 y:2 duration:0.1]]]completion:^{
            
            SKTransition *reveal = [SKTransition fadeWithDuration:.5f];
            MainScene *mainScene = [[MainScene alloc] initWithSize:self.size];
            [self.scene.view presentScene:mainScene transition:reveal];
            
        }];
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

- (SSBitmapFont *)bitmapFontForFile:(NSString *)filename
{
    // Generate a path to the font file
    NSString *path = [[NSBundle mainBundle] pathForResource:filename ofType:@"skf"];
    
    NSAssert(path, @"Could not find font file");
    
    // Create a new instance of SSBitmapFont using the font file and check for errors
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:path];
    SSBitmapFont *bitmapFont = [[SSBitmapFont alloc] initWithFile:url error:&error];
    
    NSAssert(!error, @"%@: %@", error.domain, error.localizedDescription);
    
    return bitmapFont;
}


@end