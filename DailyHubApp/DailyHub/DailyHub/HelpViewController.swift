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
    
    let helpString = "Here you'll find all your favorite online communities in one place. You are currently on your home feed. Tap the \"preferences\" icon in the top right corner to customize the content you will see here. The order you place the sites on the preferences page will be reflected on the feed. Tap the number next to a site's logo to select how many posts you'd like to see from that site. \n\n Checkout the discover page by tapping the \"discover\" icon on the bottom tab bar. Here, we recommend some online communities that we think you should check out."
    
    var helpView = UIVisualEffectView()
    
    var logoImageView = UIImageView()
    
    var titleLabel = UILabel()
    var contentLabel = UILabel()
    var startExploringLabel = UIButton()
    
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
        helpView.frame = CGRect(x: 25, y: 25, width: self.view.frame.size.width - 50, height: self.view.frame.size.height - 50)
        helpView.effect = blurEffect
        helpView.layer.cornerRadius = 15
        helpView.clipsToBounds = true
        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture))
        panGesture.delegate = self
        helpView.addGestureRecognizer(panGesture)
        
        animator = UIDynamicAnimator(referenceView: view)
        originalBounds = helpView.bounds
        originalCenter = helpView.center
        
        logoImageView.frame = CGRect(x: 0, y: 5, width: self.helpView.frame.size.width, height: 200)
        logoImageView.contentMode = .scaleAspectFit
        logoImageView.image = UIImage(named: "logoWhite")
        
        titleLabel.frame = CGRect(x: 10, y: 190, width: self.helpView.frame.size.width - 20, height: 50)
        titleLabel.text = "Welcome to DailyHub!"
        titleLabel.font = UIFont(name: "Avenir-Black", size: 18)
        titleLabel.textColor = UIColor.white
        titleLabel.textAlignment = .center
        
        contentLabel.frame = CGRect(x: 10, y: 220, width: self.helpView.frame.size.width - 20, height: self.helpView.frame.size.height - 300)
        contentLabel.font = UIFont(name: "Avenir", size: 14)
        contentLabel.textColor = UIColor.white
        contentLabel.textAlignment = .justified
        contentLabel.lineBreakMode = .byWordWrapping
        contentLabel.numberOfLines = 0
        contentLabel.text = helpString
        
        startExploringLabel.frame = CGRect(x: 45, y: self.helpView.frame.size.height - 70, width: self.helpView.frame.size.width - 90, height: 50)
        startExploringLabel.titleLabel?.font = UIFont(name: "Avenir-Black", size: 16)
        startExploringLabel.setTitleColor(UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0), for: .normal)
        startExploringLabel.setTitleColor(UIColor.darkGray, for: .highlighted)
        startExploringLabel.titleLabel?.textAlignment = .center
        startExploringLabel.setTitle("Start Exploring!", for: .normal)
        startExploringLabel.addTarget(self, action: #selector(startExploringTapped), for: .touchUpInside)
        startExploringLabel.layer.cornerRadius = 35/2
        startExploringLabel.layer.borderColor = UIColor(red:1.00, green:0.32, blue:0.32, alpha:1.0).cgColor
        startExploringLabel.layer.borderWidth = 1
        startExploringLabel.tintColor = UIColor.gray

        helpView.addSubview(logoImageView)
        helpView.addSubview(titleLabel)
        helpView.addSubview(contentLabel)
        helpView.addSubview(startExploringLabel)
        
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
        
    }
    
    func startExploringTapped() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func handlePanGesture(sender: UIPanGestureRecognizer) {
        
        let location = sender.location(in: self.view)
        let boxLocation = sender.location(in: self.helpView)
        
        switch sender.state {
        case .began:

            animator.removeAllBehaviors()
            
            let centerOffset = UIOffset(horizontal: boxLocation.x - helpView.bounds.midX, vertical: boxLocation.y - helpView.bounds.midY)
            attachmentBehavior = UIAttachmentBehavior(item: helpView, offsetFromCenter: centerOffset, attachedToAnchor: location)
        
            animator.addBehavior(attachmentBehavior)
            
            
        case .ended:
            
            animator.removeAllBehaviors()
            
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
                itemBehavior.friction = 0.5
                itemBehavior.allowsRotation = false
                itemBehavior.addAngularVelocity(CGFloat(angle), for: helpView)
                animator.addBehavior(itemBehavior)
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                    self.dismiss(animated: false, completion: nil)
                }

            } else {
                resetView()
            }
            
        default:
             attachmentBehavior.anchorPoint = sender.location(in: view)
        }
    }
    
    func throwViewAway() {
        
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
