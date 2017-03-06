import UIKit

class ExpandableCategoriesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var preSelectedCategory: Categories? = nil
    var data: [ExpandableCategory] = []
    var allCategories = Utility.categories
    var catIds: [Int] = []
    var hiddenCells: [ExpandableCategoriesTableViewCell] = []
    var fromCategoryPage = false
    
    var alternate = 0
    var colors: [UIColor] = [ UIColor(netHex:0xf5f5f5) ]
    
    @IBOutlet weak var expandableTable: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        allCategories = Utility.categories
        expandableTable.dataSource = self
        expandableTable.delegate = self
        for cat in allCategories {
            catIds.append(cat.id)
        }
        prepareData(allCategories, parent: nil, level: 0)
        var mathedRow = 0
        if preSelectedCategory != nil {
            for (index,exCategory) in self.data.enumerated() {
                if exCategory.category.id == preSelectedCategory!.id {
                    mathedRow = index
                }
            }
        }
        self.expandableTable.reloadData()
        let indexPath = IndexPath(row: mathedRow, section: 1)
        
        if fromCategoryPage {
            self.tableView(self.expandableTable, didSelectRowAt: indexPath)
            self.expandableTable.selectRow(at: indexPath, animated: true, scrollPosition: UITableViewScrollPosition.middle)
        }
    }
    
    func prepareData(_ categories: [Categories], parent: ExpandableCategory?, level: Int) {
        for category in categories {
            var isTopLevelCategory = false
            var isVisible = false
            var isLastChild = false
            var isExpanded = false
            let isSelected = false
            if level == 0 {
                isTopLevelCategory = true
                isVisible = true
                isExpanded = false
//                isSelected = true
            }
            let childCategories = category.childrens
            if childCategories?.count == 0 {
                isLastChild = true
            }
            let exCat = ExpandableCategory(category: category, isTopLevelCategory: isTopLevelCategory, isVisible: isVisible, isExpanded: isExpanded, isLastChild: isLastChild, parentCategory: parent, level: level, isSelected: isSelected)
            data.append(exCat)
            if (childCategories?.count)! > 0 {
                let newLevel = level + 1
                prepareData(childCategories!, parent: exCat, level: newLevel)
            }
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        else {
            return self.data.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if (indexPath as NSIndexPath).section == 0 {
            let cell = expandableTable.dequeueReusableCell(withIdentifier: "ExpandableCategoriesTableViewCell") as! ExpandableCategoriesTableViewCell
            cell.catName.text = "Brands"
            cell.expandableSign.text = ""
            cell.backgroundColor = colors[0]
            alternate += 1
            cell.separator.isHidden = true
            return cell
        }
        else {
            let expandableCategory = self.data[(indexPath as NSIndexPath).row]
            let category = expandableCategory.category
            let cell = expandableTable.dequeueReusableCell(withIdentifier: "ExpandableCategoriesTableViewCell") as! ExpandableCategoriesTableViewCell
            cell.catName.text = category?.title
            cell.expandableSign.text = ""
            cell.backgroundColor = UIColor.white
            if !expandableCategory.isLastChild {
                if expandableCategory.isExpanded {
                    cell.expandableSign.text = "-"
                }
                else {
                    cell.expandableSign.text = "+"
                }
            }
            if expandableCategory.isVisible {
                cell.isHidden = false
            }
            else {
                cell.isHidden = true
                self.hiddenCells.append(cell)
            }
            
            if expandableCategory.level == 0 {
                cell.catName.text = category?.title
                cell.backgroundColor = colors[0]
                alternate += 1
            }
            else if expandableCategory.level == 1 {
                cell.catName.text = "   \(category!.title)"
            }
            else if expandableCategory.level == 2 {
                cell.catName.text = "       \(category!.title)"
            }
            if expandableCategory.isSelected {
                cell.catName.font = UIFont(name:"Whitney-semibold", size: 18.0)
                if expandableCategory.isTopLevelCategory {
                    cell.separator.isHidden = false
                }
            }
            else {
                cell.catName.font = UIFont(name:"Whitney-book", size: 18.0)
                cell.separator.isHidden = true
            }
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if (indexPath as NSIndexPath).section == 0 {
            return 50.0
        }
        else {
            let expandableCategory = self.data[(indexPath as NSIndexPath).row]
            if expandableCategory.isTopLevelCategory || expandableCategory.isVisible {
                return 50.0
            }
            else {
                return 0.0
            }
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if (indexPath as NSIndexPath).section == 0 {
            performSegue(withIdentifier: "BrandPage", sender: nil)
        }
        else {
            let expandableCategory = self.data[(indexPath as NSIndexPath).row]
            if expandableCategory.isLastChild {
                performSegue(withIdentifier: "ProductsByCategory", sender: indexPath)
            }
            else {
                let rows: [Int] = makeChildCategoriesVisibleOrHidden(expandableCategory, parentRow: (indexPath as NSIndexPath).row)
                expandableCategory.isExpanded = !expandableCategory.isExpanded
                expandableCategory.isSelected = !expandableCategory.isSelected
                var indexPathsToReload: [IndexPath] = []
                for row in rows {
                    let indexPath = IndexPath(row: row, section: 1)
                    indexPathsToReload.append(indexPath)
                }
//                self.expandableTable.reloadData()
                self.expandableTable.reloadRows(at: indexPathsToReload, with: .fade)
                if expandableCategory.isTopLevelCategory {
                    self.expandableTable.scrollToRow(at: indexPath, at: UITableViewScrollPosition.top, animated: true)
                }
            }
        }
    }
    
    func makeChildCategoriesVisibleOrHidden(_ exCategory: ExpandableCategory, parentRow: Int) ->[Int] {
        var rows: [Int] = [parentRow]
        for (index, exCat) in self.data.enumerated() {
            if exCat.parentCategory != nil {
                if exCat.parentCategory!.category.id == exCategory.category.id {
                    rows.append(index)
                    if exCategory.isExpanded {
                        hideAllChildren(exCategory)
                    }
                    else {
                        exCat.isVisible = !exCat.isVisible
                    }
                }
            }
        }
        return rows
    }
    
    func hideAllChildren(_ exCategory: ExpandableCategory){
        for expandableCategory in self.data {
            if exCategory.category.id == expandableCategory.parentCategory?.category.id {
                expandableCategory.isVisible = false
                expandableCategory.isExpanded = false
                hideAllChildren(expandableCategory)
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ProductsByCategory" {
            let indexPath = sender as! IndexPath
            let category = self.data[(indexPath as NSIndexPath).row].category
            let destinationVC = segue.destination as! ItemCollectionViewController
            destinationVC.type = "category"
            destinationVC.category = category
        }
    }
    
}
