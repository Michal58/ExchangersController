

import Foundation

enum Nutritient {
    case carb
    case prot
    case fat
    case kcal
}

class FoodModel: Codable {
    static let DEFAULT_SPECIFIER: Int = 100
    static let massUnit: String = "g"
    private(set) var idOfFood: UUID
    private(set) var name: String
    private(set) var massSpecifier: Int
    
    init(name: String, massSpecifier: Int) {
        self.idOfFood = UUID()
        self.name = name
        self.massSpecifier = massSpecifier
    }
    

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(idOfFood, forKey: .idOfFood)
        try container.encode(name, forKey: .name)
        try container.encode(massSpecifier, forKey: .massSpecifier)
    }
    
    enum CodingKeys: String, CodingKey {
        case idOfFood, name, massSpecifier
    }
    
    // to override
    func modifyWithValuesOfOther(_ other: FoodModel){
        self.name = other.name
        self.massSpecifier = other.massSpecifier
    }
    
    // to override
    func getCarbohydrates()->Int {
        fatalError("Method to override")
    }
    
    // to override
    func getProteins()->Int {
        fatalError("Method to override")
    }
    
    // to override
    func getFat()->Int {
        fatalError("Method to override")
    }
    
    func isLocal()->Bool {
        fatalError("Method to override")
    }
    
    func getNutritient(_ nutritient: Nutritient)-> Int {
        switch nutritient {
        case .carb:
            getCarbohydrates()
        case .prot:
            getProteins()
        case .fat:
            getFat()
        case .kcal:
            getKcal()
        }
    }
    
    func getKcal()->Int {
        calcKcal(getCarbohydrates(), getProteins(), getFat())
    }
    
    func getNutritientValueWithMass(_ nutritient: Nutritient, _ mass: Int)->Int {
        if self.massSpecifier != 0{
            self.getNutritient(nutritient)*mass/self.massSpecifier
        }
        else {
            0
        }
    }
    
    func copy()->FoodModel {
        return FoodModel(name: self.name, massSpecifier: self.massSpecifier)
    }
    
    func setName(_ name: String)->Void {
        self.name = name
    }
    
    func setMassSpecifier(_ newSpecifier: Int)->Void{
        self.massSpecifier = newSpecifier
    }
    
    func getFoodSummary(mass: Int)->BriefExchangersSummary {
        let wwValue = calcWW(getNutritientValueWithMass(.carb, mass))
        let wbtValue = calcWbt(getNutritientValueWithMass(.prot, mass), getNutritientValueWithMass(.fat, mass))
        
        return BriefExchangersSummary(wwValue: wwValue, wbtValue: wbtValue, kcal: getNutritientValueWithMass(.kcal, mass))
    }
    
}

class SimpleFood: FoodModel {
    var carbohydates: Int
    var proteins: Int
    var fat: Int
    var isLocalVar: Bool
    
    private let discriminator: String = "Simple"
    
    init(name: String, massSpecifier: Int, carbohydates: Int, proteins: Int, fat: Int, isLocal: Bool = true) {
        self.carbohydates = carbohydates
        self.proteins = proteins
        self.fat = fat
        self.isLocalVar = isLocal
        super.init(name: name, massSpecifier: massSpecifier)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.carbohydates = try container.decode(Int.self, forKey: .carbohydrates)
        self.proteins = try container.decode(Int.self, forKey: .proteins)
        self.fat = try container.decode(Int.self, forKey: .fat)
        self.isLocalVar = try container.decode(Bool.self, forKey: .isLocalVar)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FoodModel.CodingKeys.self)
        try container.encode(idOfFood, forKey: .idOfFood)
        try container.encode(name, forKey: .name)
        try container.encode(massSpecifier, forKey: .massSpecifier)
        
