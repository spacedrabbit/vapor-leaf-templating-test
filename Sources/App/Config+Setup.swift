import FluentProvider
import LeafProvider


extension Config {
  public func setup() throws {
    // allow fuzzy conversions for these types
    // (add your own types here)
    Node.fuzzy = [Row.self, JSON.self, Node.self]
    
    try setupProviders()
    try setupPreparations()
  }
  
  public func addRoutes(drop: Droplet) {
    print(drop.config.environment)
    
    // our first html page
    // localhost:8080/
    drop.get("") { (request: Request) in
    
      let phrases = ["Bienvenue",
                     "Welcome",
                     "Velkommen",
                     "Willkommen",
                     "Добро пожаловат",
                     "ようこそ"]
      
      //let randomPhrase = phrases[Int(arc4random_uniform(UInt32(phrases.count)))].appending(", Leaf!")
      let phrase = phrases.last!
      
      let userNode = try Node(node: ["name" : "louis",
                                     "message" : "Welcome to the Jungle!",
                                     "welcome_phrase" : phrase])

      return try drop.view.make("base", userNode)
    }
    
    // localhost:8080/all
    drop.get("all") { ( request:Request ) in
      let cat1 = try Node(node: ["name":"Mittens",
                                  "breed":"American Shorthair"])
      let cat2 = try Node(node: ["name":"Capt. Snuggles",
                                 "breed":"Sphynx"])
      
      return try drop.view.make("cats", Node(node:
       ["cats_array": [cat1, cat2]]))
      }
    
  }
  
  /// Configure providers
  private func setupProviders() throws {
    try addProvider(FluentProvider.Provider.self)
    try addProvider(LeafProvider.Provider.self)
  }
  
  /// Add all models that should have their
  /// schemas prepared before the app boots
  private func setupPreparations() throws {
    preparations.append(Post.self)
  }
}
