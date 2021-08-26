//****************************************************************************************
//  RCCommon.swift
//
//  Copyright (C) 2020 Reflect Code Technologies (OPC) Pvt. Ltd.
//  For detailed please check - http://ReflectCode.com
//
//  Description - Common utilities used in project converted by ReflectCode.com 
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

import Foundation
import UIKit

	// Constants used to return result when user press back button on Navigation control
	// Reference - https://developer.android.com/reference/android/app/Activity.html#RESULT_OK
	struct RCResult {
		static let RESULT_OK         : Int = -1
		static let RESULT_CANCELED   : Int =  0
		static let RESULT_FIRST_USER : Int =  1
	}

	// This protocol defines the delegate function which will be invoked by called ViewController to 
	// send data back to calling ViewController  
	// It represents android method - https://developer.android.com/reference/android/app/Activity.html#onActivityResult(int,%2520int,%2520android.content.Intent)
	protocol RCResultHandlerDelegate : AnyObject {
		func rcOnActivityResult( _ requestCode:Int, _ resultCode:Int, _ data: [String:Any]) -> Void
	}


	extension CALayer{
		// This method is used to set CALayer color from Storyboard
		func shadowUIColor(color : UIColor){
			self.shadowColor = color.cgColor
		}
	}


	extension Comparable {
        // https://docs.oracle.com/javase/7/docs/api/java/lang/Comparable.html#compareTo(T)
        // Extension to provide android like Int.compareTo(Int) feature
        // e.g.  10.compareTo(20) will return -1
        // e.g.  10.compareTo(10) will return 0
        // e.g.  10.compareTo(2) will return 1
        
        func rcCompareTo(_ anotherObject : Self?) throws -> Int {
			
            if object_getClass(self) != object_getClass(anotherObject) {
				throw NSError(domain: "ClassCastException", code: 0, userInfo: nil)
			}
			
			if anotherObject == nil {
				throw NSError(domain: "NullPointerException", code: 0, userInfo: nil)
			}
			
			if self == anotherObject {
				return 0
			} else if self < anotherObject! {
				return -1
			} else {
				return 1
			}
		}
        
        // Entension to provide Java Comparable.compareTo(), non throwing function
        // https://docs.oracle.com/javase/7/docs/api/java/lang/Comparable.html        
        func compareTo(_ ele: Self) -> Int {
            
            // Warning : Comparing non-optional valye of type 'self' to 'nil' always returns false
            // if ele == nil {
            //      return 1
            // }
            
            if self > ele {
                return 1
            } else if self < ele {
                return -1
            } else {
                return 0
            }
        }
    }

    extension String {
        // Extension to provide android like compareTo() functionality
		func rcCompareTo(_ anotherString : String) -> Int {
			
			if self == anotherString {
				return 0
			} else if self < anotherString {
				return -1
			} else {
				return 1
			}
		}

		func rcCompareToIgnoreCase(_ anotherString : String) -> Int {
			if self.lowercased() == anotherString.lowercased() {
				return 0
			} else if self.lowercased() < anotherString.lowercased() {
				return -1
			} else {
				return 1
			}
		}
		
		func rcMatches(_ pattern: String) -> Bool {
			guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return false }
			let str = self as NSString
			let result = regex.matches(in: self, options: [], range: NSMakeRange(0, str.length))
			
			if result.count == 0 {
				return false
			} else {
				return true
			}        
		}
		
        func rcMatches(_ regEx: NSRegularExpression?) -> Bool {
            guard let regex = regEx else { return false }
            let str = self as NSString
            let result = regex.matches(in: self, options: [], range: NSMakeRange(0, str.length))
            
            if result.count == 0 {
                return false
            } else {
                return true
            }
        }
        
        
		func rcRegionMatches(_ ignoreCase : Bool, _ toffset : Int, _ other : String, _ ooffset : Int, _ len : Int) -> Bool {
			
			let thisStrArray = Array(self)
			let compareStrArray = Array(other)
			
			if (toffset+len) >= thisStrArray.count {
				return false
			}
			
			if (ooffset+len) >= compareStrArray.count {
				return false
			}
			
			var thisStr : String = String(thisStrArray[toffset...(toffset+len)])
			var compareStr : String = String(compareStrArray[ooffset...(ooffset+len)])
			
			if ignoreCase {
				thisStr = thisStr.lowercased()
				compareStr = compareStr.lowercased()
			}
			
			return  thisStr.rcCompareTo(compareStr) == 0
		}
	 
		func rcRegionMatches(_ toffset : Int, _ other : String, _ ooffset : Int, _ len : Int) -> Bool {
			return self.rcRegionMatches(true, toffset, other, ooffset, len)
		}

		
		func rcReplaceAll(_ pattern : String, _ replacement : String) -> String {
			// String.replaceAll method which uses regular expression to find string to be replaced
			guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
			let result = regex.stringByReplacingMatches(in: self, options: [], range: NSMakeRange(0, self.count), withTemplate: replacement)
			return result
		}

		func rcReplaceFirst(_ pattern : String, _ replacement : String) -> String {
			// String.replaceFirst method which uses regular expression to find string to be replaced
			var result = self

			guard let regex = try? NSRegularExpression(pattern: pattern, options: []) else { return self }
			let firstMatchRange = regex.rangeOfFirstMatch(in: self, options: [], range: NSMakeRange(0, self.count))
			result = regex.stringByReplacingMatches(in: self, options: [], range: firstMatchRange, withTemplate: replacement)
			
			return result
		}
        
	}



	// Gravity used by RCDrawerController.swift
    public enum RCGravity: Int{
        case START, END
    }
    

	// UIView extention to get the view which is currently focused
	// This is to implement the Android like functionality of Activity.getCurrentFocus()
	// https://developer.android.com/reference/android/app/Activity.html#getCurrentFocus()
	// Credit : https://stackoverflow.com/questions/1823317/get-the-current-first-responder-without-using-a-private-api
	// Limitation : This logic covers only subviews and not viwes which are siblings or in some other view hirarchy
	extension UIView {
		func rcGetCurrentFocus() -> UIView? {
			guard !isFirstResponder else { return self }
			for subview in subviews {
				if subview.isFirstResponder {
					return subview
				}
			}
			return nil
		}
	}
	
	
	// UIView extention to get the view which is currently focused
	// This is to implement the Android like functionality of Activity.getCurrentFocus()
	// https://developer.android.com/reference/android/app/Activity.html#getCurrentFocus()
	// Credit : https://stackoverflow.com/questions/5029267/is-there-any-way-of-asking-an-ios-view-which-of-its-children-has-first-responder/14135456#14135456
	extension UIResponder {

		private static weak var _currentFirstResponder: UIResponder?

		static var currentFirstResponder: UIResponder? {
			_currentFirstResponder = nil
			UIApplication.shared.sendAction(#selector(UIResponder.findFirstResponder(_:)), to: nil, from: nil, for: nil)

			return _currentFirstResponder
		}

		@objc func findFirstResponder(_ sender: Any) {
			UIResponder._currentFirstResponder = self
		}

	}


	
	// Swift implementation of Java synchronized block
	// https://docs.oracle.com/javase/tutorial/essential/concurrency/locksync.html
	// Note : Java synchronized methods are converted into synchronized block by moving 
	//        complete code of method inside synchronized block
	// Usage : rcSynchronized(self){
	//				<< Block of swift statements to be synchronized >>
	//         }
	//
    func rcSynchronized(_ lock: Any, closure: () -> () ) {
        objc_sync_enter(lock)
        closure()
        objc_sync_exit(lock)
    }
	
    //  Android Ref : https://developer.android.com/reference/java/lang/Thread.State
    enum RCThreadState{
        case NEW
        case RUNNABLE
        case BLOCKED
        case WAITING
        case TIMED_WAITING
        case TERMINATED
    }


    //  Android Ref : https://developer.android.com/reference/java/lang/Thread.html#getState()
    extension Thread{
        
        func getState() -> RCThreadState {
            if self.isExecuting {
                return RCThreadState.RUNNABLE
                
            } else if self.isCancelled{
                return RCThreadState.BLOCKED
                
            } else if self.isFinished {
                return RCThreadState.TERMINATED
                
            } else {
                return RCThreadState.NEW
                
            }
        }
    }


	// Overload '+' operator to concatinate strings
	// Non string objects will be converted into string using its .description method
	public func +(left: Any, right: String) -> String {
		return "\(left)\(right)"
	}

	public func +(left: String, right: Any) -> String {
		return "\(left)\(right)"
	}


    // Convert CALayer to UIImage
    // Credit - https://stackoverflow.com/a/3454613/11771055
    public func imageFromLayer(layer:CALayer) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(layer.frame.size, layer.isOpaque, 0)
        layer.render(in: UIGraphicsGetCurrentContext()!)
        let outputImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return outputImage!
    }


