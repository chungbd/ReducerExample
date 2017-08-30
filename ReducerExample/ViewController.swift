//
//  ViewController.swift
//  ReducerExample
//
//  Created by Chung BD on 8/29/17.
//  Copyright © 2017 Benjamin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet var txtChangingMoney: UITextField!
    @IBOutlet var txtChangeRatio: UITextField!
    @IBOutlet var txtChangedMoney: UITextField!

    var state = State() {
        didSet {
            self.txtChangedMoney.text = state.output.map { "\($0) USD" } ?? ""
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        txtChangingMoney.addTarget(self, action: #selector(self.textFieldDidChange(txt:)), for: .editingChanged)
        txtChangeRatio.addTarget(self, action: #selector(self.textFieldDidChange(txt:)), for: .editingChanged)
        txtChangedMoney.isEnabled = false
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func send(_ message: Message) {
        _ = state.send(message)
    }

    // Action selector to UIControl
    func textFieldDidChange(txt:UITextField) {
        if txtChangingMoney == txt {
            send(.inputChanged(txt.text))
        }
        
        if txtChangeRatio == txt {
            send(.ratesAvailable(txt.text))
        }
    }
    
}

extension ViewController:UITextFieldDelegate {
    
}


struct State {
    
    private var inputAmount: Double? = nil
    private var rate: Double? = nil
    var output: Double? {
        guard let i = inputAmount, let r = rate else { return nil }
        return i * r
    }
    
    mutating func send(_ message: Message) -> Command? {
        switch message {
        case .inputChanged(let input):
            inputAmount = input.flatMap { Double($0) }
            return nil
        case .ratesAvailable(let rate):
            self.rate = rate.flatMap { Double($0) }
            return nil
        }
    }
}

enum Message {
    case inputChanged(String?)
    case ratesAvailable(String?)
}

enum Command {
    case load(URL, onComplete: (String?) -> Message)
}

extension Command {
}
