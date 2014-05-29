//
//  MainScene.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/28/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "MainScene.h"

@implementation MainScene


-(id) initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        //setup your scene
        
        [self createBackground];
        [self createPlayButton];
        [self createHelpButton];
        [self createCreditsButton];
        
    }return self;
}

//create backgeround
-(void) createBackground{
    SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"mainBG"];
    self.background = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    self.background.position = (CGPoint) {CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)};
    [self addChild:self.background];
}

//create Play Button
-(void) createPlayButton{
    self.playButton = [SKSpriteNode spriteNodeWithImageNamed:@"play"];
    self.playButton.position =(CGPoint) {CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)+100};
}

//create Help Button
-(void) createHelpButton{
    
}

//create Credits Button
-(void) createCreditsButton{
    
}

@end
