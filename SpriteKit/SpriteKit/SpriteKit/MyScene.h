//
//  MyScene.h
//  SpriteKit
//

//  Copyright (c) 2014 Dinky_Details. All rights reserved.
//

#import <SpriteKit/SpriteKit.h>

@interface MyScene : SKScene{
    
    //answer if character is damaged or not
    bool isDamaged;
    bool isGrounded;
    //setting up int for speed
    int speed;
    
    SKAction *jumpMovement;
    bool isJumping;
    SKAction *jumpAnimation;
    
    //checking how many times the man is hit    
    int hitCount;
}

@end
