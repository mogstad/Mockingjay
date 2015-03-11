//
//  BuildersTests.swift
//  Mockingjay
//
//  Created by Kyle Fuller on 01/03/2015.
//  Copyright (c) 2015 Cocode. All rights reserved.
//

import Foundation
import XCTest
import Mockingjay


class FailureBuilderTests : XCTestCase {
  func testFailure() {
    let request = NSURLRequest()
    let error = NSError()

    let response = failure(error)(request:request)

    XCTAssertEqual(response, Response.Failure(error))
  }

  func testHTTP() {
    let request = NSURLRequest(URL: NSURL(string: "http://example.com/index.html")!)
    let error = NSError()

    let response = http()(request: request)

    switch response {
    case let .Success(response, data):
      if let response = response as? NSHTTPURLResponse {
        XCTAssertEqual(response.statusCode, 200)
      } else {
        XCTFail("Test Failure")
      }
      break
    default:
      XCTFail("Test Failure")
    }
  }

  func testJSON() {
    let request = NSURLRequest(URL: NSURL(string: "http://example.com/index.json")!)
    let error = NSError()

    let response = json(["A"])(request: request)

    switch response {
    case let .Success(response, data):
      if let response = response as? NSHTTPURLResponse {
        XCTAssertEqual(response.statusCode, 200)
        XCTAssertEqual(response.MIMEType!, "application/json")
        XCTAssertEqual(response.textEncodingName!, "utf-8")
        let body = NSString(data:data!, encoding:NSUTF8StringEncoding) as! String
        XCTAssertEqual(body, "[\"A\"]")
      } else {
        XCTFail("Test Failure")
      }
      break
    default:
      XCTFail("Test Failure")
    }
  }
}
