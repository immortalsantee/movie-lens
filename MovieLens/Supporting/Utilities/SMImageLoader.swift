//
//  SMImageLoader.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import UIKit

final class SMImageLoader {

    static let shared = SMImageLoader()

    private let memoryCache = NSCache<NSString, UIImage>()
    private let fileManager = FileManager.default
    private let diskQueue = DispatchQueue(label: "com.movielens.imageloader.disk")

    private init() {}

    func loadImage(path: String?) async -> UIImage? {
        guard let path else { return nil }

        let urlString = "https://image.tmdb.org/t/p/w500\(path)"
        let key = urlString as NSString

        if let cached = memoryCache.object(forKey: key) {
            return cached
        }

        if let diskImage = loadFromDisk(for: key as String) {
            memoryCache.setObject(diskImage, forKey: key)
            return diskImage
        }

        guard let url = URL(string: urlString) else { return nil }

        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            guard let image = UIImage(data: data) else { return nil }

            memoryCache.setObject(image, forKey: key)
            saveToDisk(image, for: key as String)

            return image
        } catch {
            return nil
        }
    }

    private func cacheDirectory() -> URL {
        let urls = fileManager.urls(for: .cachesDirectory, in: .userDomainMask)
        let dir = urls[0].appendingPathComponent("SMImageCache", isDirectory: true)

        if !fileManager.fileExists(atPath: dir.path) {
            try? fileManager.createDirectory(at: dir, withIntermediateDirectories: true)
        }
        return dir
    }

    private func fileURL(for key: String) -> URL {
        let fileName = key.replacingOccurrences(of: "/", with: "_")
        return cacheDirectory().appendingPathComponent(fileName)
    }

    private func loadFromDisk(for key: String) -> UIImage? {
        let url = fileURL(for: key)
        guard fileManager.fileExists(atPath: url.path) else { return nil }
        return UIImage(contentsOfFile: url.path)
    }

    private func saveToDisk(_ image: UIImage, for key: String) {
        let url = fileURL(for: key)
        diskQueue.async {
            guard let data = image.pngData() else { return }
            try? data.write(to: url, options: .atomic)
        }
    }
}
