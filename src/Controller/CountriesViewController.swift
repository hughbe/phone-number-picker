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
        return UIStoryboard(name: "PhoneNumberPicker", bundle: NSBundle(forClass: self)).instantiateViewControllerWithIdentifier("Countries") as! CountriesViewController
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
        tableView.tableFooterView = UIView(frame: CGRect.zeroRect)
        definesPresentationContext = true
    }
    
    public func willPresentSearchController(searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    
    public func willDismissSearchController(searchController: UISearchController) {
        tableView.reloadSectionIndexTitles()
    }
    
    public func updateSearchResultsForSearchController(searchController: UISearchController) {
        let searchString = searchController.searchBar.text
        searchForText(searchString)
        tableView.reloadData()
    }
    
    private func searchForText(text: String) {
        if text.isEmpty {
            filteredCountries = unfilteredCountries
        } else {
            let allCountries: [Country] = Countries.countries.filter { $0.name.rangeOfString(text) != nil }
            filteredCountries = partionedArray(allCountries, usingSelector: Selector("name"))
            filteredCountries.insert([], atIndex: 0) //Empty section for our favorites
        }
        tableView.reloadData()
    }
    
    public func searchBarTextDidEndEditing(searchBar: UISearchBar) {
        filteredCountries = unfilteredCountries
        tableView.reloadData()
    }
    
    //MARK: Viewing Countries
    private func setupCountries() {
        
        tableView.sectionIndexTrackingBackgroundColor = UIColor.clearColor()
        tableView.sectionIndexBackgroundColor = UIColor.clearColor()
        
        unfilteredCountries = partionedArray(Countries.countries, usingSelector: Selector("name"))
        unfilteredCountries.insert(Countries.countriesFromCountryCodes(majorCountryLocaleIdentifiers), atIndex: 0)
        tableView.reloadData()
        
        if let selectedCountry = selectedCountry {
            for (index, countries) in enumerate(unfilteredCountries) {
                if let countryIndex = find(countries, selectedCountry) {
                    let indexPath = NSIndexPath(forRow: countryIndex, inSection: index)
                    tableView.scrollToRowAtIndexPath(indexPath, atScrollPosition: .Middle, animated: true)
                    break
                }
            }
        }
    }
    
    override public func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return filteredCountries.count
    }
    
    override public func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredCountries[section].count
    }
    
    override public  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = self.tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath) as! UITableViewCell
        
        let country = filteredCountries[indexPath.section][indexPath.row]
        
        cell.textLabel?.text = country.name
        cell.detailTextLabel?.text = "+" + country.phoneExtension
        
        cell.accessoryType = .None
        
        if let selectedCountry = selectedCountry where country == selectedCountry {
            cell.accessoryType = .Checkmark
        }
        
        return cell
    }
    
    override public func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let countries = filteredCountries[section]
        if countries.isEmpty {
            return nil
        }
        if section == 0 {
            return ""
        }
        return UILocalizedIndexedCollation.currentCollation().sectionTitles[section - 1] as? String
    }
    
    override public func sectionIndexTitlesForTableView(tableView: UITableView) -> [AnyObject]! {
        return searchController.active ? nil : UILocalizedIndexedCollation.currentCollation().sectionTitles
    }
    
    override public func tableView(tableView: UITableView, sectionForSectionIndexTitle title: String, atIndex index: Int) -> Int {
        return UILocalizedIndexedCollation.currentCollation().sectionForSectionIndexTitleAtIndex(index + 1)
    }
    
    override public func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        delegate?.countriesViewController(self, didSelectCountry: filteredCountries[indexPath.section][indexPath.row])
    }
    
    @IBAction private func cancel(sender: UIBarButtonItem) {
        delegate?.countriesViewControllerDidCancel(self)
    }
}

private func partionedArray<T: AnyObject>(array: [T], usingSelector selector: Selector) -> [[T]] {
    let collation = UILocalizedIndexedCollation.currentCollation() as! UILocalizedIndexedCollation
    let numberOfSectionTitles = collation.sectionTitles.count
    
    var unsortedSections: [[T]] = Array(count: numberOfSectionTitles, repeatedValue: [])
    for object in array {
        let sectionIndex = collation.sectionForObject(object, collationStringSelector: selector)
        unsortedSections[sectionIndex].append(object)
    }
    
    var sortedSections: [[T]] = []
    for section in unsortedSections {
        let sortedSection = collation.sortedArrayFromArray(section, collationStringSelector: selector) as! [T]
        sortedSections.append(sortedSection)
    }
    return sortedSections
}