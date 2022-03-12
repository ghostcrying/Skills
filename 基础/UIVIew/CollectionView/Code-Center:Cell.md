```
class BlockRecordResultExtraLayout: UICollectionViewFlowLayout {
    
    private var contentRect: CGRect = .zero
    private var itemAttributes: [IndexPath:UICollectionViewLayoutAttributes] = [:]
    
    override var collectionViewContentSize: CGSize {
        return contentRect.size
    }
    
    override func prepare() {
        super.prepare()
        
        scrollDirection = .horizontal
        
        itemAttributes.removeAll()
        contentRect = .zero
        
        guard let `collectionView` = collectionView, let dataSource = collectionView.dataSource else {
            return
        }
        
        contentRect = CGRect(x: 0, y: 0, width: 0, height: collectionView.bounds.height)
        
        let insetForSection = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        let interitemSpacingForSection: CGFloat = 24
        let itemSize = CGSize(width: collectionView.bounds.height, height: collectionView.bounds.height)
        
        let sectionIndex: Int = 0
        let numberOfItems = dataSource.collectionView(collectionView, numberOfItemsInSection: sectionIndex)
        
        var left: CGFloat = insetForSection.left
        
        for itemIndex in 0..<numberOfItems {
            
            if itemIndex > 0 {
                left += interitemSpacingForSection
            }
            
            let itemIndexPath = IndexPath(item: itemIndex, section: sectionIndex)
            
            let itemAttribute = UICollectionViewLayoutAttributes(forCellWith: itemIndexPath)
            
            itemAttribute.frame = CGRect(x: left, y: 0, width: itemSize.width, height: itemSize.height)
            
            left += itemSize.width
            
            contentRect = contentRect.union(itemAttribute.frame)
            
            itemAttributes[itemIndexPath] = itemAttribute
        }
        
        left += insetForSection.right
        
        contentRect.size.width += insetForSection.right
        
        if numberOfItems > 0, contentRect.width < collectionView.bounds.width {
            let offset = (collectionView.bounds.width - contentRect.width) / 2
            itemAttributes.forEach {
                $0.value.center = CGPoint(x: $0.value.center.x + offset, y: $0.value.center.y)
            }
        }
        
        contentRect.size = CGSize(width: max(collectionView.bounds.width, contentRect.width), height: max(collectionView.bounds.height, contentRect.height))
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        return itemAttributes.compactMap { rect.intersects($0.value.frame) ? $0.value : nil }
    }
    
    override func layoutAttributesForItem(at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return itemAttributes[indexPath]
    }
    
    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
        return super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath)
    }
    
    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
}


```