        var ingredientContainer = encoder.container(keyedBy: CodingKeys.self)
        try ingredientContainer.encode(carbohydates, forKey: .carbohydrates)
        try ingredientContainer.encode(proteins, forKey: .proteins)
        try ingredientContainer.encode(fat, forKey: .fat)
        try ingredientContainer.encode(isLocalVar, forKey: .isLocalVar)
        try ingredientContainer.encode(self.discriminator, forKey: .discriminator)
    }
    
    enum CodingKeys: String, CodingKey {
        case carbohydrates, proteins, fat, isLocalVar, discriminator
    }
    
    static func createDefaultModel() -> SimpleFood {
        SimpleFood(name: "", massSpecifier: 100, carbohydates: 0, proteins: 0, fat: 0)
    }
    
    func setCarbs(_ carbValue: Int) {
        self.carbohydates = carbValue
    }
    
    func setProts(_ protsValue: Int) {
        self.proteins = protsValue
    }
    
    func setFat(_ fatValue: Int) {
        self.fat = fatValue
    }
    
    override func modifyWithValuesOfOther(_ other: FoodModel) {
        super.modifyWithValuesOfOther(other)
        self.carbohydates = other.getCarbohydrates()
        self.proteins = other.getProteins()
        self.fat = other.getFat()
    }
    
    override func getCarbohydrates()->Int {
        self.carbohydates
    }
    
    override func getProteins() -> Int {
        self.proteins
    }
    
    override func getFat() -> Int {
        self.fat
    }
    
    override func isLocal() -> Bool {
        self.isLocalVar
    }
    
    func nonLocalCopy()->SimpleFood {
        SimpleFood(
            name: self.name,
            massSpecifier: self.massSpecifier,
            carbohydates: self.carbohydates,
            proteins: self.proteins,
            fat: self.fat,
            isLocal: false
        )
    }
    
    override func copy() -> FoodModel {
        SimpleFood(
            name: self.name,
            massSpecifier: self.massSpecifier,
            carbohydates: self.carbohydates,
            proteins: self.proteins,
            fat: self.fat,
            isLocal: self.isLocalVar
        )
    }
}

class ComplexFood:FoodModel {
    var foodExtension: [FoodDosage]
    
    private let discriminator: String = "Complex"
    
    init(name: String, massSpecifier: Int, foodExtension: [FoodDosage]) {
        self.foodExtension = foodExtension
        super.init(name: name, massSpecifier: massSpecifier)
    }
    
    required init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.foodExtension = try container.decode([FoodDosage].self, forKey: .foodExtension)
        
        try super.init(from: decoder)
    }
    
    override func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: FoodModel.CodingKeys.self)
        try container.encode(idOfFood, forKey: .idOfFood)
        try container.encode(name, forKey: .name)
        try container.encode(massSpecifier, forKey: .massSpecifier)
        
        var ingredientContainer = encoder.container(keyedBy: CodingKeys.self)
        try ingredientContainer.encode(foodExtension, forKey: .foodExtension)
        try ingredientContainer.encode(self.discriminator, forKey: .discriminator)
    }
    
    enum CodingKeys: String, CodingKey {
        case foodExtension, discriminator
    }
    
    static func createDefaultModel()->ComplexFood {
        ComplexFood(name: "", massSpecifier: 100, foodExtension: [])
    }
    
    func getAccumulatedMass()->Int {
        foodExtension.reduce(0) { acc, dosage in
            acc + dosage.totalMass()
        }
    }
    
    func getAccumulatedNutritient(_ nutritient: Nutritient)->Int {
        let composedTotal = foodExtension.reduce(0) { acc, dosage in
            acc + dosage.totalNutritient(nutritient)
        }
        let wholeMass = self.getAccumulatedMass()
        return if wholeMass == 0 {
            0
        } else {
            composedTotal*self.massSpecifier/wholeMass
        }
    }
    
    func dosagesTotalMass()->Int {
        foodExtension.reduce(0) { acc, dosage in
            acc + dosage.totalMass()
        }
    }
    
    func setExtension(_ newExtension: [FoodDosage]) {
        self.foodExtension = newExtension
    }
    
    func copyExtension()->[FoodDosage]{
        self.foodExtension.map {
            $0.copy()
        }
    }
    
    override func modifyWithValuesOfOther(_ other: FoodModel) {
        super.modifyWithValuesOfOther(other)
        self.foodExtension = (other as! ComplexFood).foodExtension
    }
    
    override func getCarbohydrates()->Int {
        getAccumulatedNutritient(.carb)
    }
    
    override func getProteins() -> Int {
        getAccumulatedNutritient(.prot)
    }
    
    override func getFat() -> Int {
        getAccumulatedNutritient(.fat)
    }
    
    override func isLocal() -> Bool {
        true
    }
    
    override func copy() -> FoodModel {
        ComplexFood(name: self.name, massSpecifier: self.massSpecifier, foodExtension: copyExtension())
    }
}


struct PartiallyDecodedFood: Decodable {
    enum ModelKind: String, Decodable {
        case Complex, Simple
    }
    let kind: ModelKind
    var model: FoodModel

    private enum DecodingKeys: String, CodingKey {
        case discriminator = "discriminator"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DecodingKeys.self)
        self.kind = try container.decode(ModelKind.self, forKey: .discriminator)
        switch kind {
        case .Simple:
            self.model = try SimpleFood(from: decoder)
        case .Complex:
            self.model = try ComplexFood(from: decoder)
        }
    }
}
