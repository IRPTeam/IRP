#language: en
@tree
@Positive
@ItemCatalogs

Feature: filling in catalog Items

As an owner
I want to fill out items information
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one




# All indivisible packages of the same product are wound up using Specification with type Set. Then a separate Item key is created for the product, in which the necessary set is specified.
# and a price is set on it. It's the Set that's stored on the remains. In order to break it up you need to run the Unbandling document
# For the simple accounting of goods in the packages of documents (the remnants are stored pieces) usedItem units of measurement pcs. For each product, a different Unit is specified
# like pcs consisting of 6 pieces, 10 pieces, etc. # In this case, the price of the order gets as the price of a piece. There's pcs going through the registers, too. 


Scenario: _005110 filling in the "UI groups" catalog 
# Catalog "UI group" is designed to create groups of additional attributes for the items. Also provides for the location of the group on the item's form (right or left)
	When set True value to the constant
	And Delay 5
	* Opening the UI groups creation form 
		Given I open hyperlink "e1cib/list/Catalog.InterfaceGroups"
		And I click the button named "FormCreate"
	* Creating UI groups: Product information, Accounting information
		And I click Open button of the field named "Description_en"
		And I input "Product information" text in the field named "Description_en"
		And I input "Product information TR" text in the field named "Description_tr"
		And I input "Информация о продукте" text in "RU" field
		And I click "Ok" button
		And I change the radio button named "FormPosition" value to "Left"
		And I click "Save" button
		* Check data save
			Then the form attribute named "FormPosition" became equal to "Left"
			Then the form attribute named "Picture" became equal to "Picture"
			Then the form attribute named "Description_en" became equal to "Product information"
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accounting information" text in the field named "Description_en"
		And I input "Accounting information TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change the radio button named "FormPosition" value to "Right"
		And I click "Save" button
		* Check data save
			Then the form attribute named "FormPosition" became equal to "Right"
			Then the form attribute named "Picture" became equal to "Picture"
			Then the form attribute named "Description_en" became equal to "Accounting information"
		And I click "Save and close" button
	* Check for added UI groups in the catalog 
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Product information"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Product information TR"
		Then I check for the "InterfaceGroups" catalog element with the "Description_ru" "Информация о продукте"
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Accounting information"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Accounting information TR"
	


Scenario: _005111 filling in the "Add attribute and property"
	* Opening the Add attribute and property creation form 
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
		And I click the button named "FormCreate"
		And Delay 5
	* Creating additional attribute Brand
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''                               |
				| 'Additional attribute value'     |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Brand" text in the field named "Description_en"
		And I input "Brand TR" text in the field named "Description_tr"
		And I input "Бренд" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Brand"
			Then the form attribute named "ValueType" became equal to "Additional attribute value"
			And I wait the field named "UniqueID" will be filled in "3" seconds
		And I click the button named "FormWriteAndClose"
	* Creating additional attribute producer 
		And I click the button named "FormCreate"
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''                               |
				| 'Additional attribute value'     |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Producer" text in the field named "Description_en"
		And I input "Producer TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Producer"
			Then the form attribute named "ValueType" became equal to "Additional attribute value"
			And I wait the field named "UniqueID" will be filled in "3" seconds
		And I click the button named "FormWriteAndClose"
	* Check for added additional attributes
			And "List" table contains lines
			| 'Description'    |
			| 'Brand'          |
			| 'Producer'       |



		
Scenario: _005112 filling in Additional attribute values with type Additional attribute values
# the value of additional attributes (Producer, Color, Size,Season, Country of consignment)
	* Opening the Add attribute and property form
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
	* Adding value Producer
		And I go to line in "List" table
		| 'Description'   |
		| 'Producer'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "UNIQ" text in the field named "Description_en"
		And I input "UNIQ" text in the field named "Description_tr"
		And I input "UNIQ" text in "RU" field
		And I click "Ok" button
		And I click "Save" button
		* Check data save
			And I wait the field named "UniqueID" will be filled in "3" seconds
			Then the form attribute named "Owner" became equal to "Producer"
			Then the form attribute named "Description_en" became equal to "UNIQ"
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "PZU" text in the field named "Description_en"
		And I input "PZU" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Adding value Brand
		And I go to line in "List" table
		| 'Description'   |
		| 'Brand'         |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "York" text in the field named "Description_en"
		And I input "York" text in the field named "Description_tr"
		And I input "York" text in "RU" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Gir" text in the field named "Description_en"
		And I input "Gir" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save" button
		* Check data save
			And I wait the field named "UniqueID" will be filled in "3" seconds
			Then the form attribute named "Owner" became equal to "Brand"
			Then the form attribute named "Description_en" became equal to "Gir"
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Check for added additional attributes values
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertyValues"
		And "List" table contains lines
		| 'Additional attribute'  | 'Description'   |
		| 'Producer'              | 'UNIQ'          |
		| 'Producer'              | 'PZU'           |
		| 'Brand'                 | 'York'          |
		| 'Brand'                 | 'Gir'           |




Scenario: _005113 filling in the "Item types" catalog 
	* Opening the form for filling in Item types
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I click the button named "FormCreate"
	* Creating item types: TV (Product), Smartphones (Product), Rent (Service)
		And I click Open button of the field named "Description_en"
		And I input "Smartphones" text in the field named "Description_en"
		And I input "Smartphones TR" text in the field named "Description_tr"
		And I input "Смартфоны" text in the field named "Description_ru"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Smartphones"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "TV set" text in the field named "Description_en"
		And I input "TV set TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "TV set"
			Then the form attribute named "Type" became equal to "Product"
		And I click the button named "FormWriteAndClose"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Rent (Service)" text in the field named "Description_en"
		And I input "Rent (Service) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I change "Type" radio button value to "Service"
		And I click the button named "FormWrite"
		* Check data save
			Then the form attribute named "Description_en" became equal to "Rent (Service)"
			Then the form attribute named "Type" became equal to "Service"
		And I click the button named "FormWriteAndClose"
	* Check for created elements
		Then I check for the "ItemTypes" catalog element with the "Description_en" "Smartphones"  
		Then I check for the "ItemTypes" catalog element with the "Description_tr" "Smartphones TR"
		Then I check for the "ItemTypes" catalog element with the "Description_ru" "Смартфоны"  
	* Create a group of item types
		* Create Item Type group
			And I click the button named "FormCreateFolder"
			And I click Open button of the field named "Description_en"
			And I input "Accessories" text in the field named "Description_en"
			And I input "Accessories TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
		* Create item type in group Accessories
			And I click the button named "FormCreate"
			And I click Open button of the field named "Description_en"
			And I input "Earrings" text in the field named "Description_en"
			And I input "Earrings TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I select from "Parent" drop-down list by "Accessories" string
			And I click "Save and close" button
		* Create item type Earrings
			And I go to line in "List" table
				| 'Description'     |
				| 'Accessories'     |
			And I move one level down in "List" table
			And "List" table contains lines
				| 'Description'     |
				| 'Accessories'     |
				| 'Earrings'        |
			And I close all client application windows
	* Check the items group display in AddAttributeAndPropertySets by item key
			Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
			And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_ItemKeys'        |
			And I select current line in "List" table
			And "AttributesTree" table contains lines
				| 'Presentation'     |
				| 'Accessories'      |
				| 'Earrings'         |
			And I close all client application windows

