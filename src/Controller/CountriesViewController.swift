//
//  CountriesViewController.swift
//  PhoneNumberPicker
//
//  Created by Hugh Bellamy on 06/09/2015.
//  Copyright (c) 2015 Hugh Bellamy. All rights reserved.
//

import UIKit

public protocol CountriesViewControllerDelegate {
    func countriesViewControllerDidCancel(countriesViewController: CountriesViewController)
    func countriesViewController(countriesViewController: CountriesViewController, didSelectCountry country: Country)
}

public final class CountriesViewController: UITableViewController, UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate {
    public class func standardController() -> CountriesViewController {
        return UIStoryboard(name: "PhoneNumberPicker", bundle: Bundle(for: self)).instantiateViewController(withIdentifier: "Countries") as! CountriesViewController
    }
    
    @IBOutlet weak public var cancelBarButtonItem: UIBarButtonItem!
    public var cancelBarButtonItemHidden = false { didSet { setupCancelButton() } }
    
    private func setupCancelButton() {
        if let cancelBarButtonItem = cancelBarButtonItem {
            navigationItem.leftBarButtonItem = cancelBarButtonItemHidden ? nil: cancelBarButtonItem
        }
    }
    
    private var searchController = UISearchController(searchResultsController: nil)
    
    public var unfilteredCountries: [[Country]]! { didSet { filteredCountries = unfilteredCountries } }
    public var filteredCountries: [[Country]]!
    
    public var selectedCountry: Country?
    public var majorCountryLocaleIdentifiers: [String] = []
    
    public var delegate: CountriesViewControllerDelegate?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        
        setupCancelButton()
        
        setupCountries()
        setupSearchController()
    }
    
    //MARK: Searching Countries
    private func setupSearchController() {
        searchController.delegate = self
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        searchController.searchBar.delegate = self
        searchController.searchBar.sizeToFit()
        
        tableView.tableHeaderView = searchController.searchBar
        tableView.tableFooterView = UIView(frame: CGRect.zero)
        definesPresentationContext = true
    }
    
    public func willPresentSearchController(_ searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    
    public func willDismissSearchController(_ searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    
    public func updateSearchResults(for searchController: UISearchController) {
        let searchString = searchController.searchBar.text ?? ""
        searchForText(text: searchString)
        tableView.reloadData()
    }
    
    private func searchForText(text: String) {
        if text.isEmpty {
            filteredCountries = unfilteredCountries
        } else {
            let allCountries: [Country] = Countries.countries.filter { $0.name.range(of: text) != nil }
            filteredCountries = partionedArray(array: allCountries, usingSelector: #selector(getter: Country.name))
            filteredCountries.insert([], at: 0) //Empty section for our favorites
        }
        tableView.reloadData()
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        filteredCountries = unfilteredCountries
        tableView.reloadData()
    }
    
    //MARK: Viewing Countries
    private func setupCountries() {
        
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clear
        tableView.sectionIndexBackgroundColor = UIColor.clear
        
        unfilteredCountries = partionedArray(array: Countries.countries, usingSelector: #selector(getter: Country.name))
        unfilteredCountries.insert(Countries.countriesFromCountryCodes(countryCodes: majorCountryLocaleIdentifiers), at: 0)
        tableView.reloadData()
        
        if let selectedCountry = selectedCountry {
            for (index, countries) in unfilteredCountries.enumerated() {
                if let countryIndex = countries.index(of: selectedCountry) {
                    let indexPath = NSIndexPath(row: countryIndex, section: index)
                    tableView.scrollToRow(at: indexPath as IndexPath, at: .middle, animated: true)
                    break
                }
            }
        }
    }
    
    public override func numberOfSections(in tableView: UITableView) -> Int {
        return filteredCountries.count
    }
    
    public override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries[section].count
    }
    
    public override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let country = filteredCountries[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "+" + country.phoneExtension
        
        cell.accessoryType = .none
        
        if let selectedCountry = selectedCountry, country == selectedCountry {
            cell.accessoryType = .checkmark
        }
        
        return cell
    }
    
    public override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let countries = filteredCountries[section]
        if countries.isEmpty {
            return nil
        }
        if section == 0 {
            return ""
        }
        return UILocalizedIndexedCollation.current().sectionTitles[section - 1]
    }
    
    public override func sectionIndexTitles(for tableView: UITableView) -> [String]? {
        return searchController.isActive ? nil : UILocalizedIndexedCollation.current().sectionTitles
    }
    
    public override func tableView(_ tableView: UITableView, sectionForSectionIndexTitle title: String, at index: Int) -> Int {
        return UILocalizedIndexedCollation.current().section(forSectionIndexTitle: index + 1)
    }
    
    public override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.countriesViewController(countriesViewController: self, didSelectCountry: filteredCountries[indexPath.section][indexPath.row])
    }
    
    @IBAction private func cancel(sender: UIBarButtonItem) {
        delegate?.countriesViewControllerDidCancel(countriesViewController: self)
    }
}

private func partionedArray<T: AnyObject>(array: [T], usingSelector selector: Selector) -> [[T]] {
    let collation = UILocalizedIndexedCollation.current()
    let numberOfSectionTitles = collation.sectionTitles.count
    
    var unsortedSections: [[T]] = Array(repeating: [], count: numberOfSectionTitles)
    for object in array {
        let sectionIndex = collation.section(for: object, collationStringSelector: selector)
        unsortedSections[sectionIndex].append(object)
    }
    
    var sortedSections: [[T]] = []
    for section in unsortedSections {
        let sortedSection = collation.sortedArray(from: section, collationStringSelector: selector) as! [T]
        sortedSections.append(sortedSection)
    }
    return sortedSections
}
