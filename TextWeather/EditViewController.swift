//
//  EditViewController.swift
//  TextWeather
//
//  Created by Chao Qu on 2014-07-23.
//  Copyright (c) 2014 Chao Qu. All rights reserved.
//

import Cartography
import Foundation
import UIKit

class EditViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet weak var weatherTextCarousel: UIScrollView!
    @IBOutlet weak var pageDots: UIPageControl!
    override func viewWillAppear(animated: Bool) {
        self.navigationController.setNavigationBarHidden(false, animated: true)
        super.viewWillAppear(animated)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        //add some text views
        let textViews = [UITextView(frame: CGRectZero),UITextView(frame: CGRectZero),UITextView(frame: CGRectZero)]
        pageDots.numberOfPages = textViews.count
        for textView in textViews {
            textView.text = "Hello you are in {location}, today's high is {high}, and today's low is {low}, and today's wind is {wind} and today's feel like is {current}"
            textView.editable = false
            textView.selectable = false
            weatherTextCarousel.addSubview(textView)
        }
        layout(textViews[0], textViews[1], textViews[2]) { t1, t2, t3 in
            let superview = t1.superview!
            let width = superview.width - 20
            let height = superview.height - 20
            t1.width == width
            t2.width == width
            t3.width == width
            t1.height == height
            t2.height == height
            t3.height == height
            
            t1.top == superview.top + 10
            t1.leading == superview.leading + 10
            
            t2.top == t1.top
            t2.leading == t1.trailing + 20
            
            t3.top == t1.top
            t3.leading == t2.trailing + 20
            t3.trailing == superview.trailing - 10
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView!){
        let width = scrollView.frame.size.width
        let currentPage = Int(round(scrollView.contentOffset.x / width))
        pageDots.currentPage = currentPage
    }
}