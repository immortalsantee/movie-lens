//
//  UIImageView+AsyncLoad.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

import UIKit

private var imageTaskKey: UInt8 = 0

extension UIImageView {

    private var currentTask: Task<Void, Never>? {
        get { objc_getAssociatedObject(self, &imageTaskKey) as? Task<Void, Never> }
        set { objc_setAssociatedObject(self, &imageTaskKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC) }
    }

    func smSetImage(
        from path: String?,
        placeholder: UIImage? = UIImage(named: "moviePlaceholder"),
        contentMode: UIView.ContentMode = .scaleAspectFill,
        fadeIn: Bool = false,
        onDone: (() -> Void)? = nil
    ) {
        currentTask?.cancel()
        
        self.contentMode = contentMode

        currentTask = Task { [weak self] in
            guard let self else { return }

            let image = await SMImageLoader.shared.loadImage(path: path)

            if Task.isCancelled {
                await MainActor.run { onDone?() }
                return
            }

            await MainActor.run {
                if let _image = image {
                    if fadeIn {
                        self.alpha = 0
                        self.image = _image
                        UIView.animate(withDuration: 0.25) {
                            self.alpha = 1
                        }
                    } else {
                        self.image = _image
                    }
                } else {
                    self.image = placeholder
                }

                self.contentMode = contentMode
                onDone?()
            }
        }
    }

    func smCancelImageLoad() {
        currentTask?.cancel()
        currentTask = nil
        image = nil
    }
}
