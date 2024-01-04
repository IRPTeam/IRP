#language: en
@tree
@Positive
@PartnerCatalogs

Feature: terms of cooperation with partners

As an accountant
I want to add a mechanism for partner Partner terms
To specify the commercial terms of cooperation


Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: _012000 preparation (partners term)
		When set True value to the constant
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Companies objects (partners company)
		When Create catalog Partners objects
		When Create catalog BusinessUnits objects
		When Create catalog PartnerSegments objects
		When Create catalog Companies objects (Main company)
		When Create catalog Countries objects
		When Create catalog Stores objects
		When Create catalog PriceTypes objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog ItemSegments objects

Scenario: _0120001 check preparation
	When check preparation

Scenario: _012001 adding partners (customers) to a segment (register)
	* Opening a register for Partner segments content
		And I close all client application windows
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
	* Adding partner Ferron BP to the Retail Segment
		And I click the button named "FormCreate"
		And Delay 2
		And I click Select button of "Segment" field
		And Delay 2
		And I go to line in "List" table
			| 'Description'    |
			| 'Retail'         |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Partner" field
		And Delay 5
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| Segment   | Partner      |
			| Retail    | Ferron BP    |
	* Adding partner Kalipso to the Dealer Segment
		And I click the button named "FormCreate"
		And Delay 2
		And I click Select button of "Segment" field
		And Delay 2
		And I go to line in "List" table
			| 'Description'    |
			| 'Dealer'         |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Partner" field
		And Delay 5
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| Segment   | Partner    |
			| Dealer    | Kalipso    |
	* Adding partner Kalipso to the Retail Segment
		And I click the button named "FormCreate"
		And Delay 2
		And I click Select button of "Segment" field
		And Delay 2
		And I go to line in "List" table
			| 'Description'    |
			| 'Retail'         |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Partner" field
		And I click the button named "FormList"
		And Delay 5
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
	
	
	

Scenario: _012002 adding partners (customers) to 2 segments at the same time (register)
# Ferron BP client is included in the retail and dealership segment
	* Opening a register for Partner segments content
		Given I open hyperlink "e1cib/list/InformationRegister.PartnerSegments"
	* Adding partner Ferron BP to the Dealer Segment
		And I click the button named "FormCreate"
		And Delay 2
		And I click Select button of "Segment" field
		And Delay 2
		And I go to line in "List" table
			| 'Description'    |
			| 'Dealer'         |
		And I select current line in "List" table
		And Delay 2
		And I click Select button of "Partner" field
		And Delay 5
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 10
	* Check to add a Ferron BP partner to 2 segments at the same time
		And "List" table contains lines
			| Segment   | Partner      |
			| Retail    | Ferron BP    |
			| Dealer    | Ferron BP    |

Scenario: _012003 filling in the segment of managers in the customers
	* Opening the partner catalog
		Given I open hyperlink "e1cib/list/Catalog.Partners"
	* Filling Manager segment for partner Ferron BP
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
		And I click Select button of "Manager segment" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Region 1'       |
		And I select current line in "List" table
		And I click "Save and close" button
	* Filling Manager segment for partner Kalipso
		And I go to line in "List" table
			| 'Description'    |
			| 'Kalipso'        |
		And I select current line in "List" table
		And I click Select button of "Manager segment" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Region 2'       |
		And I select current line in "List" table
		And I click "Save and close" button
	


