//
//  SCSearchMainNode+UISearchBarDelegate.swift
//  SCSearch
//
//  Created by Nikita Arutyunov on 12.04.2022.
//

import AsyncDisplayKit
import UIKit

extension SCSearchMainNode: UISearchBarDelegate {
    public func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(true, animated: true)

        delegate?.updateLayoutState()
    }

    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.setShowsCancelButton(false, animated: true)

        delegate?.updateLayoutState()
    }

    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        delegate?.search(searchText)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
