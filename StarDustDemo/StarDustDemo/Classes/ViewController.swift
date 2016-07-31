//
//  ViewController.swift
//  StarDustDemo
//
//  Created by Jigar on 31/07/16.
//  Copyright © 2016 Jigar Oza. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UICollisionBehaviorDelegate
{
    @IBOutlet weak var lblWelcome:UILabel!
    @IBOutlet weak var consWelcomeTop: NSLayoutConstraint!
    
    var animator: UIDynamicAnimator!
    var gravityBehavior: UIGravityBehavior!
    var collisionBehavior: UICollisionBehavior!
    
    var timer: NSTimer!
    var starCount = 0
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        lblWelcome.alpha = 0.0
        consWelcomeTop.constant = 0
    }
    
    override func viewDidAppear(animated: Bool)
    {
        UIView.animateWithDuration(0.3, delay: 2.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            self.lblWelcome.alpha = 1.0
            self.consWelcomeTop.constant = 150
            self.view.layoutIfNeeded()
            }) { (complete) -> Void in
                self.startAnimation()
        }
    }
    
    func startAnimation()
    {
        self.animator = UIDynamicAnimator(referenceView: self.view)
        self.gravityBehavior = UIGravityBehavior()
        self.collisionBehavior = UICollisionBehavior()
        self.collisionBehavior.collisionDelegate = self
        self.collisionBehavior.translatesReferenceBoundsIntoBoundary = true
        self.animator.addBehavior(self.collisionBehavior)
        self.animator.addBehavior(self.gravityBehavior)
        
        self.timer = NSTimer.scheduledTimerWithTimeInterval(0.1, target: self, selector: "creteStarsEffect", userInfo: nil, repeats: true)
    }
    
    func creteStarsEffect()
    {
        starCount++
        let starSize = CGFloat(arc4random_uniform(16) + 12) as CGFloat
        
        let starView = UIImageView()
        starView.tag = starCount
        
        starView.frame = CGRectMake(CGFloat(arc4random_uniform(320)), 0.0, starSize, starSize)
        starView.image = UIImage(named: "star1")
        self.view.addSubview(starView)
        
        self.gravityBehavior.addItem(starView)
        self.collisionBehavior.addItem(starView)
        self.animator.addBehavior(self.collisionBehavior)
        
        print("\(starCount)")
    }
    
    func collisionBehavior(behavior: UICollisionBehavior, endedContactForItem item: UIDynamicItem, withBoundaryIdentifier identifier: NSCopying?)
    {
        if starCount > 200
        {
            for view in self.view.subviews
            {
                if view.isKindOfClass(UIImageView)
                {
                    view.removeFromSuperview()
                }
            }
            
            starCount = 0
            timer.invalidate()
            self.startAnimation()
        }
    }
}