Scenario: _012004 create common Partner term	
	* Opening an Partner term catalog
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Creating and checking customer Partner term Basic Partner terms, TRY
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "20" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'TRY'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And Delay 3
		And I change checkbox "Price includes tax"
		And I input "4" text in "Days before delivery" field
		And I click Select button of "Store" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Store 01'        |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Basic Partner terms, TRY" text in the field named "Description_en"
		And I input "Basic Partner terms, TRY" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		Then I check for the "Agreements" catalog element with the "Description_en" "Basic Partner terms, TRY"
	* Creating and checking customer Partner term Basic Partner terms, $
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "21" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'USD'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And Delay 3
		And I input "5" text in "Days before delivery" field
		And I click Select button of "Store" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Basic Partner terms, $" text in the field named "Description_en"
		And I input "Basic Partner terms, $" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		Then I check for the "Agreements" catalog element with the "Description_en" 'Basic Partner terms, $'
	* Creating and checking customer Partner term Basic Partner terms, without VAT
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "22" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I input "m" text in "Multi currency movement type" field
		And I select from "Multi currency movement type" drop-down list by "try" string
		And I move to the next attribute		
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'TRY'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		Then "Price types" window is opened
		And I go to line in "List" table
				| 'Description'                 |
				| 'Basic Price without VAT'     |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And Delay 3
		And I input "4" text in "Days before delivery" field
		And I click Select button of "Store" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Basic Partner terms, without VAT" text in the field named "Description_en"
		And I input "Basic Partner terms, without VAT" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		Then I check for the "Agreements" catalog element with the "Description_en" 'Basic Partner terms, without VAT'

Scenario: _012005 creation of an individual Partner term in USD 
	* Opening an Partner term catalog
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Creating and checking customer Partner term Personal Partner terms, $
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "31" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'USD'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		Then "Price types" window is opened
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Kalipso'         |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I change checkbox "Price includes tax"
		And I input "2" text in "Days before delivery" field
		And I click Select button of "Store" field
		Then "Stores" window is opened
		And I go to line in "List" table
				| 'Description'     |
				| 'Store 02'        |
		And I select current line in "List" table
		And I click Open button of the field named "Description_en"
		And I input "Personal Partner terms, $" text in the field named "Description_en"
		And I input "Personal Partner terms, $" text in the field named "Description_tr"
		And I click "Ok" button
	* Select account
		And I click Choice button of the field named "Account"
		And I click "Create" button
		And I input "Partner account 1" text in "ENG" field
		And I input "56788999000" text in the field named "Number"
		And I click Choice button of the field named "Currency"
		And I select current line in "List" table
		And I select from the drop-down list named "Partner" by "kalipso" string
		And I select from "Legal entity" drop-down list by "kalipso" string	
		And I input "Bank 1" text in "Bank name" field
		And I select from the drop-down list named "Branch" by "Front office" string	
		And I click "Save and close" button
		And I click "Select" button
		And I click "Save and close" button		
		And Delay 5
		Then I check for the "Agreements" catalog element with the "Description_en" 'Personal Partner terms, $'
	* Creating and checking vendor Partner term Vendor Ferron, TRY
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Vendor"
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "31" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'TRY'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| Description           |
				| Vendor price, TRY     |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
				| Description     |
				| Ferron BP       |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I change checkbox "Price includes tax"
		And I click Open button of the field named "Description_en"
		And I input "Vendor Ferron, TRY" text in the field named "Description_en"
		And I input "Vendor Ferron, TRY TR" text in the field named "Description_tr"
		And I click "Ok" button
	* Select account
		And I click Choice button of the field named "Account"
		And I click "Create" button
		And I input "Partner account 1" text in "ENG" field
		And I input "56788999001" text in the field named "Number"
		And I click Choice button of the field named "Currency"
		And I select current line in "List" table
		And I select from the drop-down list named "Partner" by "ferron" string
		And I select from "Legal entity" drop-down list by "ferron" string	
		And I input "Bank 1" text in "Bank name" field
		And I select from the drop-down list named "Branch" by "Front office" string	
		And I click "Save and close" button
		And I click "Select" button
		And I click "Save and close" button
		And Delay 5
		Then I check for the "Agreements" catalog element with the "Description_en" 'Vendor Ferron, TRY'
	* Creating and checking vendor Partner term Vendor Ferron, USD
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Vendor"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "31" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'USD'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
			| Description          |
			| Vendor price, USD    |
		And I select current line in "List" table
		And I click Select button of "Partner" field
		And I go to line in "List" table
			| Description    |
			| Ferron BP      |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I change checkbox "Price includes tax"
		And I click Open button of the field named "Description_en"
		And I input "Vendor Ferron, USD" text in the field named "Description_en"
		And I input "Vendor Ferron, USD TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button	
		And Delay 2
		Then I check for the "Agreements" catalog element with the "Description_en" 'Vendor Ferron, USD'
	

	

