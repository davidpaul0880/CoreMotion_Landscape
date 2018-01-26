/*
 * Copyright (c) 2015-2016 Razeware LLC
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 */
import Foundation
import UIKit

enum CellAction: Int {
    case cellTapped = 0
}
protocol CellConfigurable: class {
    associatedtype Controller
    var cellController: Controller? { get set }
    var cellItemTapped: ((Controller, IndexPath?) -> Void)? {get set}
    var tappedIndexPath: IndexPath? {get set}
    func configureCellAtIndexPath(indexPath: IndexPath)
}
protocol CellHaveCollectionView: class {
    var collectionViewOffset: CGFloat? {get set}
}
extension CellHaveCollectionView {
    var collectionViewOffset: CGFloat? {
        get {
            return 0
        }
        set {
            printDebug("default tappedIndexPath")
        }
    }
}
extension CellConfigurable {
    func configureCellAtIndexPath(indexPath: IndexPath) {}
    var cellItemTapped: ((Controller, IndexPath?) -> Void)? {
        get {
            return nil
        }
        set {
            printDebug("default cellItemTapped")
        }
    }
    var tappedIndexPath: IndexPath? {
        get {
            return nil
        }
        set {
            printDebug("default tappedIndexPath")
        }
    }
}
