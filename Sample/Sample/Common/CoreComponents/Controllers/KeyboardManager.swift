//
//  KeyboardManager.swift
//  JPulikkottil
//
//  Created by Jijo Pulikkottil on 20/04/16.
//  Copyright © 2017 JPulikkottil All rights reserved.
//
import Foundation
import UIKit

/*
 It need Xcode 7.3 to compile
 //Following is the sample class to descripbe how to use KeyboardManager
 class ExampleViewController:UIViewController, UITextFieldDelegate {
 
 
 
 Storyboard view hierarchy
 
 ViewConrtroller
 --UIView
 ----UIScrollView        -> @IBOutlet weak var scrollView: UIScrollView!
 ------UIView
 --------textfield1
 --------textfield2
 
 
 var kbManager: KeyboardManager!
 @IBOutlet weak var scrollView: UIScrollView!
 
 override func viewDidLoad() {
 super.viewDidLoad()
 // to fix the empty space (64 pt) on top. if you not set  this in storyboard
 self.automaticallyAdjustsScrollViewInsets = false
 
 self.kbManager = KeyboardManager(ContainerScrollView: scrollView, SetTextFieldDelegateWith: self, SetTextViewDelegateWith: nil, DissmissTapOutside: false)
 
 }
 
 override func viewWillAppear(animated: Bool) {
 super.viewWillAppear(animated)
 kbManager.registerKeyboardEvents()
 
 }
 override func viewWillDisappear(animated: Bool) {
 super.viewWillDisappear(animated)
 kbManager.deRegisterKeyboardEvents()
 
 }
  extension LoginViewController: UITextFieldDelegate {
 
 // became first responder
 func textFieldDidBeginEditing(textField: UITextField) {
 
 kbManager.didBeginEditing(textField)
 }
 // may be called if forced even if shouldEndEditing returns NO (e.g. view removed from window) or endEditing:YES called
 func textFieldDidEndEditing(textField: UITextField) {
 
 }
 // called when 'return' key pressed. return NO to ignore.
 func textFieldShouldReturn(textField: UITextField) -> Bool {
 
 kbManager.textFieldShouldReturn()
 return true
 }
 }
 */

struct KeyBoardTolbarAppearence {

    var barTintColor: UIColor
    var titleFont: UIFont
    var titleColor: UIColor
}

extension Keyboard: UITextFieldDelegate {
    // became first responder
    func textFieldDidBeginEditing(_ textField: UITextField) {
        self.didBeginEditing(textField, isShowToolbar: false)
    }
    // called when 'return' key pressed. return NO to ignore.
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.textFieldShouldReturn()
        return true
    }
}
protocol KBToolbarDelegate: class {
    func tappedDoneButton(textField: UIView?)
}
protocol KBReloadDelegate: class {
    func keyboardReloadedOnScrollView(_ scrollView: UIScrollView)
}
protocol KeyboardManager {
    var adjustHeight: CGFloat {get set}
    weak var activeTextField: UIView? {get}
    weak var toolbarDelegate: KBToolbarDelegate? {get set}
    weak var keyboardDelegate: KBReloadDelegate? {get set}
    func dismissKeyboard()
    func deRegisterKeyboardEvents()
    func registerKeyboardEvents()
    func textFieldShouldReturn()
    func didBeginEditing(_ textField: UIView, isShowToolbar: Bool)
    func didBeginEditing(_ textField: UIView)
    func didEndEditing(_ textField: UIView)
    var useTagvalue: Bool {get set} //we need to access this if there is textfield in scrollview and a tableview in scrollview
    var keyboardHeight: CGFloat? {get}
}
class Keyboard: NSObject, KeyboardManager {

    var keyboardHeight: CGFloat?
    weak var toolbarDelegate: KBToolbarDelegate?
    weak var keyboardDelegate: KBReloadDelegate?
    weak var scrollView: UIScrollView!
    fileprivate var arrayField = [UIView]()
    weak var activeTextField: UIView?
    weak var nextActiveTextField: UIView?
    var adjustHeight: CGFloat = 10
    var useTagvalue = false
    private let numberToolbar = UIToolbar() //do with lazy ToDo:
    static var toolbarAppearence = KeyBoardTolbarAppearence(barTintColor: UIColor.white, titleFont: UIFont.systemFont(ofSize: 14), titleColor: UIColor.gray)

