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
    @State var selectedConversionType: String = "Temperature"
    @FocusState private var keyboardActive: Bool
    
    let allUnits = [
        "Temperature": [
            "Celsius",
            "Fahrenheit",
            "Kelvin"
        ],
        "Length": [
            "Metres",
            "Kilometres",
            "Feet",
            "Yards",
            "Miles"
        ],
        "Time": [
            "Seconds",
            "Minutes",
            "Hours",
            "Days"
        ]
    ]
    
    let conversionTypes = ["Temperature", "Length", "Time"]
    
    var availableUnits: [String] {
        allUnits[selectedConversionType] ?? allUnits["Temperature"]!
    }
    
    var computedOutput: Double {
        var baseValue: Double = 0.0
        
        if selectedConversionType == "Temperature" {
            // Derive base value in kelvin (strategy is to get base unit value then derive desired unit value)
            if inputUnit == "Celsius" {
                baseValue = 273.15 + inputValue
            } else if inputUnit == "Fahrenheit" {
                baseValue = (inputValue - 32) * (5 / 9) + 273.15
            } else if inputUnit == "Kelvin" {
                baseValue = inputValue
            }
            
            // Derive desired unit value
            if outputUnit == "Kelvin" {
                return baseValue
            } else if outputUnit == "Celsius" {
                return baseValue - 273.15
            } else if outputUnit == "Fahrenheit" {
                return (baseValue - 273.15) * (9 / 5) + 32
            }
        } else if selectedConversionType == "Length" {
            // Base value is centimetres
            
            // Derive base value from input value
            if inputUnit == "Metres" {
                baseValue = inputValue * 100
            } else if inputUnit == "Kilometres" {
                baseValue = inputValue * 1000 * 100
            } else if inputUnit == "Feet" {
                baseValue = inputValue * 30.48
            } else if inputUnit == "Yards" {
                baseValue = inputValue * 91.44
            } else if inputUnit == "Miles" {
                baseValue = inputValue * 160934
            }
            
            // Derive desired output unit value from base value
            if outputUnit == "Metres" {
                return baseValue / 100
            } else if outputUnit == "Kilometres" {
                return baseValue / 100 / 1000
            } else if outputUnit == "Feet" {
                return baseValue / 30.48
            } else if outputUnit == "Yards" {
                return baseValue / 91.44
            } else if outputUnit == "Miles" {
                return baseValue / 160934
            }
        } else if selectedConversionType == "Time" {
            // Base value is seconds
            
            // Derive base value from input value
            if inputUnit == "Seconds" {
                baseValue = inputValue
            } else if inputUnit == "Minutes" {
                baseValue = inputValue * 60
            } else if inputUnit == "Hours" {
                baseValue = inputValue * 60 * 60
            } else if inputUnit == "Days" {
                baseValue = inputValue * 24 * 60 * 60
            }
            
            // Derive desired output unit value from base value
            if outputUnit == "Seconds" {
                return baseValue
            } else if outputUnit == "Minutes" {
                return baseValue / 60
            } else if outputUnit == "Hours" {
                return baseValue / 60 / 60
            } else if outputUnit == "Days" {
                return baseValue / 24 / 60 / 60
            }
        }
        
        return 0.0
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker("Select a conversion type", selection: $selectedConversionType) {
                        ForEach(conversionTypes, id: \.self) {
                            Text($0)
                        }
                    }
                    .pickerStyle(.segmented)
                    .onChange(of: self.selectedConversionType) { newValue in
                        print("hello")
                        outputUnit = availableUnits[1]
                    }
                } header: {
                    Text("Conversion Type")
                }
                
                Section {
                    VStack {
                        TextField("Enter input value", value: $inputValue, format: .number)
                            .keyboardType(.decimalPad)
                            .padding(10)
                            .focused($keyboardActive)
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
                
                if availableUnits.contains(inputUnit) {
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
                    } header: {
                        Text("Output Value and Unit")
                    }
                }
            }
            .navigationTitle("I Don't Like Units")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button {
                        keyboardActive = false
                    } label: {
                        Text("Done")
                    }

                }
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
