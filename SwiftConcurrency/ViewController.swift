//
//  ViewController.swift
//  SwiftConcurrency
//
//  Created by Callen Egan on 2025-02-10.
//

import UIKit
import SwiftUI

class ViewController: UIViewController {
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Simulated framework-style attachment of detection view
        // originally designed as an SDK that offers a complete UI experience
        let swiftUIVC = UIHostingController(rootView: Navigator())
        swiftUIVC.modalPresentationStyle = .fullScreen
        present(swiftUIVC, animated: true)
    }
    
}

