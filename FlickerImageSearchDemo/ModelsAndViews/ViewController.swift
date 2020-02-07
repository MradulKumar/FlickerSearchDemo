//
//  ViewController.swift
//  FlickerImageSearchDemo
//
//  Created by Mradul Kumar  on 30/01/20.
//  Copyright © 2020 Mradul Kumar . All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    private var searchTextField: UITextField?
    private var itemsPerRow: CGFloat = 3.0
    private var padding: CGFloat = 10.0
    private let sectionInsets = UIEdgeInsets(top: 10.0, left: 10.0, bottom: 10.0, right: 10.0)
    private var viewModel = ImagesViewModel()
    private var isFirstTimeActive = true
    private var footerView:CollectionViewReusableFooterView?
    private var photosAnimator = PhotosViewAnimationController()
    private var selectedCell:ImageCollectionViewCell?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        viewModelClosures()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if isFirstTimeActive {
            self.searchTextField?.becomeFirstResponder()
            isFirstTimeActive = false
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func showAlert(title: String = "Flickr", message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction = UIAlertAction(title:NSLocalizedString("OK", comment: ""), style: UIAlertAction.Style.default) {(action) in
        }
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
}

//MARK:- View Rotation
extension ViewController {
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
}

//MARK:- Configure UI
extension ViewController {
    
    fileprivate func configureUI() {
        
        // Nav bar styling
        self.navigationController?.navigationBar.barTintColor = UIColor.darkGray
        self.navigationController?.navigationBar.tintColor = UIColor.darkGray
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor:UIColor.black]
        self.navigationController?.navigationBar.isHidden = false
        
        // Setting up search bar & options button
        let navitem = UINavigationItem()
        let organiseItem = UIBarButtonItem.init(image: UIImage.init(named: "OptionsIcon"), style: .done, target: self, action: #selector(optionsButtonTapped(sender:)))
        organiseItem.tintColor = .white
        navitem.rightBarButtonItem = organiseItem
        
        let btnFrame = organiseItem.customView?.bounds
        var textFieldFrame = CGRect(x:5, y:5, width: 0, height:34)
        textFieldFrame.size.width = self.view.bounds.size.width - (btnFrame?.size.width ?? 100) - 10 // 10:offset
        self.searchTextField = UITextField.init(frame: textFieldFrame)
        self.searchTextField?.borderStyle = .roundedRect
        self.searchTextField?.delegate = self
        self.searchTextField?.backgroundColor = .white
        self.searchTextField?.placeholder = "Type here to search"
        self.searchTextField?.textColor = .black
        self.searchTextField?.returnKeyType = .search
        self.searchTextField?.clearButtonMode = .whileEditing
        navitem.leftBarButtonItem = UIBarButtonItem.init(customView: self.searchTextField!)
        self.navigationController?.navigationBar.setItems([navitem], animated: true)
        
        //setting up collection view
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: ImageCollectionViewCell.nibName, bundle: nil), forCellWithReuseIdentifier:ImageCollectionViewCell.nibName)
        collectionView.register(CollectionViewReusableFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter, withReuseIdentifier: CollectionViewReusableFooterView.reusableIdentifier)
        if let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionInset = sectionInsets
        }
        collectionView.contentInsetAdjustmentBehavior = .never
    }
}

//MARK:- UITextFieldDelegate
extension ViewController : UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        guard let text = textField.text, text.count > 1 else {
            self.searchTextField?.resignFirstResponder()
            return true;
        }
        
        let searchText = text.components(separatedBy: .whitespaces).joined()
        searchImage(searchText)
        return true;
    }
    
}

//MARK:- Actions
extension ViewController {
    
    @objc func optionsButtonTapped(sender: UIBarButtonItem) {
        print("Options button tapped");
        showViewOptionsForTiles()
    }
    
    func searchImage(_ text:String) {
        //cancelling all operations when search text changes
        ImageDownloadManager.shared.cancelAllDownloadOperations()
        
        self.searchTextField?.resignFirstResponder()
        viewModel.search(text: text) {
            
        }
    }
}


//MARK:- Action Sheet
extension ViewController {
    
