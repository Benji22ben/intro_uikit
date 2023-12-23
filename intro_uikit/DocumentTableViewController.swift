//
//  DocumentTableViewController.swift
//  intro_uikit
//
//  Created by MARQUES BALULA Benjamin on 06/12/2023.
//

import UIKit
import QuickLook
import MobileCoreServices

struct DocumentFile {
    var title: String
    var size: Int
    var imageName: String?
    var url: URL
    var type: String
    
    var isImported: Bool {
        return !url.absoluteString.starts(with: "file://")
    }
}

extension Int {
    func formattedSize() -> String {
        return ByteCountFormatter().string(fromByteCount: Int64(Int(self)))
    }
}

class DocumentTableViewController: UITableViewController, QLPreviewControllerDataSource, UIDocumentPickerDelegate {
    var allDocumentFiles = [DocumentFile]()
    
    var importedDocumentFiles: [DocumentFile] {
        return allDocumentFiles.filter { $0.isImported }
    }
    
    var bundleDocumentFiles: [DocumentFile] {
        return allDocumentFiles.filter { !$0.isImported }
    }
    
    var selectedDocumentIndex: Int?
    
    func listFiles() {
        allDocumentFiles.removeAll()

        if let bundleResourcePath = Bundle.main.resourcePath {
            do {
                let bundleFileURLs = try FileManager.default.contentsOfDirectory(atPath: bundleResourcePath)
                for item in bundleFileURLs {
                    if item.hasSuffix("jpg") {
                        let url: URL = URL(fileURLWithPath: bundleResourcePath + "/" + item)
                        let file = try url.resourceValues(forKeys: [.typeIdentifierKey, .nameKey, .fileSizeKey])

                        guard let fileSize = file.fileSize, let name = file.name, let type = file.typeIdentifier else { return }

                        let documentFile = DocumentFile(title: name, size: fileSize, url: url, type: type)
                        allDocumentFiles.append(documentFile)
                    }
                }
            } catch {
                print(error)
            }
        }

        // 2. Récupérer les fichiers du dossier de l'application
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        do {
            let fileURLs = try FileManager.default.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            for fileURL in fileURLs {
                let file = try fileURL.resourceValues(forKeys: [.typeIdentifierKey, .nameKey, .fileSizeKey])
                guard let fileSize = file.fileSize, let name = file.name, let type = file.typeIdentifier else { return }

                let documentFile = DocumentFile(title: name, size: fileSize, url: fileURL, type: type)
                allDocumentFiles.append(documentFile)
            }
        } catch {
            print(error)
        }

        tableView.reloadData()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        listFiles()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addDocument))
    }
    
    @objc func addDocument() {
        launchDocumentPicker()
    }
    
    func launchDocumentPicker() {
        let documentPicker = UIDocumentPickerViewController(documentTypes: [String(kUTTypeData)], in: .import)
        documentPicker.delegate = self
        present(documentPicker, animated: true, completion: nil)
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        guard let pickedURL = urls.first else { return }
        
        copyFileToDocumentsDirectory(fromUrl: pickedURL)
    }
    
    func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func copyFileToDocumentsDirectory(fromUrl url: URL) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        // Créez un nouveau nom de fichier unique en ajoutant un timestamp
        let uniqueFilename = "\(Date().timeIntervalSince1970)_\(url.lastPathComponent)"
        
        // Créez l'URL de destination avec le nouveau nom de fichier
        let destinationUrl = documentsDirectory.appendingPathComponent(uniqueFilename)
        
        do {
            try FileManager.default.copyItem(at: url, to: destinationUrl)
        } catch {
            print(error)
        }
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch section {
        case 0:
            return importedDocumentFiles.count
        case 1:
            return bundleDocumentFiles.count
        default :
            return 0
        }

    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        switch section {
        case 0:
            return "Importé"
        case 1 :
            return "Bundle"
        default :
            return nil
        }
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocumentCell", for: indexPath)


        switch indexPath.section {
        case 0:
            let importedDocument = importedDocumentFiles[indexPath.row]
            cell.textLabel?.text = importedDocument.title
            cell.detailTextLabel?.text = String(importedDocument.size.formattedSize())
        case 1:
            let bundleDocument = bundleDocumentFiles[indexPath.row]
            cell.textLabel?.text = bundleDocument.title
            cell.detailTextLabel?.text = String(bundleDocument.size.formattedSize())
        default:
            break
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            selectedDocumentIndex = indexPath.row
            showPreviewController()
        }
    
    func showPreviewController() {
        guard selectedDocumentIndex != nil else { return }

            let previewController = QLPreviewController()
            previewController.dataSource = self

            navigationController?.pushViewController(previewController, animated: true)
        }
    
    func numberOfPreviewItems(in controller: QLPreviewController) -> Int {
            return 1
        }
    
    func previewController(_ controller: QLPreviewController, previewItemAt index: Int) -> QLPreviewItem {
            guard let selectedDocumentIndex = selectedDocumentIndex else {
                fatalError("Selected document index is nil.")
            }

            let selectedDocument = allDocumentFiles[selectedDocumentIndex]

            return selectedDocument.url as QLPreviewItem
        }
    
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        if segue.identifier == "ShowDocumentSegue" {
//            if let indexPath = tableView.indexPathForSelectedRow {
//                let selectedDocument = allDocumentFiles[indexPath.row]
//                if let destinationVC = segue.destination as? DocumentViewController {
//                    destinationVC.imageName = selectedDocument.imageName
//                }
//            }
//        }
//    }
    

    
    /*
     // Override to support conditional editing of the table view.
     override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the specified item to be editable.
     return true
     }
     */
    
    /*
     // Override to support editing the table view.
     override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
     if editingStyle == .delete {
     // Delete the row from the data source
     tableView.deleteRows(at: [indexPath], with: .fade)
     } else if editingStyle == .insert {
     // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
     }
     }
     */
    
    /*
     // Override to support rearranging the table view.
     override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {
     
     }
     */
    
    /*
     // Override to support conditional rearranging of the table view.
     override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
     // Return false if you do not want the item to be re-orderable.
     return true
     }
     */
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}
