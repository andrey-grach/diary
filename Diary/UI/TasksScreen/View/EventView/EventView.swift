//
//  EventView.swift
//  Diary
//
//  Created by Андрей Грач on 15.12.2024.
//

import UIKit

//@IBDesignable
final class EventView: UIView {
    
    @IBOutlet private weak var titleLabel: UILabel!
    
//    override init(frame: CGRect) {
//        super.init(frame: frame)
//        configureView()
//    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureView()
    }
    
    private func configureView() {
        guard let view = loadViewFromNib(nibName: "EventView") else { return }
        view.frame = self.bounds
        addSubview(view)
    }
    
    func configureView(title: String) {
        self.titleLabel.text = title
    }
}