Scenario: _0051131 create Item type for Certificate
	And I close all client application windows
	* Opening Item types form
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I click the button named "FormCreate"
	* Create Certificate item type
		And I click Open button of the field named "Description_en"
		And I input "Certificate" text in the field named "Description_en"
		And I input "Certificate TR" text in the field named "Description_tr"
		And I click "Ok" button 
		And I change the radio button named "Type" value to "Certificate"		
	* Check settings 
		Then the form attribute named "AlwaysAddNewRowAfterScan" became equal to "Yes"
		Then the form attribute named "NotUseLineGrouping" became equal to "Yes"
		Then the form attribute named "UseSerialLotNumber" became equal to "Yes"
		Then the form attribute named "EachSerialLotNumberIsUnique" became equal to "Yes"
		Then the form attribute named "SingleRow" became equal to "Yes"
	* Try modify settings
		When I Check the steps for Exception
			| 'And I remove checkbox named "AlwaysAddNewRowAfterScan"'    |
		When I Check the steps for Exception
			| 'And I remove checkbox named "NotUseLineGrouping"'    |
		When I Check the steps for Exception
			| 'And I remove checkbox named "UseSerialLotNumber"'    |
		When I Check the steps for Exception
			| 'And I remove checkbox named "EachSerialLotNumberIsUnique"'    |		
		And I click the button named "FormWriteAndClose"
	* Check creation
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description'    |
			| 'Certificate'    |
		And I select current line in "List" table
		Then the form attribute named "AlwaysAddNewRowAfterScan" became equal to "Yes"
		Then the form attribute named "NotUseLineGrouping" became equal to "Yes"
		Then the form attribute named "UseSerialLotNumber" became equal to "Yes"
		Then the form attribute named "EachSerialLotNumberIsUnique" became equal to "Yes"
		Then the form attribute named "SingleRow" became equal to "Yes"
		Then the form attribute named "Description_en" became equal to "Certificate"
				

Scenario: _005114 filling in the settings for creating ItemKeys for Item type Coat and Jeans
# for clothes specify the color, for shoes - season
# It is indicated through the type of item with duplication in sets
		And I close all client application windows
	* Preparation
		When Create catalog ItemTypes objects (Coat, Jeans)
		When Create chart of characteristic types AddAttributeAndProperty objects
	* Opening the form for filling in Item keys settings 
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| Description    |
			| Coat           |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description    |
			| Size           |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description    |
			| Color          |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Coat"
			And "AvailableAttributes" table became equal
				| 'Attribute'    | 'Affect pricing'    | 'Show in HTML'    | 'Required'     |
				| 'Size'         | 'No'                | 'No'              | 'No'           |
				| 'Color'        | 'No'                | 'No'              | 'No'           |
		And I click "Save and close" button
	* Item key creation options for Jeans
		And I go to line in "List" table
			| Description    |
			| Jeans          |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description    |
			| Size           |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description    |
			| Season         |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Jeans"
			And "AvailableAttributes" table became equal
				| 'Attribute'    | 'Affect pricing'    | 'Show in HTML'    | 'Required'     |
				| 'Size'         | 'No'                | 'No'              | 'No'           |
				| 'Season'       | 'No'                | 'No'              | 'No'           |
		And I click "Save and close" button
		And I close current window


Scenario: _005115 adding general additional attributes and properties for catalog Item
# AddAttributeAndPropertySets (Catalog_Items)
	* Preparation
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		* Create property Property 01
			Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''                                |
					| 'Additional attribute value'      |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Property 01" text in the field named "Description_en"
			And I click "Ok" button
			And I click "Save and close" button
	* Opening the form for adding additional attributes for Items
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_Items'           |
		And I select current line in "List" table
	* Adding additional attributes
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Producer'       |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Brand'          |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
	* Distribution of added additional attributes by UI groups
		And I activate "UI group" field in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute'    |
			| 'Brand'        |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'                |
			| 'Purchase and production'    |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute'    |
			| 'Producer'     |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'         |
			| 'Main information'    |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click Open button of the field named "Description_en"
		And I input "Items" text in the field named "Description_en"
		And I input "Items" text in the field named "Description_tr"
		And I input "Номенклатура" text in "RU" field
		And I click "Ok" button
	* Adding additional property
		And I move to "Properties" tab
		And in the table "Properties" I click the button named "PropertiesAdd"
		And I click choice button of "Property" attribute in "Properties" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Property 01'    |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
	* Check data save
		Then the form attribute named "Description_en" became equal to "Items"
		And "Attributes" table became equal
			| 'UI group'                  | 'Attribute'   | 'Required'   | 'Show in HTML'    |
			| 'Main information'          | 'Producer'    | 'No'         | 'No'              |
			| 'Purchase and production'   | 'Brand'       | 'No'         | 'No'              |
		And "Properties" table became equal
			| 'Property'      | 'Show in HTML'    |
			| 'Property 01'   | 'No'              |
		And I click "Save and close" button
	* Check the display additional attributes in Item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And field "Brand" exists
		And field "Producer" exists
		And I close all client application windows
		



