# SwiftTextViewHashtag
Hash tag detection for TextViews in Swift

## Overview

This is a quick and dirty sample project implementing Hashtag detection

## Hashtag detection

The approach used here is to add an attribute to hashtag words, much like an "href".  

### URL detection

Before doing anything, we need to detect URLs.  
* In the storyboard, make sure the TextView can detect *Links*
* For the above to work, de-select *Editable*

At this point, URLs in the textview will open the link in the Safari app.

### Add link attributes to the hashtags

Next, add an "href" attribute to each hashtagged word.  

The overall process goes something like this:
* Iterate over each word and look for anything that starts with `#`
* Grab the string, and chop off the `#` character.  For example, `#helloWorld` becomes `helloWorld`
* Create a fake URL using a fake URL scheme.  For example, `fakeScheme:helloWorld`
* Associate this fake URL with the hashtag word.  `NSMutableAttributedString` has methods to accomplish this.

Here's the code:

```
    @IBOutlet weak var textView: UITextView!
    
    func setCellText(text:String){
        
        // turn string in to NSString
        let nsText:NSString = text
        
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
        textView.attributedText = attrString
    }
```

### Clicking on hashtags

Now that hashtags are URLs, they are a different color and can be clicked.  Note: there's no need to add a tap gesture to the TextView, because it's already listening for URL clicks.

Intercept the URL click and check for your fake URL scheme.  
* Set the TextView delegate.  
* Implement the `UITextFieldDelegate` which has a `shouldInteractWithURL` method 
* Check for your fake `URL.scheme` 
* Grab the payload in the `URL.resourceSpecifier`

## Other resources

* A much more mature [Objective-C library](https://github.com/SebastienThiebaud/STTweetLabel) for hashtag detection
* A [swift implementation](https://yeti.co/blog/hashtags-and-mentions/) of hashtags and mentions.  I wish this was available when I first implemented hashtags.  I won't be offended if you use it!  
* I used [this](http://kishikawakatsumi.hatenablog.com/entry/20130605/1370370925) to initially figure out my approach.  Just click "translate from japanese" on the top.
* I used [this](http://stackoverflow.com/questions/11547919/check-if-string-contains-a-hashtag-and-then-change-hashtag-color) to figure out how to use `NSMutableAttributedString`
* [Ray Wenderlich Scroll View](http://www.raywenderlich.com/video-tutorials#swiftscrollview) video series helped me understand keyboard movement.  It's tricky!  Video subscription is pay per month, but worth it.
