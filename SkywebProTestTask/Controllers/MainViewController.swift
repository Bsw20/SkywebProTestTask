//
//  MainViewController.swift
//  SkywebProTestTask
//
//  Created by Ярослав Карпунькин on 04.03.2021.
//

import Foundation
import UIKit
import SnapKit
import SwiftyBeaver

class MainViewController: UIViewController {
    //MARK: - Variables
    private var service: ImageDataFetcher = NetworkService()
    private var model: ImageAPIResponse = .init(images: [])
    
    //MARK: - Controls
    private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    
    //MARK: - VC Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = #colorLiteral(red: 0.6025224368, green: 0.823663052, blue: 1, alpha: 1)
        
        configure()
        setupConstraints()
        
        addImages()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.isNavigationBarHidden = true
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    //MARK: - Funcs
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offSetX = scrollView.contentOffset.x
        var contentWidth = scrollView.contentSize.width
        contentWidth -= UIScreen.main.bounds.width
        if offSetX > contentWidth{
            addImages()
        }
    }
    private func configure() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ImageCell.self, forCellWithReuseIdentifier: ImageCell.reuseId)
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
        collectionView.alwaysBounceHorizontal = true
    }
    
    private func addImages() {
        DispatchQueue.global(qos: .userInteractive).async {
            self.service.getImages {[weak self] (result) in
                switch result {
                
                case .success(let data):
                    switch ImageAPIResponse.parseToModel(data: data) {
                    
                    case .success(let model):
                        self?.model.addImages(images: model.images)
                        DispatchQueue.main.async {
                            self?.collectionView.reloadData()
                        }

                    case .failure(let error):
                        UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
                    }
                case .failure(let error):
                    UIApplication.showAlert(title: "Ошибка!", message: error.localizedDescription)
                }
            }
        }
    }
}

//MARK: - CollectionView Delegate&DataSource
extension MainViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return model.images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCell.reuseId, for: indexPath) as? ImageCell else {
            fatalError("Can't cast to ImageCell")
        }
        cell.configure(model: model.images[indexPath.item])
        return cell
    }
    
}

//MARK: - UICollectionViewDelegateFlowLayout
extension MainViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let bounds = collectionView.bounds
        let width = bounds.width * 0.8
        let height = width * 9 / 16
        return CGSize(width: width, height: height)
    }
}

//MARK: - Constraints
extension MainViewController {
    private func setupConstraints() {
        view.addSubview(collectionView)
        collectionView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(view.safeAreaLayoutGuide)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(10)
        }
    }
}
