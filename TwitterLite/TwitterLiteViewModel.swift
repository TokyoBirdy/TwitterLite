/// Copyright (c) 1 Reiwa Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import Foundation

class TwitterLiteViewModel {

// View model can track the state of the model, and Viewcontroller only need to handle how to react the the data. if only search, there is only ome state, but with refresh to control, there is more states that needs to be dealt with, and ViewModel is a good place to handle this to keep ViewController more focused on its UI job
  // handle the state of the model by saving the current model status * 

  let initialSearchText = ""
  var searchText: String
  var loadedTweets: [Tweet] = []
  let fetchLimit = 10

  var response: ([Tweet]) -> Void
  var moreResponse: ([Tweet]) -> Void

  init(response: @escaping ([Tweet]) -> Void, moreResponse: @escaping ([Tweet]) -> Void) {
    self.response = response
    self.moreResponse = moreResponse
    self.searchText = initialSearchText
  }

  //these functions were private functions before in ViewController, therefore there is no need to test. But doesn't mean that they are not testable.
  func loadTweets() {
    // Mimic the behaviour of sending backend request
    let range = makeRange(withStartIndex: 0)
    loadedTweets = Array(fetchResults(basedOn: searchText, range: range).reversed())
    response(loadedTweets)
  }

  func loadMoreTweets() {
    let range = makeRange(withStartIndex: loadedTweets.count)
    let tweets = Array(fetchResults(basedOn: searchText, range: range).reversed())
    loadedTweets = tweets + loadedTweets
    moreResponse(tweets)
  }

  private func makeRange(withStartIndex startIndex: Int) -> Range<Int> {
    let endIndex = startIndex + fetchLimit
    return startIndex..<endIndex
  }

  private func fetchResults(basedOn text: String, range: Range<Int>) -> [Tweet] {
    let searchResults = backendTweets.filter { $0.text.contains(text) }
    let fetchResults = Array(searchResults[range.startIndex..<min(range.endIndex, searchResults.count)])
    return fetchResults
  }
  
}