Scenario: _005116 filling in the "Items" catalog 
	* Preparation
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Units objects (box (8 pcs))
		When Create catalog Units objects (pcs)
		When Create catalog AddAttributeAndPropertyValues objects
	* Opening the form for creating Items
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And Delay 2
	* Test item creation Bodie
		And I click Open button of the field named "Description_en"
		And I input "Bodie" text in the field named "Description_en"
		And I input "Bodie TR" text in the field named "Description_tr"
		And I input "Боди" text in the field named "Description_ru"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description'    |
			| 'Coat'           |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And "List" table does not contain lines
			| 'Description'    |
			| 'box (8 pcs)'    |
		Then the number of "List" table lines is "меньше или равно" "2"
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I click Select button of "Producer" field
		And I go to line in "List" table
			| 'Description'    |
			| 'UNIQ'           |
		And I select current line in "List" table
		Then "Item (create) *" window is opened
		And I expand "Purchase and production" group
		And I move to "Purchase and production" tab		
		And I click Select button of "Brand" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Gir'            |
		And I select current line in "List" table
		And I input "AB475590i" text in "Item ID" field
		And I click Select button of "Vendor" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Ferron BP'      |
		And I select current line in "List" table
	* Check data save
		Then the form attribute named "ItemID" became equal to "AB475590i"
		Then the form attribute named "ItemType" became equal to "Coat"
		Then the form attribute named "Unit" became equal to "pcs"
		Then the form attribute named "Vendor" became equal to "Ferron BP"
		Then the form attribute named "Description_en" became equal to "Bodie"
		If "Brand" field is equal to "Gir" Then
		If "Producer" field is equal to "UNIQ" Then
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Jeans
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Jeans" text in the field named "Description_en"
		And I input "Jeans TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description'     |
				| 'Jeans'           |
		And I select current line in "List" table
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Check Items save
		And "List" table contains lines
		| 'Description'  | 'Item type'   |
		| 'Bodie'        | 'Coat'        |
		| 'Jeans'        | 'Jeans'       |

Scenario: _0051171 name uniqueness control (Items)
	And I close all client application windows
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.Items"
		If "List" table does not contain lines Then
			| 'Description' |
			| 'Bodie'       |
			Then I stop script execution "Skipped"
	* Create item
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Bodie" text in the field named "Description_en"
		And I input "Bodie TR" text in the field named "Description_tr"
		And I input "Боди" text in the field named "Description_ru"
		And I click "Ok" button
		And I select from "Item type" drop-down list by "coat" string
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Check uniqueness control
		Then there are lines in TestClient message log
			|'Description not unique [Bodie]'|
		And I click Open button of the field named "Description_en"
		And I input "1" text in the field named "Description_en"	
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		Then there are lines in TestClient message log
			|'Description not unique [Bodie]'|	
		And I click Open button of the field named "Description_en"
		And I input "1" text in the field named "Description_tr"	
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		Then there are lines in TestClient message log
			|'Description not unique [Bodie]'|	
		ANd I close all client application windows
			

Scenario: _005118 check filling in additional property for item
	And I close all client application windows
	* Opening the Item form
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Bodie'          |
	* Filling additional property
		And I click "Add properties" button
		Then "Edit add properties" window is opened
		And I activate "Value" field in "Properties" table
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		And I click the button named "FormCreate"
		And I input "Property 001" text in "ENG" field
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I input "Property 002" text in "ENG" field
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Description'     |
			| 'Property 001'    |
		And I click the button named "FormChoose"
		And I finish line editing in "Properties" table
		And I click "Save" button
	* Check
		And "Properties" table became equal
			| 'Property'      | 'Value'           |
			| 'Property 01'   | 'Property 001'    |
	* Refill property		
		And I select current line in "Properties" table
		And I click choice button of "Value" attribute in "Properties" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'     |
			| 'Property 01'            | 'Property 002'    |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
	* Check saving
		Then "Items" window is opened
		And I click "Add properties" button
		Then "Edit add properties" window is opened
		And "Properties" table became equal
			| 'Property'      | 'Value'           |
			| 'Property 01'   | 'Property 002'    |
		And I click "Save and close" button
		
				
		
				




Scenario: _005117 filling in Item keys
# Bodie, Shoes
	And I close all client application windows
	Given I open hyperlink "e1cib/list/Catalog.Items"
	* Preparation
		When Create catalog AddAttributeAndPropertyValues objects
		When Create chart of characteristic types AddAttributeAndProperty objects
	* Filling in Item keys for Bodie
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Bodie'          |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Size'                   | 'XS'             |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Color'                  | 'Blue'           |
		And I select current line in "List" table
		And I change "UnitMode" radio button value to "Own"
		And I click Select button of "Unit" field
		And "List" table does not contain lines
			| 'Description'    |
			| 'box (8 pcs)'    |
		Then the number of "List" table lines is "меньше или равно" "2"
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		Then the form attribute named "OwnUnit" became equal to "pcs"
		Then the form attribute named "UnitMode" became equal to "Own"
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Item key'    |
			| 'XS/Blue'     |
		And I select current line in "List" table
		Then the form attribute named "OwnUnit" became equal to "pcs"
		Then the form attribute named "UnitMode" became equal to "Own"
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Size'                   | 'M'              |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Color'                  | 'White'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And "List" table contains lines
			| 'Item key'    |
			| 'XS/Blue'     |
			| 'M/White'     |
		And I close current window
	* Filling in Item keys for Jeans
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Additional attribute'   |  'Description'    |
			| 'Size'                   | '36'              |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Season'                 | '19SD'           |
		And I select current line in "List" table
		And I click "Save and close" button
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Size'                   | '38'             |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Additional attribute'   |  'Description'    |
			| 'Season'                 | '18SD'            |
		And I select current line in "List" table
		And I click "Save and close" button
		And "List" table contains lines
			| 'Item key'    |
			| '36/19SD'     |
			| '38/18SD'     |
	And I close all client application windows
	



Scenario: _005119 packaging for Jeans
	* Opening the form for creating Item units
		Given I open hyperlink "e1cib/list/Catalog.Units"
	* Create packaging Jeans box (8 pcs)
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Jeans box (8 pcs)" text in the field named "Description_en"
		And I input "Jeans box (8 adet) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I input "8" text in "Quantity" field
		And I click "Save and close" button
	* Create packaging Boots (12 pcs)
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Boots (12 pcs)" text in the field named "Description_en"
		And I input "Boots (12 adet) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I input "12" text in "Quantity" field
		And I click "Save and close" button
	And I close current window


Scenario: _0051191 filling in Package unit
	* Open item form
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
	* Select Package unit
		And I click Select button of "Package unit" field
		And "List" table contains lines
			| 'Description'          |
			| 'pcs'                  |
			| 'Jeans box (8 pcs)'    |
			| 'Boots (12 pcs)'       |
		Then the number of "List" table lines is "равно" "3"
		And I go to line in "List" table
			| 'Description'          |
			| 'Jeans box (8 pcs)'    |
		And I select current line in "List" table
		And I click the button named "FormWrite"
	* Check
		Then the form attribute named "PackageUnit" became equal to "Jeans box (8 pcs)"
		And I close all client application windows

