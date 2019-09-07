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

//protocol TwitterLiteViewModelDelegate: class {
//  func viewModel(_ viewModel: TwitterLiteViewModel,
//                 didReceiveResponse loadingStatus: LoadingStatus)
//}

class TwitterLiteViewModel {

  typealias CompletionHandler = (LoadingStatus) -> Void

 // weak var delegate: TwitterLiteViewModelDelegate?

  let emptyText = ""
  let fetchLimit = 6
  var searchContent: String
  var lastFetchedTweetsCount: Int = 0
  var tweets: [Tweet] = []
  var response: CompletionHandler

  init(response: @escaping CompletionHandler) {
    self.searchContent = emptyText
    self.response = response
  }
  // Mimic the behaviour of sending backend request
  func loadTweets(loadingStatus: LoadingStatus) {
    // 1
    if loadingStatus == .initial {
      tweets = []
    }
    // 2
    let range = makeRange(withStartIndex: tweets.count)
    // 3
    let fetchedResults = fetchResults(basedOn: searchContent, range: range)
    // 4
    let reversedResults = fetchedResults.reversed()
    // 5
    let tweetsArray = Array(reversedResults)
    // 6
    response(loadingStatus)
    //delegate?.viewModel(self, didReceiveResponse: loadingStatus)
  }

  private func makeRange(withStartIndex startIndex: Int) -> Range<Int> {
    let endIndex = startIndex + fetchLimit
    return startIndex..<endIndex
  }

  private func fetchResults(basedOn text: String, range: Range<Int>) -> [Tweet] {
    let searchResults = Backend.backendTweets.filter {
      return $0.text.range(of: text, options: .caseInsensitive) != nil
    }
    let clampedRange = range.clamped(to: range.lowerBound..<searchResults.count)
    let fetchResults = Array(searchResults[clampedRange])
    lastFetchedTweetsCount = fetchResults.count
    return fetchResults
  }
}
