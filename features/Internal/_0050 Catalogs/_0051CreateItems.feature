#language: en
@tree
@Positive


Feature: filling in catalogs Items

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
	* Opening the UI groups creation form 
		Given I open hyperlink "e1cib/list/Catalog.InterfaceGroups"
		And I click the button named "FormCreate"
	* Creating UI groups: Product information, Accounting information, Purchase and production 
		And I click Open button of the field named "Description_en"
		And I input "Product information" text in "ENG" field
		And I input "Product information TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And I wait "UI groups (create)" window closing in 5 seconds
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Accounting information" text in "ENG" field
		And I input "Accounting information TR" text in "TR" field
		And I click "Ok" button
		And I change the radio button named "FormPosition" value to "Right"
		And I click "Save and close" button
		And I wait "UI groups (create)" window closing in 5 seconds
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Purchase and production" text in "ENG" field
		And I input "Purchase and production TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And I wait "UI groups (create)" window closing in 5 seconds
	* Check for added UI groups in the catalog 
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Product information"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Product information TR"
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Accounting information"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Accounting information TR"
		Then I check for the "InterfaceGroups" catalog element with the "Description_en" "Purchase and production"  
		Then I check for the "InterfaceGroups" catalog element with the "Description_tr" "Purchase and production TR"


Scenario: _005111 filling in the "Add attribute and property" catalog 
	* Opening the Add attribute and property creation form 
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
		And I click the button named "FormCreate"
		And Delay 5
	* Creating additional attribute Type
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "*" table
				| ''       |
				| 'String' |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Type" text in the field named "Description_en"
		And I input "Type TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		And I input "V123445" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional attribute Brand
		And I click the button named "FormCreate"
		And Delay 5
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''       |
				| 'Additional attribute value' |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Brand" text in the field named "Description_en"
		And I input "Brand TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		And I input "V123446" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional attribute producer 
		And I click the button named "FormCreate"
		And Delay 5
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
		And I input "V123447" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional attribute Size
		And I click the button named "FormCreate"
		And Delay 5
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
		And I click the button named "FormWrite"
		And I input "Size1" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional attribute Color
		And I click the button named "FormCreate"
		And Delay 5
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
		And I click the button named "FormWrite"
		And I input "Color1" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional property article
		And I click the button named "FormCreate"
		And Delay 5
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''       |
				| 'String' |
		And I select current line in "" table
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Article" text in the field named "Description_en"
		And I input "Article TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		And I input "V123448" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional property country of consignment
		And I click the button named "FormCreate"
		And Delay 5
		And I click Choice button of the field named "ValueType"
		And Delay 2
		And I go to line in "" table
				| ''       |
				| 'Additional attribute value' |
		And I click the button named "OK"
		And I click Open button of the field named "Description_en"
		And I input "Country of consignment" text in the field named "Description_en"
		And I input "Country of consignment TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWrite"
		And I input "V123449" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
	* Creating additional property season
		And I click the button named "FormCreate"
		And Delay 5
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
		And I click the button named "FormWrite"
		And I input "V123450" text in the field named "UniqueID"
		And I click the button named "FormWriteAndClose"
		And I wait "Add attribute and property (create) *" window closing in 20 seconds

Scenario: _005112 filling in Additional attribute values with type Additional attribute values
# the value of additional attributes (Producer, Color, Size,Season, Country of consignment)
	* Opening the Add attribute and property form
		Given I open hyperlink "e1cib/list/ChartOfCharacteristicTypes.AddAttributeAndProperty"
	* Adding value Size
		And I go to line in "List" table
		| 'Description' |
		| 'Size'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "S" text in "ENG" field
		And I input "S" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "XS" text in "ENG" field
		And I input "XS" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "M" text in "ENG" field
		And I input "M" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "L" text in "ENG" field
		And I input "L" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "XL" text in "ENG" field
		And I input "XL" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "XXL" text in "ENG" field
		And I input "XXL" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "36" text in "ENG" field
		And I input "36" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "37" text in "ENG" field
		And I input "37" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "38" text in "ENG" field
		And I input "38" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "39" text in "ENG" field
		And I input "39" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Adding value Color
		And I go to line in "List" table
		| 'Description' |
		| 'Color'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Yellow" text in "ENG" field
		And I input "Yellow TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Blue" text in "ENG" field
		And I input "Blue TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Brown" text in "ENG" field
		And I input "Brown TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "White" text in "ENG" field
		And I input "White TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Red" text in "ENG" field
		And I input "Red TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Green" text in "ENG" field
		And I input "Green TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Black" text in "ENG" field
		And I input "Black TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Adding value Season
		And I go to line in "List" table
		| 'Description' |
		| 'Season'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "18SD" text in "ENG" field
		And I input "18SD" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "19SD" text in "ENG" field
		And I input "19SD" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "20SD" text in "ENG" field
		And I input "20SD" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Adding value Country of consignment
		And I go to line in "List" table
		| 'Description' |
		| 'Country of consignment'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Turkey" text in "ENG" field
		And I input "Turkey TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Romania" text in "ENG" field
		And I input "Romania TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Ukraine" text in "ENG" field
		And I input "Ukraine TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Poland" text in "ENG" field
		And I input "Poland TR" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button
	* Adding value Producer
		And I go to line in "List" table
		| 'Description' |
		| 'Producer'      |
		And I select current line in "List" table
		And In this window I click command interface button "Additional attribute values"
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "UNIQ" text in "ENG" field
		And I input "UNIQ" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "PZU" text in "ENG" field
		And I input "PZU" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "ODS" text in "ENG" field
		And I input "ODS" text in "TR" field
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
		And I input "York" text in "ENG" field
		And I input "York" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Gir" text in "ENG" field
		And I input "Gir" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Rose" text in "ENG" field
		And I input "Rose" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And I click the button named "FormCreate"
		And I click Open button of the field named "Description_en"
		And I input "Montel" text in "ENG" field
		And I input "Montel" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 2
		And In this window I click command interface button "Main"
		And I click "Save and close" button


