//
//  TextCell.swift
//  textViewSample
//
//  Created by Robert Chen on 5/8/15.
//  Copyright (c) 2015 Thorn Technologies. All rights reserved.
//

import UIKit

class TextCell : UITableViewCell {
    
    @IBOutlet weak var textView: UITextView!
    
    func setCellText(text:String){
        
        // turn string in to NSString
        let nsText:NSString = text
        
        // this needs to be an array of NSString.  String does not work.
        let words:[NSString] = nsText.componentsSeparatedByString(" ") as! [NSString]
        
        var attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(17.0)
        ]
        
        var attrString = NSMutableAttributedString(string: nsText as String, attributes:attrs)
        
        // tag each word if it has a hashtag
        for word in words {
            
            // found a word that is prepended by a hashtag!
            if word.hasPrefix("#") {
                
                // a range is the character position, followed by how many characters are in the word
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
                } else {
                    // set a link for when the user clicks on this word.
                    // it's not enough to use the word "hash", but you need the url scheme syntax "hash://"
                    // note:  since it's a URL now, the color set above is ignored.
                    attrString.addAttribute(NSLinkAttributeName, value: "hash:\(stringifiedWord)", range: matchRange)
                }
                
            }
        }
        
        textView.attributedText = attrString
    }
    
}