// Convert various data types to its Byte Array representation
// Credit : https://stackoverflow.com/a/26954091
// Usage -
//     toByteArray(1729.1729)
//     toByteArray(1729.1729 as Float)
//     toByteArray(1729)
//     toByteArray(-1729)
//
// Output -
//     [234, 149, 178, 12, 177, 4, 155, 64]
//     [136, 37, 216, 68]
//     [193, 6, 0, 0, 0, 0, 0, 0]
//     [63, 249, 255, 255, 255, 255, 255, 255]
//
// Note- results are reversed because of endianness, use toByteArray(1729.1729).reverse() to get correct order
    
func toByteArray<T>(_ value: T) -> [UInt8] {
    var value = value
    return withUnsafeBytes(of: &value) { Array($0) }
}

func fromByteArray<T>(_ value: [UInt8], _: T.Type) -> T {
    return value.withUnsafeBytes {
        $0.baseAddress!.load(as: T.self)
    }
}

func getPointer(_ value: [UInt8]) -> UnsafeMutablePointer<UInt8>? {
    var baseAddr: UnsafeMutablePointer<UInt8>? = nil
    
    value.withUnsafeBytes { (m: UnsafeRawBufferPointer) in
        // Note : explicit param 'm' is required to get Mutable pointer
        baseAddr = m.baseAddress?.assumingMemoryBound(to: UInt8.self) as? UnsafeMutablePointer<UInt8>        
    }
    return baseAddr
}



