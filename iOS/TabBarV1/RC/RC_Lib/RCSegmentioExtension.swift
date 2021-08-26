//****************************************************************************************
//  RCCommon.swift
//
//  Copyright © 2020 Reflect Code Technologies (OPC) Pvt. Ltd.
//  For detailed please check - http://ReflectCode.com
//
//  Description - This file contains methods required to port android 'TabLayout' on iOS platform 
//                It uses open source 'Segmentio' lib from Yalantis (https://github.com/Yalantis/Segmentio)
//
//  Android class - com.google.android.material.tabs.TabLayout
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy of this 
//  software and associated documentation files (the "Software"), to deal in the Software 
//  without restriction, including without limitation the rights to use, copy, modify, merge,
//  publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons 
//  to whom the Software is furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all copies or 
//  substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING 
//  BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND 
//  NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
//  DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, 
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//****************************************************************************************


import UIKit
import Segmentio

extension Segmentio{
    
    private func syncWithTab(_ item: Int) -> Void {
        selectedSegmentioIndex = item
    }
    
    func setupWithPageViewController(_ pageController: UIPageViewController){
    
        var adapter = pageController.dataSource as? RCPageViewControllerExtra
        adapter!.syncWithTab = syncWithTab
        selectedSegmentioIndex = adapter?.getCurrentItem() ?? 0
        
        var tabs: [SegmentioItem] = []
        for i in 0 ..< (adapter?.getCount() ?? 0) {
            tabs.append(SegmentioItem(title: adapter?.getPageTitle(i), image: nil))
        }
        
        var tabStates = SegmentioStates(
            defaultState: SegmentioState(
                backgroundColor: UIColor(white: 0.95, alpha: 1),
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .darkGray
            ),
            selectedState: SegmentioState(
                backgroundColor: UIColor(white: 0.95, alpha: 1),
                titleFont: UIFont.systemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .black
            ),
            highlightedState: SegmentioState(
                backgroundColor: UIColor(white: 0.8, alpha: 1),
                titleFont: UIFont.boldSystemFont(ofSize: UIFont.smallSystemFontSize),
                titleTextColor: .darkGray
            )
        )
        
        var segOption = SegmentioOptions(backgroundColor: UIColor.white,
                                         segmentPosition: SegmentioPosition.fixed(maxVisibleItems: 4),
                                         scrollEnabled: false,
                                         indicatorOptions: SegmentioIndicatorOptions(type: .bottom, ratio: 1, height: 4, color: .black),
                                         horizontalSeparatorOptions: nil,
                                         verticalSeparatorOptions: nil,
                                         imageContentMode: .scaleAspectFit,
                                         labelTextAlignment: .center,
                                         labelTextNumberOfLines: 1,
                                         segmentStates: tabStates)
                                         
        setup(content: tabs, style: .onlyLabel, options: segOption)
        
        valueDidChange = { segmento, index in
            self.updatePage(pageController,index)
        }
    }
    
    
    func updatePage(_ pageController: UIPageViewController, _ index: Int){
        var adapter = pageController.dataSource as? RCPageViewControllerExtra
        if adapter?.getCurrentItem() != index {
            var direction: UIPageViewController.NavigationDirection = .reverse
            if adapter!.getCurrentItem() < index{
                direction = .forward
            }
            
            adapter?.setCurrentItem(index)
            pageController.setViewControllers([adapter!.initPage(pageController, index) as! UIViewController], direction: direction, animated: true, completion: nil)
        }
    }

}
