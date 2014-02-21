//
//  SnakeScene.m
//  PhysicsCreature
//
//  Created by Nicholas Wong on 2/19/14.
//  Copyright (c) 2014 Nicholas Workshop. All rights reserved.
//

#import "SnakeScene.h"
#import "HumanScene.h"

@interface SnakeScene ()
@property SKShapeNode *head;
@property SKSpriteNode *button;
@end

@implementation SnakeScene

- (void)spawnSnake
{
    SKShapeNode *lastNode = NULL;
    float lastRadius = 1;
    float interval = 1;

    for (int i = 0; i < 15; i++) {

        // update head path
        float radius = lastRadius + 1;
        SKShapeNode *node = [[SKShapeNode alloc] init];
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathAddArc(path, NULL, 0, 0, radius, 0, (float) M_PI * 2, YES);
        [node setPath:path];
        [node setFillColor:[UIColor blueColor]];
        [node setLineWidth:0];

        // calculate the node position
        float y = self.size.height / 4;
        if (lastNode) y = lastNode.position.y + lastRadius + radius + interval;
        [node setPosition:CGPointMake(self.size.width / 4*3, y)];

        // set up physics body
        [node setPhysicsBody:[SKPhysicsBody bodyWithCircleOfRadius:radius]];
        [node.physicsBody setRestitution:.5];
        [self addChild:node];

        // add joints
        if (lastNode) {
            SKPhysicsJointLimit *joint = [SKPhysicsJointLimit
                    jointWithBodyA:lastNode.physicsBody
                             bodyB:node.physicsBody
                           anchorA:lastNode.position
                           anchorB:node.position];
            [self.physicsWorld addJoint:joint];
        }

        // update nodes
        lastNode = node;
        lastRadius = radius;
    }

    // set head node
    _head = lastNode;
}

- (void)spawnShelf
{
    SKSpriteNode *shelf = [SKSpriteNode spriteNodeWithColor:[SKColor lightGrayColor] size:CGSizeMake(100, 40)];
    shelf.position = CGPointMake(self.size.width / 2.5, self.size.height / 2);
    shelf.physicsBody = [SKPhysicsBody bodyWithRectangleOfSize:shelf.size];
    [shelf.physicsBody setDynamic:NO];
    [self addChild:shelf];
}

- (void)spawnButtonWithText:(NSString *)text position:(CGPoint)position
{
    _button = [[SKSpriteNode alloc] initWithColor:[UIColor whiteColor] size:CGSizeMake(140, 40)];
    [_button setPosition:CGPointMake(position.x, position.y + 8)];
    [self addChild:_button];

    SKLabelNode *label = [SKLabelNode labelNodeWithFontNamed:@"HelveticaNeue-Light"];
    [label setText:text];
    [label setFontSize:16];
    [label setFontColor:[UIColor blackColor]];
    [label setPosition:position];
    [self addChild:label];
}

- (id)initWithSize:(CGSize)size
{
    if (self = [super initWithSize:size]) {
        self.scaleMode = SKSceneScaleModeAspectFit;
        [self setPhysicsBody:[SKPhysicsBody bodyWithEdgeLoopFromRect:self.frame]];
        [self.physicsBody setRestitution:.5];
        [self spawnSnake];
        [self spawnShelf];
        [self spawnButtonWithText:@"Switch To Human" position:CGPointMake(self.size.width - 80, self.size.height - 60)];
    }
    return self;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_head.physicsBody.dynamic) {
        [_head.physicsBody setDynamic:NO];
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_head setPosition:location];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        [_head setPosition:location];
    }
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_head.physicsBody.dynamic) {
        [_head.physicsBody setDynamic:YES];
    }
    for (UITouch *touch in touches) {
        CGPoint location = [touch locationInNode:self];
        if (CGRectContainsPoint(_button.frame, location)) {
            SKScene *scene = [HumanScene sceneWithSize:self.view.bounds.size];
            scene.scaleMode = SKSceneScaleModeAspectFill;
            [self.view presentScene:scene];
        }
    }
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (!_head.physicsBody.dynamic) {
        [_head.physicsBody setDynamic:YES];
    }
}

- (void)update:(CFTimeInterval)currentTime
{
    /* Called before each frame is rendered */
}

@end
