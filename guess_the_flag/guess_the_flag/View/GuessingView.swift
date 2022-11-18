import SwiftUI

struct GuessingView: View {
    @StateObject var viewModel: GuessingViewModel = .init()
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3),
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.7),
            ], center: .top, startRadius: 300, endRadius: 400)
            .ignoresSafeArea()
            
            VStack(spacing: 15) {
                if viewModel.questionNR < viewModel.questionLimit && !viewModel.timesUP {
                    VStack {
                        Text("Tap the flag of")
                            .foregroundColor(.white)
                            .font(.subheadline.weight(.heavy))
                        
                        Text(viewModel.countries[viewModel.correctAnswer])
                            .foregroundColor(.white)
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            viewModel.flagTapped(number)
                        } label: {
                            Image(viewModel.countries[number])
                                .renderingMode(.original)
                                .clipShape(Capsule())
                                .shadow(radius: 5)
                        }
                    }
                    
                    Text("Score: \(viewModel.score)")
                        .font(.largeTitle.weight(.semibold))
                    
                    Text("Streak: \(viewModel.streak)")
                        .font(.subheadline.weight(.semibold))
                    
                    Text("Question: \(viewModel.questionNR) out of \(viewModel.questionLimit - 1)")
                        .font(.subheadline.weight(.semibold))
                    
                    Text("Time remaining: \(viewModel.time) seconds")
                        .onReceive(timer) { _ in
                            if viewModel.time == viewModel.timeLimit {
                                viewModel.timesUP = true
                            } else {
                                viewModel.time = viewModel.time - 1
                            }
                        }
                    
                } else {
                    if viewModel.questionNR == 1 {
                        Text("You're lazy :D")
                    } else {
                        if viewModel.score > viewModel.successThreshold {
                            Text("Your score is: \(viewModel.score) points out of \(viewModel.questionNR - 1) questions answered. Congrats!")
                        } else {
                            Text("Your score is: \(viewModel.score) points out of \(viewModel.questionNR - 1) questions answered.")
                        }
                        
                        Text("That was fun, let's try again.")
                    }
                    
                    Button(action: {
                        viewModel.restart()
                    }) {
                        Text("Restart")
                    }
                }
            }
            .padding(.horizontal, 50)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 20)
            .background(.regularMaterial)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
        .alert(viewModel.scoreTitle, isPresented: $viewModel.showingScore) {
            Button("Continue", action: viewModel.askQuestion)
        }
    }
}
