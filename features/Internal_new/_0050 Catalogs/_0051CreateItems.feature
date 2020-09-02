#language: en
@tree
@Positive
@Test


Feature: filling in catalog Items

As an owner
I want to fill out items information
To further use it when reflecting in the program of business processes

Background:
	Given I open new TestClient session or connect the existing one
	And I set "True" value to the constant "ShowBetaTesting"
	And I set "True" value to the constant "ShowAlphaTestingSaas"
	And I set "True" value to the constant "UseItemKey"
	And I set "True" value to the constant "UseCompanies"



# All indivisible packages of the same product are wound up using Specification with type Set. Then a separate Item key is created for the product, in which the necessary set is specified.
# and a price is set on it. It's the Set that's stored on the remains. In order to break it up you need to run the Unbandling document
# For the simple accounting of goods in the packages of documents (the remnants are stored pieces) usedItem units of measurement pcs. For each product, a different Unit is specified
# like pcs consisting of 6 pieces, 10 pieces, etc. # In this case, the price of the order gets as the price of a piece. There's pcs going through the registers, too. 



Scenario: _005110 filling in the "UI groups" catalog 
# Catalog "UI group" is designed to create groups of additional attributes for the items. Also provides for the location of the group on the item's form (right or left)
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
				| ''       |
				| 'Additional attribute value' |
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
				| ''       |
				| 'Additional attribute value' |
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
			| 'Description' |
			| 'Brand'       |
			| 'Producer'    |



		
Scenario: _005112 filling in Additional attribute values with type Additional attribute values
# the value of additional attributes (Producer, Color, Size,Season, Country of consignment)
	* Opening the Add attribute and property form
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
	* Adding value Producer
		And I go to line in "List" table
		| 'Description' |
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
		| 'Description' |
		| 'Brand'      |
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
		| 'Additional attribute' | 'Description' |
		| 'Producer'             | 'UNIQ'        |
		| 'Producer'             | 'PZU'         |
		| 'Brand'                | 'York'        |
		| 'Brand'                | 'Gir'         |




Scenario: _005113 filling in the "Item types" catalog 
	* Opening the form for filling in Item types
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
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
				| 'Description' |
				| 'Accessories'            |
			And I move one level down in "List" table
			And "List" table contains lines
				| 'Description'    |
				| 'Accessories' |
				| 'Earrings'    |
			And I close all client application windows
	* Check the items group display in AddAttributeAndPropertySets by item key
			Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
			And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_ItemKeys'          |
			And I select current line in "List" table
			And "AttributesTree" table contains lines
				| 'Presentation'      |
				| 'Accessories'    |
				| 'Earrings'       |
			And I close all client application windows


Scenario: _005114 filling in the settings for creating ItemKeys for Item type Closets and Shoes
# for clothes specify the color, for shoes - season
# It is indicated through the type of item with duplication in sets
	* Preparation
		When Create catalog ItemTypes objects (Clothes, Shoes)
		* Create Size AddAttributeAndProperty
			Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Size" text in the field named "Description_en"
			And I input "Size TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
		* Create Color AddAttributeAndProperty
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Color" text in the field named "Description_en"
			And I input "Color TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
		* Create Season AddAttributeAndProperty
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Season" text in the field named "Description_en"
			And I input "Season TR" text in the field named "Description_tr"
			And I click "Ok" button
			And I click "Save and close" button
	* Opening the form for filling in Item keys settings 
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
	* Item key creation options for Clothes
		And I go to line in "List" table
			| Description      |
			| Clothes |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Size      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Color      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Clothes"
			And "AvailableAttributes" table became equal
				| 'Attribute' | 'Affect pricing' | 'Show in HTML' | 'Required' |
				| 'Size'      | 'No'             | 'No'           | 'No'       |
				| 'Color'     | 'No'             | 'No'           | 'No'       |
		And I click "Save and close" button
	* Item key creation options for Shoes
		And I go to line in "List" table
			| Description      |
			| Shoes |
		And I select current line in "List" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Size      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And in the table "AvailableAttributes" I click the button named "AvailableAttributesAdd"
		And I click choice button of "Attribute" attribute in "AvailableAttributes" table
		And I go to line in "List" table
			| Description |
			| Season      |
		And I select current line in "List" table
		And I finish line editing in "AvailableAttributes" table
		And I click "Save" button
		* Check data save
			Then the form attribute named "Type" became equal to "Product"
			Then the form attribute named "Description_en" became equal to "Shoes"
			And "AvailableAttributes" table became equal
				| 'Attribute' | 'Affect pricing' | 'Show in HTML' | 'Required' |
				| 'Size'      | 'No'             | 'No'           | 'No'       |
				| 'Season'    | 'No'             | 'No'           | 'No'       |
		And I click "Save and close" button
		And I close current window


