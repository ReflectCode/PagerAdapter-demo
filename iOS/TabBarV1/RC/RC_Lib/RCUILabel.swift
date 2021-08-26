//****************************************************************************************
//  RCUILabel.swift
//
//  Copyright (C) 2020 Reflect Code Technologies (OPC) Pvt. Ltd.
//  For detailed please check - http://ReflectCode.com
//
//  Description - Custom UILabel Swift class to add image behind the text 
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

@IBDesignable class RCUILabel: UILabel {

    @IBInspectable var topInset: CGFloat = 0.0
    @IBInspectable var bottomInset: CGFloat = 0.0
    @IBInspectable var leftInset: CGFloat = 0.0
    @IBInspectable var rightInset: CGFloat = 0.0
    @IBInspectable var cornerRadius: CGFloat = 0.0
    
    @IBInspectable var roundEdges: Bool = false
    @IBInspectable var backImage: String = ""

    
    func drawUI(){
        if roundEdges {
            layer.cornerRadius = frame.height / 2
            clipsToBounds = true
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        drawUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        drawUI()
    }
    
    override func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
        drawUI()
    }
    
    override func drawText(in rect: CGRect) {
        
        if topInset + bottomInset + leftInset + rightInset != 0 {
            // Set padding to text
            let insets = UIEdgeInsets.init(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
            super.drawText(in: rect.inset(by: insets))
            
        } else {
            super.drawText(in: rect)
        }
        
        if roundEdges {
            cornerRadius = self.frame.height / 2
        }
        if cornerRadius != 0 {
            self.clipsToBounds = true
            self.layer.cornerRadius = cornerRadius
        }
        
    }


	func setPadding(_ leftInset: Int, _ topInset: Int, _ rightInset: Int, _ bottomInset: Int){
		self.leftInset = CGFloat(leftInset)
		self.topInset = CGFloat(topInset)
		self.rightInset = CGFloat(rightInset)
		self.bottomInset = CGFloat(bottomInset)
		drawUI()
	}

    override var intrinsicContentSize: CGSize {
        let size = super.intrinsicContentSize
        
        var delta: CGFloat = 0
        if roundEdges && size.width < size.height {
            // If width is less than height, then match width to height to make perfect circle and not a skwed circle
            delta = size.height - size.width
        }
    
        let newSize = CGSize(
            width: size.width + leftInset + rightInset + delta,
            height: size.height + topInset + bottomInset
        )
        return newSize
    }
  
}


// Supporting function to handle tap on URL inside UILabel
// https://www.codementor.io/@nguyentruongky/hyperlink-label-qv2k8rpk9
// Check : AuthViewController.handleTermTapped()
extension UILabel {
    func indexOfAttributedTextCharacterAtPoint(point: CGPoint) -> Int {
        assert(self.attributedText != nil, "This method is developed for attributed string")
        let textStorage = NSTextStorage(attributedString: self.attributedText!)
        let layoutManager = NSLayoutManager()
        textStorage.addLayoutManager(layoutManager)
        let textContainer = NSTextContainer(size: self.frame.size)
        textContainer.lineFragmentPadding = 0
        textContainer.maximumNumberOfLines = self.numberOfLines
        textContainer.lineBreakMode = self.lineBreakMode
        layoutManager.addTextContainer(textContainer)

        let index = layoutManager.characterIndex(for: point, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        return index
    }
}

