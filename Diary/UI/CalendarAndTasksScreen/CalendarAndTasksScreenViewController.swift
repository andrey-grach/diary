import UIKit

final class CalendarAndTasksScreenViewController: UIViewController {

    @IBOutlet private var tableView: UITableView!
    @IBOutlet private var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Поменять местами?
        collectionView.register(
            CalendarDayCollectionViewCell.nib(),
            forCellWithReuseIdentifier: CalendarDayCollectionViewCell.identifier
        )
    }
}

extension CalendarAndTasksScreenViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        print("Selected row at \(indexPath)")
    }
}

extension CalendarAndTasksScreenViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        24
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "Hello world!"
        return cell
    }
}

extension CalendarAndTasksScreenViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: true)
        print("Selected item at \(indexPath)")
    }
}

extension CalendarAndTasksScreenViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        12
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: CalendarDayCollectionViewCell.identifier,
            for: indexPath
        )
        
        guard let cell = cell as? CalendarDayCollectionViewCell else { return cell }
        
        cell.configure(with: "Text")
        return cell
    }
}

//extension ViewController: UICollectionViewDelegateFlowLayout {
//    
//}
