//
//  zmbLevel.m
//  RPG_Zombie
//
//  Created by DANIEL ANNIS on 5/22/14.
//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import "zmbLevel.h"

@interface zmbLevel(){
  
     SKNode* myWorld;
    
}

@end

@implementation zmbLevel


-(id)initWithSize:(CGSize)size {
    if (self = [super initWithSize:size]) {
        /* Setup your scene here */
        
//        self.backgroundColor = [SKColor colorWithRed:0.15 green:0.15 blue:0.3 alpha:1.0];
//        
//        SKLabelNode *myLabel = [SKLabelNode labelNodeWithFontNamed:@"Chalkduster"];
//        
//        myLabel.text = @"Level!!";
//        myLabel.fontSize = 30;
//        myLabel.position = CGPointMake(CGRectGetMidX(self.frame),
//                                       CGRectGetMidY(self.frame));
//        
//        [self addChild:myLabel];
        [self setUpScene];
        
    }
    return self;
}

-(void) setUpScene{
    //Setting up the world and bringing in the pList
    
    self.anchorPoint = CGPointMake(0.5, 0.5); //0,0 to 1,1
    myWorld = [SKNode node];
    [self addChild:myWorld];
    
    
    SKSpriteNode* map = [SKSpriteNode spriteNodeWithImageNamed:@"level_map1"];
    map.position = CGPointMake(0, 0);
    [self addChild:map];
    
    
    
}

-(void)update:(CFTimeInterval)currentTime {
    /* Called before each frame is rendered */
}

@end
