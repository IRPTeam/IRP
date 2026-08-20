#language: en
@tree
@Positive
@AccessRights


Feature: per-attribute access (configuration metadata and access profiles)

Variables:
import "Variables.feature"

Background:
	Given I launch TestClient opening script or connect the existing one


Scenario: 950600 preparation (access profiles attributes)
	When set True value to the constant
	* Load info
		When Create catalog AccessGroups objects
		When Create catalog AccessProfiles objects
		When Create catalog Agreements objects
		When Create catalog BusinessUnits objects
		When Create catalog Companies objects (Main company)
		When Create catalog Companies objects (partners company)
		When Create catalog Countries objects
		When Create catalog ItemTypes objects
		When Create catalog ObjectStatuses objects
		When Create catalog Partners objects (Ferron BP)
		When Create catalog Partners objects (Kalipso)
		When Create catalog Partners objects
		When Create catalog Stores objects
		When Create catalog Units objects
		When Create chart of characteristic types CurrencyMovementType objects
		When Create catalog Currencies objects
		When Create catalog ItemKeys objects
		When Create catalog Items objects
		When Create catalog PriceTypes objects
		When Create catalog Specifications objects
		When Create chart of characteristic types AddAttributeAndProperty objects
		When Create catalog AddAttributeAndPropertySets objects
		When Create catalog AddAttributeAndPropertyValues objects
		When Create catalog Users objects
		When Create catalog TaxRates objects
		When Create catalog Taxes objects
		When Create information register TaxSettings records
		When Create information register CurrencyRates records
		When Create information register Taxes records (VAT)
		When Create document SalesInvoice objects
	* Fill configuration metadata
		When auto filling Configuration metadata catalog
	* Restrict Sales invoice attributes in the configuration metadata
		Given I open hyperlink "e1cib/list/Catalog.ConfigurationMetadata"
		And I go to line in "List" table
			| "Description"   |
			| "Sales invoice" |
		And I select current line in "List" table
		And I go to line in "AttributesTree" table
			| 'Description' |
			| 'Price'       |
		And I set checkbox named "AttributesTreeReadOnly" in "AttributesTree" table
		And I finish line editing in "AttributesTree" table
		And I go to line in "AttributesTree" table
			| 'Description' |
			| 'Quantity'    |
		And I set checkbox named "AttributesTreeHidden" in "AttributesTree" table
		And I finish line editing in "AttributesTree" table
		And I click "Save and close" button
	And I close all client application windows


Scenario: 9506001 check preparation
	When check preparation


Scenario: 950601 check read only and hidden attributes on the document form
	And I close all client application windows
	* The restricted attributes are read only or hidden for the current user
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '15'     |
		And I select current line in "List" table
		Then in "ItemList" table "Price" attribute is read only
		When I Check the steps for Exception
			| 'And I activate "Quantity" field in "ItemList" table' |
	And I close all client application windows


Scenario: 950602 check profile exceptions unlock the restricted attributes
	And I close all client application windows
	* Create the profile with edit and view exceptions
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And I click "Create" button
		And I input "Attribute exceptions" text in "ENG" field
		And I move to the tab named "PageAccessToEdit"
		And I go to line in "AccessToEditAttributesTree" table
			| 'Description' |
			| 'Price'       |
		And I set checkbox named "AccessToEditAttributesTreeMark" in "AccessToEditAttributesTree" table
		And I finish line editing in "AccessToEditAttributesTree" table
		And I move to the tab named "PageAccessToView"
		And I go to line in "AccessToViewAttributesTree" table
			| 'Description' |
			| 'Quantity'    |
		And I set checkbox named "AccessToViewAttributesTreeMark" in "AccessToViewAttributesTree" table
		And I finish line editing in "AccessToViewAttributesTree" table
		And I click "Save and close" button
	* Grant the profile to the current user through an access group
		Given I open hyperlink "e1cib/list/Catalog.AccessGroups"
		And I click "Create" button
		And I input "Attribute exceptions group" text in "ENG" field
		And in the table "Profiles" I click "Add" button
		And I select "Attribute exceptions" from "Profile" drop-down list by string in "Profiles" table
		And I finish line editing in "Profiles" table
		And in the table "Users" I click "Add" button
		And I select "CI" from "User" drop-down list by string in "Users" table
		And I finish line editing in "Users" table
		And I click "Save and close" button
	* The restricted attributes are available again
		Given I open hyperlink "e1cib/list/Document.SalesInvoice"
		And I go to line in "List" table
			| 'Number' |
			| '15'     |
		And I select current line in "List" table
		And in "ItemList" table "Price" attribute is not read only
		And I activate "Quantity" field in "ItemList" table
	And I close all client application windows


Scenario: 950603 check select all and unselect all commands of the profile
	And I close all client application windows
	* Select all attributes to edit
		Given I open hyperlink "e1cib/list/Catalog.AccessProfiles"
		And I go to line in "List" table
			| 'Description'          |
			| 'Attribute exceptions' |
		And I select current line in "List" table
		And I move to the tab named "PageAccessToEdit"
		And I click the button named "AccessToEditAttributesTreeSelectAllToEdit"
		And "AccessToEditAttributesTree" table contains lines
			| 'Description'   | 'Mark' |
			| 'Price'       | 'Yes'  |
	* Unselect all attributes to edit
		And I click the button named "AccessToEditAttributesTreeUnselectAllToEdit"
		And "AccessToEditAttributesTree" table contains lines
			| 'Description'   | 'Mark' |
			| 'Price'       | 'No'   |
		And I close current window
	And I close all client application windows


Scenario: 950604 check session starts for an infobase user without a catalog record
	And I close all client application windows
	// documents the PR2965 defect: InternalCommandsServer.SetSessionParameters reads
	// SessionParameters.CurrentUserAccessGroupList, which SessionParametersServer does not
	// set for a session whose infobase user has no Catalog.Users record - such sessions
	// (fresh users, background jobs) fail to start
	* Create an infobase user without a catalog record
		And I execute 1C:Enterprise script at server
			| 'User = InfoBaseUsers.CreateUser(); User.Name = "NoCatalogUser"; User.FullName = "NoCatalogUser"; User.StandardAuthentication = True; User.Password = ""; User.Roles.Add(Metadata.Roles.FullAccess); User.Write();' |
	* A session of this user starts
		And I connect "Test" TestClient using "NoCatalogUser" login and "" password
		And I close "Test" TestClient
	And I close all client application windows