Scenario: _005114 adding general additional attributes and properties for catalog Item
# AddAttributeAndPropertySets (Catalog_Items)
	* Preparation
		When Create catalog InterfaceGroups objects (Purchase and production,  Main information)
		* Create property Property 01
			Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
			And I click the button named "FormCreate"
			And I click Choice button of the field named "ValueType"
			And Delay 2
			And I go to line in "" table
					| ''       |
					| 'Additional attribute value' |
			And I click the button named "OK"
			And I click Open button of the field named "Description_en"
			And I input "Property 01" text in the field named "Description_en"
			And I click "Ok" button
			And I click "Save and close" button
	* Opening the form for adding additional attributes for Items
		Given I open hyperlink "e1cib/list/Catalog.AddAttributeAndPropertySets"
		And I go to line in "List" table
			| 'Predefined data item name' |
			| 'Catalog_Items'      |
		And I select current line in "List" table
	* Adding additional attributes
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Producer'  |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Brand'     |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
	* Distribution of added additional attributes by UI groups
		And I activate "UI group" field in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Brand'   |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Purchase and production' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Producer'     |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Main information' |
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
			| 'Description' |
			| 'Property 01' |
		And I select current line in "List" table
		And I finish line editing in "Properties" table
		And I click "Save" button
	* Check data save
		Then the form attribute named "Description_en" became equal to "Items"
		And "Attributes" table became equal
			| 'UI group'                | 'Attribute' | 'Required' | 'Show in HTML' |
			| 'Main information'        | 'Producer'  | 'No'       | 'No'           |
			| 'Purchase and production' | 'Brand'     | 'No'       | 'No'           |
		And "Properties" table became equal
			| 'Property'    | 'Show in HTML' |
			| 'Property 01' | 'No'           |
		And I click "Save and close" button
	* Check the display additional attributes in Item
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And field "Brand" exists
		And field "Producer" exists
		And I close all client application windows
		



Scenario: _005115 filling in the "Items" catalog 
	* Preparation
		When Create catalog ItemTypes objects (Clothes, Shoes)
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Units objects (box (8 pcs))
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
			| 'Description' |
			| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I go to line in "List" table
			| 'Description' |
			| 'box (8 pcs)' |
		And I select current line in "List" table
		And I click Select button of "Producer" field
		And I go to line in "List" table
			| 'Description' |
			| 'UNIQ'        |
		And I select current line in "List" table
		And I click Select button of "Brand" field
		And I go to line in "List" table
			| 'Description' |
			| 'Gir'        |
		And I select current line in "List" table
		And I input "AB475590i" text in "Item ID" field
		And I click Select button of "Vendor" field
		And I go to line in "List" table
			| 'Description' |
			| 'Ferron BP'   |
		And I select current line in "List" table
		And I click the button named "FormWrite"
	* Check data save
		Then the form attribute named "ItemID" became equal to "AB475590i"
		Then the form attribute named "ItemType" became equal to "Clothes"
		Then the form attribute named "Unit" became equal to "box (8 pcs)"
		Then the form attribute named "Vendor" became equal to "Ferron BP"
		Then the form attribute named "Description_en" became equal to "Bodie"
		If "Brand" field is equal to "Gir" Then
		If "Producer" field is equal to "UNIQ" Then
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Sneakers
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Sneakers" text in the field named "Description_en"
		And I input "Sneakers TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Clothes'       |
		And I select current line in "List" table
		And I go to line in "List" table
			| 'Description' |
			| 'box (8 pcs)' |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Check Items save
		And "List" table became equal
		| 'Description' | 'Item type' |
		| 'Bodie'       | 'Clothes'   |
		| 'Sneakers'    | 'Clothes'   |


// доделать после того как будет загрузка планов видов характеристик

