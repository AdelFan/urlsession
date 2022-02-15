import UIKit

class ViewController: UIViewController {
    
    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        executeCall()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<String> = { result, response in
            guard let responseUnwrapped = response else { return }
            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let team):
                print("team = \(team)")
            case .failure(let error):
                print(error)
            }
        }
        endpointClient.executeRequest(endpoint, completion: completion)
    }
}
final class GetNameEndpoint: ObjectResponseEndpoint<String> {
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/public/characters" }
    
    override init() {
        super.init()
        
        queryItems = [
            URLQueryItem(name: "ts", value: "1"),
            URLQueryItem(name: "name", value: "Spider-Man"),
            URLQueryItem(name: "apikey", value: "021c5b5b03b7218db980d374f8952634"),
            URLQueryItem(name: "hash", value: "5b6b236d947686584b40b77e18585735")
        ]
    }
    
}

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    let data = Data(str.utf8)
    
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}

