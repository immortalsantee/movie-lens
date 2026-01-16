//
//  SMVCReusable.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

import UIKit

//MARK:- UIStoryboard
protocol SMVCReusable {}

extension SMVCReusable where Self: UIViewController {
    static var smReuseIdentifier:String {
        return String(describing: self)
    }
}

extension UIViewController: SMVCReusable {}

extension UIStoryboard {
    func smInstantiateViewController<T:UIViewController>(_:T.Type) -> T {
        guard let vc = self.instantiateViewController(withIdentifier: T.smReuseIdentifier) as? T else {
            fatalError("Could not instantiate view controller named = \(T.smReuseIdentifier)")
        }
        return vc
    }
}
