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

//TODO: replace it with real data
//TODO: add tests
class TwitterLiteViewController: UIViewController {
  @IBOutlet var tableView: UITableView!

  var viewModel: TwitterLiteViewModel!

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    viewModel = TwitterLiteViewModel(response: responseTweets, moreResponse: moreResponseTweets)
  }

  override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
    super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    viewModel = TwitterLiteViewModel(response: responseTweets, moreResponse: moreResponseTweets)
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    setupRefreshControl()
    viewModel.loadTweets()
  }

  private func setupRefreshControl() {
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
    tableView.refreshControl = refreshControl
  }

  private func displayResults() {
    DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.25) {
      self.tableView.refreshControl?.endRefreshing()
      self.tableView.reloadData()
    }
  }

  @objc private func refreshData() {
    viewModel.loadMoreTweets()
  }

  private func responseTweets() {
    displayResults()
  }

  //TODO:tableview animate the new data insertion
  // viewcontroller acts differently based on data income
  // added, loaded. Point to show how viewcontroller would act differently based on what ViewModel send 
  private func moreResponseTweets() {
    tableView.beginUpdates()
    let indexes = (0..<viewModel.lastFetchedTweetsCount).map { IndexPath(row: $0, section: 0) }
    tableView.insertRows(at: indexes, with: .fade)
    tableView.endUpdates()
    tableView.refreshControl?.endRefreshing()
  }
}

extension TwitterLiteViewController: UITableViewDataSource {
   func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return viewModel.tweets.count
  }

   func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "Tweet", for: indexPath)
    cell.textLabel?.text = viewModel.tweets[indexPath.row].text
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
    if searchText == viewModel.initialSearchText {
      viewModel.tweets = []
      tableView.reloadData()
    } else {
      viewModel.searchText = searchText
      viewModel.loadTweets()
    }
  }
}
