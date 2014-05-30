//
//  GameOver.h
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/8/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//


#import <SpriteKit/SpriteKit.h>
#import "SSBitmapFont.h"
#import "SSBitmapFontLabelNode.h"

@interface GameOver : SKScene{
    SSBitmapFontLabelNode * gameOverLabel;
    SSBitmapFontLabelNode * scoreLabel;
    
    SKSpriteNode *menu;
    SKSpriteNode *retry;
}

-(id)initWithSize:(CGSize)size lose: (NSInteger)score;

@end