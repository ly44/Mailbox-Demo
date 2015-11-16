//
//  MailboxViewController.swift
//  Mailbox Demo
//
//  Created by Yang, Lin on 11/12/15.
//  Copyright © 2015 Yang, Lin. All rights reserved.
//

import UIKit

class MailboxViewController: UIViewController {
    
    @IBOutlet weak var mailboxView: UIView!
    
    //creatingn outlets for items in mailbox
    @IBOutlet weak var messageScrollView: UIScrollView!
    @IBOutlet weak var help_label: UIImageView!
    @IBOutlet weak var search: UIImageView!
    @IBOutlet weak var feedView: UIImageView!
    
    @IBOutlet weak var messageContainer: UIView!
    @IBOutlet weak var messageView: UIImageView!
    @IBOutlet weak var deleteIcon: UIImageView!
    @IBOutlet weak var archiveIcon: UIImageView!
    @IBOutlet weak var listIcon: UIImageView!
    @IBOutlet weak var laterIcon: UIImageView!
    
    @IBOutlet weak var rescheduleView: UIImageView!
    @IBOutlet weak var listView: UIImageView!
    
    
    var messageOriginalCenter: CGPoint!
    var rightIconOriginalCenter: CGPoint!
    var leftIconOriginalCenter: CGPoint!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Setting scrollview height
        messageScrollView.contentSize.height = help_label.frame.height + search.frame.height; +messageView.frame.height + feedView.frame.height
        
        // Create panGestureRecognizer
        let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: "onMessageSwipe:")
        messageView.addGestureRecognizer(panGestureRecognizer)
        
        // Create edgeGestureRecognizer
        let edgeGesture = UIScreenEdgePanGestureRecognizer(target: self, action: "onEdgePan:")
        edgeGesture.edges = UIRectEdge.Left
        mailboxView.addGestureRecognizer(edgeGesture)
        
        // Set icon visibilities
        laterIcon.alpha = 0.5
        listIcon.alpha = 0
        archiveIcon.alpha = 0.5
        deleteIcon.alpha = 0
        
        // Set screen visibilities
        rescheduleView.alpha = 0
        listView.alpha = 0
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func onMessageSwipe(sender: UIPanGestureRecognizer) {
        
        // Track panning
        let translation = sender.translationInView(view)
        
        if sender.state == UIGestureRecognizerState.Began {
            // Set background gray and record starting point of messageView
            messageContainer.backgroundColor = UIColor.grayColor()
            messageOriginalCenter = messageView.center
            rightIconOriginalCenter = laterIcon.center
            leftIconOriginalCenter = archiveIcon.center
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            // Move messageView with panning
            messageView.center = CGPoint(x: messageOriginalCenter.x + translation.x, y: messageOriginalCenter.y)
            
            
            if translation.x < -60 && translation.x > -200 {
            // If panning left more than 60pixels but less than 260pixels, laterIcon begins to follow panning, background turns yellow
                messageContainer.backgroundColor = UIColor.yellowColor()
                laterIcon.alpha = 1
                laterIcon.center.x = messageView.center.x + 175
            
            } else if translation.x < -200 {
            // If panning left more than 260pixels, listIcon begins to follow panning, background turns brown
                messageContainer.backgroundColor = UIColor.brownColor()
                laterIcon.alpha = 0
                listIcon.alpha = 1
                listIcon.center.x = messageView.center.x + 175
            
            } else if translation.x > 60 && translation.x < 200 {
            // If panning right more than 60 pixels but less than 260 pixels, archiveIcon begins to follow panning, background turns green
                messageContainer.backgroundColor = UIColor.greenColor()
                archiveIcon.alpha = 1
                archiveIcon.center.x = messageView.center.x - 175
            
            } else if translation.x > 200 {
                // If panning right more than 260 pixels, deleteIcon begins to follow panning, background turns red
                messageContainer.backgroundColor = UIColor.redColor()
                archiveIcon.alpha = 0
                deleteIcon.alpha = 1
                deleteIcon.center.x = messageView.center.x - 175
            }
            
            
        } else if sender.state == UIGestureRecognizerState.Ended {
            
            // resetting icons
            archiveIcon.center = leftIconOriginalCenter
            deleteIcon.center = leftIconOriginalCenter
            laterIcon.center = rightIconOriginalCenter
            listIcon.center = rightIconOriginalCenter
            
            laterIcon.alpha = 0.5
            listIcon.alpha = 0
            archiveIcon.alpha = 0.5
            deleteIcon.alpha = 0
            
            
            // setting slide animation of message based on pan
            if translation.x > 60 {
            // if panned more than 60 pixels right, slide message offscreen
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = self.view.frame.width
                })
                
            } else if translation.x < -60 {
            // if panned more than 60 pixels left, slide message offsecreen
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x -= self.view.frame.width
                })
            } else if translation.x < 60 && messageView.frame.origin.x > -60 {
            // otherwise reset
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.messageView.frame.origin.x = 0
                    self.messageContainer.backgroundColor = UIColor.grayColor()
                })
            }
            
            // Setting whether and which direction message pans off screen
            if messageContainer.backgroundColor == UIColor.greenColor() || messageContainer.backgroundColor == UIColor.redColor() {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.feedView.center.y -= 90
                })
    
            } else if messageContainer.backgroundColor == UIColor.yellowColor() {
                UIView.animateWithDuration(0.2, animations: { () -> Void in
                    self.rescheduleView.alpha = 1
                    self.laterIcon.alpha = 0
                })
            } else if messageContainer.backgroundColor == UIColor.brownColor() {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.listView.alpha = 1
                    self.listIcon.alpha = 0
                })
            }
        }
    }
    
    @IBAction func didTapList(sender: AnyObject) {
        listView.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.feedView.center.y -= 90
        })
    }
    
    
    @IBAction func didTapReschedule(sender: AnyObject) {
        rescheduleView.hidden = true
        UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.feedView.center.y -= 90
        })
    }
    

    func onEdgePan(sender: UIScreenEdgePanGestureRecognizer) {
        let contentTranslation = sender.translationInView(view)
        print(contentTranslation)
        
        mailboxView.center.x += contentTranslation.x
        
        if sender.state == UIGestureRecognizerState.Ended {
            if contentTranslation.x > 200 {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mailboxView.center.x += 280
                })
                
            } else {
                UIView.animateWithDuration(0.3, animations: { () -> Void in
                    self.mailboxView.center.x = 160
                })
            }
        }
    }
}
