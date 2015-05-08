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

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var toolbarBottom: NSLayoutConstraint!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var placeholderText: UILabel!
    @IBOutlet weak var textviewHeight: NSLayoutConstraint!
    
    @IBAction func sendButton(sender: AnyObject) {
        textView.endEditing(true)
        // clear the text
        textView.text = ""
        // and manually trigger the delegate method
        self.textViewDidChange(textView)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
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
    
    /// helper method.  shift the scrollview up or down by the dynamic height of the keyboard.
    func adjustInsetForKeyboardShow(show: Bool, notification: NSNotification) {
        // pad it for the sake of the custom toolbar
        let adjustmentHeight = getKeyboardHeight(notification) * (show ? 1 : 0)
        toolbarBottom.constant = adjustmentHeight
        // animate the constraint change.  this is how to do it.
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
        let keyboardFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        return CGRectGetHeight(keyboardFrame)
    }
    
}

// MARK: - UITableViewDataSource methods

extension ViewController : UITableViewDataSource {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("cell") as! UITableViewCell
        return cell
    }
    
}

// MARK: - UITextViewDelegate methods

extension ViewController : UITextViewDelegate {
    
    // increase the height of the textview as the
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
    
}