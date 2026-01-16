//
//  SMTableReusable.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import UIKit

protocol SMTableReusable {}

extension SMTableReusable where Self: UITableViewCell {
    static var smReuseIdentifier: String {
        return String(describing: self)
    }
}

extension UITableViewCell: SMTableReusable {}

extension UITableView {
    func smRegisterCell<T: UITableViewCell>(_: T.Type) {
        register(T.self, forCellReuseIdentifier: T.smReuseIdentifier)
    }
    
    func smDequeueReusableCell<T: UITableViewCell>(forIndexPath indexPath: IndexPath) -> T {
        guard let cell = dequeueReusableCell(
            withIdentifier: T.smReuseIdentifier,
            for: indexPath
        ) as? T else {
            fatalError("Could not dequeue \(T.smReuseIdentifier) cell.")
        }
        return cell
    }
}
