import Foundation

class GuessingViewModel: ObservableObject {
    @Published var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @Published var correctAnswer = Int.random(in: 0...2)
    @Published var scoreTitle = ""
    @Published var showingScore = false
    @Published var score = 0
    @Published var questionNR = 1
    @Published var streak = 0
    @Published var time = 2
    @Published var timesUP = false
    
    
    let questionLimit = 9
    let successThreshold = 3
    let streakThreshold = 3
    let timeLimit = 0
    
    func restart() {
        timesUP = false
        time = 30
        streak = 0
        questionNR = 0
        score = 0
        askQuestion()
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            scoreTitle = "Correct"
            if streak >= streakThreshold {
                score = score + 2
            } else {
                score = score + 1
            }
            streak = streak + 1
        } else {
            scoreTitle = "Wrong, that was the flag of \(countries[number])"
            streak = 0
        }
        showingScore = true
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        questionNR = questionNR + 1
    }
}
