//
//  CurrencyTextField.swift
//  SwiftUIGoodies
//
//  Created by Eyal Katz on 23/04/2025.
//

import SwiftUI

struct CurrencyTextField: View {
    
    enum Style {
        case `default`
        case largeIntegerPart
        
        var font: Font {
            switch self {
            case .default:
                return .system(size: 18)
            case .largeIntegerPart:
                return .system(size: 18)
            }
        }
        
        var integerPartFont: Font {
            switch self {
            case .default:
                return .system(size: 18)
            case .largeIntegerPart:
                return .system(size: 54)
            }
        }
    }
    
    @FocusState private var isFocused: Bool
    @Binding var amount: Double
    @Binding var cleatText: Bool
    var placeholder: String = "Amount"
    var style: Style
    
    @State private var attributedAmount: AttributedString
    @State private var stringAmount: String = "0"
    
    init(amount: Binding<Double>, clearText: Binding<Bool> = .constant(false), placeholder: String = "Amount", style: Style = .default) {
        self._amount = amount
        self._cleatText = clearText
        self.placeholder = placeholder
        self.style = style
        self.attributedAmount = .init()
    }
    
    var body: some View {
        ZStack {
            TextField("", text: $stringAmount)
                .font(style.integerPartFont)
                .focused($isFocused)
                .opacity(0)
                .keyboardType(.decimalPad)
            
            HStack {
                Text(attributedAmount)
                    .minimumScaleFactor(0.5)
                    .lineLimit(1)
                
                Spacer()
            }
            .contentTransition(.numericText())
        }
        .onAppear {
            attributedAmount = attributedAmount(amount)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                isFocused = true
            }
        }
        .onChange(of: stringAmount) { [stringAmount] newValue in
            if newValue.isAllZeros, stringAmount.isAllZeros {
                self.stringAmount = "0"
                return
            }
            
            if newValue.count > stringAmount.count {
                onNewCharacter(oldValue: stringAmount, newValue: newValue)
            } else {
                onDeleteCharacter(oldValue: stringAmount, newValue: newValue)
            }
        }
        .onChange(of: cleatText) { newValue in
            if newValue {
                clear()
                cleatText = false
            }
        }
        .animation(.bouncy(duration: 0.22), value: attributedAmount)
    }
    
    private func onNewCharacter(oldValue: String, newValue: String) {
        guard let newCharacterValue = newValue.last else {
            clear()
            return
        }
        
        let newCharacter = String(newCharacterValue)
        
        if oldValue.isEmpty, newCharacter == .decimalSeparator {
            stringAmount = "0" + newCharacter
            updateAttributedAmount(oldValue: oldValue, newValue: stringAmount)
            attributedAmount.append(AttributedString(newCharacter))
            return
        }
        
        if oldValue == "0", newCharacter == "0" {
            stringAmount = "0"
            return
        }
        
        let splitedString = newValue.split(separator: String.decimalSeparator)
        
        guard splitedString.count <= 2 else {
            stringAmount = oldValue
            return
        }
        
        if oldValue.hasDecimalSeparator {
            let decimalPart = newValue.split(separator: String.decimalSeparator).last ?? ""
            
            guard decimalPart.count <= 2 else {
                stringAmount = oldValue
                return
            }
        }
        
        updateAttributedAmount(oldValue: oldValue, newValue: newValue)
    }
    
    private func onDeleteCharacter(oldValue: String, newValue: String) {
        guard !newValue.isEmpty else {
            clear()
            return
        }
        
        guard let _ = newValue.last else {
            stringAmount = oldValue
            return
        }
        
        updateAttributedAmount(oldValue: oldValue, newValue: newValue)
    }
    
    private func clear() {
        amount = 0
        attributedAmount = attributedAmount(0)
        stringAmount = "0"
    }
    
    private func attributedAmount(_ amount: Double) -> AttributedString {
        guard amount < 1000000000 else { return attributedAmount }
        
        var attributedAmount = amount.formatted(
            .currency(code: "ILS")
            .presentation(.narrow)
            .precision(.fractionLength(0...2))
            .decimalSeparator(strategy: .automatic)
            .attributed
        )
        
        for run in attributedAmount.runs {
            switch run.attributes.numberSymbol {
            case .currency, .decimalSeparator:
                attributedAmount[run.range].font = style.font
            default:
                break
            }
            
            switch run.attributes.numberPart {
            case .integer:
                attributedAmount[run.range].font = style.integerPartFont
            case .fraction:
                attributedAmount[run.range].font = style.font
            default:
                break
            }
        }
        
        return attributedAmount
    }
    
    private func updateAttributedAmount(oldValue: String, newValue: String) {
        guard let amount = Double(newValue), amount < 1000000000 else {
            stringAmount = oldValue
            return
        }
        
        self.amount = amount
        attributedAmount = attributedAmount(amount)
        
        if !oldValue.hasDecimalSeparator, let lastCharacter = newValue.last, String(lastCharacter) == .decimalSeparator {
            attributedAmount.append(AttributedString(String.decimalSeparator))
            return
        }
        
        let stringParts = newValue.split(separator: String.decimalSeparator)
        
        if stringParts.count == 1, newValue.hasDecimalSeparator {
            attributedAmount.append(AttributedString(.decimalSeparator))
            return
        }
        
        if stringParts.count == 2, let decimalPart = stringParts.last {
            if decimalPart == "0" {
                attributedAmount.append(AttributedString(.decimalSeparator +  "0"))
            } else if decimalPart == "00" {
                attributedAmount.append(AttributedString(.decimalSeparator + "00"))
            } else if decimalPart.last == "0" {
                attributedAmount.append(AttributedString("0"))
            }
        }
    }
}

#Preview {
    @State var amount: Double = 0
    @State var amount2: Double = 0
    
    VStack(spacing: 24) {
        CurrencyTextField(amount: $amount, style: .largeIntegerPart)
        
        CurrencyTextField(amount: $amount2, style: .largeIntegerPart)
    }
    .padding()
}

fileprivate extension String {
    
    static let decimalSeparator = Locale.current.decimalSeparator ?? "."

    var isAllZeros: Bool {
        allSatisfy { ("0").contains($0) }
    }
    
    var decimalFiltered: String {
        filter { ("0123456789" + String.decimalSeparator).contains($0) }
    }
      
    var hasDecimalSeparator: Bool {
        contains(String.decimalSeparator)
    }
}
