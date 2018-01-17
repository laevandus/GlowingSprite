//: A SpriteKit based Playground

import PlaygroundSupport
import SpriteKit

extension SKSpriteNode {
    /// Initializes a textured sprite with a glow using an existing texture object.
    convenience init(texture: SKTexture, glowRadius: CGFloat) {
        self.init(texture: texture, color: .clear, size: texture.size())
        
        let glow: SKEffectNode = {
            let glow = SKEffectNode()
            glow.addChild(SKSpriteNode(texture: texture))
            glow.filter = CIFilter(name: "CIGaussianBlur", withInputParameters: ["inputRadius": glowRadius])
            glow.shouldRasterize = true
            return glow
        }()
        
        let glowRoot: SKNode = {
            let node = SKNode()
            node.name = "Glow"
            node.zPosition = -1
            return node
        }()
        
        glowRoot.addChild(glow)
        addChild(glowRoot)
    }
}


final class GameScene: SKScene {
    
    override func didMove(to view: SKView) {
        let texture = SKTexture(imageNamed: "logo")
        let logo = SKSpriteNode(texture: texture, glowRadius: 30)
        addChild(logo)
        
        guard let glow = logo.childNode(withName: "Glow") else { return }
        let scale = SKAction.repeatForever(.sequence([.scale(to: 1.03, duration: 3.0),
                                                      .scale(to: 0.98, duration: 3.0)]))
        scale.timingMode = .easeInEaseOut
        glow.run(scale)
    }
}

let sceneView = SKView(frame: CGRect(x:0 , y:0, width: 640, height: 480))
guard let scene = GameScene(fileNamed: "GameScene") else { fatalError() }
scene.scaleMode = .aspectFill
sceneView.presentScene(scene)
PlaygroundSupport.PlaygroundPage.current.liveView = sceneView
