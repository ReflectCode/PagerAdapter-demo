
import UIKit


final class tab1Page : UIViewController {


    // RC Note : source android method is onCreate()
    // RC Note : Any code refering to UI should be moved to viewDidAppear()
    override public func viewDidLoad() {
        var savedInstanceState = UserDefaults.standard.dictionaryRepresentation()
        super.viewDidLoad()
    }

    var arguments: [String:Any] = [:]

    public override func loadView() {
        super.loadView()
        self.view = UINib(nibName: "fragment_tab1", bundle: Bundle(for: type(of: self)))
                .instantiate(withOwner: self, options: nil)
                .first as! UIView 
        self.view.translatesAutoresizingMaskIntoConstraints = true
        self.view.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        self.view.layoutSubviews()
    }

}
