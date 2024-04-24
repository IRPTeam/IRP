#language: en
@tree
@Positive
@LoadInfo

Functionality: Import/Export object from DB

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _020200 preparation (Import/Export object from DB)
	When set True value to the constant
	When set True value to the constant Use commission trading 
	* Load info
		When Create catalog ExpenseAndRevenueTypes objects
		When Create catalog BusinessUnits objects
		When Create information register Barcodes records
		When Create catalog Companies objects (own Second company)
		When Create catalog CashAccounts objects
		When Create catalog Agreements objects
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemKeys objects (serial lot numbers)
		When Create catalog ItemTypes objects
		When Create catalog ItemTypes objects (serial lot numbers)
		When Create catalog Units objects
		When Create catalog Countries objects
		When Create catalog Items objects
		When Create catalog Items objects (serial lot numbers)
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Users objects
		When Create catalog Partners objects
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When Create catalog SerialLotNumbers objects (serial lot numbers)
		When Create information register Barcodes records (serial lot numbers)
		When Create catalog FileStorageVolumes objects
		When Create catalog Files objects
		When Create information register Taxes records (VAT)
	* Load SI
		When Create document SalesInvoice objects (import and export)

Scenario: _0202001 check preparation
	When check preparation


Scenario: _0202002 check import item
	And I close all client application windows
	* Open Item catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'      |
			| 'Product 5 with SLN'    |
	* Open Import/Export object from DB
		Given I open hyperlink "e1cib/app/DataProcessor.LoadAndUnloadData"
		And in the table "FormItems" I click "Update" button
		And "FormItems" table became equal
			| 'Description'          |
			| 'Items/List/Rows:1'    |
		And in the table "FormItems" I click "Serialize" button	
	* Check import item
		And I save the value of the field named "SerializedInfo" as "SerializedInfo"
		And I execute 1C:Enterprise script
			| "Контекст.SerializedInfo=StrReplace(Контекст.SerializedInfo, "992046ec-7f8d-11ed-b78d-b8d3fd6dff8b", "992046ec-7f8d-11ed-b78d-b8d3fd6dff9b");" |
			| "Контекст.SerializedInfo=StrReplace(Контекст.SerializedInfo, "Product 5 with SLN", "Product 5 with SLN New");"                                 |
			| "Контекст.SerializedInfo=StrReplace(Контекст.SerializedInfo, "165", "180")"                                                                    |
		And I input "$SerializedInfo$" variable value in "Deserialized info" field
		And I click the button named "Import"
		Then the form attribute named "Log" became equal to "Product 5 with SLN New"
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click "Refresh" button
		And I go to line in "List" table
			| 'Description'          |
			| 'Product 5 with SLN New'    |
		And I select current line in "List" table
		Then the form attribute named "ItemType" became equal to "With serial lot numbers (without stock control)"
		Then the form attribute named "Unit" became equal to "pcs"
		Then the form attribute named "Vendor" became equal to ""
		Then the form attribute named "Code" became equal to "180"
		Then the form attribute named "Description_en" became equal to "Product 5 with SLN New"
		Then the form attribute named "Length" became equal to "0"
		Then the form attribute named "Width" became equal to "0"
		Then the form attribute named "Height" became equal to "0"
		Then the form attribute named "Volume" became equal to "0"
		Then the form attribute named "Weight" became equal to "0"


