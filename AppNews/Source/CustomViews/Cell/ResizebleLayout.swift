//
//  ResizebleLayout.swift
//  AppNews
//
//  Created by Евгений Ганусенко on 5/9/22.
//

import UIKit

struct UIHelper {
    static let standartHeight: CGFloat = 100
    static let featuredHeight: CGFloat = 280
}

class ResizebleLayout: UICollectionViewLayout {

    let dragOffset: CGFloat = UIHelper.featuredHeight - UIHelper.standartHeight

    var cacheAttributes = [UICollectionViewLayoutAttributes]()

    var featuredItemIndex: Int {
        max(0, Int(collectionView!.contentOffset.y / dragOffset))
    }

    // коэфициент наплыва ячейки
    var procentageOffset: CGFloat {
        collectionView!.contentOffset.y / dragOffset - CGFloat(featuredItemIndex)
    }

    var widht: CGFloat {
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
            width: widht,
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

            var height = UIHelper.standartHeight

            if path.item == featuredItemIndex {
                y = collectionView!.contentOffset.y - UIHelper.standartHeight * procentageOffset
                height = UIHelper.featuredHeight
            } else if path.item == (featuredItemIndex + 1) {
                height = UIHelper.standartHeight + max(0, dragOffset * procentageOffset)
                let maxY = y + UIHelper.standartHeight
                y = maxY - height
            }

            frame = CGRect(x: 0, y: y, width: widht, height: height)
            atribures.frame = frame
            atribures.zIndex = index
            cacheAttributes.append(atribures)

            y = frame.maxY
        }
    }

    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        var result = [UICollectionViewLayoutAttributes]()

        for attributes in cacheAttributes {
            if attributes.frame.intersects(rect) {
                result.append(attributes)
            }
        }

        return result
    }

    override func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint) -> CGPoint {
        let index = round(proposedContentOffset.y / dragOffset)
        let y = index * dragOffset
        return CGPoint(x: 0, y: y)
    }
}