Scenario: _0051192 filling in Package unit when create new item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And I input "Test1" text in "ENG" field
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		And I click "Save" button		
		And I click Select button of "Unit" field
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table	
		When I Check the steps for Exception
			| 'And I click Select button of "Package unit" field'    |
		And I click "Save" button	
		And I click Select button of "Package unit" field
		And "List" table contains lines
			| 'Description'    |
			| 'pcs'            |
		Then the number of "List" table lines is "равно" "1"
		And I select current line in "List" table
		And I click "Save" button
		Then the form attribute named "PackageUnit" became equal to "pcs"
		And I close all client application windows

Scenario: _0051193 filling in Package unit when create new item (copy)
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And in the table "List" I click the button named "ListContextMenuCopy"
		Then the form attribute named "PackageUnit" became equal to ""
		And I close all client application windows
		

Scenario: _005120 set Coat/Jeans specification creation
# Set is a dimensional grid, set to the type of item
	* Create a specification for Coat
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Coat'           |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description'    |
			| 'XS'             |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Blue'           |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'M'              |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Brown'          |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'L'              |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| 'Green'          |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click Open button of the field named "Description_en"
		And I input "A-8" text in the field named "Description_en"
		And I input "A-8" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10
	* Create a specification for Jeans
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Jeans'          |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| Description    |
			| 36             |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description'    |
			| '18SD'           |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description'    |
			| '37'             |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| '18SD'           |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description'    |
			| '38'             |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| '18SD'           |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description'    |
			| '39'             |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description'    |
			| '18SD'           |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click Open button of the field named "Description_en"
		And I input "S-8" text in the field named "Description_en"
		And I input "S-8" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 10


Scenario: _005121 filling item key according to specification for set
		If platform version "=" "8.3.25.1336" Then
			Then I stop script execution "Skipped"
	* Opening the Bodie element in the Items catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'   | 'Item type'    |
			| 'Bodie'         | 'Coat'         |
		And I select current line in "List" table
	* Creating for Bodie a new item key for the specification
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
		And "List" table does not contain lines
			| 'Description'   | 'Type'    |
			| 'S-8'           | 'Set'     |
		And I go to line in "List" table
			| 'Description'   | 'Type'    |
			| 'A-8'           | 'Set'     |
		And I select current line in "List" table
		And I select from the drop-down list named "Specification" by "A-8" string	
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| 'Item key'     |
			| 'Bodie/A-8'    |
		And I close current window
	* Opening the Jeans element in the Items catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'   | 'Item type'    |
			| 'Jeans'         | 'Jeans'        |
		And I select current line in "List" table
	* Creating for Boots a new item key for the specification
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
		And "List" table does not contain lines
			| 'Description'   | 'Type'    |
			| 'A-8'           | 'Set'     |
		And I go to line in "List" table
			| 'Description'   | 'Type'    |
			| 'S-8'           | 'Set'     |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| 'Item key'     |
			| 'Jeans/S-8'    |
		And I close current window

Scenario: _005122 create specification (item key)
		And I close all client application windows
	* Select item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'   | 'Item type'    |
			| 'Bodie'         | 'Coat'         |
		And I select current line in "List" table
	* Create new item key
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
	* Create Specification
		And I click the button named "FormCreate"
		And I change the radio button named "Type" value to "Bundle by item key"
		And I input "Bundle by item key" text in "ENG" field
		And I click Select button of "Item bundle" field
		And I go to line in "List" table
			| 'Description' |
			| 'Bodie'       |
		And I select current line in "List" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Jeans'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Jeans' | '38/18SD'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "1,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And in the table "ItemList" I click the button named "ItemListAdd"
		And I click choice button of the attribute named "ItemListItem" in "ItemList" table
		And I go to line in "List" table
			| 'Description' |
			| 'Jeans'       |
		And I select current line in "List" table
		And I activate "Item key" field in "ItemList" table
		And I click choice button of "Item key" attribute in "ItemList" table
		And I go to line in "List" table
			| 'Item'  | 'Item key' |
			| 'Jeans' | '36/19SD'  |
		And I select current line in "List" table
		And I activate field named "ItemListQuantity" in "ItemList" table
		And I input "2,000" text in the field named "ItemListQuantity" of "ItemList" table
		And I finish line editing in "ItemList" table
		And I click "Save and close" button
	* Check creation
		And "List" table contains lines
			| 'Description'        |
			| 'Bundle by item key' |
		And I go to line in "List" table
			| 'Description'        |
			| 'Bundle by item key' |
		And I select current line in "List" table
	* Save item key
		And I click "Save" button
		Then the form attribute named "Specification" became equal to "Bundle by item key"
		And I click "Save and close" button	
		And "List" table contains lines
			| 'Item key'                 | 'Specification'      |
			| 'Bodie/Bundle by item key' | 'Bundle by item key' |
	And I close all client application windows
	

Scenario: _005125 check Dimensions and weight information (item)
	*  Select item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Bodie'          |
		And I select current line in "List" table
	* Change dimensions and check volume calculation
		And I expand "Dimensions" group
		And I input "10,000" text in "Length" field
		And I input "10,000" text in "Width" field
		And I input "10,000" text in "Height" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "1 000,000"
		And I input "0,020" text in "Length" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "2,000"
		And I click "Save" button
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "2,000"
		And I input "2,005" text in "Volume" field
		And I click "Save" button
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "2,005"
		And I input "20,000" text in "Width" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "4,000"
		And I input "20,000" text in "Height" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "8,000"
	* Change weight information and check saving
		And I expand "Weight information" group
		And I input "10,000" text in "Weight" field
		And I click "Save" button
		And the editing text of form attribute named "Weight" became equal to "10,000"
		And I close all client application windows