Scenario: _0202003 check import SI
	And I close all client application windows
	* Open SI list form
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number'    |
			| '16'        |
	* Open Import/Export object from DB
		Given I open hyperlink "e1cib/app/DataProcessor.LoadAndUnloadData"
		And in the table "FormItems" I click "Update" button
		And "FormItems" table became equal
			| 'Description'                   |
			| 'Sales invoices/List/Rows:1'    |
		And in the table "FormItems" I click "Serialize" button	
	* Check import item
		And I save the value of the field named "SerializedInfo" as "SerializedInfo1"
		And I execute 1C:Enterprise script
			| "Контекст.SerializedInfo1=StrReplace(Контекст.SerializedInfo1, "c0c54205-d3a6-11ed-b799-96ebf0bd5444", "c0c54205-d3a6-11ed-b799-96ebf0bd6444");"    |
			| "Контекст.SerializedInfo1=StrReplace(Контекст.SerializedInfo1, "<d2p1:Number>16</d2p1:Number>", "<d2p1:Number>180</d2p1:Number>")"                  |
		And I input "$SerializedInfo1$" variable value in "Deserialized info" field
		And I set checkbox "Import data to product data base is granted"
		And I click the button named "Import"
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Refresh" button
		And I go to line in "List" table
			| 'Number'    |
			| '180'       |
		And I select current line in "List" table
		Then the form attribute named "Partner" became equal to "Kalipso"
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, without VAT"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "TransactionType" became equal to "Sales"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table became equal
			| '#'   | 'Inventory origin'   | 'Sales person'   | 'Price type'                | 'Item'    | 'Item key'   | 'Profit loss center'   | 'Dont calculate row'   | 'Tax amount'   | 'Unit'   | 'Serial lot numbers'   | 'Source of origins'   | 'Quantity'   | 'Price'    | 'VAT'   | 'Offers amount'   | 'Net amount'   | 'Total amount'   | 'Use work sheet'   | 'Other revenue type'   | 'Additional analytic'   | 'Store'      | 'Delivery date'   | 'Use shipment confirmation'   | 'Detail'   | 'Sales order'   | 'Work order'   | 'Revenue type'    |
			| '1'   | 'Own stocks'         | ''               | 'Basic Price without VAT'   | 'Dress'   | 'XS/Blue'    | ''                     | 'No'                   | '158,64'       | 'pcs'    | ''                     | ''                    | '2,000'      | '440,68'   | '18%'   | ''                | '881,36'       | '1 040,00'       | 'No'               | ''                     | ''                      | 'Store 02'   | '11.10.2020'      | 'Yes'                         | ''         | ''              | ''             | ''                |
			| '2'   | 'Own stocks'         | ''               | 'Basic Price without VAT'   | 'Dress'   | 'XS/Blue'    | ''                     | 'No'                   | '237,97'       | 'pcs'    | ''                     | ''                    | '3,000'      | '440,68'   | '18%'   | ''                | '1 322,04'     | '1 560,01'       | 'No'               | ''                     | ''                      | 'Store 02'   | '11.10.2020'      | 'Yes'                         | ''         | ''              | ''             | ''                |
		
		Then the form attribute named "ManagerSegment" became equal to "Region 2"
		Then the form attribute named "Branch" became equal to ""
		Then the form attribute named "Author" became equal to "CI"
		Then the form attribute named "Manager" became equal to ""
		Then the form attribute named "PriceIncludeTax" became equal to "No"
		Then the form attribute named "Date" became equal to "05.04.2023 14:48:51"
		Then the form attribute named "Number" became equal to "180"
		Then the form attribute named "Currency" became equal to "TRY"
		And the editing text of form attribute named "ItemListTotalNetAmount" became equal to "2 203,40"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "396,61"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "2 600,01"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
		And I close all client application windows



Scenario: _0202004 check find refs
	And I close all client application windows
	* Open Import/Export object from DB
		Given I open hyperlink "e1cib/app/DataProcessor.LoadAndUnloadData"
	* Finf refs
		Then "Load and unload data" window is opened
		And I move to "Find refs" tab
		And I click Select button of "Search ref" field
		Then "Select data type" window is opened
		And I go to line in "" table
			| ''           |
			| 'Company'    |
		And I select current line in "" table
		Then "Companies" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'DFC'            |
		And I select current line in "List" table
		And I click "Find ref" button
	* Check
		And "FoundRefList" table contains lines
			| 'Ref'                             | 'Metadata name'         |
			| 'Partner term vendor DFC'         | 'Catalog.Agreements'    |
			| 'DFC Vendor by Partner terms'     | 'Catalog.Agreements'    |
			| 'DFC Customer by Partner terms'   | 'Catalog.Agreements'    |
	And I close all client application windows
	
				
				


				
	
