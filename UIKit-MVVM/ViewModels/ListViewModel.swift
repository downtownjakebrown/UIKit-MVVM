//
//  See LICENSE file for this project's licensing information.
//

import Foundation
import Combine

/// A view model for our list view
class ListViewModel {
    
    /// The list items for the list view
    @Published var listItems = [ListItem]()
    
    /// The repository for our (pretend) external data source
    private let listRepository = ListRepository()
    
    /// A combine helper
    private var cancellables = Set<AnyCancellable>()
    
    /// A view model for our list view
    init() {
        listRepository.$listItems
        .assign(to: \.listItems, on: self)
        .store(in: &cancellables)
    }
    
    /// Adds a new item to our list of items
    func addListItem(_ title: String) {
        listRepository.addListItem(title)
    }
    
}

