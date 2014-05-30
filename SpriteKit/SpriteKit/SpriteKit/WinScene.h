//
//  WinScene.h
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/29/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>
#import "SSBitmapFont.h"
#import "SSBitmapFontLabelNode.h"
#import "MyScene.h"
#import "MainScene.h"
@import AVFoundation;


@interface WinScene : SKScene{
    SSBitmapFontLabelNode * gameWonLabel;
    SSBitmapFontLabelNode * scoreLabel;
    
    SKSpriteNode *menu;
    SKSpriteNode *replay;
    SKSpriteNode *next;
}

-(id)initWithSize:(CGSize)size win: (NSInteger)score;

@end
