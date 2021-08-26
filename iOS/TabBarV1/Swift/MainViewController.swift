
import UIKit


import Segmentio

final class MainViewController : UIViewController {

    var adapter: PagerAdapter? = nil

    var viewPager: UIPageViewController?

    static let storyboardName = "mainView"
    static let storyboardID = "MainViewController"

    var rcExtraData: [String:Any] = [:]

    @IBOutlet weak var main_layout: UIView!
    @IBOutlet weak var tab_layout: Segmentio!
    @IBOutlet weak var pager: UIView!

    //RC Note: Required to get data passed to app when it is launched by external event such as Push Notification.
    @objc func rcGetDataFromAppDelegate(){
        rcExtraData = AppDelegate.rcExtraData
        viewDidLoad()
    }
    
    public override func viewDidDisappear(_ animated: Bool) {
        NotificationCenter.default.removeObserver(self, name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
    }
    
    // RC Note : source android method is onCreate()
    // RC Note : Any code refering to UI should be moved to viewDidAppear()
    override public func viewDidLoad() {
        super.viewDidLoad()
        

        viewPager = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal, options: nil)
        addChild(viewPager!)
        viewPager!.view.frame = pager.bounds
        pager.addSubview(viewPager!.view)
        viewPager!.view.translatesAutoresizingMaskIntoConstraints = false
        let constraintSet = [ viewPager!.view.leadingAnchor.constraint(equalToSystemSpacingAfter: pager!.leadingAnchor, multiplier: 0),
                    viewPager!.view.trailingAnchor.constraint(equalToSystemSpacingAfter: pager!.trailingAnchor, multiplier: 0),
                    viewPager!.view.topAnchor.constraint(equalToSystemSpacingBelow: pager!.topAnchor, multiplier: 0),
                    viewPager!.view.bottomAnchor.constraint(equalToSystemSpacingBelow: pager!.bottomAnchor, multiplier: 0) ]
        
        NSLayoutConstraint.activate(constraintSet)
        viewPager?.didMove(toParent: self)
        pager.setNeedsLayout()
        let tabLayout: Segmentio = tab_layout as Segmentio
        //var adapter = PagerAdapter(this, supportFragmentManager)
        
        adapter = PagerAdapter(viewPager!)

        for vc in self.children{
            if vc.restorationIdentifier == "viewpager-content" {
                self.viewPager = vc as! UIPageViewController
            }
        }
        viewPager?.dataSource = adapter
        viewPager?.delegate = adapter
        self.adapter?.pageVC = self.viewPager
        self.adapter?.setCurrentItem(1)
        tabLayout.setupWithPageViewController(viewPager!)

        
        // RC Note : 'valueDidChange' is used to update UIPageViewController, assigning new value will break its connection and pages will not get updated.
        // You can manually call updatePage() method
        var previousTab: Int = 0
        tabLayout.valueDidChange = { segmento, index in
            var tabItem: SegmentioItem = segmento.segmentioItems[index]
            
            if index == previousTab {
                self.onTabReselected(tabItem, index)
            } else {
                self.onTabUnselected(segmento.segmentioItems[previousTab], previousTab)
                previousTab = index
                self.onTabSelected(segmento.segmentioItems[index], index)
                tabLayout.updatePage(self.viewPager!, index)
            }
        }
            
    }
    
    func onTabSelected(_ tab: SegmentioItem, _ tabPosition: Int) -> Void{
        print("RC:   onTabSelected() = \(tabPosition)")
        //viewPager.currentItem = tab.position
    }

    func onTabUnselected(_ tab: SegmentioItem, _ tabPosition: Int) -> Void{
        print("RC: onTabUnselected() = \(tabPosition)")
    }

    func onTabReselected(_ tab: SegmentioItem, _ tabPosition: Int) -> Void{
        print("RC: onTabReselected() = \(tabPosition)")
    }
    
}
