//
//  APSuggestedWordsViewController.swift
//  MyQuickType
//
//  Created by Amita Pai on 3/18/16.
//  Copyright © 2016 Amita Pai. All rights reserved.
//

import UIKit

protocol APSuggestedWordsDelegate {
    func suggestedWordsView(suggestedView: UIInputView, didSelect word: String)
}

class APSuggestedWordsViewController: UIViewController {
    
    let reuseIdentifier = "reuseIdentifier-suggestions"

    @IBOutlet weak var collectionView: UICollectionView!
    
    var suggestedWordsDelegate: APSuggestedWordsDelegate?
    var words: [String]? {
        didSet {
            self.collectionView?.reloadData()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.collectionView.reloadData()
        
        print(self.view)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

extension APSuggestedWordsViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.words?.count ?? 0
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(self.reuseIdentifier, forIndexPath: indexPath)
        
        if let word = self.words?[indexPath.row] {
            (cell.contentView.subviews.first as! UILabel).text = word
        }
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if let word = self.words?[indexPath.row] {
            self.suggestedWordsDelegate?.suggestedWordsView((self.view as! UIInputView), didSelect: word)
        }
    }
}
