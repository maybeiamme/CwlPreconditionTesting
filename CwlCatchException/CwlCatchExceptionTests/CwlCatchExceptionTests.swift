//
//  CwlCatchException.swift
//  CwlAssertionTesting
//
//  Created by Matt Gallagher on 2016/01/10.
//  Copyright © 2016 Matt Gallagher ( http://cocoawithlove.com ). All rights reserved.
//
//  Permission to use, copy, modify, and/or distribute this software for any purpose with or without
//  fee is hereby granted, provided that the above copyright notice and this permission notice
//  appear in all copies.
//
//  THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS
//  SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE
//  AUTHOR BE LIABLE FOR ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
//  WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT,
//  NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR PERFORMANCE
//  OF THIS SOFTWARE.
//

import Foundation
import XCTest
import CwlCatchException

class ExceptionSubclass: NSException {
}

class CatchExceptionTests: XCTestCase {
	func testCatchException() {
		// If no exception is thrown, result must be nil
		let noException = NSException.catchException {}
		XCTAssert(noException == nil)
		
		// An exception thrown should be caught by a "catch" of the same type
		let exceptionA = NSException.catchException {
			NSException(name: "a", reason: "b", userInfo: nil).raise()
		}
		XCTAssert(exceptionA != nil)
		XCTAssert(exceptionA!.name == "a")
		XCTAssert(exceptionA!.reason == "b")
		
		// An exception thrown should *not* be caught by a "catch" of a subtype
		var exceptionC: NSException? = nil
		let exceptionB = NSException.catchException {
			exceptionC = ExceptionSubclass.catchException {
				NSException(name: "c", reason: "d", userInfo: nil).raise()
			}
		}
		XCTAssert(exceptionB != nil)
		XCTAssert(exceptionB!.name == "c")
		XCTAssert(exceptionB!.reason == "d")
		XCTAssert(exceptionC == nil)
		
		// An exception thrown should be caught by a "catch" of a supertype
		let exceptionD = NSException.catchException {
			ExceptionSubclass(name: "e", reason: "f", userInfo: nil).raise()
		}
		XCTAssert(exceptionD != nil)
		XCTAssert(exceptionD!.name == "e")
		XCTAssert(exceptionD!.reason == "f")
	}
}