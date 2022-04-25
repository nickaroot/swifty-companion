import Alamofire
import Foundation

public class SCAPI: SCAPIAuthOutput, SCAPIUsersOutput, SCAPICursusOutput {
    public lazy var closureEventMonitor: ClosureEventMonitor = {
        let monitor = ClosureEventMonitor()

        return monitor
    }()

    public lazy var eventMonitors = [
        closureEventMonitor
    ]

    // MARK: - Authentication

    private lazy var authenticator = BearerAuthenticator(refreshToken: auth.refreshToken)

    lazy var authenticationInterceptor = BearerInterceptor(
        authenticator: authenticator,
        credential: auth.keychainToken
    )

    public var isAuthorized: Bool {
        auth.keychainToken != nil
    }

    // MARK: - Session

    lazy var session: Session = {
        let configuration = URLSessionConfiguration.af.default

        let session = Session(
            configuration: configuration,
            interceptor: authenticationInterceptor,
            eventMonitors: eventMonitors
        )

        return session
    }()

    public func getTestData() async throws -> Result<String, AFError> {
        await session.request("https://httpbin.org/get").serializingString().result
    }

    // MARK: - Base URL

    public var baseURL: URL? {
        URL(string: "https://api.intra.42.fr")
    }

    // MARK: - Auth

    public var auth = Auth()

    // MARK: - Users

    public var users = Users()

    // MARK: - Cursus

    public var cursus = Cursus()

    // MARK: - Init

    public init() {
        auth.api = self
        users.api = self
        cursus.api = self
    }
}
