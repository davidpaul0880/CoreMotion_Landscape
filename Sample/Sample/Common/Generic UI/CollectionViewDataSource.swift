//
//  CollectionViewDataSource.swift
//  bitreel
//
//  Created by ZCo Engg Dept on 02/05/17.
//  Copyright © 2017 bitreel. All rights reserved.
//

import UIKit
@objc protocol CollectionViewCellSizeDelegate: class {
    func getCellSize(_ collectionView: UICollectionView, count: Int, indexPath: IndexPath) -> CGSize
    //@objc optional func getInsetForSectionAt(_ section: Int, collectionView: UICollectionView, count: Int) -> UIEdgeInsets
}

final class CollectionViewDataSource<Model, Cell: UICollectionViewCell>: NSObject, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout where Cell: CellConfigurable, Model == Cell.Controller { //Cell: Reusable, 
    var dataSource: [Model] = [] {
        didSet { collectionView.reloadData() }
    }
    func reloadCollections() {
        collectionView.reloadData()
    }
    var searchDataSource: [Model]? {
        didSet {
            //isSearching = searchDataSource != nil
            collectionView.reloadData()
        }
    }
    weak var cellSizeDelegate: CollectionViewCellSizeDelegate?
    var actionHandler: ((Model, IndexPath) -> Void)?
    fileprivate unowned var collectionView: UICollectionView
    init(collectionView: UICollectionView) {
        self.collectionView = collectionView
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let searchSource = searchDataSource {
            return searchSource.count
        }
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell: Cell = collectionView.dequeueReusableCell(indexPath: indexPath)
        if let searchSource = searchDataSource {
            cell.cellController = searchSource[indexPath.row]
        } else {
            cell.cellController = dataSource[indexPath.row]
        }
        cell.configureCellAtIndexPath(indexPath: indexPath)
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let searchSource = searchDataSource {
            actionHandler?(searchSource[indexPath.row], indexPath)
        } else {
            actionHandler?(dataSource[indexPath.row], indexPath)
        }
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.cellSizeDelegate?.getCellSize(collectionView, count: dataSource.count, indexPath: indexPath) ?? CGSize(width: collectionView.frame.size.width, height: 44)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0.0
    }
    deinit {
        printDebug("\(String(describing: self)) is being deInitialized.")
    }
}
