import Foundation

let text = "abbbIcccddffgakg"

func firstNonRepeated(_ s: String){
    var text = s
    for char in s {
        let charCount = s.filter{$0 == char}.count
        if charCount == 1 {
            print(char)
            return
        } else {
            text.replacingOccurrences(of: char.description, with: "")
        }
    }
}
 
firstNonRepeated(text)

