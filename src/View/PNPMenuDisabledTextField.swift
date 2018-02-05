//
//  PNPMenuDisabledTextField.swift
//  UIComponents
//
//  Created by Hugh Bellamy on 05/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//
import UIKit

@IBDesignable
internal class PNPMenuDisabledTextField: UITextField {
    @IBInspectable private var menuEnabled: Bool = false
    @IBInspectable private var canPositionCaretAtStart: Bool = true
    @IBInspectable private var editingRectDeltaY: CGFloat = 0
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        return menuEnabled
    }
    
    override func caretRect(for position: UITextPosition) -> CGRect {
        if position == beginningOfDocument && !canPositionCaretAtStart {
            return super.caretRect(for: self.position(from: position, offset: 1)!)
        }

        return super.caretRect(for: position)
    }
    
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 0, dy: editingRectDeltaY)
    }
}
