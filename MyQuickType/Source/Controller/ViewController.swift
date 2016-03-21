//
//  ViewController.swift
//  MyQuickType
//
//  Created by Amita Pai on 3/18/16.
//  Copyright © 2016 Amita Pai. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var textField: UITextField!
    
    let wordsSample = ["I Solemnly Swear", "That I Am", "up to No Good"]

    let samples = [
        "Harry Potter": ["I Solemnly Swear", "That I Am", "up to No Good"],
        "Jane Austen": ["In vain", "have I", "struggled", "It will not do", "My feelings", "will not be", "repressed","You must allow me", "to tell you", "how ardently I admire", "and love you."],
        "": []
    ]
    
    lazy var suggestionViewController: APSuggestedWordsViewController = {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SuggestedWordsViewController") as! APSuggestedWordsViewController
        vc.suggestedWordsDelegate = self
        return vc
    } ()
    
    lazy var suggestionView: UIInputView = {
        let  sView = self.suggestionViewController.view as! UIInputView
        sView.frame = CGRectMake(0.0, 0.0, UIScreen.mainScreen().bounds.width, 36.0)
        return sView
    } ()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let alert = UIAlertController(title: "Alert!!", message: "Try the text field below. Type in Harry Potter or Jane Austen.", preferredStyle: .Alert)
        alert.addTextFieldWithConfigurationHandler { (textField) -> Void in
            textField.placeholder = NSLocalizedString("Type here...", comment: "")
            textField.delegate = self
            self.textField = textField
        }
        alert.addAction(UIAlertAction(title: "Dismiss", style: .Destructive, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else {
            return
        }
        switch identifier {
        case "embedSuggestedView":
            let destinationVC = segue.destinationViewController as! APSuggestedWordsViewController
            destinationVC.words = self.wordsSample
        default: break
        }
    }
}

extension ViewController: UITextFieldDelegate, APSuggestedWordsDelegate {
    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == self.textField {
            if textField.text?.characters.count == 0 {
                self.addSuggestionView(textField)
            }
        }
        return true
    }
    
    func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
        if textField == self.textField {
            if var text = textField.text?.lastWord() {
                text += string
                if text.characters.count > 0 {
                    let keys = Array(samples.keys).filter{ (key) -> Bool in
                        return key.lowercaseString.containsString(text.lowercaseString)
                    }
                    self.suggestionViewController.words = {
                        var values = [String]()
                        for key in keys {
                            if let value = self.samples[key] {
                                values.appendContentsOf(value)
                            }
                        }
                        return values
                    } ()
                }
            }
            if self.suggestionViewController.words?.count == 0 {
                self.removeSuggestionView()
            } else {
                self.addSuggestionView(textField)
            }
        }
        return true
    }
    
    private func addSuggestionView(textField: UITextField) {
        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self.textField, selector: #selector(UIResponder.resignFirstResponder), userInfo: nil, repeats: false)
        
        textField.inputAccessoryView = self.suggestionView
        textField.autocorrectionType = .No
        textField.reloadInputViews()
        
        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self.textField, selector: #selector(UIResponder.becomeFirstResponder), userInfo: nil, repeats: false)

    }
    
    private func removeSuggestionView() {
        self.textField.inputAccessoryView = nil
        self.textField.inputAccessoryView = nil
        self.textField.autocorrectionType = .Yes
        self.textField.reloadInputViews()
        
        self.suggestionViewController.words?.removeAll()
        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self.textField, selector: "resignFirstResponder", userInfo: nil, repeats: false)
        NSTimer.scheduledTimerWithTimeInterval(0.0, target: self.textField, selector: "becomeFirstResponder", userInfo: nil, repeats: false)
    }
    
    func suggestedWordsView(suggestedView: UIInputView, didSelect word: String) {
        if self.suggestionView == suggestedView {
            if var text = self.textField.text {
                if let range = text.rangeOfString(" ", options: .BackwardsSearch, range: nil, locale: nil) {
                    if text.startIndex.distanceTo(range.startIndex) == text.characters.count {
                        self.textField.text = text + word + " "
                    } else {
                        let rangeOfLastWord = range.startIndex.advancedBy(1)..<text.endIndex
                        text.replaceRange(rangeOfLastWord, with: word + " ")
                        self.textField.text = text
                    }
                } else {
                    self.textField.text = word + " "
                }
            
            }
            self.removeSuggestionView()
        }
    }
}