    // MARK: public methodss
    func didEndEditing(_ textField: UIView) {
        textField.layoutIfNeeded()
    }
    func didBeginEditing(_ textField: UIView) {
        didBeginEditing(textField, isShowToolbar: DeviceType.isIphone)
    }
    func didBeginEditing(_ textField: UIView, isShowToolbar: Bool) {

        if let txtField = textField as? UITextField {
            if isShowToolbar {
                txtField.inputAccessoryView = numberToolbar
            } else {
                txtField.inputAccessoryView = nil
            }
            if let toolBar = textField.inputAccessoryView as? UIToolbar {
                if let barButtonItem = toolBar.items?[0] {
                    if let titleLabel = barButtonItem.customView as? UILabel {
                        titleLabel.text = txtField.placeholder
                    }
                }
            }
        } else if let txtField = textField as? UITextView {
            if isShowToolbar {
                txtField.inputAccessoryView = numberToolbar
            } else {
                txtField.inputAccessoryView = nil
            }
        }

        self.activeTextField = textField
        if useTagvalue || arrayField.isEmpty == true {
            arrayField = self.findAllTextFieldsInView(self.scrollView)
            arrayField.sort(by: { (view1, view2) -> Bool in
                return view1.tag < view2.tag
            })
        }
    }

    func textFieldShouldReturn() {

        let nextTextField: UIView? = hasNextTextField()
        if nextTextField != nil {
            nextTextField?.becomeFirstResponder()
        } else {
            self.activeTextField?.resignFirstResponder()
        }
    }
    private func hasNextTextField() -> UIView? {

        var selIndex = 0
        if let foundIndex = arrayField.index(where: { (element) -> Bool in
            return element == self.activeTextField
        }) {
            selIndex = foundIndex
        }

        var nextTextField: UIView?
        let start = selIndex + 1
        if start < arrayField.count {

            for i in start ... arrayField.count - 1 {
                if self.isResignKB(arrayField[i]) {
                    nextTextField = nil
                    continue
                }
                if self.isEligibleTextFild(arrayField[i]) {
                    nextTextField = arrayField[i]
                    break
                }
            }
        }
        return nextTextField
    }
    fileprivate override init() {
        super.init()
    }
    init(containerScrollView: UIScrollView, textFieldDelegate: UITextFieldDelegate? = nil, textViewDelegate: UITextViewDelegate? = nil, isDismiss: Bool = false) {

        super.init()
        self.scrollView = containerScrollView
        if containerScrollView is UITableView || containerScrollView is UICollectionView {
            useTagvalue = true
        }
        arrayField = self.findAllTextFieldsInView(self.scrollView)
        let textDelegate = textFieldDelegate ?? self
        for txtField in arrayField {
            if let textField = txtField as? UITextField {
                textField.isUserInteractionEnabled = textField.isEnabled
                textField.delegate = textDelegate
            }
        }
        if textViewDelegate != nil {
            for txtField in arrayField {
                if let textView = txtField as? UITextView {
                    textView.delegate = textViewDelegate
                }
            }
        }
        if isDismiss {
            let tapRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleSingleTap(_:)))
            tapRecognizer.numberOfTapsRequired = 1
            tapRecognizer.cancelsTouchesInView = false
            // tapRecognizer.delegate = self
            self.scrollView.addGestureRecognizer(tapRecognizer)
        }
        self.scrollView.keyboardDismissMode = .interactive // https://forums.developer.apple.com/thread/48678

        //if DeviceType.isIphone {
        customizedToolBar(numberToolbar)
        //}
    }
    func customizedToolBar(_ toolBar: UIToolbar) {
        let label = UILabel(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 200, height: 50)))
        label.font = Keyboard.toolbarAppearence.titleFont
        label.textColor = Keyboard.toolbarAppearence.titleColor
        let toolBarTitle = UIBarButtonItem(customView: label)
        let frmae = UIScreen.main.bounds //main.applicationFrame
        toolBar.frame = CGRect(x: 0, y: 0, width: frmae.size.width, height: 50)
        toolBar.barStyle = UIBarStyle.default
        toolBar.barTintColor = Keyboard.toolbarAppearence.barTintColor
        let doneButton =  UIBarButtonItem(title: "keyboard.done".localized(), style: UIBarButtonItemStyle.plain, target: self, action: #selector(tappedDoneButton))
        let barButtonAppearenceDict: [NSAttributedStringKey: AnyObject] = [
            NSAttributedStringKey.foregroundColor: Keyboard.toolbarAppearence.titleColor
        ]
        doneButton.setTitleTextAttributes(barButtonAppearenceDict, for: .normal)
        toolBar.items = [
            toolBarTitle,
            UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.flexibleSpace, target: nil, action: nil),
            doneButton]
        toolBar.sizeToFit()
    }
    // FromController ctrlr: UIViewController,
    func registerKeyboardEvents() {

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidShow(_:)), name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }

    @objc func handleSingleTap(_ recognizer: UITapGestureRecognizer) {
        self.scrollView.endEditing(true)
    }
    func deRegisterKeyboardEvents() {

        self.activeTextField?.resignFirstResponder()
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardDidShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)

    }
    @objc func tappedDoneButton() {
        toolbarDelegate?.tappedDoneButton(textField: activeTextField)
        dismissKeyboard()
    }
    func dismissKeyboard() {
        self.activeTextField?.resignFirstResponder()
    }

    // MARK: - Keyboard Actions
    @objc func keyboardWillShow(_ notification: Notification) {

        if let keyboardSize = ((notification as NSNotification).userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var safeAreaBottom: CGFloat = 0.0
            if #available(iOS 11.0, *) {
                if let bottom = UIApplication.shared.keyWindow?.safeAreaInsets.bottom { // iPhone X
                    safeAreaBottom = bottom
                }
            }
            let kbHeight = keyboardSize.height - safeAreaBottom
            keyboardHeight = kbHeight
            printDebug("adjustHeight = \(adjustHeight)")
            UIView.beginAnimations(nil, context: nil)
            UIView.setAnimationBeginsFromCurrentState(true)
            self.scrollView.contentInset = UIEdgeInsets(top: 0.0, left: 0.0, bottom: kbHeight + adjustHeight, right: 0.0)
            UIView.commitAnimations()
            keyboardDelegate?.keyboardReloadedOnScrollView(scrollView)
        }

    }
    @objc func keyboardDidShow(_ notification: Notification) {

        if let activeField = self.activeTextField, activeField is UITextView {

            //self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
        }
    }
    @objc func keyboardWillHide(_ notification: Notification) {

        UIView.beginAnimations(nil, context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        var contentInset = self.scrollView.contentInset
        contentInset.bottom = 0
        self.scrollView.contentInset = contentInset
        UIView.commitAnimations()
    }

    // MARK: - Private methods
    fileprivate func isEligibleTextFild(_ txtField: UIView) -> Bool {
        if let supView = txtField.superview, !supView.isHidden, !txtField.isHidden, txtField.isUserInteractionEnabled, txtField.canBecomeFirstResponder {

            return true
        }
        return false
    }
    fileprivate func isResignKB(_ txtField: UIView) -> Bool {
        return !txtField.isUserInteractionEnabled
    }
    fileprivate func findAllTextFieldsInView(_ view: UIView) -> [UIView] {
        var array = [UIView]()

        for sview in view.subviews {
            if sview.isKind(of: UITextField.self) || sview.isKind(of: UITextView.self) {
                array.append(sview)
            } else if sview.responds(to: #selector(getter: UIView.subviews)) && !sview.isHidden {
                array.append(contentsOf: self.findAllTextFieldsInView(sview))
            }
        }

        return array
    }
}
