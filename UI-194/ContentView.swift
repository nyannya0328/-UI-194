//
//  ContentView.swift
//  UI-194
//
//  Created by にゃんにゃん丸 on 2021/05/18.
//

import SwiftUI

struct ContentView: View {
    @State var text = ""
    @State var containerHeight : CGFloat = 0
    var body: some View {
        NavigationView{
            
            
            VStack{
                
                AutoRisizingTF(hint: "Enter", text: $text, containerHeight: $containerHeight, onEnd: {
                    
                    
                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                    
                })
                    .padding(.horizontal)
                    .frame(height: containerHeight <= 150 ? containerHeight : 150)
                    .background(Color.white)
                    .cornerRadius(10)
            }
           
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.primary.opacity(0.04)
                            
                            .onTapGesture {
                                UIApplication.shared.windows.first?.rootViewController?.view.endEditing(true)
                            }
                            
                            .ignoresSafeArea()
            
    
            
            )
            .navigationTitle("AUTO SIZING TF")
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

struct AutoRisizingTF : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return AutoRisizingTF.Coordinator(parent: self)
    }
    
    var hint : String
    @Binding var text : String
    @Binding var containerHeight : CGFloat
    
    var onEnd: ()->()
    
    func makeUIView(context: Context) -> UITextView {
        
        let view = UITextView()
        view.text = hint
        view.font = .systemFont(ofSize: 25)
        view.textColor = .gray
        view.delegate = context.coordinator
        
        
        let toolBar = UIToolbar(frame: CGRect(x: 20, y: 20, width: UIScreen.main.bounds.width, height: 50))
        
        toolBar.barStyle = .default
        
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        
        
        let donButton = UIBarButtonItem(barButtonSystemItem: .done, target: context.coordinator, action: #selector(context.coordinator.closekeybord))
        
        toolBar.items = [spacer,donButton]
        
        view.inputAccessoryView = toolBar
        
        return view
        
    }
    func updateUIView(_ uiView: UITextView, context: Context) {
        
        DispatchQueue.main.async {
            if containerHeight == 0{
                
                containerHeight = uiView.contentSize.height
                
                
            }
        }
        
    }
    
    class Coordinator : NSObject,UITextViewDelegate{
        
        
        var parent : AutoRisizingTF
        
        init(parent : AutoRisizingTF) {
            self.parent = parent
        }
        
        
        @objc func closekeybord(){
            
            
            parent.onEnd()
            
        }
        
        func textViewDidBeginEditing(_ textView: UITextView) {
            
            if textView.text == parent.hint{
                
                textView.text = ""
                textView.textColor = UIColor(Color.primary)
                
                
            }
            
        }
        
        func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
            
            parent.containerHeight = textView.contentSize.height
            
        }
        
        func textViewDidEndEditing(_ textView: UITextView) {
            
            if textView.text == ""{
                
                
                parent.text = textView.text
                textView.textColor = .gray
            }
            
        }
        
        
        
        
        
    }
}


