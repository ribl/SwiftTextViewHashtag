//
//  ViewController.swift
//  textViewSample
//
//  Created by Robert Chen on 5/8/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var lastTextViewHeight:CGFloat = 0.0
    
    var messages:[String] = ["regular text, nothing to see here", "#ribl <- click on it to see an alert", "@mention not implemented yet", "regular urls are clickable http://ribl.co", "add your own text below"]

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var textviewHeight: NSLayoutConstraint!
    
    @IBAction func sendButton(sender: AnyObject) {
        textView.endEditing(true)
        messages.append(textView.text)
        // clear the text
        textView.text = ""
        // and manually trigger the delegate method
        self.textViewDidChange(textView)
        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // listen for the keyboard going up and down
        keyboardHeightRegisterNotifications()
    }
    
}

// MARK: - Keyboard helper methods

// all this just to move the keyboard up and down.
extension ViewController {
    
    /// register keyboard notifications to shift the scrollview content insets
    func keyboardHeightRegisterNotifications() {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    /// just pass true or false if you're shifting the keyboard up or down
    func keyboardWillShow(notification: NSNotification) {
        adjustInsetForKeyboardShow(true, notification: notification)
    }
    
    func keyboardWillHide(notification: NSNotification) {
        adjustInsetForKeyboardShow(false, notification: notification)
    }
    
    /// consolidate the keyboard movement logic into one method, and just pass a boolean for up or down.
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        // some implementations out there use -1 and 1 to move it up or down. 
        // debugging is a little easier if you use -1 and 0 instead.
        toolbarBottom.constant = getKeyboardHeight(notification) * (show ? 1 : 0)
        // normally, the constraint change is updated immediately.
        // by simply added UIView.animateWithDuration along with a layoutIfNeeded(),
        // the constraint change will happen in the animation.
        // the animation settings below sort of match the keyboard animation
        UIView.animateWithDuration(0.5,
            delay: 0.0,
            options: .CurveEaseInOut,
            animations: {
                // animate the constraint change
                self.view.layoutIfNeeded()
            },
            completion: nil
        )
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat{
        // == userInfo || {}
        let userInfo = notification.userInfo ?? [:]
        // CGRect wrapped in a NSValue
        // Make sure you use UIKeyboardFrameEndUserInfoKey, NOT UIKeyboardFrameBeginUserInfoKey
        // "End" is good.  "Begin" is bad.  
        // To test, switch keyboards and make sure the heights are correct.
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return CGRectGetHeight(keyboardFrame)
    }
    
}

// MARK: - UITableViewDataSource methods

extension ViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! TextCell
        cell.setCellText(messages[indexPath.row])
        return cell
    }
    
}

// MARK: - UITableViewDelegate methods

extension ViewController : UITableViewDelegate {
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        // set the height of the row based on the text height.  
        // TODO: there's probably a better way to do this.
        
        // type cast to NSString to get additional methods
        let myString: NSString = messages[indexPath.row] as NSString
        // label height depends on font
        let attributes = [NSFontAttributeName: UIFont.systemFontOfSize(18.0)]
        let stringWidth:CGFloat = UIScreen.mainScreen().bounds.width - 20
        // hard-coding a really big number that exceeds the screen height
        let infiniteHeight:CGFloat = 1600
        let temporarySize = CGSizeMake(stringWidth, infiniteHeight)
        let rect:CGRect = myString.boundingRectWithSize(temporarySize, options: .UsesLineFragmentOrigin, attributes: attributes, context: nil)
        return rect.height + 30
    }
    
}

// MARK: - UITextViewDelegate methods

extension ViewController : UITextViewDelegate {
    
    // increase the height of the textview as the user types
    func textViewDidChange(textView: UITextView){
        // hide placeholder text
        placeholderText.hidden = !textView.text.isEmpty
        // create a hypothetical tall box that contains the text.
        // then shrink down the height based on the content.
        let newSize:CGSize = textView.sizeThatFits(CGSize(width: textView.frame.size.width, height: 1600.0))
        // remember that new height
        let newHeight = newSize.height
        // change the height constraint only if it's different.
        // otherwise, it get set on every single character the user types.
        if lastTextViewHeight != newHeight {
            lastTextViewHeight = newHeight
            // the 7.0 is to account for the top of the text getting scrolled up slightly
            // to account for a potential new line
            textviewHeight.constant = newSize.height + 7.0
        }
    }
 
    func textView(textView: UITextView, shouldInteractWithURL URL: NSURL, inRange characterRange: NSRange) -> Bool {
        
        // check for our fake URL scheme hash:helloWorld
        if URL.scheme == "hash" {
            let alertView = UIAlertView()
            alertView.title = "hash tag detected"
            // get a handle on the payload
            alertView.message = "\(URL.resourceSpecifier!)"
            alertView.addButtonWithTitle("Ok")
            alertView.show()
        }
        
        return true
    }
    
}