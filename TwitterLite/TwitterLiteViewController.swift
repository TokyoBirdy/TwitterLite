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

import UIKit

class TwitterLiteViewController: UIViewController {
  
  @IBOutlet var tableView: UITableView!

  let emptyText = ""
  let fetchLimit = 6
  var searchContent: String
  var lastFetchedTweetsCount: Int = 0
  var tweets: [Tweet] = []

  required init?(coder aDecoder: NSCoder) {
    self.searchContent = emptyText
    super.init(coder: aDecoder)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupRefreshControl()
  }
  
  private func setupRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }
  
  @objc private func refreshData() {
    loadTweets(loadingStatus: .subsequent)
  }

  private func displayTweets(loadingStatus: LoadingStatus) {
    switch loadingStatus {
    case .initial:
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
        self.tableView.refreshControl?.endRefreshing()
        self.tableView.reloadData()
      }
    case .subsequent:
      tableView.refreshControl?.endRefreshing()
      let indexes = (0..<lastFetchedTweetsCount).map { IndexPath(row: $0, section: 0) }
      UIView.animate(withDuration: 1, delay: 0.5, options: [], animations: {
        self.tableView.beginUpdates()
        self.tableView.insertRows(at: indexes, with: .fade)
        self.tableView.endUpdates()
      }, completion: nil)
    }
  }

  private func loadTweets(loadingStatus: LoadingStatus) {
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
    tweets = tweetsArray + tweets
    displayTweets(loadingStatus: loadingStatus)
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

extension TwitterLiteViewController: UITableViewDataSource {
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return tweets.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
    cell.textLabel?.text = tweets[indexPath.row].text
    return cell
  }
}

extension TwitterLiteViewController: UITableViewDelegate {
  func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
  
  func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
    return UITableView.automaticDimension
  }
}

extension TwitterLiteViewController: UISearchBarDelegate {
  func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    searchBar.resignFirstResponder()
  }
  
  func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    if searchText == emptyText {
      tweets = []
      tableView.reloadData()
    } else {
      searchContent = searchText
      loadTweets(loadingStatus: .initial)
    }
  }
}
