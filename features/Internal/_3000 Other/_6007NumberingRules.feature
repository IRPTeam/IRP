#language: en
@tree
@Positive
@Other


Feature: check numbering rules

Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"
Tag = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Tag"), "#Tag#")}"
webPort = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("webPort"), "#webPort#")}"
Publication = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Publication"), "#Publication#")}"


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _607700 preparation (check numbering rules)
	When set True value to the constant
	When set True value to the constant Use numbering rules
	* Load info
		When Create catalog ObjectStatuses objects
		When Create catalog BusinessUnits objects
		When Create catalog ItemKeys objects
		When Create catalog ItemTypes objects
		When Create catalog Partners objects
		When Create catalog Units objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertySets objects for ITO and item
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog PartnersBankAccounts objects
		When Create catalog CancelReturnReasons objects
		When Create catalog Currencies objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (own Second company)
		When Create catalog Stores objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create information register PartnerSegments records
		When Create catalog PartnerSegments objects
		When Create catalog Agreements objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects	
		When Create information register TaxSettings records
		When Create information register PricesByItemKeys records
		When Create catalog IntegrationSettings objects
		When Create catalog IntegrationSettings objects (db connection)
		When Create catalog Users objects
		When Create information register CurrencyRates records
		When Create information register Barcodes records
		When Create catalog ExternalFunctions objects
		When Create information register Taxes records (VAT)
		When Create catalog NumeratorBasicRules, NumeratorGroups objects and Counter
	When Create document PurchaseOrder objects (check movements, GR before PI, not Use receipt sheduling)
	When Create document PurchaseOrder objects (check movements, GR before PI, Use receipt sheduling)
	When Create document InventoryTransferOrder objects (check movements)
	When Create document InternalSupplyRequest objects (check movements)
	When Create document PurchaseInvoice objects
	* Settings for numerator
		* ConfigurationMetadata
			Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
			And I click "Refill metadata" button
			And I go to line in "List" table
				| "Description" |
				| "Catalogs"    |
			And I move one level down in "List" table
			And I go to line in "List" table
				| "Description"   |
				| "Partner terms" |
			And I select current line in "List" table
			And I remove checkbox named "Unused"
			And I click "Save and close" button
		* NumeratorBasicRules
			Given I open hyperlink "e1cib/data/Catalog.NumeratorBasicRules?ref=b857ef6bdcc86de611efda2e71ee5283"
			And I move to the tab named "GroupCatalogPrefixes"
			And in the table "CatalogPrefixes" I click the button named "CatalogPrefixesAdd"
			And I select "Partner terms" by string from the drop-down list named "CatalogPrefixesCatalog" in "CatalogPrefixes" table
			And I activate field named "CatalogPrefixesPrefix" in "CatalogPrefixes" table
			And I input "1" text in the field named "CatalogPrefixesPrefix" of "CatalogPrefixes" table
			And I finish line editing in "CatalogPrefixes" table
			And I move to the tab named "GroupDocumentPrefixes"
			And in the table "DocumentPrefixes" I click the button named "DocumentPrefixesAdd"
			And I select "sales invoice" by string from the drop-down list named "DocumentPrefixesDocument" in "DocumentPrefixes" table
			And I activate field named "DocumentPrefixesPrefix" in "DocumentPrefixes" table
			And I input "3" text in the field named "DocumentPrefixesPrefix" of "DocumentPrefixes" table
			And I finish line editing in "DocumentPrefixes" table
			And in the table "DocumentPrefixes" I click the button named "DocumentPrefixesAdd"
			And I select "Purchase invoice" by string from the drop-down list named "DocumentPrefixesDocument" in "DocumentPrefixes" table
			And I activate field named "DocumentPrefixesPrefix" in "DocumentPrefixes" table
			And I input "3" text in the field named "DocumentPrefixesPrefix" of "DocumentPrefixes" table
			And I finish line editing in "DocumentPrefixes" table
			And in the table "DocumentPrefixes" I click the button named "DocumentPrefixesAdd"
			And I select "Sales order" by string from the drop-down list named "DocumentPrefixesDocument" in "DocumentPrefixes" table
			And I activate field named "DocumentPrefixesPrefix" in "DocumentPrefixes" table
			And I input "2" text in the field named "DocumentPrefixesPrefix" of "DocumentPrefixes" table
			And I finish line editing in "DocumentPrefixes" table
			And I click "Save and close" button
		* NumeratorGroups
			Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5284"
			And I move to "For documents" tab
			And in the table "Documents" I click the button named "DocumentsAdd"
			And I select "sales invoice" from "Document" drop-down list by string in "Documents" table
			And I finish line editing in "Documents" table
			And in the table "Documents" I click the button named "DocumentsAdd"
			And I select "Purchase invoice" from "Document" drop-down list by string in "Documents" table
			And I finish line editing in "Documents" table
			And in the table "Documents" I click the button named "DocumentsAdd"
			And I select "Sales order" from "Document" drop-down list by string in "Documents" table
			And I move to "For catalogs" tab
			And I finish line editing in "Documents" table
			And in the table "Catalogs" I click the button named "CatalogsAdd"
			And I select "Partner terms" from "Catalog" drop-down list by string in "Catalogs" table
			And I activate field named "CatalogsNumberName" in "Catalogs" table
			And I click choice button of the attribute named "CatalogsNumberName" in "Catalogs" table
			And I select "Number" by string from the drop-down list named "CatalogsNumberName" in "Catalogs" table
			And I finish line editing in "Catalogs" table
			And I activate "Date attribute name" field in "Catalogs" table
			And I select current line in "Catalogs" table
			And I click choice button of "Date attribute name" attribute in "Catalogs" table
			And I select "Date" from "Date attribute name" drop-down list by string in "Catalogs" table
			And I finish line editing in "Catalogs" table
			And I click "Save and close" button						
		* Company numerator group (for documents)
			Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5286"
			And I move to "For documents" tab
			And in the table "Documents" I click the button named "DocumentsAdd"
			And I select "sales invoice" from "Document" drop-down list by string in "Documents" table
			And I finish line editing in "Documents" table
			And I click "Save and close" button
		* Yearly numerator group (for documents)
			Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5287"
			And I move to "For documents" tab
			And in the table "Documents" I click the button named "DocumentsAdd"
			And I select "Purchase invoice" from "Document" drop-down list by string in "Documents" table
			And I finish line editing in "Documents" table
			And I click "Save and close" button
	And I close all client application windows


