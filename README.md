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

At this point, URLs in the textview will open in the Safari app.

### Add link attributes to the hashtags

Next, add an "href" attribute to each hashtagged word.  

The overall process goes something like this:
* Iterate over each word and look for anything that starts with `#`
* Grab the string, and chop off the `#` character.  For example, `#helloWorld` becomes `helloWorld`
* Create a fake URL using a fake URL scheme.  For example, `fakeScheme:helloWorld`
* Associate this fake URL with the hashtag word.  `NSMutableAttributedString` has methods to accomplish this.

Here's the [code](https://github.com/ribl/SwiftTextViewHashtag/blob/master/textViewSample/UITextField%2BExtension.swift#L13)

### Clicking on hashtags

Now that hashtags are URLs, they are a different color and can be clicked.  Note: there's no need to add a tap gesture to the TextView, because it's already listening for URL clicks.

Intercept the URL click and check for your fake URL scheme.  
* Set the TextView delegate.  
* Implement the `UITextFieldDelegate` which has a `shouldInteractWithURL` method 
* Check for your fake `URL.scheme` 
* Grab the payload in the `URL.resourceSpecifier`

## Other resources

* [STTweetLabel](https://github.com/SebastienThiebaud/STTweetLabel), an Objective-C CocoaPod for hashtag detection
* A [swift implementation](https://yeti.co/blog/hashtags-and-mentions/) of hashtags and mentions.  I wish this was available when I first implemented hashtags.  I won't be offended if you use it!  
* I used [this](http://kishikawakatsumi.hatenablog.com/entry/20130605/1370370925) to initially figure out my approach.  Just click "translate from japanese" on the top.
* I used [this](http://stackoverflow.com/questions/11547919/check-if-string-contains-a-hashtag-and-then-change-hashtag-color) to figure out how to use `NSMutableAttributedString`
* [Ray Wenderlich Scroll View](http://www.raywenderlich.com/video-tutorials#swiftscrollview) video series helped me understand keyboard movement.  It's tricky!  Video subscription is pay per month, but worth it.
