//
//  ImageViewLoader.swift
//  FeedApp
//
//  Created by James Rochabrun on 3/15/21.
//

import UIKit
import SDWebImage
import MobileCoreServices

final class ImageViewLoader: BaseView, ContentReusable {
    
    private lazy var imageView: PreviewLoaderView = {
        var imageView = PreviewLoaderView(transitionDuration: 0.3)
        imageView.isUserInteractionEnabled = true
        return imageView
    }()
    
    override func setupViews() {
        addSubview(imageView)
        imageView.fillSuperview()
        let dragInteraction = UIDragInteraction(delegate: self)
        dragInteraction.isEnabled = true
        imageView.addInteraction(dragInteraction)
        
        // Enable dropping onto the image view (see ViewController+Drop.swift).
        let dropInteraction = UIDropInteraction(delegate: self)
        imageView.addInteraction(dropInteraction)
        
        let touch = UITapGestureRecognizer(target: self, action: #selector(touched))
     //   touch.delegate = self
        imageView.addGestureRecognizer(touch)
    }
    
    @objc
    func touched() {
        print("zizou ❤️")
    }
    
    func load(regularURL: String, lowResURL: String, placeholder: UIImage?) {
        self.imageView.alpha = 0
        imageView.loadPreviewWith(thumbnailURL: URL(string: lowResURL), previewImageURL: URL(string: regularURL), placeholder: placeholder) { [weak self] _ in
            UIView.animate(withDuration: 0.2) {
                self?.imageView.alpha = 1.0
            }
        }
    }
    
    func cleanAndReuse() {
        imageView.alpha = 1.0
    }
}

extension ImageViewLoader: UIGestureRecognizerDelegate {
    
    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }
}

extension ImageViewLoader: UIDragInteractionDelegate {
    
    /*
         The `dragInteraction(_:itemsForBeginning:)` method is the essential method
         to implement for allowing dragging from a view.
    */
    func dragInteraction(_ interaction: UIDragInteraction, itemsForBeginning session: UIDragSession) -> [UIDragItem] {
        guard let image = imageView.previewImage else { return [] }

        let provider = NSItemProvider(object: image)
        let item = UIDragItem(itemProvider: provider)
        item.localObject = image
        
        /*
             Returning a non-empty array, as shown here, enables dragging. You
             can disable dragging by instead returning an empty array.
        */
        return [item]
    }

    /*
         Code below here adds visual enhancements but is not required for minimal
         dragging support. If you do not implement this method, the system uses
         the default lift animation.
    */
    func dragInteraction(_ interaction: UIDragInteraction, previewForLifting item: UIDragItem, session: UIDragSession) -> UITargetedDragPreview? {
        guard let image = item.localObject as? UIImage else { return nil }
        
        // Scale the preview image view frame to the image's size.
        let frame: CGRect
        if image.size.width > image.size.height {
            let multiplier = imageView.frame.width / image.size.width
            frame = CGRect(x: 0, y: 0, width: imageView.frame.width, height: image.size.height * multiplier)
        } else {
            let multiplier = imageView.frame.height / image.size.height
            frame = CGRect(x: 0, y: 0, width: image.size.width * multiplier, height: imageView.frame.height)
        }

        // Create a new view to display the image as a drag preview.
        let previewImageView = UIImageView(image: image)
        previewImageView.contentMode = .scaleAspectFit
        previewImageView.frame = frame

        /*
             Provide a custom targeted drag preview that lifts from the center
             of imageView. The center is calculated because it needs to be in
             the coordinate system of imageView. Using imageView.center returns
             a point that is in the coordinate system of imageView's superview,
             which is not what is needed here.
         */
        let center = CGPoint(x: imageView.bounds.midX, y: imageView.bounds.midY)
        let target = UIDragPreviewTarget(container: imageView, center: center)
        return UITargetedDragPreview(view: previewImageView, parameters: UIDragPreviewParameters(), target: target)
    }
}

extension ImageViewLoader: UIDropInteractionDelegate {
    // MARK: - UIDropInteractionDelegate
    
    /**
         Ensure that the drop session contains a drag item with a data representation
         that the view can consume.
    */
    func dropInteraction(_ interaction: UIDropInteraction, canHandle session: UIDropSession) -> Bool {
        return true//session.hasItemsConforming(toTypeIdentifiers: [kUTTypeImage as String]) && session.items.count == 1
    }
    
    // Update UI, as needed, when touch point of drag session enters view.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnter session: UIDropSession) {
        let dropLocation = session.location(in: self)
        updateLayers(forDropLocation: dropLocation)
    }
    
    /**
         Required delegate method: return a drop proposal, indicating how the
         view is to handle the dropped items.
    */
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidUpdate session: UIDropSession) -> UIDropProposal {
        let dropLocation = session.location(in: self)
        updateLayers(forDropLocation: dropLocation)

        let operation: UIDropOperation

        if imageView.frame.contains(dropLocation) {
            /*
                 If you add in-app drag-and-drop support for the .move operation,
                 you must write code to coordinate between the drag interaction
                 delegate and the drop interaction delegate.
            */
            operation = session.localDragSession == nil ? .copy : .move
        } else {
            // Do not allow dropping outside of the image view.
            operation = .cancel
        }

        return UIDropProposal(operation: operation)
    }
    
    /**
         This delegate method is the only opportunity for accessing and loading
         the data representations offered in the drag item.
    */
    func dropInteraction(_ interaction: UIDropInteraction, performDrop session: UIDropSession) {
        // Consume drag items (in this example, of type UIImage).
        session.loadObjects(ofClass: UIImage.self) { imageItems in
            let images = imageItems as! [UIImage]

            /*
                 If you do not employ the loadObjects(ofClass:completion:) convenience
                 method of the UIDropSession class, which automatically employs
                 the main thread, explicitly dispatch UI work to the main thread.
                 For example, you can use `DispatchQueue.main.async` method.
            */
            self.imageView.previewImage = images.first
        }

        // Perform additional UI updates as needed.
        let dropLocation = session.location(in: self)
        updateLayers(forDropLocation: dropLocation)
    }
    
    // Update UI, as needed, when touch point of drag session leaves view.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidExit session: UIDropSession) {
        let dropLocation = session.location(in: self)
        updateLayers(forDropLocation: dropLocation)
    }
    
    // Update UI and model, as needed, when drop session ends.
    func dropInteraction(_ interaction: UIDropInteraction, sessionDidEnd session: UIDropSession) {
        let dropLocation = session.location(in: self)
        updateLayers(forDropLocation: dropLocation)
    }

    // MARK: - Helpers

    func updateLayers(forDropLocation dropLocation: CGPoint) {
        if imageView.frame.contains(dropLocation) {
            layer.borderWidth = 0.0
            layer.borderColor = UIColor.blue.cgColor
            imageView.layer.borderWidth = 2.0
            imageView.layer.borderColor = UIColor.red.cgColor
        } else if frame.contains(dropLocation) {
            layer.borderWidth = 5.0
            imageView.layer.borderWidth = 0.0
        } else {
            layer.borderWidth = 0.0
            imageView.layer.borderWidth = 0.0
        }
    }
}
