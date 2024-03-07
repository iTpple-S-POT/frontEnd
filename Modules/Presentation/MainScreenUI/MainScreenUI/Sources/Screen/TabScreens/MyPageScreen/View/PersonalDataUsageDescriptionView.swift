//
//  PersonalDataUsageDescriptionView.swift
//  MainScreenUI
//
//  Created by 최준영 on 3/7/24.
//

import SwiftUI
import UIKit
import GlobalUIComponents
import PDFKit
import DefaultExtensions

struct PersonalDataUsageDescriptionView: View {
    
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        
        ZStack {
            
            VStack {
                
                SpotNavigationBarView(title: "") {
                    
                    dismiss()
                }
                
                Spacer()
                
            }
            .zIndex(1)
            
            PDUDView()
                .padding(.top, 56)
        }
    }
}

struct PDUDView: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> PDFViewController {
        let vc = PDFViewController()
        
        return vc
    }
    
    func updateUIViewController(_ uiViewController: PDFViewController, context: Context) {
        
    }
    
    typealias UIViewControllerType = PDFViewController
}

class PDFViewController: UIViewController {
    
    let pdfView: PDFView = {
        
        let view = PDFView()
        
        view.autoScales = true
        view.displayMode = .singlePageContinuous
        
        view.translatesAutoresizingMaskIntoConstraints = false
        
        return view
    }()
    
    override func viewDidLoad() {
        
        setAutoLayout()
        
        loadPdf()
    }
    
    func setAutoLayout() {
        
        view.addSubview(pdfView)
        
        NSLayoutConstraint.activate([
            
            pdfView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            pdfView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            pdfView.topAnchor.constraint(equalTo: view.topAnchor),
            pdfView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func loadPdf() {
        
        guard let pdfPath = Bundle.module.url(forResource: "peronal_data_usage_des", withExtension: "pdf") else {
            
            fatalError("no pdf")
        }
        
        if let document = PDFDocument(url: pdfPath) {
            
            pdfView.document = document
        }
        
    }
}



#Preview {
    PersonalDataUsageDescriptionView()
}