Scenario: _005126 check Dimensions and weight information (item key)
	*  Select item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Bodie'          |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I go to line in "List" table
			| 'Item key'    |
			| 'M/White'     |
		And I activate "Item key" field in "List" table
		And I select current line in "List" table		
	* Change dimensions and check volume calculation
		And I expand "Dimensions" group
		And I input "10,000" text in "Length" field
		And I input "10,000" text in "Width" field
		And I input "10,000" text in "Height" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "1 000,000"
		And I input "0,020" text in "Length" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "2,000"
		And I click "Save" button
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "2,000"
		And I input "2,005" text in "Volume" field
		And I click "Save" button
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "2,005"
		And I input "20,000" text in "Width" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "4,000"
		And I input "20,000" text in "Height" field
		And I move to the next attribute
		And the editing text of form attribute named "Volume" became equal to "8,000"
	* Change weight information and check saving
		And I expand "Weight information" group
		And I input "10,000" text in "Weight" field
		And I click "Save" button
		And the editing text of form attribute named "Weight" became equal to "10,000"
		And I close all client application windows

Scenario: _005127 check the filling of required additional attribute
	And I close all client application windows
	* Select Additional attribute
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description'   | 'Predefined data name'    |
			| 'Items'         | 'Catalog_Items'           |
		And I select current line in "List" table
		And I go to line in "Attributes" table
			| '#'   | 'Attribute'   | 'UI group'                   |
			| '2'   | 'Brand'       | 'Purchase and production'    |
		And I activate field named "AttributesRequired" in "Attributes" table
		And I set checkbox named "AttributesRequired" in "Attributes" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
		And I close all client application windows
	* Check required filling
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And Delay 2
		And I input "Test2" text in the field named "Description_en"
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description'    |
			| 'Coat'           |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I click "Save and close" button
		Then I wait that in user messages the "Field [Brand] is empty." substring will appear in "10" seconds
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And table "List" does not contain lines:
			| 'Description'    |
			| 'Test2'          |
		And I close all client application windows


Scenario: _005128 check show add property in the html field
	And I close all client application windows
	* Select Additional attribute
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description'   | 'Predefined data name'    |
			| 'Items'         | 'Catalog_Items'           |
		And I select current line in "List" table
		And I move to "Properties" tab
		And I activate field named "PropertiesShowInHTML" in "Properties" table
		And I change checkbox named "PropertiesShowInHTML" in "Properties" table
		And I finish line editing in "Properties" table
		And I click "Save and close" button
		And I wait "Items (Additional attribute set) *" window closing in 20 seconds
	* Check show in the html field
		And I close all client application windows
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "ViewAdditionalAttribute"
		Then user message window does not contain messages
		
Scenario: _005129 add additional attribute for item type
	And I close all client application windows
	* Select Additional attribute
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_ItemTypes'       |
		And I select current line in "List" table	
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
		And I go to line in "List" table
			| 'Description'    |
			| 'Season'         |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
		And I wait "en description is empty (Additional attribute set) *" window closing in 10 seconds
	* Check 
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description'    |
			| 'Coat'           |
		And I select current line in "List" table
		And "Season" form attribute is available
		And I close current window
	* Change requered property and check
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_ItemTypes'       |
		And I select current line in "List" table
		Then "en description is empty (Additional attribute set)" window is opened
		And I activate "Required" field in "Attributes" table
		And I change "Required" checkbox in "Attributes" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
		And I wait "en description is empty (Additional attribute set) *" window closing in 20 seconds
	* Check 
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description'    |
			| 'Coat'           |
		And I select current line in "List" table
		And "Season" form attribute is available
		And I click "Save and close" button	
		Then I wait that in user messages the "Field [Season] is empty." substring will appear in "10" seconds
		And I close all client application windows


Scenario: _005130 add additional attribute with type boolean for item
	And I close all client application windows
	When Create chart of characteristic types AddAttributeAndProperty objects (boolean and string)
	* Select Additional attribute
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data name'    |
			| 'Catalog_Items'           |
		And I select current line in "List" table	
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of the attribute named "AttributesAttribute" in "Attributes" table
		And I go to line in "List" table
			| 'Description'             |
			| 'Add atribute Boolean'    |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click "Save and close" button
	* Check
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And "Add atribute Boolean" form attribute is available
		And I set checkbox "Add atribute Boolean"
		And I remove checkbox "Add atribute Boolean"
	And I close all client application windows
	
Scenario: _005131 create specification with primitive type
	And I close all client application windows
	When Create chart of characteristic types AddAttributeAndProperty objects (boolean and string)
	* Preparation
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I click the button named "FormCreate"
		And I input "With one attribute" text in "ENG" field
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| 'Description'            |
			| 'Add atribute String'    |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click Select button of "Season" field
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Additional attribute'   | 'Description'    |
			| 'Season'                 | '19SD'           |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create specification
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I input "Primitive" text in "ENG" field
		And I change the radio button named "Type" value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description'           |
			| 'With one attribute'    |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I input "String 1" text in "Add atribute String" field of "FormTable*" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click the button named "FormTable*Add"
		And I input "String 2" text in "Add atribute String" field of "FormTable*" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And I click "Save" button
		When I Check the steps for Exception
			| 'Then the form attribute named "UniqueMD5" became equal to ""'    |
		And I click "Save and close" button
		And table "List" contains lines:
			| 'Description'    |
			| 'Primitive'      |
		And I close all client application windows
		
				

