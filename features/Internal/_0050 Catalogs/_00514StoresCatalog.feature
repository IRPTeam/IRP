#language: en
@tree
@Positive
@SettingsCatalogs

Feature: filling in Stores catalog

As an owner
I want to fill out information on the company
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one





Scenario: _005032 filling in the "Stores" catalog
	When set True value to the constant
	* Opening a form for creating Stores
		Given I open hyperlink "e1cib/list/Catalog.Stores"
		* Check hierarchical
			When create Groups in the catalog
	* Create Store 01
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 01" text in the field named "Description_en"
		And I input "Store 01 TR" text in the field named "Description_tr"
		And I input "Склад 01" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "No"
			Then the form attribute named "UseShipmentConfirmation" became equal to "No"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 01"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 02
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 02" text in the field named "Description_en"
		And I input "Store 02 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		And I set checkbox named "UseShipmentConfirmation"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
			Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 02"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 03
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 03" text in the field named "Description_en"
		And I input "Store 03 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseGoodsReceipt"
		Then the form attribute named "Transit" became equal to "No"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "Yes"
			Then the form attribute named "UseShipmentConfirmation" became equal to "No"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 03"
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Create Store 04
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Store 04" text in the field named "Description_en"
		And I input "Store 04 TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I set checkbox named "UseShipmentConfirmation"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "UseGoodsReceipt" became equal to "No"
			Then the form attribute named "UseShipmentConfirmation" became equal to "Yes"
			Then the form attribute named "Transit" became equal to "No"
			Then the form attribute named "Description_en" became equal to "Store 04"
		And I click the button named "FormWriteAndClose"
	* Check creation "Stores"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 01"  
		Then I check for the "Stores" catalog element with the "Description_tr" "Store 01 TR"
		Then I check for the "Stores" catalog element with the "Description_ru" "Склад 01"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 02"  
		Then I check for the "Stores" catalog element with the "Description_en" "Store 03"
		Then I check for the "Stores" catalog element with the "Description_en" "Store 04"