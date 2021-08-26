
import UIKit


final class PagerAdapter : RCPageViewControllerHelper {


    override init(_ fm: UIViewController){
        super.init(fm)
    }

    var mNumOfTabs: Int? = 3

    convenience init(_ fm: UIViewController?, _ NumOfTabs: Int){
        self.init(fm!)
        mNumOfTabs = NumOfTabs
    }

    override public func getPageTitle(_ position: Int) -> String?{
        return "Tab-" + position
    }

    override func getItem(_ position: Int) -> UIViewController{
        switch position{

        case 0:
            return tab1Page()

        case 1:
            return tab2Page()

        case 2:
            return tab3Page()

        default:
            print("Default case is required...")
            return tab3Page()
        
        }
    }

    override func getCount() -> Int?{
        return mNumOfTabs ?? 0
    }

}