Scenario: _005113 filling in the "Item types" catalog 
	* Opening the form for filling in Item types
		Given I open hyperlink "e1cib/list/Catalog.ItemTypes"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Creating item types: Clothes, Box, Shoes
		And I click Open button of the field named "Description_en"
		And I input "Clothes" text in the field named "Description_en"
		And I input "Clothes TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Box" text in the field named "Description_en"
		And I input "Box TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click the button named "FormWriteAndClose"
		And Delay 5
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Shoes" text in the field named "Description_en"
		And I input "Shoes TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click "Save and close" button
		And Delay 5
	* Check for created elements
		Then I check for the "ItemTypes" catalog element with the "Description_en" "Clothes"  
		Then I check for the "ItemTypes" catalog element with the "Description_tr" "Clothes TR"
		Then I check for the "ItemTypes" catalog element with the "Description_en" "Shoes"  
		Then I check for the "ItemTypes" catalog element with the "Description_tr" "Shoes TR"
		Then I check for the "ItemTypes" catalog element with the "Description_en" "Box"  
		Then I check for the "ItemTypes" catalog element with the "Description_tr" "Box TR"


Scenario: _005114 adding general additional attributes for Item
# AddAttributeAndPropertySets (Catalog_Items)
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
			| 'Article'   |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description' |
			| 'Brand'     |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And in the table "Attributes" I click the button named "AttributesAdd"
		And I click choice button of "Attribute" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'              |
			| 'Country of consignment' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Producer'  |
	* Distribution of added additional attributes by UI groups
		And I activate "UI group" field in "Attributes" table
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Purchase and production' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Article'   |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Accounting information' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute' |
			| 'Brand'     |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Product information' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I go to line in "Attributes" table
			| 'Attribute'              |
			| 'Country of consignment' |
		And I select current line in "Attributes" table
		And I click choice button of "UI group" attribute in "Attributes" table
		And I go to line in "List" table
			| 'Description'      |
			| 'Product information' |
		And I select current line in "List" table
		And I finish line editing in "Attributes" table
		And I click Open button of the field named "Description_en"
		And I input "Items" text in "ENG" field
		And I input "Items" text in "TR" field
		And I click "Ok" button
		And I click "Save and close" button

Scenario: _005115 filling in the "Items" catalog 
	* Opening the form for creating Items
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And Delay 2
		And I click the button named "FormCreate"
		And Delay 2
	* Test item creation Dress
		And I click Open button of the field named "Description_en"
		And I input "Dress" text in the field named "Description_en"
		And I input "Dress TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click Select button of "Producer" field
		And I go to line in "List" table
			| 'Description' |
			| 'UNIQ'        |
		And I select current line in "List" table
		And I click Select button of "Brand" field
		And I go to line in "List" table
			| 'Description' |
			| 'Rose'        |
		And I select current line in "List" table
		And I click Select button of "Country of consignment" field
		And I go to line in "List" table
			| 'Description' |
			| 'Poland'      |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Trousers
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Trousers" text in the field named "Description_en"
		And I input "Trousers TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Shirt
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Shirt" text in the field named "Description_en"
		And I input "Shirt TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Boots
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Boots" text in the field named "Description_en"
		And I input "Boots TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Shoes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation High shoes
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "High shoes" text in the field named "Description_en"
		And I input "High shoes TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Shoes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation Box
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Box" text in the field named "Description_en"
		And I input "Box TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
				| 'Description' |
				| 'Box'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		Given I open hyperlink "e1cib/list/Catalog.Units"
		And I go to line in "List" table
			| 'Description' |
			| 'box (4 pcs)'       |
		And I select current line in "List" table
		And I click Select button of "Item" field
		And I go to line in "List" table
			| 'Description' |
			| 'Box'       |
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
	* Test item creation for bundle Bound Dress+Shirt
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Bound Dress+Shirt" text in the field named "Description_en"
		And I input "Bound Dress+Shirt TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5
	* Test item creation for bundle Bound Dress+Trousers
		Given I open hyperlink "e1cib/list/Catalog.Items"
		And I click the button named "FormCreate"
		And Delay 2
		And I click Open button of the field named "Description_en"
		And I input "Bound Dress+Trousers" text in the field named "Description_en"
		And I input "Bound Dress+Trousers TR" text in the field named "Description_tr"
		And I click "Ok" button
		And I click Choice button of the field named "ItemType"
		And I go to line in "List" table
			| 'Description' |
			| 'Clothes'       |
		And I select current line in "List" table
		And I click Choice button of the field named "Unit"
		And I select current line in "List" table
		And I click the button named "FormWriteAndClose"
		And Delay 5


Scenario: _005116 filling in the settings for creating ItemKeys for Item type Closets and Shoes
# for clothes specify the color, for shoes - season
# It is indicated through the type of item with duplication in sets
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
		And I click "Save and close" button
		And I close current window


Scenario: _005117 fill in Item keys
# Dress, Trousers, Shirt, Boots, High shoes, Box
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
		And I input "High shoes box (8 pcs)" text in "ENG" field
		And I input "High shoes box (8 adet) TR" text in "TR" field
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
		And I input "Boots (12 pcs)" text in "ENG" field
		And I input "Boots (12 adet) TR" text in "TR" field
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
		And I input "A-8" text in "ENG" field
		And I input "A-8" text in "TR" field
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
		And I input "S-8" text in "ENG" field
		And I input "S-8" text in "TR" field
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

