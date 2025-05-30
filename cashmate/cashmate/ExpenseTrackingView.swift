//
//  ExpenseTrackingView.swift
//  cashmate
//
//  Created by student on 30/05/25.
//

// ExpenseTrackingView.swift
// Place this in cashmate/cashmateApp group
// ExpenseTrackingView.swift
// ExpenseTrackingView.swift
import SwiftUI

struct ExpenseTrackingView: View {
    @State private var price: String = ""
    @State private var description: String = ""
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var showingFileImporter = false
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Expense Details")) {
                    // Photo selection
                    Button(action: {
                        showingImagePicker = true
                    }) {
                        HStack {
                            Image(systemName: "photo")
                            Text("Photo")
                            Spacer()
                            if inputImage != nil {
                                Image(uiImage: inputImage!)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 40, height: 40)
                                    .clipShape(RoundedRectangle(cornerRadius: 8))
                            }
                        }
                    }
                    
                    // File chooser
                    Button(action: {
                        showingFileImporter = true
                    }) {
                        HStack {
                            Image(systemName: "folder")
                            Text("Choose file")
                        }
                    }
                    
                    // Price input
                    HStack {
                        Image(systemName: "dollarsign.circle")
                        TextField("Price", text: $price)
                            .keyboardType(.decimalPad)
                    }
                    
                    // Description - Changed to TextEditor for multi-line input
                    VStack(alignment: .leading) {
                        HStack {
                            Image(systemName: "text.bubble")
                            Text("Description")
                        }
                        TextEditor(text: $description)
                            .frame(height: 100) // Set height for larger input area
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.gray.opacity(0.5), lineWidth: 1)
                            )
                            .padding(.top, 4)
                    }
                }
                
                // Submit button
                Section {
                    Button(action: submitExpense) {
                        HStack {
                            Spacer()
                            Text("Submit")
                                .fontWeight(.bold)
                            Spacer()
                        }
                    }
                }
            }
            .navigationTitle("Expense Tracking")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: $inputImage)
            }
            .fileImporter(isPresented: $showingFileImporter, allowedContentTypes: [.item]) { result in
                // Handle file import result here
            }
        }
    }
    
    func loadImage() {
        // Handle image loading if needed
    }
    
    func submitExpense() {
        // Handle expense submission
        print("Expense submitted - Price: \(price), Description: \(description)")
    }
}

// ImagePicker for photo selection
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var image: UIImage?
    @Environment(\.presentationMode) var presentationMode
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UINavigationControllerDelegate, UIImagePickerControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let uiImage = info[.originalImage] as? UIImage {
                parent.image = uiImage
            }
            parent.presentationMode.wrappedValue.dismiss()
        }
    }
}

// Preview
struct ExpenseTrackingView_Previews: PreviewProvider {
    static var previews: some View {
        ExpenseTrackingView()
    }
}