Scenario: _012007 create common Partner term with Item Segment
		* Opening an Partner term catalog
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Creating common Partner term with Item Segment
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I change "AP/AR posting detail" radio button value to "By documents"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "23" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'EUR'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
		And I select current line in "List" table
		And I click Select button of "Item segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Sale autum'      |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I input "01.11.2018" text in "End of Use" field
		And I click Open button of the field named "Description_en"
		And I input "Sale autum, TRY" text in the field named "Description_en"
		And I input "Sale autum, TRY" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
	* Check the creation of the Partner term
		Then I check for the "Agreements" catalog element with the "Description_en" 'Sale autum, TRY'



Scenario: _012010 create Partner term without currency (negative test)
	* Opening an Partner term catalog
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Creating Partner term without currency
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "302" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Price type" field
		Then "Price types" window is opened
		And I go to line in "List" table
				| 'Description'           |
				| 'Basic Price Types'     |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
		And I select current line in "List" table
		And I click Select button of "Item segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Sale autum'      |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I click Open button of the field named "Description_en"
		And I input "Currency, TRY" text in the field named "Description_en"
		And I input "Currency, TRY" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Check that the Partner term without currency is not created
		If current window contains user messages Then
		And I close all client application windows
		When I Check the steps for Exception
			| 'Then I check for the "Agreements" catalog element with the "Description_en" 'Currency, TRY''    |

Scenario: _012011 create Partner term without price type (negative test)
	* Opening an Partner term catalog
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Creating Partner term without price type
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Customer"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "301" text in "Number" field
		And I input "01.11.2018" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
				| 'Description'      |
				| 'Main Company'     |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'TRY'           | 'Partner term'    |
		And I select current line in "List" table
		And I click Select button of "Partner segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Retail'          |
		And I select current line in "List" table
		And I click Select button of "Item segment" field
		And I go to line in "List" table
				| 'Description'     |
				| 'Sale autum'      |
		And I select current line in "List" table
		And I input "01.11.2018" text in "Start using" field
		And I click Open button of the field named "Description_en"
		And I input "Price Type, TRY" text in the field named "Description_en"
		And I input "Price Type, TRY" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	*  Checking that the Partner term without price type is not created
		If current window contains user messages Then
		And I close all client application windows
		When I Check the steps for Exception
			| 'Then I check for the "Agreements" catalog element with the "Description_en" 'Price Type, TRY''    |


Scenario: _012012 create Partner term for other partners
		And I close all client application windows
	* Opening an Partner term catalog
		Given I open hyperlink "e1cib/list/Catalog.Agreements"
	* Creating and checking customer Partner term Basic Partner terms, TRY
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Other"
		Then the form attribute named "ApArPostingDetail" became equal to "By agreements"
		And I expand "Agreement info" group
		And I expand "Price settings" group
		And I expand "Store and delivery" group
		And I input "30" text in "Number" field
		And I input "01.11.2022" text in "Date" field
		And I click Select button of "Company" field
		And I go to line in "List" table
			| 'Description'     |
			| 'Main Company'    |
		And I select current line in "List" table
		And I click Select button of "Multi currency movement type" field
		And I go to line in "List" table
			| 'Description'   | 'Type'            |
			| 'TRY'           | 'Partner term'    |
		And I select current line in "List" table
		And I input "01.11.2022" text in "Start using" field
		And Delay 3
		And I click Open button of the field named "Description_en"
		And I input "Other" text in the field named "Description_en"
		And I input "Other" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
		Then I check for the "Agreements" catalog element with the "Description_en" "Other"

Scenario: _012013 check of automatic filling of Legal name in the partner term
	And I close all client application windows
	* Select partner
		Given I open hyperlink "e1cib/list/Catalog.Partners"
		And I go to line in "List" table
			| 'Description' |
			| 'Kalipso'     |
		And I select current line in "List" table	
	* Create partner term
		And In this window I click command interface button "Partner terms"
		And I click "Create" button
	* Check Legal name
		Then the form attribute named "LegalName" became equal to "Company Kalipso"
		Then the form attribute named "Partner" became equal to "Kalipso"
	And I close all client application windows
				