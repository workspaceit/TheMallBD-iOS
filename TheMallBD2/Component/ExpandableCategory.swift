import UIKit

class ExpandableCategory: NSObject {
    
    var category: Categories!
    var isTopLevelCategory: Bool = false
    var isVisible: Bool = false
    var isExpanded: Bool = false
    var isLastChild: Bool = false
    var parentCategory: ExpandableCategory? = nil
    var level: Int = 0
    var isSelected = false
    
    init(category: Categories, isTopLevelCategory: Bool, isVisible: Bool, isExpanded: Bool, isLastChild: Bool, parentCategory: ExpandableCategory?, level: Int, isSelected: Bool) {
        self.category = category
        self.isTopLevelCategory = isTopLevelCategory
        self.isVisible = isVisible
        self.isExpanded = isExpanded
        self.isLastChild = isLastChild
        self.parentCategory = parentCategory
        self.level = level
        self.isSelected = isSelected
    }
    
}
