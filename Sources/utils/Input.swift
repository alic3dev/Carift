enum Input {
  static func get(validInput: [String], caseSensitive: Bool = false) -> String {
    let userInput: String = self.get()

    if validInput.isEmpty {
      return userInput
    }

    if caseSensitive
      ? !validInput.contains(userInput)
      : !validInput.contains(where: { $0.lowercased() == userInput.lowercased() })
    {
      print("Invalid input")
      return self.get(validInput: validInput, caseSensitive: caseSensitive)
    }

    return userInput
  }

  static func get() -> String {
    print("> ", terminator: "")

    return readLine() ?? ""
  }
}
