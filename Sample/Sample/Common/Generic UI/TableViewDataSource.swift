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

import UIKit

final class TableViewDataSource<Model, Cell: UITableViewCell>: NSObject, UITableViewDataSource, UITableViewDelegate where Cell: CellConfigurable, Model == Cell.Controller { //Cell: Reusable, 
    var dataSource: [Model] = [] {
        didSet {
            if storedOffsets.count > 0 {
                if let cells = tableView.visibleCells as? [CellHaveCollectionView] {
                    for cell in cells {
                        cell.collectionViewOffset = 0
                    }
                }
            }
            storedOffsets.removeAll()
            tableView.reloadData()
        }
    }
    var actionHandler: ((Model, IndexPath) -> Void)?
    var cellSubViewTapped: ((Model, IndexPath?) -> Void)?
    var startToScroll: (() -> Void)?
    var endToScrollTop: (() -> Void)?
    var lastContentOffset = CGPoint.zero
    var isTopViewHidden = false
    var storedOffsets = [Int: CGFloat]()
    fileprivate unowned var tableView: UITableView

    init(tableView: UITableView, hideFooter: Bool = true) {
        self.tableView = tableView
        if hideFooter {
            tableView.tableFooterView = UIView()
        }
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: Cell = tableView.dequeueReusableCell(indexPath: indexPath)
        if let buttonTapped = cellSubViewTapped {

            cell.cellItemTapped = buttonTapped
            cell.tappedIndexPath = indexPath
        }
        cell.cellController = dataSource[indexPath.row]
        printDebug("return cell")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        actionHandler?(dataSource[indexPath.row], indexPath)
    }
    // MARK: UIScrollViewDelegate
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let scrollStart = startToScroll, dataSource.count > 0 else { return }
        let delta = scrollView.contentOffset.y - lastContentOffset.y
        if delta > 0 && isTopViewHidden == false && scrollView.contentOffset.y > 0 {
            scrollStart()
            isTopViewHidden = true
        }
        if delta < 0 && isTopViewHidden == true && scrollView.contentOffset.y < 0 {
            endToScrollTop?()
            isTopViewHidden = false
        }
        lastContentOffset = scrollView.contentOffset
    }
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellConfig = cell as? CellHaveCollectionView else { return }
        printDebug("indexPath.row = \(indexPath.row), storedOffsets[indexPath.row] = \(String(describing: storedOffsets[indexPath.row]))")
        cellConfig.collectionViewOffset = storedOffsets[indexPath.row] ?? 0
    }

    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let cellConfig = cell as? CellHaveCollectionView else { return }
        storedOffsets[indexPath.row] = cellConfig.collectionViewOffset
    }
    deinit {
        printDebug("\(String(describing: self)) is being deInitialized.")
    }
}

