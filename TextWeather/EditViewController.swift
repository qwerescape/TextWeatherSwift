//
//  EditViewController.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-07-23.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import Foundation
import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var weatherTextCarousel: UIScrollView
    @IBOutlet var pageDots: UIPageControl
    override func viewWillAppear(animated: Bool) {
        self.navigationController.setNavigationBarHidden(false, animated: true)
//        self.navigationController.navigationItem.backBarButtonItem.title = "DONE"
        super.viewWillAppear(animated)
    }
    override func viewWillLayoutSubviews() {
        let carouselRect = weatherTextCarousel.frame
        let alternativeTextFrame: CGRect = CGRect(origin: CGPoint(x: 10, y: 10), size: CGSize(width: carouselRect.size.width-20, height: carouselRect.size.height-20))
        //find the subview
        if let textView = weatherTextCarousel.subviews[0] as? UITextView {
            textView.frame = alternativeTextFrame
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        //add some text views
        let alternativeText: UITextView = UITextView()
        alternativeText.editable = false
        alternativeText.text = "very long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first timevery long ass mother fucking shit stuff that will for sure scroll you son of a bitch, piece of shit i know you won't work the first time"
        weatherTextCarousel.addSubview(alternativeText)
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!){
        
    }
}