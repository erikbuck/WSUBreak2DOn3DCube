//
//  BreakScene.swift
//  SwiftBreak
//
//  Created by wsucatslabs on 10/15/21.
//

import SpriteKit
import GameplayKit

class BreakScene: SKScene, SKPhysicsContactDelegate {
   
   private var paddle = SKSpriteNode()
   private var ball = SKSpriteNode()
   private var ballStartPosition = CGPoint(x: 0, y: 0)
   private var isBallInPlay = true
   private var leftEdge = CGFloat(0)
   private var rightEdge = CGFloat(0)

   func setup() {
      let leftNode = childNode(withName: "LeftEdge")!
      leftEdge = leftNode.position.x
      let rightNode = childNode(withName: "RightEdge")!
      rightEdge = rightNode.position.x
      paddle = self.childNode(withName: "Paddle") as! SKSpriteNode
      ball = self.childNode(withName: "Ball") as! SKSpriteNode
      ballStartPosition = ball.position
      ball.physicsBody!.contactTestBitMask = ball.physicsBody!.collisionBitMask
      physicsWorld.contactDelegate = self
      
   }
   
   override func didMove(to view: SKView) {
      setup();
   }
   
   func touchMoved(toPoint pos : CGPoint) {
      var constrainedPosition = pos
      constrainedPosition.y = paddle.position.y
      paddle.position = constrainedPosition
   }
   
   override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
      for t in touches { self.touchMoved(toPoint: t.location(in: self)) }
   }
   
   func resteBall() {
      ball.position = ballStartPosition
      ball.physicsBody!.velocity = CGVector(dx: 0, dy: 0)
      isBallInPlay = true
   }
   
   func removeBrick(brick : SKNode) {
      DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) {
         brick.removeFromParent()
      }
   }
   
   override func update(_ currentTime: TimeInterval) {
      paddle.position = CGPoint(x: min(max(leftEdge, paddle.position.x), rightEdge),
                              y: paddle.position.y)
      
      if isBallInPlay {
         if ball.position.y < paddle.position.y {
            isBallInPlay = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
               self.resteBall()
            }
         } else {
            var constrainedVelocity = ball.physicsBody!.velocity
            if constrainedVelocity.dy > 1200 {
               constrainedVelocity.dy = 1200
            }
            ball.physicsBody!.velocity = constrainedVelocity
         }
      }
   }
   
   func didBegin(_ contact: SKPhysicsContact) {
      if contact.bodyA.node?.name == nil {
         removeBrick(brick: contact.bodyA.node!)
      } else if contact.bodyB.node?.name == nil {
         removeBrick(brick: contact.bodyB.node!)
      }
   }
}
