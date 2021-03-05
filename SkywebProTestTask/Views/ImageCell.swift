//
//  ImageCell.swift
//  SkywebProTestTask
//
//  Created by Ярослав Карпунькин on 04.03.2021.
//

import Foundation
import UIKit

protocol ImageCellViewModel {
    var url: String { get }
    var width: Int { get }
    var height: Int { get }
}

class ImageCell: UICollectionViewCell {
    //MARK: - Variables
    public static let reuseId = "ImageCell"
    
    
    //MARK: - Controls
    private var scrollView: UIScrollView = {
      let view = UIScrollView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .clear
        return view
    }()
    
    private var imageView: WebImageView = {
        let imageView = WebImageView()
         imageView.translatesAutoresizingMaskIntoConstraints = false
         imageView.backgroundColor = .clear
         return imageView
    }()
    
    //MARK: - Lifecycle
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = #colorLiteral(red: 0.6242458093, green: 0.6221778342, blue: 0.6779795175, alpha: 1)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        imageView.resetUrl()
        for view in subviews {
            view.removeFromSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if scrollView.contentSize.height > scrollView.frame.height {
            scrollView.isUserInteractionEnabled = true
        } else {
            scrollView.isUserInteractionEnabled = false
        }
    }
    
    //MARK: - Funcs
    public func configure(model: ImageCellViewModel) {
        imageView.set(imageURL: model.url)
        setupConstraints(model: model)
    }
}

//MARK: - Constraints
extension ImageCell {
    private func setupConstraints(model: ImageCellViewModel) {
        addSubview(scrollView)
        scrollView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        scrollView.addSubview(imageView)
        imageView.snp.makeConstraints { (make) in
            make.top.left.equalToSuperview()
            make.width.equalTo(snp.width)
            //Высчитываем отношение высоты к ширине; ширина фиксированная(равна ширине superview) => легко находим высоту
            let ratio = CGFloat(model.height) / CGFloat(model.width)
            make.height.equalTo(snp.width).multipliedBy(ratio)
            make.bottom.equalToSuperview()
        }
    }
}