Scenario: _005135 fill default description for catalog AddAttributeAndPropertySets
	And I close all client application windows
	* Open catalog and fill default description
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I click "Fill default descriptions" button
		And Delay 5
	* Check
		And I click "Refresh" button
		And "List" table contains lines
			| 'Description'                      | 'Predefined data name'                     |
			| 'Item keys'                        | 'Catalog_ItemKeys'                         |
			| 'Items'                            | 'Catalog_Items'                            |
			| 'Item types'                       | 'Catalog_ItemTypes'                        |
			| 'Sales invoice'                    | 'Document_SalesInvoice'                    |
			| 'Partners'                         | 'Catalog_Partners'                         |
			| 'Expense and revenue types'        | 'Catalog_ExpenseAndRevenueTypes'           |
			| 'Business units'                   | 'Catalog_BusinessUnits'                    |
			| 'Price keys'                       | 'Catalog_PriceKeys'                        |
			| 'Sales order'                      | 'Document_SalesOrder'                      |
			| 'Cheque bonds'                     | 'Catalog_ChequeBonds'                      |
			| 'Specifications'                   | 'Catalog_Specifications'                   |
			| 'Purchase invoice'                 | 'Document_PurchaseInvoice'                 |
			| 'Purchase order'                   | 'Document_PurchaseOrder'                   |
			| 'Partner terms'                    | 'Catalog_Agreements'                       |
			| 'Cash/Bank accounts'               | 'Catalog_CashAccounts'                     |
			| 'Companies'                        | 'Catalog_Companies'                        |
			| 'Countries'                        | 'Catalog_Countries'                        |
			| 'Currencies'                       | 'Catalog_Currencies'                       |
			| 'Price types'                      | 'Catalog_PriceTypes'                       |
			| 'Item serial/lot numbers'          | 'Catalog_SerialLotNumbers'                 |
			| 'Stores'                           | 'Catalog_Stores'                           |
			| 'Tax types'                        | 'Catalog_Taxes'                            |
			| 'Item units'                       | 'Catalog_Units'                            |
			| 'Users'                            | 'Catalog_Users'                            |
			| 'Bank payment'                     | 'Document_BankPayment'                     |
			| 'Bank receipt'                     | 'Document_BankReceipt'                     |
			| 'Bundling'                         | 'Document_Bundling'                        |
			| 'Cash expense'                     | 'Document_CashExpense'                     |
			| 'Cash payment'                     | 'Document_CashPayment'                     |
			| 'Cash receipt'                     | 'Document_CashReceipt'                     |
			| 'Cash revenue'                     | 'Document_CashRevenue'                     |
			| 'Cash transfer order'              | 'Document_CashTransferOrder'               |
			| 'Goods receipt'                    | 'Document_GoodsReceipt'                    |
			| 'Incoming payment order'           | 'Document_IncomingPaymentOrder'            |
			| 'Inventory transfer'               | 'Document_InventoryTransfer'               |
			| 'Inventory transfer order'         | 'Document_InventoryTransferOrder'          |
			| 'Labeling'                         | 'Document_Labeling'                        |
			| 'Opening entry'                    | 'Document_OpeningEntry'                    |
			| 'Outgoing payment order'           | 'Document_OutgoingPaymentOrder'            |
			| 'Physical count by location'       | 'Document_PhysicalCountByLocation'         |
			| 'Physical inventory'               | 'Document_PhysicalInventory'               |
			| 'Price list'                       | 'Document_PriceList'                       |
			| 'Purchase return'                  | 'Document_PurchaseReturn'                  |
			| 'Purchase return order'            | 'Document_PurchaseReturnOrder'             |
			| 'Reconciliation statement'         | 'Document_ReconciliationStatement'         |
			| 'Sales return'                     | 'Document_SalesReturn'                     |
			| 'Sales return order'               | 'Document_SalesReturnOrder'                |
			| 'Shipment confirmation'            | 'Document_ShipmentConfirmation'            |
			| 'Stock adjustment as surplus'      | 'Document_StockAdjustmentAsSurplus'        |
			| 'Stock adjustment as write-off'    | 'Document_StockAdjustmentAsWriteOff'       |
			| 'Unbundling'                       | 'Document_Unbundling'                      |
			| 'Files'                            | 'Catalog_Files'                            |
			| 'Retail sales receipt'             | 'Document_RetailSalesReceipt'              |
			| 'Payment terminals'                | 'Catalog_PaymentTerminals'                 |
			| 'Retail return receipt'            | 'Document_RetailReturnReceipt'             |
			| 'Bank terms'                       | 'Catalog_BankTerms'                        |
			| 'Retail customers'                 | 'Catalog_RetailCustomers'                  |
			| 'Cash statement'                   | 'Document_CashStatement'                   |
			| 'Cash statement statuses'          | 'Catalog_CashStatementStatuses'            |
			| 'Credit note'                      | 'Document_CreditNote'                      |
			| 'Debit note'                       | 'Document_DebitNote'                       |
			| 'Workstations'                     | 'Catalog_Workstations'                     |
			| 'Hardware'                         | 'Catalog_Hardware'                         |
			| 'Item segments'                    | 'Catalog_ItemSegments'                     |
			| 'Partner segments'                 | 'Catalog_PartnerSegments'                  |
			| 'Payment types'                    | 'Catalog_PaymentTypes'                     |
			| 'Special offer rules'              | 'Catalog_SpecialOfferRules'                |
			| 'Special offers'                   | 'Catalog_SpecialOffers'                    |
			| 'Special offer types'              | 'Catalog_SpecialOfferTypes'                |
			| 'Tax rates'                        | 'Catalog_TaxRates'                         |
			| 'User groups'                      | 'Catalog_UserGroups'                       |
			| 'Internal supply request'          | 'Document_InternalSupplyRequest'           |
			| 'Partners bank accounts'           | 'Catalog_PartnersBankAccounts'             |
			| 'Lock data modification reasons'   | 'Catalog_LockDataModificationReasons'      |
			| 'Item stock adjustment'            | 'Document_ItemStockAdjustment'             |
			| 'Manual register entry'            | 'Document_ManualRegisterEntry'             |
			| 'Sales order closing'              | 'Document_SalesOrderClosing'               |
			| 'Planned receipt reservation'      | 'Document_PlannedReceiptReservation'       |
			| 'Purchase order closing'           | 'Document_PurchaseOrderClosing'            |
			| 'Partner items'                    | 'Catalog_PartnerItems'                     |
			| 'Journal entry'                    | 'Document_JournalEntry'                    |
			| 'Ledger types'                     | 'Catalog_LedgerTypes'                      |
			| 'Money transfer'                   | 'Document_MoneyTransfer'                   |
			| 'User access groups'               | 'Catalog_AccessGroups'                     |
			| 'User access profiles'             | 'Catalog_AccessProfiles'                   |
			| 'Accounting operations'            | 'Catalog_AccountingOperations'             |
			| 'Cancel/Return reasons'            | 'Catalog_CancelReturnReasons'              |
			| 'Equipment drivers'                | 'Catalog_EquipmentDrivers'                 |
			| 'Plugins'                          | 'Catalog_ExternalDataProc'                 |
			| 'File storages info'               | 'Catalog_FileStoragesInfo'                 |
			| 'File storage volumes'             | 'Catalog_FileStorageVolumes'               |
			| 'Integration settings'             | 'Catalog_IntegrationSettings'              |
			| 'UI groups'                        | 'Catalog_InterfaceGroups'                  |
			| 'Legal name contracts'             | 'Catalog_LegalNameContracts'               |
			| 'Objects statuses'                 | 'Catalog_ObjectStatuses'                   |
			| 'Payment terms'                    | 'Catalog_PaymentSchedules'                 |
			| 'Planning periods'                 | 'Catalog_PlanningPeriods'                  |
			| 'Tax additional analytics'         | 'Catalog_TaxAnalytics'                     |
			| 'Units of measurement'             | 'Catalog_UnitsOfMeasurement'               |
			| 'Ledger type variants'             | 'Catalog_LedgerTypeVariants'               |
			| 'Cheque bond transaction'          | 'Document_ChequeBondTransaction'           |
			| 'Consolidated retail sales'        | 'Document_ConsolidatedRetailSales'         |
			| 'Work order'                       | 'Document_WorkOrder'                       |
			| 'Work order closing'               | 'Document_WorkOrderClosing'                |
			| 'Bill of materials'                | 'Catalog_BillOfMaterials'                  |
			| 'Work sheet'                       | 'Document_WorkSheet'                       |
			| 'Filling templates'                | 'Catalog_FillingTemplates'                 |
			| 'Production planning'              | 'Document_ProductionPlanning'              |
			| 'Production planning correction'   | 'Document_ProductionPlanningCorrection'    |
			| 'Production planning closing'      | 'Document_ProductionPlanningClosing'       |
			| 'Production'                       | 'Document_Production'                      |
			| 'Sales report from trade agent'    | 'Document_SalesReportFromTradeAgent'       |
			| 'Sales report to consignor'        | 'Document_SalesReportToConsignor'          |
			| 'Source of origins'                | 'Catalog_SourceOfOrigins'                  |
			| 'Employee cash advance'            | 'Document_EmployeeCashAdvance'             |
			| 'Production costs allocation'      | 'Document_ProductionCostsAllocation'       |
			| 'Payroll'                          | 'Document_Payroll'                         |
			| 'Accrual and deduction types'      | 'Catalog_AccrualAndDeductionTypes'         |
			| 'Employee positions'               | 'Catalog_EmployeePositions'                |
			| 'Time sheet'                       | 'Document_TimeSheet'                       |
			| 'Addresses'                        | 'Catalog_Addresses'                        |
			| 'Vehicles'                         | 'Catalog_Vehicles'                         |
			| 'Vehicle types'                    | 'Catalog_VehicleTypes'                     |
		And I close all client application windows
		
		
