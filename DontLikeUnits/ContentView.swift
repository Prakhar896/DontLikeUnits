//
//  ContentView.swift
//  DontLikeUnits
//
//  Created by Prakhar Trivedi on 24/2/23.
//

import SwiftUI

struct ContentView: View {
    @State var inputValue = 0.0
    @State var inputUnit: String = "Celsius"
    @State var outputUnit: String = "Fahrenheit"
    
    let availableUnits = ["Celsius", "Fahrenheit", "Kelvin"]
    
    var computedOutput: Double {
        var baseValue: Double = 0.0
        
        // Derive base value in kelvin (strategy is to get base unit value then derive desired unit value)
        if inputUnit == "Celsius" {
            baseValue = 273.15 + inputValue
        } else if inputUnit == "Fahrenheit" {
            baseValue = (inputValue - 32) * (5 / 9) + 273.15
        }
        
        // Derive desired unit value
        if outputUnit == "Kelvin" {
            return baseValue
        } else if outputUnit == "Celsius" {
            return baseValue - 273.15
        } else if outputUnit == "Fahrenheit" {
            return (baseValue - 273.15) * (9 / 5) + 32
        } else {
            return 0.0
        }
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    VStack {
                        TextField("Enter input value", value: $inputValue, format: .number)
                            .keyboardType(.decimalPad)
                            .padding(10)
                        Picker("Select your input value's unit", selection: $inputUnit) {
                            ForEach(availableUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.segmented)
                    }
                } header: {
                    Text("Input Value and Unit")
                }
                
                Section {
                    HStack {
                        Text(computedOutput, format: .number)
                        Picker("", selection: $outputUnit) {
                            ForEach(availableUnits, id: \.self) {
                                Text($0)
                            }
                        }
                        .pickerStyle(.menu)
                    }
                }
            }
            .navigationTitle("I Don't Like Units")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
