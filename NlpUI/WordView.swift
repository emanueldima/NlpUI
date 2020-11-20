import SwiftUI
import CoreData
import NaturalLanguage



struct WordView: View {
    var item: Item
    var body: some View {
        VStack {
            Text("\(item.name ?? "[empty]")")
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .padding()
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .stroke(Color.accentColor, lineWidth: 1)
                )
                .padding()
            ForEach(findNeighbours(word: item.name!.lowercased())) { neighbour in
                HStack{
                    Text("\(neighbour.word)")
                        .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                    Text("\(neighbour.distance)")
                }
                .padding(4)
            }
        }
    }
    
    func findNeighbours(word: String) -> [Neighbour] {
        let english = NLEmbedding.wordEmbedding(for: .english)!
        let neighbours = english.neighbors(for: word, maximumCount: 10)
        let res = neighbours.map { word, distance -> Neighbour in
            return Neighbour(id: word.hashValue, word: word, distance: distance)
        }
        return res
    }
}

struct Neighbour: Identifiable {
    var id: Int
    var word: String
    var distance: NLDistance
}
