//
//  UITextField+Extension.swift
//  textViewSample
//
//  Created by Robert Chen on 5/22/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

extension UITextView {
    
    func resolveHashTags(){
        
        // turn string in to NSString
        let nsText:NSString = self.text
        
        // this needs to be an array of NSString.  String does not work.
        let words:[NSString] = nsText.componentsSeparatedByString(" ") as! [NSString]
        
        // you can't set the font size in the storyboard anymore, since it gets overridden here.
        var attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(17.0)
        ]
        
        // you can staple URLs onto attributed strings
        var attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        
        // tag each word if it has a hashtag
        for word in words {
            
            // found a word that is prepended by a hashtag!
            // homework for you: implement @mentions here too.
            if word.hasPrefix("#") {
                
                // a range is the character position, followed by how many characters are in the word.
                // we need this because we staple the "href" to this range.
                let matchRange:NSRange = nsText.rangeOfString(word as String)
                
                // convert the word from NSString to String
                // this allows us to call "dropFirst" to remove the hashtag
                var stringifiedWord:String = word as String
                
                // drop the hashtag
                stringifiedWord = dropFirst(stringifiedWord)
                
                // check to see if the hashtag has numbers.
                // ribl is "#1" shouldn't be considered a hashtag.
                let digits = NSCharacterSet.decimalDigitCharacterSet()
                
                if let numbersExist = stringifiedWord.rangeOfCharacterFromSet(digits) {
                    // hashtag contains a number, like "#1"
                    // so don't make it clickable
                } else {
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color is set to the project's tint color
                    attrString.addAttribute(NSLinkAttributeName, value: "hash:\(stringifiedWord)", range: matchRange)
                }
                
            }
        }
        
        // we're used to textView.text
        // but here we use textView.attributedText
        // again, this will also wipe out any fonts and colors from the storyboard,
        // so remember to re-add them in the attrs dictionary above
        self.attributedText = attrString
    }
    
}
