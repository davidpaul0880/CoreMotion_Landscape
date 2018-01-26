//
//  BODUIScrollViewExtension.swift
//  bitreel
//
//  Created by ZCo Engg Dept on 20/04/16.
//  Copyright © 2016 zco. All rights reserved.
//

import Foundation
import UIKit

extension UIScrollView {

    var isAtTop: Bool {
        return contentOffset.y <= verticalOffsetForTop
    }
    var isNearTop: Bool {
        return contentOffset.y <= verticalOffsetForTop + 10
    }
    var isAtBottom: Bool {
        return contentOffset.y >= verticalOffsetForBottom
    }
    var isAtLeft: Bool {
        return contentOffset.x <= horizontalOffsetForLeft
    }

    var isAtRight: Bool {
        return contentOffset.x >= horizontalOffsetForRight
    }
    var verticalOffsetForTop: CGFloat {
        let topInset = contentInset.top
        return -topInset
    }

    var verticalOffsetForBottom: CGFloat {
        let scrollViewHeight = bounds.height
        let scrollContentSizeHeight = contentSize.height
        let bottomInset = contentInset.bottom
        let scrollViewBottomOffset = scrollContentSizeHeight + bottomInset - scrollViewHeight
        return floor(scrollViewBottomOffset)
    }

    var horizontalOffsetForLeft: CGFloat {
        let topInset = contentInset.left
        return -topInset
    }

    var horizontalOffsetForRight: CGFloat {
        let scrollViewWidth = bounds.width
        let scrollContentSizeWidth = contentSize.width
        let rightInset = contentInset.right
        let scrollViewRightOffset = scrollContentSizeWidth + rightInset - scrollViewWidth
        return floor(scrollViewRightOffset)
    }

}