Scenario: _607700 check preparation
	When check preparation

Scenario: _607701 check numeration for documents (continuous numbering is used for PI and SI, SO separate)
	And I close all client application windows
	* Create SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "72630016"
	* Create PI
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "72630017"
	* Create SO
		Given I open hyperlink "e1cib/list/Document.SalesOrder"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "72620001"
				
		
Scenario: _607702 check numeration for catalog (partner term)
	And I close all client application windows
	* Create Partber term
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "test" text in "ENG" field
		And I select from "Multi currency movement type" drop-down list by "eu" string
		And I expand "Agreement info" group
		And I input "24.01.2026" text in the field named "Date"
		And I change the radio button named "Type" value to "Customer"
		And I click "Save" button
		Then the form attribute named "Number" became equal to "72610128"
	And I close all client application windows

Scenario: _607703 check manual editing for numerator
	And I close all client application windows
	* Create SI with manually entered number
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "4545566" text in the field named "DocumentNumber"
	* Manually entered number is replaced by the numerator on write
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "72630018"
	And I close all client application windows


Scenario: _607704 check uniqueness control for documents
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.NumeratorGroups"
		And I go to line in "List" table
			| "Description"           |
			| "Basic numerator group" |
		And I select current line in "List" table
		And I move to "Other" tab
		And I set checkbox "Uniqueness control"
		And I set checkbox "Allowed manual editing"		
		And I click "Save and close" button
	* Create first SI
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click "Save" button
		And I save the value of the field named "DocumentNumber" as "SI1DocumentNumber"
		And I save the window as "SalesInvoice607704"
		And I close current window
	* Create second SI	
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "$SI1DocumentNumber$" variable value in the field named "DocumentNumber"
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Number [$SI1DocumentNumber$] is already used for [$SalesInvoice607704$]'|
	* Create PI with the same number (continuous numbering for PI and SI)
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "$SI1DocumentNumber$" variable value in the field named "DocumentNumber"
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Number [$SI1DocumentNumber$] is already used for [$SalesInvoice607704$]'|
	And I close all client application windows


Scenario: _607705 check numerator group is selected by company
	And I close all client application windows
	* Second company uses its own numerator group
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "00000001"
		And I close current window
	* Main company keeps the basic numerator group
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "72630019"


Scenario: _607706 check numbering period Year resets the counter
	And I close all client application windows
	* First PI of the previous year
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I input "15.06.2025" text in the field named "Date"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "00000001"
		And I close current window
	* First PI of the current year starts the counter again
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I input "15.06.2026" text in the field named "Date"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "00000001"


