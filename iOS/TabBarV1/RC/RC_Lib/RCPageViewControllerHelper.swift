//****************************************************************************************
//  RCPageViewControllerHelper.swift
//
//  Copyright © 2020 Reflect Code Technologies (OPC) Pvt. Ltd.
//  For detailed please check - http://ReflectCode.com
//
//  Description - Helper class to implement the convenience methods required for converting to iOS platform
//  Android Class - androidx.fragment.app.FragmentPagerAdapter 
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

public typealias onPageSelectedCallbackType = (Int) -> Void
public typealias onPageScrolledCallbackType = (Int, Float, Int) -> Void
public typealias onPageScrollStateChangedCallbackType = (Int) -> Void

protocol RCPageViewControllerExtra {
    // RC Note : Required to setup Segmentio Tab bar
    func getCount() -> Int?
    func getPageTitle(_ position: Int) -> String?
    func setCurrentItem(_ position: Int)
    func getCurrentItem() -> Int
    func initPage(_ container: UIPageViewController?, _ position: Int) -> UIViewController?
    var syncWithTab: onPageSelectedCallbackType? { get set }
}


public class RCPageViewControllerHelper : NSObject, RCPageViewControllerExtra, UIPageViewControllerDataSource, UIPageViewControllerDelegate {
        
    internal var fm: UIViewController
    internal weak var pageVC: UIPageViewController?
    internal var pageLocation: UIPageControl? = nil
    internal var currentPosition: Int = -1
    internal var scrollDirection: Int = 0
    private var pageIsAnimating: Bool = false
    
    public var syncWithTab: onPageSelectedCallbackType?
    
    public var onPageSelectedCallback: onPageSelectedCallbackType?
    public var onPageScrolledCallback: onPageScrolledCallbackType?
    public var onPageScrollStateChangedCallback: onPageScrollStateChangedCallbackType?
    
    internal var viewPages: [Int:UIViewController?] = [:]
    
    public override init() {
        self.fm = UIViewController()
        super.init()
    }
    
    init(_ fm: UIViewController){
        self.fm = fm
        super.init()
    }
    
     // RC Note : Uncomment below two methods for making standard iOS "UIPageControl" dot indicators visible
     // public func presentationCount(for pageViewController: UIPageViewController) -> Int {
     //     return self.getCount()
     // }
     //
     // public func presentationIndex(for pageViewController: UIPageViewController) -> Int {
     //     return currentPosition
     // }
     
     
     /// Set the position of currently displayed view controller
     ///  - Parameter:
     ///  - position: position of viewcontroller to be displayed
     public func setCurrentItem(_ position: Int){
        
        
        if currentPosition != position{
            currentPosition = position
            
            var direction: UIPageViewController.NavigationDirection = .forward
            
            if currentPosition < position {
                scrollDirection = 1
            } else if currentPosition < position {
                scrollDirection = -1
            } else {
                scrollDirection = 0
            }
            
            if scrollDirection == -1 {
                if currentPosition == 0 {
                    //currentPosition = getCount()    // RC Note : Uncomment this for circular page scroll
                    direction = .forward
                } else {
                    currentPosition = currentPosition - 1
                    direction = .reverse
                }
            } else if scrollDirection == 1 {
                if currentPosition == getCount()! {
                    //currentPosition = 0            // RC Note : Uncomment this for circular page scroll
                    direction = .reverse
                } else {
                    currentPosition = currentPosition + 1
                    direction = .forward
                }
            } else {
                currentPosition = position
            }

            
            if let pglLoc = pageLocation {
                pglLoc.currentPage = currentPosition
            }
            
            if pageVC != nil {
                
                if let newPage = initPage(pageVC!, currentPosition) {
                    pageVC?.setViewControllers([newPage], direction: direction, animated: true, completion: { status in
                        if status {
                            self.onPageScrollStateChangedCallback?(0)
                            self.onPageSelectedCallback?(self.currentPosition)
                            self.syncWithTab?(self.currentPosition)
                        }
                    })
                }
            }
            
         }
        
    }
     
     /// Get the position of currently displayed view controller
     public func getCurrentItem() -> Int{
         return currentPosition
     }

    public func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        pageIsAnimating = true
        onPageScrollStateChangedCallback?(1)
    }
        
    public func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        pageIsAnimating = false
        
        if completed {
            currentPosition = viewPages.first(where: {key, val in val == pageViewController.viewControllers![0]})!.key
            
            if let pglLoc = pageLocation{
                pglLoc.currentPage = currentPosition
            }
            
            onPageScrollStateChangedCallback?(0)
            onPageSelectedCallback?(currentPosition)
            syncWithTab?(currentPosition)
        }
    }
        
        
        
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        // Called when swipped from left to right direction  ->
        if pageIsAnimating {
            return nil
        }
        
        var newPosition: Int = 0
        if currentPosition == 0 {
            // newPosition = self.getCount()    // RC Note : Uncomment this for circular page scroll
            return nil
        } else {
            newPosition = currentPosition - 1
        }
        print("---> \(newPosition)")
        onPageScrollStateChangedCallback?(0)
        return  initPage(pageViewController, newPosition) as? UIViewController
    }
        
        
        
    public func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        // Called when swipped from right to left direction  <-
        if pageIsAnimating {
            return nil
        }
        
       var newPosition: Int = 0

       if currentPosition == self.getCount()! - 1 {
            // newPosition = 0   // RC Note : Uncomment this for circular page scroll
            return nil
        } else {
            newPosition = currentPosition + 1
        }
        print("<--- \(newPosition)")
        onPageScrollStateChangedCallback?(0)
        return initPage(pageViewController, newPosition) as? UIViewController
    }

    
    /// Create a new page and setup its tag value  or returns existing page is already instentiated
    public func initPage(_ container: UIPageViewController?, _ position: Int) -> UIViewController? {
        var newPosition: Int
        
        if position >= getCount()! {
           newPosition = getCount()! - 1     // Go to last page
        } else {
            if position < 0 {
                newPosition  = 0
            } else {
                newPosition = position
            }
        }
        
        let viewCtrl: UIViewController?
        
        if viewPages.contains(where: { (key,vc) in key == newPosition}) {
            // Return the existing page
            viewCtrl = viewPages[newPosition]!!
        } else {
            // Create a new page and preserve it in viewPages
            viewCtrl = getItem(newPosition)
            let _ = viewCtrl?.view                         // RC Note : Require to instentiate the sub views
            viewCtrl?.view.frame = container!.view.bounds
            
            viewPages[newPosition] = viewCtrl
        }
        
        return viewCtrl
    }
        
    
    public func getItem(_ position: Int) -> UIViewController? {
        fatalError("Super class must override this method")
    }
    
    public func getPageTitle(_ position: Int) -> String?{
        return "Tab-" + position
    }
    
    /// Super class must override this method
    func getCount() -> Int? {
        fatalError("Super class must override this method")
    }

    
}