extension UIView {
    // To find the UIViewController responsible for this view
    // Credit : https://www.hackingwithswift.com/example-code/uikit/how-to-find-the-view-controller-responsible-for-a-view
    func findViewController() -> UIViewController? {
        if let nextResponder = self.next as? UIViewController {
            return nextResponder
        } else if let nextResponder = self.next as? UIView {
            return nextResponder.findViewController()
        } else {
            return nil
        }
    }
    
    var rcContext: UIViewController? {
        get{
            return findViewController()
        }
    }
    
}


extension UIView {
    func rcSetupView(_ view: UIView){
        view.frame = self.bounds
        view.topAnchor.constraint(equalTo: self.topAnchor).isActive = true
        view.bottomAnchor.constraint(equalTo: self.bottomAnchor).isActive = true
        view.leadingAnchor.constraint(equalTo: self.leadingAnchor).isActive = true
        view.trailingAnchor.constraint(equalTo: self.trailingAnchor).isActive = true

        view.autoresizesSubviews = true
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layoutSubviews()
        view.didMoveToSuperview()
    }
    
}


extension R.id {
    // Resources IDs for common elements
	static var rc_footer_view         = 98989800000   // Footer view to insert accessory views such as RCSnackBar
    static var design_bottom_sheet    = 98989800001   // com.google.android.material.R.id.design_bottom_sheet
    static var keyboard_tracker_view  = 98989800002   // View used to avoide keyboard overlapping
    
}

