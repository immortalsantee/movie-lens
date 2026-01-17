//
//  MovieTableViewCell.swift
//  MovieLens
//
//  Created by Santosh Maharjan on 1/13/26.
//

import UIKit

class MovieTableViewCell: UITableViewCell {
    
    //MARK: - UI
    private let loader: UIActivityIndicatorView = {
        let v = UIActivityIndicatorView(style: .medium)
        v.hidesWhenStopped = true
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    private let posterImageView: UIImageView = {
        let iv = UIImageView()
        iv.contentMode = .scaleAspectFill
        iv.clipsToBounds = true
        iv.layer.cornerRadius = 12
        iv.backgroundColor = .systemGray5
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let favoriteBadge: UIImageView = {
       let iv = UIImageView()
       iv.image = UIImage(systemName: "heart.fill")
       iv.tintColor = .systemRed
       iv.backgroundColor = UIColor.black.withAlphaComponent(0.4)
       iv.layer.cornerRadius = 10
       iv.clipsToBounds = true
       iv.contentMode = .center
       iv.translatesAutoresizingMaskIntoConstraints = false
       iv.isHidden = true
       return iv
   }()
   
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 16)
        label.numberOfLines = 2
        return label
    }()
    
    private let releaseDateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 13)
        label.textColor = .secondaryLabel
        return label
    }()
    
    private let overviewLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 3
        return label
    }()
    
    private let textStack: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 4
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    //MARK: - Override init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        posterImageView.smCancelImageLoad()
        posterImageView.image = nil
        titleLabel.text = nil
        releaseDateLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //MARK: -  Setup
    private func setupUI() {
        contentView.addSubview(posterImageView)
        contentView.addSubview(textStack)
        posterImageView.addSubview(loader)
        posterImageView.addSubview(favoriteBadge)

        
        textStack.addArrangedSubview(titleLabel)
        textStack.addArrangedSubview(releaseDateLabel)
        textStack.addArrangedSubview(overviewLabel)
        
        NSLayoutConstraint.activate([
            posterImageView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            posterImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 10),
            posterImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            posterImageView.widthAnchor.constraint(equalToConstant: 100),
            
            textStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            textStack.leadingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: 10),
            textStack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            textStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -10),
            
            loader.centerXAnchor.constraint(equalTo: posterImageView.centerXAnchor),
            loader.centerYAnchor.constraint(equalTo: posterImageView.centerYAnchor),
            
            favoriteBadge.topAnchor.constraint(equalTo: posterImageView.topAnchor, constant: 4),
            favoriteBadge.trailingAnchor.constraint(equalTo: posterImageView.trailingAnchor, constant: -4),
            favoriteBadge.widthAnchor.constraint(equalToConstant: 24),
            favoriteBadge.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    
    //MARK: - Configure
    func configure(movie: Movie) {
        titleLabel.text = movie.title
        releaseDateLabel.text = movie.releaseDate
        overviewLabel.text = movie.overview
        
        // Start loader
        loader.startAnimating()
        posterImageView.image = nil
        
        posterImageView.smSetImage(from: movie.posterPath) { [weak self] in
            guard let self = self else { return }
            self.loader.stopAnimating()
        }
        
        favoriteBadge.isHidden = !(movie.isFavorite ?? false)
    }
}