Scenario: _005136 check add attribute set form
	And I close all client application windows
	* Add test element
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Description' |
			| 'Items'    |
		And I select current line in "List" table
		And in the table "ExtensionAttributes" I click "Add" button
		And I input "Test1" text in the field named "ExtensionAttributesAttribute" of "ExtensionAttributes" table
		And I finish line editing in "ExtensionAttributes" table
		And in the table "ExtensionAttributes" I click the button named "ExtensionAttributesAdd"
		And I input "Test2" text in the field named "ExtensionAttributesAttribute" of "ExtensionAttributes" table
		And I finish line editing in "ExtensionAttributes" table
		And in the table "ExtensionAttributes" I click the button named "ExtensionAttributesAdd"
		And I input "Test3" text in the field named "ExtensionAttributesAttribute" of "ExtensionAttributes" table
		And I finish line editing in "ExtensionAttributes" table
		And I go to line in "ExtensionAttributes" table
			| 'Attribute' |
			| 'Test1'     |
		And I select current line in "ExtensionAttributes" table
		And I click choice button of the attribute named "ExtensionAttributesInterfaceGroup" in "ExtensionAttributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Main information' |
		And I select current line in "List" table
		And I set checkbox named "ExtensionAttributesRequired" in "ExtensionAttributes" table
		And I set checkbox named "ExtensionAttributesShowInHTML" in "ExtensionAttributes" table
		And I set "Show" checkbox in "ExtensionAttributes" table
		And I finish line editing in "ExtensionAttributes" table
		And I activate field named "ExtensionAttributesIsConditionSet" in "ExtensionAttributes" table
		And in the table "ExtensionAttributes" I click the button named "ExtensionAttributesSetConditionExtensionAttribute"
		Then "1C:Enterprise" window is opened
		And I click "Yes" button
		And in the table "SettingsFilter" I click the button named "SettingsFilterAddFilterItem"
		And I select "Item type" exact value from the drop-down list named "SettingsFilterLeftValue" in "SettingsFilter" table
		And I move to the next attribute
		And I select "Equal to" exact value from "Comparison type" drop-down list in "SettingsFilter" table
		And I move to the next attribute
		And I click choice button of the attribute named "SettingsFilterRightValue" in "SettingsFilter" table
		And I go to line in "List" table
			| 'Description' |
			| 'Jeans'       |
		And I select current line in "List" table
		And I finish line editing in "SettingsFilter" table
		And I click "Ok" button
	* Copy settings from first line
		And I select all lines of "ExtensionAttributes" table
		And in the table "ExtensionAttributes" I click "Copy \"Condition\"" button
		And in the table "ExtensionAttributes" I click "Copy attribute \"Show\"" button
		And in the table "ExtensionAttributes" I click "Copy attribute \"Show in HTML\"" button
		And in the table "ExtensionAttributes" I click "Copy \"Interface group\"" button
	* Check
		And "ExtensionAttributes" table became equal
			| '#' | 'Required' | 'Attribute' | 'Show' | 'UI group'         | 'Show in HTML' |
			| '1' | 'Yes'      | 'Test1'     | 'Yes'  | 'Main information' | 'Yes'          |
			| '2' | 'No'       | 'Test2'     | 'Yes'  | 'Main information' | 'Yes'          |
			| '3' | 'No'       | 'Test3'     | 'Yes'  | 'Main information' | 'Yes'          |		
		And I go to line in "ExtensionAttributes" table
			| 'Attribute' |
			| 'Test3'     |
		And in the table "ExtensionAttributes" I click "Set condition" button
		And I expand current line in "SettingsFilter" table
		And "SettingsFilter" table contains lines
			| 'Right value' |
			| 'Jeans'       |
		And I close all client application windows
		
		
				
Scenario: _005137 create certificate item and item key
	And I close all client application windows
	* Open item list
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
	* Create Certificate item
		And I input "Certificate" text in the field named "Description_en"
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description'    |
			| 'Certificate'           |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| 'Description'    |
			| 'pcs'            |
		And I select current line in "List" table
		And I expand "Purchase and production" group
		And I click Select button of "Brand" field
		And I go to line in "List" table
			| 'Description'    |
			| 'Gir'            |
		And I select current line in "List" table
		And I click "Save" button
	* Create Certificate item key
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click "Save and close" button
		And I wait "Item key (create)" window closing in 5 seconds
	And I close all client application windows

