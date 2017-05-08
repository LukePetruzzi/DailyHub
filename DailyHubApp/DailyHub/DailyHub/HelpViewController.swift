//
//  HelpViewController.swift
//  DailyHub
//
//  Created by Joe Salter on 5/8/17.
//  Copyright © 2017 Luke Petruzzi. All rights reserved.
//

import UIKit
import Foundation

class HelpViewController: UIViewController, UIGestureRecognizerDelegate {
    
    var helpView = UIVisualEffectView()
    
    private var animator: UIDynamicAnimator!
    private var attachmentBehavior: UIAttachmentBehavior!
    private var pushBehavior: UIPushBehavior!
    private var itemBehavior: UIDynamicItemBehavior!
    
    private var originalBounds = CGRect.zero
    private var originalCenter = CGPoint.zero
    
    let ThrowingThreshold: CGFloat = 1000
    let ThrowingVelocityPadding: CGFloat = 35
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor.clear
        
        let blurEffect = UIBlurEffect(style: .dark)
        helpView.effect = blurEffect
        helpView.layer.cornerRadius = 15
        helpView.clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        helpView.addGestureRecognizer(panGesture)
        
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = helpView.bounds
        originalCenter = helpView.center
        
        self.view.addSubview(helpView)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        
        helpView.frame = CGRect(x: 25, y: 25, width: self.view.frame.size.width - 50, height: self.view.frame.size.height - 50)
    }
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.helpView)
        
        switch sender.state {
        case .began:
            print("Your touch start position is \(location)")
            print("Start location in image is \(boxLocation)")
            
            animator.removeAllBehaviors()
            
            let centerOffset = UIOffset(horizontal: boxLocation.x - helpView.bounds.midX, vertical: boxLocation.y - helpView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: helpView, offsetFromCenter: centerOffset, attachedToAnchor: location)
        
            animator.addBehavior(attachmentBehavior)
            
            
        case .ended:
            print("Your touch end position is \(location)")
            print("End location in image is \(boxLocation)")
            
            animator.removeAllBehaviors()
            
            // 1
            let velocity = sender.velocity(in: self.view)
            let magnitude = sqrt((velocity.x * velocity.x) + (velocity.y * velocity.y))
            
            if magnitude > ThrowingThreshold {
                let pushBehavior = UIPushBehavior(items: [helpView], mode: .instantaneous)
                pushBehavior.pushDirection = CGVector(dx: velocity.x / 10, dy: velocity.y / 10)
                pushBehavior.magnitude = magnitude / ThrowingVelocityPadding
                
                self.pushBehavior = pushBehavior
                animator.addBehavior(pushBehavior)
                
                let angle = Int(arc4random_uniform(20)) - 10
                
                itemBehavior = UIDynamicItemBehavior(items: [helpView])
                itemBehavior.friction = 0.2
                itemBehavior.allowsRotation = true
                itemBehavior.addAngularVelocity(CGFloat(angle), for: helpView)
                animator.addBehavior(itemBehavior)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.throwViewAway()
                }

            } else {
                resetView()
            }
            
        default:
             attachmentBehavior.anchorPoint = sender.location(in: view)
        }
    }
    
    func throwViewAway() {
        self.dismiss(animated: false, completion: nil)
    }
    
    func resetView() {
        animator.removeAllBehaviors()
        
        UIView.animate(withDuration: 0.3) {
            self.helpView.bounds = self.originalBounds
            self.helpView.center = self.originalCenter
            self.helpView.transform = CGAffineTransform.identity
        }
    }
}
