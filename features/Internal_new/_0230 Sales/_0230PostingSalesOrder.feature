#language: en
@tree
@Positive
@Other

Feature: role Full access only read


Background:
	Given I launch TestClient opening script or connect the existing one

Scenario: 950000 preparation (role Full access only read)
	When Create catalog AccessGroups objects
	When Create catalog AccessProfiles objects
	When Create catalog Agreements objects
	When Create catalog BusinessUnits objects
	When Create catalog CashAccounts objects
	When Create catalog ChequeBonds objects
	When Create catalog Companies objects (Main company)
	When Create catalog Companies objects (partners company)
	When Create catalog Countries objects
	When Create catalog ExpenseAndRevenueTypes objects
	When Create catalog FileStorageVolumes objects
	When Create catalog InterfaceGroups objects
	When Create catalog ItemSegments objects
	When Create catalog ItemTypes objects (Clothes, Shoes)
	When Create catalog ItemTypes objects (Coat, Jeans)
	When Create catalog ObjectStatuses objects
	When Create catalog Partners objects (Ferron BP)
	When Create catalog Partners objects (Employee)
	When Create catalog PaymentTypes objects
	When Create catalog Stores objects
	When Create catalog Units objects (pcs)
	When Create chart of characteristic types CurrencyMovementType objects
	When Create catalog Currencies objects
	When Create catalog ItemKeys objects
	When Create catalog ItemTypes objects
	When Create catalog Units objects
	When Create catalog Items objects
	When Create catalog Items objects (Boots)
	When Create catalog PartnerSegments objects
	When Create catalog Partners objects
	When Create catalog ExternalDataProc objects
	When Create catalog PriceTypes objects
	When Create catalog Specifications objects
	When Create catalog UserGroups objects
	When Create catalog Users objects
	When Create chart of characteristic types AddAttributeAndProperty objects
	When Create catalog AddAttributeAndPropertyValues objects
	When Create catalog AddAttributeAndPropertySets objects
	When Create information register PartnerSegments records
	When Create catalog TaxRates objects
	When Create catalog Taxes objects
	When Create catalog Taxes objects (Sales tax)
	When Create information register TaxSettings records
	When Create information register Taxes records (VAT)
	When Create information register TaxSettings (Sales tax)
	When Create information register Taxes records (Sales tax)
	When Create information register PricesByItemKeys records
	When Create information register PricesByProperties records
	When Create catalog IntegrationSettings objects
	When Create information register CurrencyRates records
	When Create information register Barcodes records
	When Create accumulation register StockBalance records
	When Create information register UserSettings records (Retail document)
	When Create information register UserSettings records
	* Set password for Sofia Borisova (Manager 3)
			Given I open hyperlink "e1cib/list/Catalog.Users"
			And I go to line in "List" table
					| 'Description'                 |
					| 'Sofia Borisova (Manager 3)' |
			And I select current line in "List" table
	* Change localization code
			And I input "en" text in "Localization code" field	
			And I input "en" text in "Interface localization code" field
			And I click "Save" button
	* Set password
		And I click "Set password" button
		And I input "F12345" text in "Password" field
		And I input "F12345" text in "Confirm password" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Create user with access role Full access only read
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And I go to line in "List" table
				| 'Description' |
				| 'Commercial Agent'   |
		And I select current line in "List" table
		And in the table "Roles" I click "Update roles" button
		And I go to line in "Roles" table
				| 'Presentation'    |
				| 'Full access only read' |
		And I set "Use" checkbox in "Roles" table
		And I finish line editing in "Roles" table
		And I click "Save and close" button

Scenario: 950001 check role Full access only read
	And I connect "TestAdmin" TestClient using "SBorisova" login and "F12345" password
	And Delay 3
	* Check access rights (catalogs)
		And In the command interface I select "Purchase  - A/P" "Vendors"
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table	
		When I Check the steps for Exception
       		|'And I click the button named "FormWriteAndClose"'|



