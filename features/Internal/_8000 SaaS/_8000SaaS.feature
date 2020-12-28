#language: en
@tree
@Positive
@SaasPrepare


Feature: create SaaS area

Background:
	Given I launch TestClient opening script or connect the existing one


	
Scenario:_800001 create SaaS area
	And I set "True" value to the constant "SaasMode"
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Create area Discount
		Given I open hyperlink "e1cib/list/Catalog.DataAreas"
		And I click the button named "FormCreate"
		And I input "Discount" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "1" text in "Code" field
		And I click "Save and close" button
	* Create area Forms
		And I click the button named "FormCreate"
		And I input "Forms" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "2" text in "Code" field
		And I click "Save and close" button
	* Create area FillingDocuments
		And I click the button named "FormCreate"
		And I input "FillingDocuments" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "41" text in "Code" field
		And I click "Save and close" button
	* Create area CreationBasedMulti
		And I click the button named "FormCreate"
		And I input "CreationBasedMulti" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "3" text in "Code" field
		And I click "Save and close" button
	* Create area Other
		And I click the button named "FormCreate"
		And I input "Other" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "4" text in "Code" field
		And I click "Save and close" button
	* Create area CashManagement
		And I click the button named "FormCreate"
		And I input "CashManagement" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "5" text in "Code" field
		And I click "Save and close" button
	* Create area Inventory
		And I click the button named "FormCreate"
		And I input "Inventory" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "6" text in "Code" field
		And I click "Save and close" button
	* Create area BankCashDocuments
		And I click the button named "FormCreate"
		And I input "BankCashDocuments" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "7" text in "Code" field
		And I click "Save and close" button
	* Create area Filters
		And I click the button named "FormCreate"
		And I input "Filters" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "8" text in "Code" field
		And I click "Save and close" button
	* Create area Purchase
		And I click the button named "FormCreate"
		And I input "Purchase" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "9" text in "Code" field
		And I click "Save and close" button
	* Create area AdditionalAttributes
		And I click the button named "FormCreate"
		And I input "AdditionalAttributes" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "10" text in "Code" field
		And I click "Save and close" button
	* Create area UserSettings
		And I click the button named "FormCreate"
		And I input "UserSettings" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "11" text in "Code" field
		And I click "Save and close" button
	* Create area Sales
		And I click the button named "FormCreate"
		And I input "Sales" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "12" text in "Code" field
		And I click "Save and close" button
	* Create area LinkedTransaction
		And I click the button named "FormCreate"
		And I input "LinkedTransaction" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "13" text in "Code" field
		And I click "Save and close" button
	* Create area AgingAndCreditLimit
		And I click the button named "FormCreate"
		And I input "AgingAndCreditLimit" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "14" text in "Code" field
		And I click "Save and close" button
	* Create area RetailDocuments
		And I click the button named "FormCreate"
		And I input "RetailDocuments" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "15" text in "Code" field
		And I click "Save and close" button
	* Create area PartnerCatalogs
		And I click the button named "FormCreate"
		And I input "PartnerCatalogs" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "16" text in "Code" field
		And I click "Save and close" button
	* Create area InfoMessages
		And I click the button named "FormCreate"
		And I input "InfoMessages" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "17" text in "Code" field
		And I click "Save and close" button
	* Create area ExtensionReportForm
		And I click the button named "FormCreate"
		And I input "ExtensionReportForm" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "18" text in "Code" field
		And I click "Save and close" button
	* Create area ContactInformation
		And I click the button named "FormCreate"
		And I input "ContactInformation" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "19" text in "Code" field
		And I click "Save and close" button
	* Create area DocumentVerification
		And I click the button named "FormCreate"
		And I input "DocumentVerification" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "20" text in "Code" field
		And I click "Save and close" button
	* Create area StandartAgreement
		And I click the button named "FormCreate"
		And I input "StandartAgreement" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "21" text in "Code" field
		And I click "Save and close" button
	* Create area AccessRights
		And I click the button named "FormCreate"
		And I input "AccessRights" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "22" text in "Code" field
		And I click "Save and close" button
	* Create area ItemCatalogs
		And I click the button named "FormCreate"
		And I input "ItemCatalogs" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "23" text in "Code" field
		And I click "Save and close" button
	* Create area PhysicalInventory
		And I click the button named "FormCreate"
		And I input "PhysicalInventory" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "24" text in "Code" field
		And I click "Save and close" button
	* Create area Price
		And I click the button named "FormCreate"
		And I input "Price" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "25" text in "Code" field
		And I click "Save and close" button
	* Create area SerialLotNumber
		And I click the button named "FormCreate"
		And I input "SerialLotNumber" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "26" text in "Code" field
		And I click "Save and close" button
	* Create area InputBySearchInLine
		And I click the button named "FormCreate"
		And I input "InputBySearchInLine" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "27" text in "Code" field
		And I click "Save and close" button
	* Create area LoadInfo
		And I click the button named "FormCreate"
		And I input "LoadInfo" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "28" text in "Code" field
		And I click "Save and close" button
	* Create area Services
		And I click the button named "FormCreate"
		And I input "Services" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "29" text in "Code" field
		And I click "Save and close" button
	* Create area SettingsCatalogs
		And I click the button named "FormCreate"
		And I input "SettingsCatalogs" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "30" text in "Code" field
		And I click "Save and close" button
	* Create area BasicFormsCheck
		And I click the button named "FormCreate"
		And I input "BasicFormsCheck" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "31" text in "Code" field
		And I click "Save and close" button
	* Create area OpeningEntries
		And I click the button named "FormCreate"
		And I input "OpeningEntries" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "32" text in "Code" field
		And I click "Save and close" button
	* Create area ProcurementDataProc
		And I click the button named "FormCreate"
		And I input "ProcurementDataProc" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "33" text in "Code" field
		And I click "Save and close" button
	* Create area InventoryTransfer
		And I click the button named "FormCreate"
		And I input "InventoryTransfer" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "34" text in "Code" field
		And I click "Save and close" button
	* Create area UserCatalogs
		And I click the button named "FormCreate"
		And I input "UserCatalogs" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "35" text in "Code" field
		And I click "Save and close" button
	* Create area CompanyCatalogs
		And I click the button named "FormCreate"
		And I input "CompanyCatalogs" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "36" text in "Code" field
		And I click "Save and close" button
	* Create area TaxCalculation
		And I click the button named "FormCreate"
		And I input "TaxCalculation" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "37" text in "Code" field
		And I click "Save and close" button
	* Create area PrintForm
		And I click the button named "FormCreate"
		And I input "PrintForm" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "38" text in "Code" field
		And I click "Save and close" button
	* Create area CurrencyRate
		And I click the button named "FormCreate"
		And I input "CurrencyRate" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "39" text in "Code" field
		And I click "Save and close" button
	* Create area Barcodes
		And I click the button named "FormCreate"
		And I input "Barcodes" text in "Description" field
		And I input "##Login##" text in "Login" field
		And I input "##Password##" text in "Password" field
		And I select "English" exact value from "Localization" drop-down list
		And I select "English" exact value from "Interface" drop-down list
		And I input "0" text in "Code" field
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And I input "40" text in "Code" field
		And I click "Save and close" button
		And I click "Update areas" button
		And Delay 60
	* Check creation
		If "List" table does not contain lines Then
			| 'Description'          | 'Data area status' |
			| 'Discount'             | 'Working'          |
			| 'Forms'                | 'Working'          |
			| 'CreationBasedMulti'   | 'Working'          |
			| 'Other'                | 'Working'          |
			| 'CashManagement'       | 'Working'          |
			| 'Inventory'            | 'Working'          |
			| 'BankCashDocuments'    | 'Working'          |
			| 'Filters'              | 'Working'          |
			| 'Purchase'             | 'Working'          |
			| 'AdditionalAttributes' | 'Working'          |
			| 'UserSettings'         | 'Working'          |
			| 'Sales'                | 'Working'          |
			| 'LinkedTransaction'    | 'Working'          |
			| 'AgingAndCreditLimit'  | 'Working'          |
			| 'RetailDocuments'      | 'Working'          |
			| 'PartnerCatalogs'      | 'Working'          |
			| 'InfoMessages'         | 'Working'          |
			| 'ExtensionReportForm'  | 'Working'          |
			| 'ContactInformation'   | 'Working'          |
			| 'DocumentVerification' | 'Working'          |
			| 'StandartAgreement'    | 'Working'          |
			| 'AccessRights'         | 'Working'          |
			| 'ItemCatalogs'         | 'Working'          |
			| 'PhysicalInventory'    | 'Working'          |
			| 'Price'                | 'Working'          |
			| 'SerialLotNumber'      | 'Working'          |
			| 'InputBySearchInLine'  | 'Working'          |
			| 'LoadInfo'             | 'Working'          |
			| 'Services'             | 'Working'          |
			| 'SettingsCatalogs'     | 'Working'          |
			| 'BasicFormsCheck'      | 'Working'          |
			| 'OpeningEntries'       | 'Working'          |
			| 'ProcurementDataProc'  | 'Working'          |
			| 'InventoryTransfer'    | 'Working'          |
			| 'UserCatalogs'         | 'Working'          |
			| 'CompanyCatalogs'      | 'Working'          |
			| 'TaxCalculation'       | 'Working'          |
			| 'PrintForm'            | 'Working'          |
			| 'CurrencyRate'         | 'Working'          |
			| 'Barcodes'             | 'Working'          |
			| 'FillingDocuments'     | 'Working'          |
			And Delay 120
			If "List" table does not contain lines Then
				| 'Description'          | 'Data area status' |
				| 'Discount'             | 'Working'          |
				| 'Forms'                | 'Working'          |
				| 'CreationBasedMulti'   | 'Working'          |
				| 'Other'                | 'Working'          |
				| 'CashManagement'       | 'Working'          |
				| 'Inventory'            | 'Working'          |
				| 'BankCashDocuments'    | 'Working'          |
				| 'Filters'              | 'Working'          |
				| 'Purchase'             | 'Working'          |
				| 'AdditionalAttributes' | 'Working'          |
				| 'UserSettings'         | 'Working'          |
				| 'Sales'                | 'Working'          |
				| 'LinkedTransaction'    | 'Working'          |
				| 'AgingAndCreditLimit'  | 'Working'          |
				| 'RetailDocuments'      | 'Working'          |
				| 'PartnerCatalogs'      | 'Working'          |
				| 'InfoMessages'         | 'Working'          |
				| 'ExtensionReportForm'  | 'Working'          |
				| 'ContactInformation'   | 'Working'          |
				| 'DocumentVerification' | 'Working'          |
				| 'StandartAgreement'    | 'Working'          |
				| 'AccessRights'         | 'Working'          |
				| 'ItemCatalogs'         | 'Working'          |
				| 'PhysicalInventory'    | 'Working'          |
				| 'Price'                | 'Working'          |
				| 'SerialLotNumber'      | 'Working'          |
				| 'InputBySearchInLine'  | 'Working'          |
				| 'LoadInfo'             | 'Working'          |
				| 'Services'             | 'Working'          |
				| 'SettingsCatalogs'     | 'Working'          |
				| 'BasicFormsCheck'      | 'Working'          |
				| 'OpeningEntries'       | 'Working'          |
				| 'ProcurementDataProc'  | 'Working'          |
				| 'InventoryTransfer'    | 'Working'          |
				| 'UserCatalogs'         | 'Working'          |
				| 'CompanyCatalogs'      | 'Working'          |
				| 'TaxCalculation'       | 'Working'          |
				| 'PrintForm'            | 'Working'          |
				| 'CurrencyRate'         | 'Working'          |
				| 'Barcodes'             | 'Working'          |
				| 'FillingDocuments'     | 'Working'          |
				And Delay 120
		And I close all client application windows
		
				
		
		
				
	