Scenario: _607707 check start number of the numerator
	And I close all client application windows
	* Set start number for the yearly numerator group
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5287"
		And I input "100" text in the field named "StartNumber"
		And I click "Save and close" button
	* The first document of a new period starts from the given number
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I input "15.06.2029" text in the field named "Date"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "00000100"
		And I close current window
	* Restore the start number
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5287"
		And I input "1" text in the field named "StartNumber"
		And I click "Save and close" button


Scenario: _607708 check numerator validity period
	And I close all client application windows
	* Limit the company numerator group to the previous year
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5286"
		And I input "01.01.2025" text in the field named "BeginDate"
		And I input "31.12.2025" text in the field named "EndDate"
		And I click "Save and close" button
	* Document out of the validity period falls back to the basic numerator group
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "26300001"
		And I close current window
	* Restore the validity period
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5286"
		And I input "01.01.0001" text in the field named "BeginDate"
		And I input "01.01.0001" text in the field named "EndDate"
		And I click "Save and close" button


Scenario: _607709 check manual editing is allowed by the numerator
	And I close all client application windows
	* Numerator group allows manual editing, the entered number is kept
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "90000001" text in the field named "DocumentNumber"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "90000001"


Scenario: _607710 check numbering without leading zeros
	And I close all client application windows
	* Switch off leading zeros
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5286"
		And I set checkbox "Without leading zeros"
		And I click "Save and close" button
	* Number is created without leading zeros
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "1"
		And I close current window
	* Restore leading zeros
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5286"
		And I remove checkbox "Without leading zeros"
		And I click "Save and close" button


Scenario: _607711 check Show numerator command on the document form
	And I close all client application windows
	* Open the numerator of the current document
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click "Save" button
		And I click the button named "InternalCommand_ShowNumerator"
		Then the form attribute named "NumeratorRules" became equal to "Company numerator group"


Scenario: _607712 check uniqueness control does not block another numerator group
	And I close all client application windows
	* Second company document takes its number from the company numerator group
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I click "Save" button
		And I save the value of the field named "DocumentNumber" as "SI607712Number"
		And I close current window
	* The same number is free for the basic numerator group of another company
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "$SI607712Number$" variable value in the field named "DocumentNumber"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "$SI607712Number$"


Scenario: _607713 check uniqueness control respects the numbering period
	And I close all client application windows
	* Switch on uniqueness control for the yearly numerator group
		Given I open hyperlink "e1cib/data/Catalog.NumeratorGroups?ref=b857ef6bdcc86de611efda2e71ee5287"
		And I move to "Other" tab
		And I set checkbox "Uniqueness control"
		And I click "Save and close" button
	* The first document of a new period gets the start number again
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I input "15.06.2027" text in the field named "Date"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "00000001"


Scenario: _607714 check the number counter is not rolled back after rejection
	And I close all client application windows
	* Rejected document gets a new number on the next attempt
		Given I open hyperlink "e1cib/list/Document.PurchaseInvoice"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Second Company" string
		And I input "15.06.2028" text in the field named "Date"
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		And I click "Save" button
		Then the form attribute named "DocumentNumber" became equal to "00000002"


Scenario: _607715 check uniqueness control for catalog Partner terms
	And I close all client application windows
	* Create the first partner term
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "test uniqueness" text in "ENG" field
		And I select from "Multi currency movement type" drop-down list by "eu" string
		And I expand "Agreement info" group
		And I input "24.01.2026" text in the field named "Date"
		And I change the radio button named "Type" value to "Customer"
		And I click "Save" button
		And I save the value of the field named "Number" as "Agreement607715Number"
		And I save the window as "Agreement607715"
		And I close current window
	* The same number is rejected for the second partner term
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click "Create" button
		And I select from the drop-down list named "Company" by "Main Company" string
		And I input "test uniqueness 2" text in "ENG" field
		And I select from "Multi currency movement type" drop-down list by "eu" string
		And I expand "Agreement info" group
		And I input "24.01.2026" text in the field named "Date"
		And I change the radio button named "Type" value to "Customer"
		And I input "$Agreement607715Number$" variable value in the field named "Number"
		And I click "Save" button
		Then "1C:Enterprise" window is opened
		And I click the button named "OK"
		Then there are lines in TestClient message log
			|'Number [$Agreement607715Number$] is already used for [test uniqueness]'|
	
				
				


		
