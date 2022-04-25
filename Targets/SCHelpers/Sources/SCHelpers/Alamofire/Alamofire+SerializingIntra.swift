//
//  SerializingDecodable+ISO8601.swift
//  SCHelpers
//
//  Created by Nikita Arutyunov on 20.04.2022.
//

import Alamofire
import Foundation

extension DataRequest {
    public class IntraDecoder: JSONDecoder {
        public override init() {
            super.init()

            dateDecodingStrategy = .formatted(
                {
                    let dateFormatter = DateFormatter()

                    dateFormatter.calendar = Calendar(identifier: .iso8601)

                    dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX"

                    return dateFormatter
                }()
            )
        }
    }

    public func serializingIntra<Value: Decodable>(
        _ type: Value.Type = Value.self,
        automaticallyCancelling shouldAutomaticallyCancel: Bool = false,
        dataPreprocessor: DataPreprocessor = DecodableResponseSerializer<Value>
            .defaultDataPreprocessor,
        decoder: DataDecoder = IntraDecoder(),
        emptyResponseCodes: Set<Int> = DecodableResponseSerializer<Value>.defaultEmptyResponseCodes,
        emptyRequestMethods: Set<HTTPMethod> = DecodableResponseSerializer<Value>
            .defaultEmptyRequestMethods
    ) -> DataTask<Value> {
        serializingResponse(
            using: DecodableResponseSerializer<Value>(
                dataPreprocessor: dataPreprocessor,
                decoder: decoder,
                emptyResponseCodes: emptyResponseCodes,
                emptyRequestMethods: emptyRequestMethods
            ),
            automaticallyCancelling: shouldAutomaticallyCancel
        )
    }
}