Scenario: _005117 filling in Item keys
# Dress, Trousers
	Given I open hyperlink "e1cib/list/Catalog.Items"
	* Filling in Item keys for Dress
		And I go to line in "List" table
		| 'Description'      |
		| 'Dress' |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item keys (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'XS'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'M'           |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'L'           |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| 'XL'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'S'        |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I go to line in "List" table
			| 'Item key' |
			| 'XS'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Blue'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "XS (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'M'        |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'White'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "M (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'L'        |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "L (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| 'XL'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "XL (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I wait "Dress (Item)" window closing in 20 seconds
	* Filling in Item keys for Trousers
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Trousers'    | 'Clothes'   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '36'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '36'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '38'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And I wait "Trousers (Item)" window closing in 20 seconds
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Shirt'       | 'Clothes'   |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '36'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '36'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Red'         |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '38'       |
		And I select current line in "List" table
		And I click Select button of "Color" field
		And I go to line in "List" table
			| 'Description' |
			| 'Black'       |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		Then "Shirt (Item)" window is opened
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And Delay 5
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Boots'       | 'Shoes'     |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '36'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '37'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '39'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '36'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '37'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '38'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I go to line in "List" table
			| 'Item key' |
			| '39'       |
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I click the button named "FormChoose"
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And Delay 5
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'High shoes'  | 'Shoes'     |
		And I select current line in "List" table
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '39'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And I click the button named "FormCreate"
		And I click Select button of "Size" field
		And I go to line in "List" table
			| 'Description' |
			| '37'          |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "Item key (create) *" window closing in 20 seconds
		And I select current line in "List" table
		And I click Select button of "Season" field
		And I go to line in "List" table
			| 'Description' |
			| '19SD'        |
		And I select current line in "List" table
		And I click "Save and close" button
		And I wait "* (Item key) *" window closing in 20 seconds
		And In this window I click command interface button "Main"
		And I click "Save and close" button
		And Delay 5

		

Scenario: _005119 packaging for High shoes
	* Opening the form for creating Item units
		Given I open hyperlink "e1cib/list/Catalog.Units"
	* Create packaging High shoes box (8 pcs)
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "High shoes box (8 pcs)" text in the field named "Description_en"
		And I input "High shoes box (8 adet) TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'High shoes'  |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'      |
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
			| 'Description' |
			| 'Boots'  |
		And I select current line in "List" table
		And I click Select button of "Basis unit" field
		And I go to line in "List" table
			| 'Description' |
			| 'pcs'      |
		And I select current line in "List" table
		And I input "12" text in "Quantity" field
		And I click "Save and close" button
	And I close current window

Scenario: _005120 set Closets/Shoes specification creation
# Set is a dimensional grid, set to the type of item
	* Create a specification for Clothes
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'     |
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
			| 'Description' |
			| 'XS'          |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Blue'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'M'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Brown'       |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "2,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'L'           |
		And I select current line in "List" table
		And I activate "Color" field in "FormTable*" table
		And I click choice button of "Color" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| 'Green'       |
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
	* Create a specification for Shoes
		Given I open hyperlink "e1cib/list/Catalog.Specifications"
		And I click the button named "FormCreate"
		And I change "Type" radio button value to "Set"
		And I click Select button of "Item type" field
		And I go to line in "List" table
			| 'Description' |
			| 'Shoes'       |
		And I select current line in "List" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| Description |
			| 36          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '37'          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '38'          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
		And I select current line in "List" table
		And I activate "Quantity" field in "FormTable*" table
		And I input "1,000" text in "Quantity" field of "FormTable*" table
		And I finish line editing in "FormTable*" table
		And in the table "FormTable*" I click "Add" button
		And I click choice button of "Size" attribute in "FormTable*" table
		And I go to line in "List" table
			| 'Description' |
			| '39'          |
		And I select current line in "List" table
		And I activate "Season" field in "FormTable*" table
		And I click choice button of "Season" attribute in "FormTable*" table
		Then "Additional attribute values" window is opened
		And I go to line in "List" table
			| 'Description' |
			| '18SD'        |
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
	* Opening the Dress element in the Items catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Dress'       | 'Clothes'   |
		And I select current line in "List" table
	* Creating for Dress a new item key for the specification
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
		And "List" table does not contain lines
			| 'Description' | 'Type' |
			| 'S-8'         | 'Set'  |
		And I go to line in "List" table
			| 'Description' | 'Type' |
			| 'A-8'         | 'Set'  |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| 'Item key'   |
			| 'Dress/A-8'  |
		And I close current window
	* Opening the Boots element in the Items catalog
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I go to line in "List" table
			| 'Description' | 'Item type' |
			| 'Boots'       | 'Shoes'   |
		And I select current line in "List" table
	* Creating for Boots a new item key for the specification
		And In this window I click command interface button "Item keys"
		And I click the button named "FormCreate"
		And I change checkbox "Specification"
		And I click Choice button of the field named "Specification"
		And "List" table does not contain lines
			| 'Description' | 'Type' |
			| 'A-8'         | 'Set'  |
		And I go to line in "List" table
			| 'Description' | 'Type' |
			| 'S-8'         | 'Set'  |
		And I select current line in "List" table
		And I click "Save and close" button
		And Delay 5
		And "List" table contains lines
			| 'Item key'   |
			| 'Boots/S-8'  |
		And I close current window