//
//  ResizebleLayout.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/9/22.
//

import UIKit

struct UIHelper {
    static let standardHeight: CGFloat = 100
    static let featuredHeight: CGFloat = 250
}

class ResizebleLayout: UICollectionViewLayout {

    let dragOffset: CGFloat = UIHelper.featuredHeight - UIHelper.standardHeight

    var cacheAttributes = [UICollectionViewLayoutAttributes]()

    var featuredItemIndex: Int {
        max(0, Int(collectionView!.contentOffset.y / dragOffset))
    }

    // коэфициент наплыва ячейки
    var percentageOffset: CGFloat {
        collectionView!.contentOffset.y / dragOffset - CGFloat(featuredItemIndex)
    }

    var width: CGFloat {
        collectionView!.bounds.width
    }

    var height: CGFloat {
        collectionView!.bounds.height
    }

    var numberOfItems: Int {
        collectionView!.numberOfItems(inSection: 0)
    }
}

extension ResizebleLayout {
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        true
    }

    override var collectionViewContentSize: CGSize {
        CGSize (
            width: width,
            height: CGFloat(numberOfItems) * dragOffset + height - dragOffset
        )
    }

    override func prepare() {
        cacheAttributes.removeAll()

        var frame: CGRect = .zero
        var y: CGFloat = 0

        for index in 0..<numberOfItems {
            let path = IndexPath(item: index, section: 0)
            let atribures = UICollectionViewLayoutAttributes(forCellWith: path)

            var height = UIHelper.standardHeight

            if path.item == featuredItemIndex {
                y = collectionView!.contentOffset.y - UIHelper.standardHeight * percentageOffset
                height = UIHelper.featuredHeight
            } else if path.item == (featuredItemIndex + 1) {
                let maxY = y + UIHelper.standardHeight

                height = UIHelper.standardHeight + max(dragOffset * percentageOffset, 0)
                y = maxY - height
            }

            frame = CGRect(x: 0, y: y, width: width, height: height)
//
            atribures.frame = frame
//
            atribures.zIndex = index
//
            cacheAttributes.append(atribures)
            y = frame.maxY
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var resultAttributes = [UICollectionViewLayoutAttributes]()

        for attributes in cacheAttributes {
            if attributes.frame.intersects(rect) {
                resultAttributes.append(attributes)
            }
        }

        return resultAttributes
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
        let itemIndex = round(proposedContentOffset.y / dragOffset)
        let yOffset = itemIndex * dragOffset
        return CGPoint(x: 0, y: yOffset)
    }
}
