import SwiftUI
import UIKit

struct CameraView: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @ObservedObject var viewModel: CameraViewModel
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = .camera
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: CameraView
        
        init(_ parent: CameraView) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.image = image
                showCaptionAlert(for: image, with: picker)
            }
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.presentationMode.wrappedValue.dismiss()
        }
        
        func showCaptionAlert(for image: UIImage, with picker: UIImagePickerController) {
            let alertController = UIAlertController(title: "Add Post Details", message: "Enter a caption and select a date for your photo", preferredStyle: .alert)
            
            // Add caption text field
            alertController.addTextField { textField in
                textField.placeholder = "Caption"
            }
            
            // Add date picker
            let datePicker = UIDatePicker()
            datePicker.datePickerMode = .date
            datePicker.preferredDatePickerStyle = .compact
            datePicker.maximumDate = Date() // Can't select future dates
            
            // Create a container view for the date picker
            let containerView = UIView()
            containerView.translatesAutoresizingMaskIntoConstraints = false
            containerView.addSubview(datePicker)
            
            // Configure date picker constraints
            datePicker.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                datePicker.centerXAnchor.constraint(equalTo: containerView.centerXAnchor),
                datePicker.centerYAnchor.constraint(equalTo: containerView.centerYAnchor)
            ])
            
            // Add container to alert
            alertController.view.addSubview(containerView)
            
            // Configure container constraints
            NSLayoutConstraint.activate([
                containerView.centerXAnchor.constraint(equalTo: alertController.view.centerXAnchor),
                containerView.topAnchor.constraint(equalTo: alertController.view.topAnchor, constant: 120),
                containerView.widthAnchor.constraint(equalToConstant: 270),
                containerView.heightAnchor.constraint(equalToConstant: 100)
            ])
            
            // Adjust alert height
            let height = NSLayoutConstraint(item: alertController.view!, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 1, constant: 250)
            alertController.view.addConstraint(height)
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { _ in
                self.parent.presentationMode.wrappedValue.dismiss()
            }
            
            let saveAction = UIAlertAction(title: "Save Post", style: .default) { _ in
                if let captionText = alertController.textFields?.first?.text {
                    self.parent.viewModel.addPost(image: image, caption: captionText, timestamp: datePicker.date)
                }
                self.parent.presentationMode.wrappedValue.dismiss()
            }
            
            alertController.addAction(cancelAction)
            alertController.addAction(saveAction)
            
            picker.present(alertController, animated: true)
        }
    }
}

#Preview {
    CameraView(image: .constant(nil), viewModel: CameraViewModel())
}
