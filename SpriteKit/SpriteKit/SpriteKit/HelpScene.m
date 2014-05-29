//
//  HelpScene.m
//  SpriteKit
//
//  Created by DANIEL ANNIS on 5/28/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "HelpScene.h"

@implementation HelpScene
-(id) initWithSize:(CGSize)size{
    if (self = [super initWithSize:size]){
        //setup your scene
        
        [self createBackground];
        
    }return self;
}

//create background
-(void) createBackground{
    SKTexture *bgTexture = [SKTexture textureWithImageNamed:@"commonBG"];
    self.background = [SKSpriteNode spriteNodeWithTexture:bgTexture];
    self.background.position = (CGPoint) {CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)};
    [self addChild:self.background];
}

-(void) createBackButton{
    self.backButton = [SKSpriteNode spriteNodeWithImageNamed:@"back"];
    [self.backButton setScale:1.15];
    self.backButton.position = (CGPoint) {CGRectGetMidX(self.frame), CGRectGetMidY(self.frame)};
    [self addChild:self.backButton];
}

-(void) touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event   {
    
    //Get the touch
    UITouch *touch = [touches anyObject];
    
    //Get the position in the scene
    CGPoint positionInScene = [touch locationInNode:self];
    
    if(CGRectContainsPoint(self.backButton.frame, positionInScene)){
#ifdeg DEBUG
        NSLog(@"BackButton Tapped");
#endif
        
        //Set action to the Button
        [self.BackButton runAction:[SKAction sequence:@[[SKAction moveByX:0 y:2 duration:0.1f],[SKAction moveByX:0 y:2 duration:0.1]]] completion:^
    }
}

@end
