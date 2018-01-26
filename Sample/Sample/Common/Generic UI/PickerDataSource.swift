//
//  PickerManager.swift
//  bitreel
//
//  Created by ZCo Engg Dept on 05/05/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import Foundation
import UIKit

protocol Keyword {
    func aliasName() -> Int
    func localizedName() -> String
}

class PickerDataSource: NSObject {
    fileprivate unowned var picker: UIPickerView
    fileprivate var selectedItem: Keyword?
    fileprivate var component: Int
    fileprivate var numberOfComponents: Int
    var dataSource: [[Keyword]] = [[]] {
        didSet { picker.reloadAllComponents() }
    }
    var actionDidSelect: ((Keyword) -> Void)?
    var actionDidSelectForComponent: ((Keyword, Int) -> Void)?
    init(picker: UIPickerView, numberOfComponents: Int = 1) {
        self.picker = picker
        self.numberOfComponents = numberOfComponents
        self.component = 0
    }
    func getSelectedKeyword() -> Keyword? {
        return selectedItem
    }
    func getComponent() -> Int {
        return component
    }
    func setSelectedKeyword(item: Keyword?, component: Int = 0) {
        guard let itemToSelect = item else {
            picker.selectRow(0, inComponent: component, animated: false)
            return
        }
        if let index = dataSource[component].index(where: { (keyword) -> Bool in
            return itemToSelect.aliasName() == keyword.aliasName()
        }) {
            picker.selectRow(index, inComponent: component, animated: false)
        }
        selectedItem = item
    }
}
extension PickerDataSource: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return self.numberOfComponents
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return dataSource[component].count
    }
}
extension PickerDataSource: UIPickerViewDelegate {
//    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {
//        guard let reusableLabel = view as? UILabel else {
//            let label = UILabel()
//            label.font = UIFont.regular(17)
//            label.textAlignment = .center
//            label.adjustsFontSizeToFitWidth = true
//            label.minimumScaleFactor = 0.5
//            label.text = dataSource[row].localizedName()
//            return label
//        }
//        reusableLabel.text = dataSource[row].localizedName()
//        return reusableLabel
//    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return dataSource[component][row].localizedName()
    }
//    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
//        let attString = NSMutableAttributedString(string: dataSource[row].localizedName(), attributes: [NSFontAttributeName: fontmain, NSForegroundColorAttributeName: UIColor.blackText()])
//    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedItem = dataSource[component][row]
        if let callback = actionDidSelect {
            callback(dataSource[component][row])
        } else if let callback = actionDidSelectForComponent {
            callback(dataSource[component][row], component)
        }

    }
}
