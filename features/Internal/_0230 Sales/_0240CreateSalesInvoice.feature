#language: en
@tree
@Positive
@Sales

Feature: create document Sales invoice

As a sales manager
I want to create a Sales invoice document
To sell a product to a customer


Background:
	Given I launch TestClient opening script or connect the existing one



Scenario: _024000 preparation (Sales invoice)
	When set True value to the constant
	And I close TestClient session
	Given I open new TestClient session or connect the existing one
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create information register CurrencyRates records
		When update ItemKeys
	* Add plugin for taxes calculation
		Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
		If "List" table does not contain lines Then
				| "Description" |
				| "TaxCalculateVAT_TR" |
			When add Plugin for tax calculation
		When Create information register Taxes records (VAT)
	* Tax settings
		When filling in Tax settings for company
		When Create document SalesOrder objects (check movements, SI before SC, not Use shipment sheduling)
		And I execute 1C:Enterprise script at server
 			| "Documents.SalesOrder.FindByNumber(3).GetObject().Write(DocumentWriteMode.Posting);" |

Scenario: _024008 create document Sales Invoice based on sales order (partial quantity)
	* Select SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I go to line in "List" table
			| 'Number' | 'Partner'   | 'Date'                |
			| '3'      | 'Ferron BP' | '27.01.2021 19:50:45' |
	* Create SI
		And I click the button named "FormDocumentSalesInvoiceGenerate"
		Then "Add linked document rows" window is opened
		And I expand current line in "DocumentsTree" table
		And "DocumentsTree" table became equal
			| 'Row presentation'                        | 'Use'                                     | 'Basis unit' | 'Quantity' |
			| 'Sales order 3 dated 27.01.2021 19:50:45' | 'Sales order 3 dated 27.01.2021 19:50:45' | ''           | ''         |
			| 'Dress, XS/Blue, Store 02'                | 'Yes'                                     | 'pcs'        | '1,000'    |
			| 'Shirt, 36/Red, Store 02'                 | 'Yes'                                     | 'pcs'        | '10,000'   |
			| 'Service, Interner, Store 02'             | 'Yes'                                     | 'pcs'        | '1,000'    |
		And I go to line in "DocumentsTree" table
			| 'Row presentation'            |
			| 'Service, Interner, Store 02' |
		And I change "Use" checkbox in "DocumentsTree" table
		And I finish line editing in "DocumentsTree" table
		And I click "Ok" button
	* Check filling in SI
		Then the form attribute named "Partner" became equal to "Ferron BP"
		Then the form attribute named "LegalName" became equal to "Company Ferron BP"
		Then the form attribute named "Agreement" became equal to "Basic Partner terms, TRY"
		Then the form attribute named "Company" became equal to "Main Company"
		Then the form attribute named "Store" became equal to "Store 02"
		And "ItemList" table contains lines
			| 'Business unit' | 'Price type'        | 'Item'  | 'Item key' | 'Dont calculate row' | 'Q'      | 'Unit' | 'Tax amount' | 'Price'  | 'VAT' | 'Offers amount' | 'Net amount' | 'Total amount' | 'Additional analytic' | 'Store'    | 'Delivery date' | 'Use shipment confirmation' | 'Detail' | 'Sales order'                             | 'Revenue type' |
			| ''              | 'Basic Price Types' | 'Dress' | 'XS/Blue'  | 'No'                 | '1,000'  | 'pcs'  | '75,36'      | '520,00' | '18%' | '26,00'         | '418,64'     | '494,00'       | ''                    | 'Store 02' | '27.01.2021'    | 'No'                        | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' | ''             |
			| ''              | 'Basic Price Types' | 'Shirt' | '36/Red'   | 'No'                 | '10,000' | 'pcs'  | '507,20'     | '350,00' | '18%' | '175,00'        | '2 817,80'   | '3 325,00'     | ''                    | 'Store 02' | '27.01.2021'    | 'No'                        | ''       | 'Sales order 3 dated 27.01.2021 19:50:45' | ''             |

		And "SpecialOffers" table contains lines
			| '#' | 'Amount' |
			| '1' | '26,00'  |
			| '2' | '175,00' |

		Then the number of "PaymentTerms" table lines is "равно" 0
		And "ObjectCurrencies" table became equal
			| 'Movement type'      | 'Type'         | 'Currency from' | 'Currency' | 'Rate presentation' | 'Multiplicity' | 'Amount' |
			| 'TRY'                | 'Partner term' | 'TRY'           | 'TRY'      | '1'                 | '1'            | '3 819'  |
			| 'Local currency'     | 'Legal'        | 'TRY'           | 'TRY'      | '1'                 | '1'            | '3 819'  |
			| 'Reporting currency' | 'Reporting'    | 'TRY'           | 'USD'      | '0,1712'            | '1'            | '653,81' |

		Then the number of "ShipmentConfirmationsTree" table lines is "равно" 0
		Then the form attribute named "ManagerSegment" became equal to "Region 1"
		Then the form attribute named "BusinessUnit" became equal to ""
		Then the form attribute named "Author" became equal to "en description is empty"
		Then the form attribute named "Manager" became equal to ""
		Then the form attribute named "PriceIncludeTax" became equal to "Yes"
		Then the form attribute named "Date" became equal to "23.02.2021 00:00:00"
		Then the form attribute named "Number" became equal to "0"
		Then the form attribute named "Currency" became equal to "TRY"
		Then the form attribute named "DeliveryDate" became equal to "27.01.2021 00:00:00"
		And the editing text of form attribute named "ItemListTotalOffersAmount" became equal to "201,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "3 236,44"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "582,56"
		And the editing text of form attribute named "ItemListTotalTotalAmount" became equal to "3 819,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"
	* Change quantity
		And I go to line in "ItemList" table
			| 'Item'  | 'Item key' | 'Q'      |
			| 'Shirt' | '36/Red'   | '10,000' |
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I select current line in "ItemList" table
		And I input "5,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click the button named "FormPost"
		And I delete "$$SalesInvoice024008$$" variable
		And I delete "$$NumberSalesInvoice024008$$" variable
		And I save the window as "$$SalesInvoice024008$$"
		And I save the value of "Number" field as "$$NumberSalesInvoice024008$$"
		And I click the button named "FormPostAndClose"
  
		
				
		
				
		
				
		
				
		
				


		
				
		
	


		
	
	

