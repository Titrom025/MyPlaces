//
//  NewPlaceVC.swift
//  MyPlaces
//
//  Created by Roman Titkov on 27.07.2020.
//  Copyright © 2020 Roman Titkov. All rights reserved.
//

import UIKit

class NewPlaceVC: UITableViewController {
    
    var currentPlace: Place!
    
    var imageIsChanged = false
    
    @IBOutlet weak var saveBtn: UIBarButtonItem!
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveBtn.isEnabled = false
        placeName.addTarget(self, action: #selector(textFieldChange), for: .editingChanged)
        
        setupEditScreen()
        
    }
    
    // MARK: TableViewDelegate
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            let actionSheet = UIAlertController(title: nil,
                                                message: nil,
                                                preferredStyle: .actionSheet)
            
            let cameraIcon = #imageLiteral(resourceName: "camera")
            let photoIcon = #imageLiteral(resourceName: "photo")
            
            let camera = UIAlertAction(title: "Camera", style: .default) { (_) in
                self.chooseImagePicker(source: .camera)
            }
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let photo = UIAlertAction(title: "Photo", style: .default) { (_) in
                self.chooseImagePicker(source: .photoLibrary)
            }
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
            
        } else {
            view.endEditing(true)
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMap" { return }
        
        let mapVC = segue.destination as! MapViewController
        mapVC.place.name = placeName.text!
        mapVC.place.location = placeLocation.text
        mapVC.place.type = placeType.text
        mapVC.place.imageData = placeImage.image?.pngData()
    }
    
    func savePlace() {
        
        
        let image = imageIsChanged ? placeImage.image : #imageLiteral(resourceName: "imagePlaceholder")
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData, rating: Double(ratingControl.rating))
        
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    private func setupEditScreen() {
        if currentPlace != nil {
            
            SetupNavigationBar()
            imageIsChanged = true
            
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            ratingControl.rating = Int(currentPlace.rating)
        }
    }
    
    private func SetupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveBtn.isEnabled = true
        
    }
    
}


// MARK: TextFieldDelegate

extension NewPlaceVC: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChange() {
        if placeName.text!.isEmpty == false {
            saveBtn.isEnabled = true
        } else {
            saveBtn.isEnabled = false
        }
    }
}

// MARK: Work With Image

extension NewPlaceVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePickerController = UIImagePickerController()
            imagePickerController.delegate = self
            
            imagePickerController.allowsEditing = true
            imagePickerController.sourceType = source
            
            present(imagePickerController, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        placeImage.image = info[.editedImage] as? UIImage
        placeImage.contentMode = .scaleAspectFill
        placeImage.clipsToBounds = true
        imageIsChanged = true
        
        dismiss(animated: true)
    }
}
