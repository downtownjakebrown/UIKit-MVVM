//
//  See LICENSE file for this project's licensing information.
//

import Foundation

/// A repository for our (pretend) external data source
class ListRepository {
    
    /// The list items for the list view
    @Published var listItems = [ListItem]()
    
    /// A repository for our (pretend) external data source
    init() { loadListItems() }
    
    /// Simulates an async load of data
    private func loadListItems() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.listItems = [
                ListItem("List Item 1"),
                ListItem("List Item 2"),
                ListItem("List Item 3"),
                ListItem("List Item 4")
            ]
        }
    }
    
    /// Adds a new item to our list of items
    func addListItem(_ title: String) {
        self.listItems.append(ListItem(title))
    }
    
}
