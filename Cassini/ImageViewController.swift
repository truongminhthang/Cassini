//
//  ImageViewController.swift
//  Cassini
//
//  Created by Trương Thắng on 4/8/17.
//  Copyright © 2017 Trương Thắng. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController {

    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.delegate = self
            scrollView.contentSize = imageView.frame.size
            scrollView.maximumZoomScale = 1
            scrollView.minimumZoomScale = 0.03
            
        }
    }
    var imageURL: URL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private func fetchImage() {
        guard let url = imageURL else {return}
        DispatchQueue.global(qos: .userInitiated).async {
            guard let data = try? Data(contentsOf: url) else {return}
            DispatchQueue.main.async {[unowned self] in
                self.image = UIImage(data: data)
            }
        }
        
    }

    
    var imageView = UIImageView()
    private var image: UIImage? {
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
        }
        get {
            return imageView.image
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
        
        
    }
}

// MARK: - UIScrollViewDelegate

extension ImageViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}