    func showViewOptionsForTiles() {
        
        let actionSheet = UIAlertController.init(title: "View Options", message: "Select images per row :", preferredStyle: .actionSheet)
        
        let cancelActionButton = UIAlertAction(title: "Cancel", style: .cancel) { _ in
            print("Cancel")
        }
        actionSheet.addAction(cancelActionButton)
        
        let option2 = UIAlertAction(title: "2", style: .default) { _ in
            self.displayOptionChanged(value : 2)
        }
        actionSheet.addAction(option2)
        let option3 = UIAlertAction(title: "3", style: .default) { _ in
            self.displayOptionChanged(value : 3)
        }
        actionSheet.addAction(option3)
        let option4 = UIAlertAction(title: "4", style: .default){ _ in
            self.displayOptionChanged(value : 4)
        }
        actionSheet.addAction(option4)
        
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func displayOptionChanged(value:Int) {
        itemsPerRow = CGFloat(value)
        collectionView.layoutIfNeeded()
        collectionView.collectionViewLayout.invalidateLayout()
        collectionView.reloadData()
    }
    
    func openPhotoDetailViewControllerForItem(_ model:FlickrPhoto) {
        guard let image = self.selectedCell?.getImage() else {
            self.showAlert(message: "Image not found yet!!!")
            return
        }
        
        let photoView = PhotoDetailViewController.init(nibName: "PhotoDetailViewController", bundle: Bundle.main)
        photoView.image = image
        photoView.transitioningDelegate = self
        self.present(photoView, animated: true, completion: nil)
        
    }
}

//MARK:- UIVIewControllerTransitionDelegate

extension ViewController : UIViewControllerTransitioningDelegate {
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        photosAnimator.originFrame = self.selectedCell!.superview!.convert(self.selectedCell!.frame, to: nil)
        photosAnimator.presenting = true
        return photosAnimator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        return nil
        
        // we can also write our custom code here
    }
}

//MARK:- Clousers
extension ViewController {
    
    fileprivate func viewModelClosures() {
        
        viewModel.showAlert = { [weak self] (message) in
            self?.searchTextField?.resignFirstResponder()
            self?.showAlert(message: message)
        }
        
        viewModel.dataUpdated = { [weak self] in
            print("data source updated")
            self?.footerView?.stopAnimating()
            self?.collectionView.reloadData()
        }
        
        photosAnimator.dismissCompletion = {
            self.selectedCell?.isHidden = false
        }
        
    }
    
    private func loadNextPage() {
        viewModel.fetchNextPage {
        }
    }
}

//MARK:- UICollectionViewDataSource
extension ViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        var reusableview:UICollectionReusableView?;
        
        if(kind == UICollectionView.elementKindSectionFooter) {
            self.footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: CollectionViewReusableFooterView.reusableIdentifier, for: indexPath) as? CollectionViewReusableFooterView
            self.footerView?.startAnimating()
            reusableview = self.footerView
        }
        
        return reusableview!
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        let width = collectionView.bounds.size.width
        let height:CGFloat = 50.0
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.photoArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageCollectionViewCell.nibName, for: indexPath) as! ImageCollectionViewCell
        cell.imageView.image = nil
        return cell
    }
    
    // will display cell method : call to download image starts here
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let cell = cell as? ImageCollectionViewCell else {
            return
        }
        
        let model = viewModel.photoArray[indexPath.row]
        cell.model = ImageModel.init(withPhoto: model)
        
        if indexPath.row == (viewModel.photoArray.count - 1) {
            loadNextPage()
        }
    }
}

//MARK:- UICollectionViewDelegate
extension ViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let model = viewModel.photoArray[indexPath.row]
        self.selectedCell = collectionView.cellForItem(at: indexPath) as? ImageCollectionViewCell
        self.openPhotoDetailViewControllerForItem(model)
    }
}

//MARK:- UICollectionViewDelegateFlowLayout
extension ViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let paddingSpace = sectionInsets.left * (itemsPerRow + 1)
        let availableWidth = collectionView.bounds.width - paddingSpace
        let width = availableWidth / itemsPerRow
        return CGSize(width: width, height: width)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return sectionInsets
    }
    
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return sectionInsets.left
    }
    
    
}

//MARK:- scrollViewDidEndDecelerating
//Priority Updation
extension ViewController: UIScrollViewDelegate {
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let visibleIndexPaths:[IndexPath]? = collectionView.indexPathsForVisibleItems
        if(visibleIndexPaths?.count == 0) {
            return
        }
        var photosModelArr:[FlickrPhoto] = [FlickrPhoto]()
        for indexPath in visibleIndexPaths! {
            let row = indexPath[1]
            photosModelArr.append(viewModel.photoArray[row])
        }
        ImageDownloadManager.shared.updateOperationsPriority(forImages : photosModelArr)
    }
}

