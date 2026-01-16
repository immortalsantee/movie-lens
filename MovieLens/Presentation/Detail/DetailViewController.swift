//
//  DetailViewController.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/16/26.
//

import UIKit
import Combine

final class DetailViewController: UIViewController {

    private let viewModel: DetailViewModel
    private var cancellables = Set<AnyCancellable>()

    private let scrollView: UIScrollView = {
        let v = UIScrollView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let contentView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let backdropImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let gradientView: UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let playButton: UIButton = {
        let b = UIButton(type: .system)
        b.setImage(UIImage(systemName: "play.circle.fill"), for: .normal)
        b.tintColor = .white
        b.translatesAutoresizingMaskIntoConstraints = false
        b.contentVerticalAlignment = .fill
        b.contentHorizontalAlignment = .fill
        return b
    }()

    private let titleLabel: UILabel = {
        let l = UILabel()
        l.font = .boldSystemFont(ofSize: 26)
        l.textColor = .white
        l.numberOfLines = 2
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()

    private let genreStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.spacing = 8
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let ratingStack: UIStackView = {
        let s = UIStackView()
        s.axis = .horizontal
        s.distribution = .equalSpacing
        s.translatesAutoresizingMaskIntoConstraints = false
        return s
    }()

    private let posterImageView: UIImageView = {
        let v = UIImageView()
        v.contentMode = .scaleAspectFill
        v.clipsToBounds = true
        v.layer.cornerRadius = 8
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()

    private let overviewLabel: UILabel = {
        let l = UILabel()
        l.font = .systemFont(ofSize: 16)
        l.textColor = .label
        l.numberOfLines = 0
        return l
    }()
    
    

    init(viewModel: DetailViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setupUI()
        bind()
        setupNavigationBar()
        viewModel.loadMovie()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        gradientView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }

        let g = CAGradientLayer()
        g.frame = gradientView.bounds
        g.colors = [
            UIColor.clear.cgColor,
            UIColor.black.withAlphaComponent(0.85).cgColor
        ]
        g.locations = [0.35, 1.0]
        gradientView.layer.addSublayer(g)
    }

    private func bind() {
        viewModel.$movie
            .compactMap { $0 }
            .sink { [weak self] movie in
                self?.configure(movie)
                
                self?.genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
                let names = GenreStore.shared.names(for: movie.genre_ids ?? [])
                names.forEach { self?.genreStack.addArrangedSubview(self!.makeGenre($0)) }
            }
            .store(in: &cancellables)
    }
    
    private func updateUI() {
        let names = viewModel.genreNames
        genreStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        names.forEach {
            genreStack.addArrangedSubview(makeGenre($0))
        }
    }
}

// MARK: - UI
private extension DetailViewController {

    func setupUI() {
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)

        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),

            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor)
        ])

        contentView.addSubview(backdropImageView)
        contentView.addSubview(gradientView)
        contentView.addSubview(playButton)
        contentView.addSubview(titleLabel)
        contentView.addSubview(genreStack)

        NSLayoutConstraint.activate([
            backdropImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            backdropImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            backdropImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            backdropImageView.heightAnchor.constraint(equalToConstant: 280),

            gradientView.topAnchor.constraint(equalTo: backdropImageView.topAnchor),
            gradientView.leadingAnchor.constraint(equalTo: backdropImageView.leadingAnchor),
            gradientView.trailingAnchor.constraint(equalTo: backdropImageView.trailingAnchor),
            gradientView.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor),

            playButton.centerXAnchor.constraint(equalTo: backdropImageView.centerXAnchor),
            playButton.centerYAnchor.constraint(equalTo: backdropImageView.centerYAnchor),
            playButton.widthAnchor.constraint(equalToConstant: 64),
            playButton.heightAnchor.constraint(equalToConstant: 64),

            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            titleLabel.bottomAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: -16),

            genreStack.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            genreStack.bottomAnchor.constraint(equalTo: titleLabel.topAnchor, constant: -8)
        ])

        contentView.addSubview(ratingStack)

        NSLayoutConstraint.activate([
            ratingStack.topAnchor.constraint(equalTo: backdropImageView.bottomAnchor, constant: 16),
            ratingStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 32),
            ratingStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -32)
        ])

        contentView.addSubview(posterImageView)

        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: ratingStack.bottomAnchor, constant: 20),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            posterImageView.widthAnchor.constraint(equalToConstant: 120),
            posterImageView.heightAnchor.constraint(equalTo: posterImageView.widthAnchor, multiplier: 71/47)
        ])

        let overviewStack = UIStackView(arrangedSubviews: [overviewLabel])
        overviewStack.axis = .vertical
        overviewStack.spacing = 12
        overviewStack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(overviewStack)

        NSLayoutConstraint.activate([
            overviewStack.topAnchor.constraint(equalTo: posterImageView.topAnchor),
            overviewStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 16),
            overviewStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            overviewStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -24)
        ])
    }
}

// MARK: - Configure
private extension DetailViewController {

    func configure(_ movie: Movie) {
        title = movie.title
        titleLabel.text = movie.title
        overviewLabel.text = movie.overview

        ratingStack.arrangedSubviews.forEach { $0.removeFromSuperview() }
        ratingStack.addArrangedSubview(makeRating("Release", movie.release_date ?? ""))
        ratingStack.addArrangedSubview(makeRating("Rating", String(format: "%.1f", movie.vote_average ?? 0)))
        ratingStack.addArrangedSubview(makeRating("Reviews", "\(movie.vote_count ?? 0)"))
        
        posterImageView.smSetImage(from: movie.poster_path)
        backdropImageView.smSetImage(from: movie.backdrop_path)
        
        navigationItem.rightBarButtonItem?.image = UIImage(systemName: (movie.is_favorite ?? false) ? "heart.fill" : "heart")
    }

    func makeGenre(_ text: String) -> UILabel {
        let l = UILabel()
        l.text = " \(text) "
        l.font = .systemFont(ofSize: 12, weight: .medium)
        l.textColor = .white
        l.backgroundColor = UIColor.white.withAlphaComponent(0.25)
        l.layer.cornerRadius = 5
        l.clipsToBounds = true
        return l
    }

    func makeRating(_ title: String, _ value: String) -> UIStackView {
        let v = UILabel()
        v.text = value
        v.font = .boldSystemFont(ofSize: 16)
        v.textColor = .label

        let t = UILabel()
        t.text = title
        t.font = .systemFont(ofSize: 12)
        t.textColor = .secondaryLabel

        let s = UIStackView(arrangedSubviews: [v, t])
        s.axis = .vertical
        s.alignment = .center
        return s
    }
}

private extension DetailViewController {

    private func setupNavigationBar() {
        let favButton = UIBarButtonItem(
            image: UIImage(systemName: "heart"),
            style: .plain,
            target: self,
            action: #selector(favoriteTapped)
        )
        favButton.tintColor = .systemRed
        navigationItem.rightBarButtonItem = favButton
    }
    
    @objc private func favoriteTapped() {
        viewModel.toggleFavorite()
    }
}