Scenario: _024025 create document Sales Invoice without Sales order
	When create SalesInvoice024025



# Scenario: _024035 check the form of selection of items (sales invoice)
# 	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
# 	And I click the button named "FormCreate"
# 	* Filling in the main details of the document
# 		And I click Select button of "Partner" field
# 		And I go to line in "List" table
# 			| 'Description' |
# 			| 'Ferron BP'  |
# 		And I select current line in "List" table
# 		And I click Select button of "Partner term" field
# 		And I go to line in "List" table
# 			| 'Description'       |
# 			| 'Basic Partner terms, TRY' |
# 		And I select current line in "List" table
# 		And I click Select button of "Legal name" field
# 		And I go to line in "List" table
# 			| 'Description' |
# 			| 'Company Ferron BP'  |
# 		And I select current line in "List" table
# 	* Select Store
# 		And I click Select button of "Store" field
# 		And I go to line in "List" table
# 			| 'Description' |
# 			| 'Store 01'  |
# 		And I select current line in "List" table
# 	When check the product selection form with price information in Sales invoice
# 	And I click the button named "FormPostAndClose"
# 	* Save check
# 		And "List" table contains lines
# 			| 'Partner'     |'Σ'          |
# 			| 'Ferron BP'   | '2 050,00'  |
# 	And I close all client application windows



Scenario: _024042 check totals in the document Sales invoice
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Select Sales invoice
		And I go to line in "List" table
		| Number |
		| '$$NumberSalesInvoice024001$$'      |
		And I select current line in "List" table
	* Check totals
		Then the form attribute named "ItemListTotalOffersAmount" became equal to "0,00"
		Then the form attribute named "ItemListTotalNetAmount" became equal to "3 686,44"
		Then the form attribute named "ItemListTotalTaxAmount" became equal to "663,56"
		Then the form attribute named "ItemListTotalTotalAmount" became equal to "4 350,00"
		Then the form attribute named "CurrencyTotalAmount" became equal to "TRY"




Scenario: _300505 check connection to Sales invoice report "Related documents"
	Given I open hyperlink "e1cib/list/Document.SalesInvoice"
	* Form report Related documents
		And I go to line in "List" table
		| Number |
		| $$NumberSalesInvoice024001$$      |
		And I click the button named "FormFilterCriterionRelatedDocumentsRelatedDocuments"
		And Delay 1
	Then "Related documents" window is opened
	And I close all client application windows







	
















	