Scenario: _005138 check item creation (button + in documents)
	And I close all client application windows
	* EN
		* Open SO
			Given I open hyperlink "e1cib/list/Document.SalesOrder"	
			And I click the button named "FormCreate"
			And in the table "ItemList" I click "Add" button
			And I activate "Item" field in "ItemList" table
			And I select current line in "ItemList" table
			And I input "123" text in "Item" field of "ItemList" table
			And I click Create button of "Item" field
			Then "Item (create)" window is opened
			And I move to the next attribute
			Then the form attribute named "Description_en" became equal to "123"
		And I close current window
		And I input "" text in "Item" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I close all client application windows
	*RU
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I select "Russian" exact value from "Data localization" drop-down list
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one
		Given I open hyperlink "e1cib/list/Document.SalesOrder"	
		And I click the button named "FormCreate"
		And in the table "ItemList" I click "Add" button
		And I activate "Item" field in "ItemList" table
		And I select current line in "ItemList" table
		And I input "123" text in "Item" field of "ItemList" table
		And I click Create button of "Item" field
		Then "Item (create)" window is opened
		And I move to the next attribute
		Then the form attribute named "Description_ru" became equal to "123"
		And I close current window
		And I input "" text in "Item" field of "ItemList" table
		And I finish line editing in "ItemList" table
		And I close all client application windows
	* User Data localization lang
		Given I open hyperlink "e1cib/list/Catalog.Users"
		And I go to line in "List" table
			| 'Login'    |
			| 'CI'       |
		And I select current line in "List" table
		And I select "English" exact value from "Data localization" drop-down list
		And I click "Save and close" button
		And I close TestClient session
		Given I open new TestClient session or connect the existing one

Scenario: _005150 check name auto-generation for items (Description)
	And I close all client application windows
	* Select item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Coat'        |
		And I select current line in "List" table
	* Сreate an auto-naming formula (item desctiption template)
		And I move to "Description template" tab
		And I click the button named "EditItemDescriptionTemplate"		
		And I expand current line in "SettingsComposer" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Item ID'          |
		And I select current line in "SettingsComposer" table
		And I expand a line in "Operators" table
			| 'Description'  |
			| 'Delimiters'   |
		And I go to line in "Operators" table
			| 'Description' |
			| 'Space'           |
		And I select current line in "Operators" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Item type'        |
		And I select current line in "SettingsComposer" table
		And I go to line in "Operators" table
			| 'Description' |
			| '/'           |
		And I select current line in "Operators" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Producer'         |
		And I select current line in "SettingsComposer" table
		And I click "Check" button
		Then there are lines in TestClient message log
			|'Formula is correct'|	
		And I click "Ok" button
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check Description update
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'    |
			| 'Bodie'          |
		And I select current line in "List" table
		* Description en
			And I click the button named "ButtonFillByTemplate_Description_Description_en"
			Then the form attribute named "Description_en" became equal to "AB475590i Coat/UNIQ"
		* Description tr
			And I click Open button of "ENG" field
			And I click the button named "ButtonFillByTemplateDescription_tr"
			Then the form attribute named "Description_tr" became equal to "AB475590i Coat TR/UNIQ"
		And I click "Ok" button
		And I click "Save" button
		Then the form attribute named "Description_en" became equal to "AB475590i Coat/UNIQ"
	And I close all client application windows
			
		
Scenario: _005151 check name auto-generation for items (Local full description)
	And I close all client application windows
	* Select item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Coat'        |
		And I select current line in "List" table
	* Сreate an auto-naming formula (item desctiption template)
		And I move to "Description template" tab
		And I click the button named "EditItemLocalFullDescriptionTemplate"	
		And I expand current line in "SettingsComposer" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Item type'        |
		And I select current line in "SettingsComposer" table
		And I expand current line in "Operators" table		
		And I go to line in "Operators" table
			| 'Description' |
			| '/'           |
		And I select current line in "Operators" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Item ID'         |
		And I select current line in "SettingsComposer" table
		And I click "Check" button
		Then there are lines in TestClient message log
			|'Formula is correct'|	
		And I click "Ok" button
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
	* Check Local full description update
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description'         |
			| 'AB475590i Coat/UNIQ' |
		And I select current line in "List" table
		And I click the button named "ButtonFillByTemplate_LocalDescription"	
		Then the form attribute named "LocalFullDescription" became equal to "Coat/AB475590i"		
		And I click "Save" button
		Then the form attribute named "LocalFullDescription" became equal to "Coat/AB475590i"	
	And I close all client application windows

			
Scenario: _005152 check name auto-generation for items (Foreign full description)
	And I close all client application windows
	* Select item type
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And I go to line in "List" table
			| 'Description' |
			| 'Coat'        |
		And I select current line in "List" table
	* Сreate an auto-naming formula (item desctiption template)
		And I move to "Description template" tab
		And I click the button named "EditItemForeignFullDescriptionTemplate"	
		And I expand current line in "SettingsComposer" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Item type'        |
		And I select current line in "SettingsComposer" table
		And I expand current line in "Operators" table		
		And I go to line in "Operators" table
			| 'Description' |
			| '/'           |
		And I select current line in "Operators" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Item ID'         |
		And I select current line in "SettingsComposer" table
		And I expand current line in "Operators" table		
		And I go to line in "Operators" table
			| 'Description' |
			| '/'           |
		And I select current line in "Operators" table
		And I go to line in "SettingsComposer" table
			| 'Available fields' |
			| 'Brand'         |
		And I select current line in "SettingsComposer" table
		And I click "Check" button
		Then there are lines in TestClient message log
			|'Formula is correct'|	
		And I click "Ok" button
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
	* Create new item and check Foreign full description
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And I select from the drop-down list named "ItemType" by "coat" string
		And I select from the drop-down list named "Unit" by "pcs" string
		And I select "UNIQ" value from "Producer" drop-down list
		And I expand "Purchase and production" group
		And I select "York" value from "Brand" drop-down list
		And I click the button named "ButtonFillByTemplate_ForeignDescription"
		Then "1C:Enterprise" window is opened
		And I click the button named "Button0"
		And I input "1233" text in the field named "ItemID"
		And I click the button named "ButtonFillByTemplate_ForeignDescription"
		Then "1C:Enterprise" window is opened
		And I click the button named "Button0"
		Then the form attribute named "ForeignFullDescription" became equal to "Coat/1233/York"		
	And I close all client application windows				
