// Copyright (c) 2018 WSO2 Inc. (http://www.wso2.org) All Rights Reserved.
//
// WSO2 Inc. licenses this file to you under the Apache License,
// Version 2.0 (the "License"); you may not use this file except
// in compliance with the License.
// You may obtain a copy of the License at
//
// http://www.apache.org/licenses/LICENSE-2.0
//
// Unless required by applicable law or agreed to in writing,
// software distributed under the License is distributed on an
// "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
// KIND, either express or implied. See the License for the
// specific language governing permissions and limitations
// under the License.

package TravelAgency.CarRental;

import ballerina.net.http;

// Available car types
const string AC = "Air Conditioned";
const string NORMAL = "Normal";

// Car rental service to rent cars
@http:configuration {basePath:"/car", port:9093}
service<http> carRentalService {

    // Resource to rent a car
    @http:resourceConfig {methods:["POST"], path:"/rent", consumes:["application/json"], produces:["application/json"]}
    resource rentCar (http:Connection connection, http:InRequest request) {
        http:OutResponse response = {};

        // Try parsing the JSON payload from the request
        json payload = request.getJsonPayload();
        json name = payload.Name;
        json arrivalDate = payload.ArrivalDate;
        json departureDate = payload.DepartureDate;
        json preferredType = payload.Preference;

        // If payload parsing fails, send a "Bad Request" message as the response
        if (name == null || arrivalDate == null || departureDate == null || preferredType == null) {
            response.statusCode = 400;
            response.setJsonPayload({"Message":"Bad Request - Invalid Payload"});
            _ = connection.respond(response);
            return;
        }

        // Mock logic
        // If request is for an available car type, send a rental successful status
        string preferredTypeStr = preferredType.toString().trim();
        if (preferredTypeStr.equalsIgnoreCase(AC) || preferredTypeStr.equalsIgnoreCase(NORMAL)) {
            response.setJsonPayload({"Status":"Success"});
        }
        else {
            // If request is not for an available car type, send a rental failure status
            response.setJsonPayload({"Status":"Failed"});
        }
        // Send the response
        _ = connection.respond(response);
    }
}