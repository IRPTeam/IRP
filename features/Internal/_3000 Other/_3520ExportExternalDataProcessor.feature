#language: en
@tree
@Positive
@IgnoreOnCIMainBuild
@Other
Feature: check saving of plugin to a folder on the computer



Variables:
Path = "{?(ValueIsFilled(ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path")), ПолучитьСохраненноеЗначениеИзКонтекстаСохраняемого("Path"), "#workingDir#")}"


Background:
    Given I launch TestClient opening script or connect the existing one



Scenario: check saving of plugin to a folder on the computer
    * Add plugin without filling in Path to plugin for test
        Given I open hyperlink "e1cib/list/Catalog.ExternalDataProc"
        And I click the button named "FormCreate"
        And I input "ExternalSpecialMessage" text in "Name" field
        And I input "ExternalTest" text in the field named "Description_en"
        And I select external file "$Path$/DataProcessor/TaxCalculateVAT_TR.epf"
        And I click the button named "FormAddExtDataProc"
        And I input "" text in "Path to plugin for test" field
        And I click "Save" button

# to do save the file to disk
    



