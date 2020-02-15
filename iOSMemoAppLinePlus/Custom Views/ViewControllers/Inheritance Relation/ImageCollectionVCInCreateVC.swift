//
//  ImageCollectionVCInCreate.swift
//  iOSMemoAppLinePlus
//
//  Created by SEONGJUN on 2020/02/14.
//  Copyright © 2020 Seongjun Im. All rights reserved.
//

import UIKit
import SnapKit
import MobileCoreServices


protocol ImageCollectionVCInCreateVCDelegate: class {
    func presentActionSheetForSelectImageSource()
}


class ImageCollectionVCInCreateVC: ImageCollectionVCInDetailVC {

    
    let imagePicker = UIImagePickerController()
    
    let addImagesButton = CustomButton(backgroundColor: MyColors.KeyColor, title: "이미지 추가하기")
    
    var imagesToAdd: [UIImage]? {
        didSet{
            if imagesToAdd?.isEmpty ?? true {
                showEmptyStateView(with: "사진을 등록하실 수 있습니다.", in: self.view, imageName: "picture")
            } else {
                guard let createVC = self.parent as? CreateNewMemoViewController else {return}
                guard let images = self.imagesToAdd else {return}
                createVC.addedImages = images
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkImagesArrayEmpty()
    }
    
    private func configure() {
        view.addSubview(addImagesButton)
        addImagesButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(collectionView.snp.bottom).offset(10)
            $0.width.equalToSuperview().multipliedBy(0.5)
        }
        addImagesButton.addTarget(self, action: #selector(didTapImageAddButton), for: .touchUpInside)
    }
    
    private func checkImagesArrayEmpty() {
        if imagesToAdd?.isEmpty ?? true {
            showEmptyStateView(with: "사진을 등록하실 수 있습니다.", in: self.view, imageName: "picture")
        }
    }
    
    @objc func didTapImageAddButton() {
        print("tap")
        presentActionSheetForSelectImageSource()
        print("tap")
    }
    
    func presentActionSheetForSelectImageSource() {
        let alert = UIAlertController(title: "선택", message: "", preferredStyle: .alert)
        let takePhoto = UIAlertAction(title: "사진 찍기", style: .default) { (_) in
            guard UIImagePickerController.isSourceTypeAvailable(.camera) else {return}
            
            self.imagePicker.sourceType = .camera
            self.imagePicker.mediaTypes = [kUTTypeImage, kUTTypeMovie] as [String]
            self.imagePicker.videoQuality = .typeHigh
            
            self.present(self.imagePicker, animated: true)
        }
        let album = UIAlertAction(title: "앨범에서 선택", style: .default) { (_) in
            self.imagePicker.sourceType = .savedPhotosAlbum
            //imagePicker.sourceType = .photoLibrary
            
            self.present(self.imagePicker, animated: true) // 앨범만 띄울 수는 있다
        }
        alert.addAction(takePhoto)
        alert.addAction(album)
        self.present(alert, animated: true)
        
    }
    
    // MARK: - Overridden UICollectionView DataSource
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesToAdd?.count ?? 0
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCellForCollection.identifier, for: indexPath) as! ImageCellForCollection
        guard let image = imagesToAdd?[indexPath.item] else {return cell}
        cell.imageView.image = image
        return cell
    }
    
}


// MARK: - UIImagePickerController Delegate Method

extension ImageCollectionVCInCreateVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        let mediaType = info[.mediaType] as! NSString

        if UTTypeEqual(mediaType, kUTTypeImage) {
            let originalImage = info[.originalImage] as! UIImage
            let editedImage = info[.editedImage] as? UIImage
            let selectedImage = editedImage ?? originalImage
            self.imagesToAdd?.append(selectedImage)
            if picker.sourceType == .camera {
                UIImageWriteToSavedPhotosAlbum(selectedImage, nil, nil, nil)
            }
        } else if UTTypeEqual(mediaType, kUTTypeMovie) {
            if let mediaPath = (info[.mediaURL] as? NSURL)?.path, UIVideoAtPathIsCompatibleWithSavedPhotosAlbum(mediaPath) {
                UISaveVideoAtPathToSavedPhotosAlbum(mediaPath, nil, nil, nil)
            }

        }
        picker.dismiss(animated: true)
    }
}
